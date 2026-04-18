import { ExecutionContext, ForbiddenException } from '@nestjs/common';
import { Reflector } from '@nestjs/core';
import { RolesGuard } from './roles.guard';
import { Role } from '../enums/role.enum';

describe('RolesGuard', () => {
  let rolesGuard: RolesGuard;
  let reflector: Reflector;

  beforeEach(() => {
    reflector = new Reflector();
    rolesGuard = new RolesGuard(reflector);
  });

  it('should allow access if no roles are required', () => {
    jest.spyOn(reflector, 'getAllAndOverride').mockReturnValue(null);
    const mockContext = {
      getHandler: jest.fn(),
      getClass: jest.fn(),
      switchToHttp: jest.fn().mockReturnValue({
        getRequest: jest.fn().mockReturnValue({ user: { role: Role.PUBLIC } }),
      }),
    } as unknown as ExecutionContext;

    expect(rolesGuard.canActivate(mockContext)).toBe(true);
  });

  it('should throw ForbiddenException if user has no role defined', () => {
    jest.spyOn(reflector, 'getAllAndOverride').mockReturnValue([Role.ADMIN]);
    const mockContext = {
      getHandler: jest.fn(),
      getClass: jest.fn(),
      switchToHttp: jest.fn().mockReturnValue({
        getRequest: jest.fn().mockReturnValue({ user: {} }), // No role
      }),
    } as unknown as ExecutionContext;

    expect(() => rolesGuard.canActivate(mockContext)).toThrow(
      ForbiddenException,
    );
  });

  it('should allow access for SUPER_ADMIN unconditionally', () => {
    jest
      .spyOn(reflector, 'getAllAndOverride')
      .mockReturnValue([Role.AUTHORITY]); // Requires Authority
    const mockContext = {
      getHandler: jest.fn(),
      getClass: jest.fn(),
      switchToHttp: jest.fn().mockReturnValue({
        getRequest: jest
          .fn()
          .mockReturnValue({ user: { role: Role.SUPER_ADMIN } }), // Pass as Super Admin
      }),
    } as unknown as ExecutionContext;

    expect(rolesGuard.canActivate(mockContext)).toBe(true);
  });

  it('should block access if role does not match', () => {
    jest.spyOn(reflector, 'getAllAndOverride').mockReturnValue([Role.MEMBER]);
    const mockContext = {
      getHandler: jest.fn(),
      getClass: jest.fn(),
      switchToHttp: jest.fn().mockReturnValue({
        getRequest: jest.fn().mockReturnValue({ user: { role: Role.PUBLIC } }),
      }),
    } as unknown as ExecutionContext;

    expect(() => rolesGuard.canActivate(mockContext)).toThrow(
      ForbiddenException,
    );
  });

  it('should allow access if role matches perfectly', () => {
    jest
      .spyOn(reflector, 'getAllAndOverride')
      .mockReturnValue([Role.ADMIN, Role.MEMBER]);
    const mockContext = {
      getHandler: jest.fn(),
      getClass: jest.fn(),
      switchToHttp: jest.fn().mockReturnValue({
        getRequest: jest.fn().mockReturnValue({ user: { role: Role.MEMBER } }),
      }),
    } as unknown as ExecutionContext;

    expect(rolesGuard.canActivate(mockContext)).toBe(true);
  });
});
