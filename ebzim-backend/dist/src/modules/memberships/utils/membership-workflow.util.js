"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.MembershipWorkflowUtil = void 0;
const common_1 = require("@nestjs/common");
const role_enum_1 = require("../../../common/enums/role.enum");
class MembershipWorkflowUtil {
    static validateStatusTransition(currentStatus, newStatus, user) {
        if (user.role === role_enum_1.Role.SUPER_ADMIN)
            return;
        if (newStatus === 'APPROVED' || newStatus === 'REJECTED') {
            if (currentStatus !== 'SUBMITTED' && currentStatus !== 'UNDER_REVIEW' && currentStatus !== 'NEEDS_INFO') {
                throw new common_1.BadRequestException(`Cannot transition from ${currentStatus} to ${newStatus}`);
            }
        }
    }
}
exports.MembershipWorkflowUtil = MembershipWorkflowUtil;
//# sourceMappingURL=membership-workflow.util.js.map