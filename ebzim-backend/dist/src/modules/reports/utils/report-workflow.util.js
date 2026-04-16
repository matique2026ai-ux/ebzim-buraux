"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.ReportWorkflowUtil = void 0;
const common_1 = require("@nestjs/common");
const role_enum_1 = require("../../../common/enums/role.enum");
class ReportWorkflowUtil {
    static validateAuthorityAccess(user, report) {
        if (user.role === role_enum_1.Role.SUPER_ADMIN)
            return;
        if (user.role === role_enum_1.Role.AUTHORITY) {
            if (!report.institutionId) {
                throw new common_1.ForbiddenException('Report is not assigned to any institution');
            }
            if (report.institutionId.toString() !== user.institutionId?.toString()) {
                throw new common_1.ForbiddenException('Authority cannot manage reports assigned to other institutions');
            }
        }
    }
    static validateStatusTransition(currentStatus, newStatus, user) {
        if (newStatus === 'CLOSED' && currentStatus !== 'RESOLVED' && user.role !== role_enum_1.Role.SUPER_ADMIN) {
            throw new common_1.BadRequestException('Report must be RESOLVED before it can be CLOSED');
        }
        if (user.role === role_enum_1.Role.AUTHORITY) {
            const allowedAuthorityTargetStatuses = ['IN_INTERVENTION', 'RESOLVED', 'NEEDS_MORE_INFO'];
            if (!allowedAuthorityTargetStatuses.includes(newStatus)) {
                throw new common_1.ForbiddenException(`Authorities cannot change status to ${newStatus}`);
            }
        }
    }
}
exports.ReportWorkflowUtil = ReportWorkflowUtil;
//# sourceMappingURL=report-workflow.util.js.map