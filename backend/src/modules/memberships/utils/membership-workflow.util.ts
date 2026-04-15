import { BadRequestException } from '@nestjs/common';
import { Role } from '../../../common/enums/role.enum';

export class MembershipWorkflowUtil {
  static validateStatusTransition(currentStatus: string, newStatus: string, user: any) {
    if (user.role === Role.SUPER_ADMIN) return;

    if (newStatus === 'APPROVED' || newStatus === 'REJECTED') {
      if (currentStatus !== 'SUBMITTED' && currentStatus !== 'UNDER_REVIEW' && currentStatus !== 'NEEDS_INFO') {
        throw new BadRequestException(`Cannot transition from ${currentStatus} to ${newStatus}`);
      }
    }
  }
}
