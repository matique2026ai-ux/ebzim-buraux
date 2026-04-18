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
exports.AdminService = void 0;
const common_1 = require("@nestjs/common");
const mongoose_1 = require("@nestjs/mongoose");
const mongoose_2 = require("mongoose");
let AdminService = class AdminService {
    membershipModel;
    reportModel;
    eventModel;
    contributionModel;
    postModel;
    userModel;
    constructor(membershipModel, reportModel, eventModel, contributionModel, postModel, userModel) {
        this.membershipModel = membershipModel;
        this.reportModel = reportModel;
        this.eventModel = eventModel;
        this.contributionModel = contributionModel;
        this.postModel = postModel;
        this.userModel = userModel;
    }
    async getStats() {
        const [membersCount, pendingReportsCount, activeEventsCount, contributions, pinnedPostsCount, totalPostsCount] = await Promise.all([
            this.membershipModel.countDocuments({ status: 'APPROVED' }),
            this.reportModel.countDocuments({ status: 'SUBMITTED' }),
            this.eventModel.countDocuments({ date: { $gte: new Date() } }),
            this.contributionModel.find({ status: 'VERIFIED' }),
            this.postModel.countDocuments({ isPinned: true }),
            this.postModel.countDocuments({}),
        ]);
        const totalContributions = contributions.reduce((sum, c) => sum + (c.amount || 0), 0);
        return {
            membersCount,
            pendingReportsCount,
            activeEventsCount,
            totalContributions,
            pinnedPostsCount,
            totalPostsCount,
            totalUsersCount: await this.userModel.countDocuments({}),
        };
    }
    async getAllUsers() {
        return this.userModel.find({}, { passwordHash: 0 }).sort({ createdAt: -1 });
    }
    async updateUserStatus(userId, status) {
        return this.userModel.findByIdAndUpdate(userId, { status }, { new: true });
    }
    async deleteUser(userId) {
        return this.userModel.findByIdAndDelete(userId);
    }
    async updateUser(userId, data) {
        const { profile, ...rest } = data;
        const update = { ...rest };
        if (profile) {
            for (const key in profile) {
                update[`profile.${key}`] = profile[key];
            }
        }
        return this.userModel.findByIdAndUpdate(userId, { $set: update }, { new: true });
    }
};
exports.AdminService = AdminService;
exports.AdminService = AdminService = __decorate([
    (0, common_1.Injectable)(),
    __param(0, (0, mongoose_1.InjectModel)('Membership')),
    __param(1, (0, mongoose_1.InjectModel)('Report')),
    __param(2, (0, mongoose_1.InjectModel)('Event')),
    __param(3, (0, mongoose_1.InjectModel)('Contribution')),
    __param(4, (0, mongoose_1.InjectModel)('Post')),
    __param(5, (0, mongoose_1.InjectModel)('User')),
    __metadata("design:paramtypes", [mongoose_2.Model,
        mongoose_2.Model,
        mongoose_2.Model,
        mongoose_2.Model,
        mongoose_2.Model,
        mongoose_2.Model])
], AdminService);
//# sourceMappingURL=admin.service.js.map