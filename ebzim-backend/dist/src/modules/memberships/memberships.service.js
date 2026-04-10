"use strict";
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
var __metadata = (this && this.__metadata) || function (k, v) {
    if (typeof Reflect === "object" && typeof Reflect.metadata === "function") return Reflect.metadata(k, v);
};
var __param = (this && this.__param) || function (paramIndex, decorator) {
    return function (target, key) { decorator(target, key, paramIndex); }
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.MembershipsService = void 0;
const common_1 = require("@nestjs/common");
const mongoose_1 = require("@nestjs/mongoose");
const mongoose_2 = require("mongoose");
const role_enum_1 = require("../../common/enums/role.enum");
const membership_workflow_util_1 = require("./utils/membership-workflow.util");
const pagination_util_1 = require("../../common/utils/pagination.util");
let MembershipsService = class MembershipsService {
    membershipModel;
    userModel;
    constructor(membershipModel, userModel) {
        this.membershipModel = membershipModel;
        this.userModel = userModel;
    }
    async submit(userId, applicationData) {
        return this.membershipModel.findOneAndUpdate({ userId }, { applicationData, status: 'SUBMITTED', submissionDate: new Date() }, { upsert: true, new: true });
    }
    async getStatusByUser(userId) {
        const mem = await this.membershipModel.findOne({ userId });
        return mem ? { status: mem.status } : { status: 'NONE' };
    }
    async getAdminTable(options) {
        const { skip, limit, page } = (0, pagination_util_1.buildOffsetPagination)(options);
        const [docs, total] = await Promise.all([
            this.membershipModel.find().populate('userId', 'email').sort({ submissionDate: -1 }).skip(skip).limit(limit).exec(),
            this.membershipModel.countDocuments(),
        ]);
        return (0, pagination_util_1.formatOffsetPaginatedResponse)(docs, total, page, limit);
    }
    async processReview(id, updateDto, adminUser) {
        const membership = await this.membershipModel.findById(id);
        if (!membership)
            throw new common_1.NotFoundException('Application not found');
        if (updateDto.status) {
            membership_workflow_util_1.MembershipWorkflowUtil.validateStatusTransition(membership.status, updateDto.status, adminUser);
            membership.status = updateDto.status;
            membership.reviewDate = new Date();
            membership.reviewedBy = adminUser.userId;
            if (updateDto.status === 'APPROVED') {
                await this.userModel.findByIdAndUpdate(membership.userId, { role: role_enum_1.Role.MEMBER });
            }
        }
        if (updateDto.internalReviewNotes) {
            membership.internalReviewNotes = updateDto.internalReviewNotes;
        }
        return membership.save();
    }
};
exports.MembershipsService = MembershipsService;
exports.MembershipsService = MembershipsService = __decorate([
    (0, common_1.Injectable)(),
    __param(0, (0, mongoose_1.InjectModel)('Membership')),
    __param(1, (0, mongoose_1.InjectModel)('User')),
    __metadata("design:paramtypes", [mongoose_2.Model,
        mongoose_2.Model])
], MembershipsService);
//# sourceMappingURL=memberships.service.js.map