import { MembershipWorkflowUtil } from './membership-workflow.util';
import { Role } from '../../../common/enums/role.enum';
import { BadRequestException } from '@nestjs/common';

describe('MembershipWorkflowUtil', () => {
  const admin = { role: Role.ADMIN };
  const superAdmin = { role: Role.SUPER_ADMIN };

  describe('validateStatusTransition', () => {
    it('SUPER_ADMIN bypasses all workflow requirements', () => {
      expect(() =>
        MembershipWorkflowUtil.validateStatusTransition(
          'SUBMITTED',
          'APPROVED',
          superAdmin,
        ),
      ).not.toThrow();
    });

    it('throws if Admin tries to approve directly from SUBMITTED', () => {
      expect(() =>
        MembershipWorkflowUtil.validateStatusTransition(
          'SUBMITTED',
          'APPROVED',
          admin,
        ),
      ).toThrow(BadRequestException);
    });

    it('allows Admin to approve from UNDER_REVIEW', () => {
      expect(() =>
        MembershipWorkflowUtil.validateStatusTransition(
          'UNDER_REVIEW',
          'APPROVED',
          admin,
        ),
      ).not.toThrow();
    });

    it('allows Admin to reject from NEEDS_INFO', () => {
      expect(() =>
        MembershipWorkflowUtil.validateStatusTransition(
          'NEEDS_INFO',
          'REJECTED',
          admin,
        ),
      ).not.toThrow();
    });
  });
});
