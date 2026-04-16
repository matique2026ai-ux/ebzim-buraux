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
exports.ContributionsService = void 0;
const common_1 = require("@nestjs/common");
const mongoose_1 = require("@nestjs/mongoose");
const mongoose_2 = require("mongoose");
const contribution_schema_1 = require("./schemas/contribution.schema");
const settings_service_1 = require("../settings/settings.service");
let ContributionsService = class ContributionsService {
    contributionModel;
    settingsService;
    constructor(contributionModel, settingsService) {
        this.contributionModel = contributionModel;
        this.settingsService = settingsService;
    }
    async submitContribution(userId, dto) {
        return this.contributionModel.create({
            ...dto,
            userId: new mongoose_2.Types.ObjectId(userId),
            status: 'PENDING',
        });
    }
    async getMyContributions(userId) {
        return this.contributionModel.find({ userId: new mongoose_2.Types.ObjectId(userId) }).sort({ createdAt: -1 }).exec();
    }
    async getAllContributions() {
        return this.contributionModel.find().populate('userId', 'fullName email').sort({ createdAt: -1 }).exec();
    }
    async verifyContribution(id, adminId, status, notes) {
        const contribution = await this.contributionModel.findById(id);
        if (!contribution)
            throw new common_1.NotFoundException('Contribution record not found');
        contribution.status = status;
        contribution.reviewedBy = new mongoose_2.Types.ObjectId(adminId);
        contribution.internalReviewNotes = notes;
        if (status === 'VERIFIED' && contribution.type === 'ANNUAL_MEMBERSHIP') {
        }
        return contribution.save();
    }
};
exports.ContributionsService = ContributionsService;
exports.ContributionsService = ContributionsService = __decorate([
    (0, common_1.Injectable)(),
    __param(0, (0, mongoose_1.InjectModel)(contribution_schema_1.Contribution.name)),
    __metadata("design:paramtypes", [mongoose_2.Model,
        settings_service_1.SettingsService])
], ContributionsService);
//# sourceMappingURL=contributions.service.js.map