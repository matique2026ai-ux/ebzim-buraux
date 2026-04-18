import { ReportWorkflowUtil } from './report-workflow.util';
import { Role } from '../../../common/enums/role.enum';
import { ForbiddenException, BadRequestException } from '@nestjs/common';
import { Types } from 'mongoose';
import { Report } from '../schemas/report.schema';

describe('ReportWorkflowUtil', () => {
  const superAdmin = { role: Role.SUPER_ADMIN, institutionId: null };
  const mockInstId = new Types.ObjectId();
  const diffInstId = new Types.ObjectId();
  const authorityUser = { role: Role.AUTHORITY, institutionId: mockInstId };
  
  describe('validateAuthorityAccess', () => {
    it('allows SUPER_ADMIN complete access unconditionally', () => {
      const report = { institutionId: new Types.ObjectId() } as Report;
      expect(() => ReportWorkflowUtil.validateAuthorityAccess(superAdmin, report)).not.toThrow();
    });

    it('denies AUTHORITY if report has no institution linked', () => {
      const report = { institutionId: null } as Report;
      expect(() => ReportWorkflowUtil.validateAuthorityAccess(authorityUser, report)).toThrow(ForbiddenException);
    });

    it('denies AUTHORITY if report belongs to a different institution', () => {
      const report = { institutionId: diffInstId } as unknown as Report;
      expect(() => ReportWorkflowUtil.validateAuthorityAccess(authorityUser, report)).toThrow(ForbiddenException);
    });

    it('allows AUTHORITY if report institution ID matches cleanly', () => {
      const report = { institutionId: mockInstId } as unknown as Report;
      expect(() => ReportWorkflowUtil.validateAuthorityAccess(authorityUser, report)).not.toThrow();
    });
  });

  describe('validateStatusTransition', () => {
    it('SUPER_ADMIN can skip to CLOSED from anywhere', () => {
        expect(() => ReportWorkflowUtil.validateStatusTransition('SUBMITTED', 'CLOSED', superAdmin)).not.toThrow();
    });

    it('prevent closing if not resolved (Normal Flow)', () => {
        const admin = { role: Role.ADMIN };
        expect(() => ReportWorkflowUtil.validateStatusTransition('IN_INTERVENTION', 'CLOSED', admin)).toThrow(BadRequestException);
    });

    it('strict authority transition restrictions', () => {
        expect(() => ReportWorkflowUtil.validateStatusTransition('ASSIGNED_TO_AUTHORITY', 'RESOLVED', authorityUser)).not.toThrow();
        expect(() => ReportWorkflowUtil.validateStatusTransition('RESOLVED', 'CLOSED', authorityUser)).toThrow(ForbiddenException); // Auth cannot close
    });
  });
});
