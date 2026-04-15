import { ForbiddenException, BadRequestException } from '@nestjs/common';
import { Role } from '../../../common/enums/role.enum';
import { Report } from '../schemas/report.schema';

export class ReportWorkflowUtil {
  static validateAuthorityAccess(user: any, report: Report) {
    if (user.role === Role.SUPER_ADMIN) return; // Super admin overrides

    // If an Admin/Editor tries to alter a report, ensure it's not strictly assigned to an authority
    // (Optional logic, depends on strict bounds, but for now Admins might still triage)
    
    // Core check: AUTHORITY can only touch reports strictly assigned to their Institution
    if (user.role === Role.AUTHORITY) {
      if (!report.institutionId) {
        throw new ForbiddenException('Report is not assigned to any institution');
      }
      if (report.institutionId.toString() !== user.institutionId?.toString()) {
        throw new ForbiddenException('Authority cannot manage reports assigned to other institutions');
      }
    }
  }

  static validateStatusTransition(currentStatus: string, newStatus: string, user: any) {
    // Basic logic constraint: Can only close if it was resolved, etc.
    if (newStatus === 'CLOSED' && currentStatus !== 'RESOLVED' && user.role !== Role.SUPER_ADMIN) {
      throw new BadRequestException('Report must be RESOLVED before it can be CLOSED');
    }

    if (user.role === Role.AUTHORITY) {
      // Authority mostly updates status to IN_INTERVENTION, RESOLVED
      const allowedAuthorityTargetStatuses = ['IN_INTERVENTION', 'RESOLVED', 'NEEDS_MORE_INFO'];
      if (!allowedAuthorityTargetStatuses.includes(newStatus)) {
        throw new ForbiddenException(`Authorities cannot change status to ${newStatus}`);
      }
    }
  }
}
