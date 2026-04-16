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
exports.ReportsService = void 0;
const common_1 = require("@nestjs/common");
const mongoose_1 = require("@nestjs/mongoose");
const mongoose_2 = require("mongoose");
const report_workflow_util_1 = require("./utils/report-workflow.util");
const pagination_util_1 = require("../../common/utils/pagination.util");
const role_enum_1 = require("../../common/enums/role.enum");
let ReportsService = class ReportsService {
    reportModel;
    constructor(reportModel) {
        this.reportModel = reportModel;
    }
    async createReport(dto, reporterId) {
        const reportData = { ...dto };
        if (!reportData.title) {
            const categoryLabel = reportData.incidentCategory?.toLowerCase().replace('_', ' ') || 'incident';
            reportData.title = `${categoryLabel.charAt(0).toUpperCase() + categoryLabel.slice(1)} Report`;
        }
        return this.reportModel.create({
            ...reportData,
            reporterId,
            status: 'SUBMITTED',
            timeline: [{ actorId: reporterId ? new mongoose_2.Types.ObjectId(reporterId) : null, action: 'SUBMITTED', timestamp: new Date() }],
        });
    }
    async getReports(user, options) {
        const { skip, limit, page } = (0, pagination_util_1.buildOffsetPagination)(options);
        const query = {};
        if (user.role === role_enum_1.Role.AUTHORITY) {
            query.institutionId = user.institutionId;
        }
        const [reports, total] = await Promise.all([
            this.reportModel.find(query).sort({ createdAt: -1 }).skip(skip).limit(limit).exec(),
            this.reportModel.countDocuments(query),
        ]);
        return (0, pagination_util_1.formatOffsetPaginatedResponse)(reports, total, page, limit);
    }
    async updateStatus(id, newStatus, user) {
        const report = await this.reportModel.findById(id);
        if (!report)
            throw new common_1.NotFoundException('Report not found');
        report_workflow_util_1.ReportWorkflowUtil.validateAuthorityAccess(user, report);
        report_workflow_util_1.ReportWorkflowUtil.validateStatusTransition(report.status, newStatus, user);
        report.status = newStatus;
        report.timeline.push({
            actorId: user.userId,
            action: `STATUS_CHANGED_TO_${newStatus}`,
            timestamp: new Date(),
        });
        return report.save();
    }
};
exports.ReportsService = ReportsService;
exports.ReportsService = ReportsService = __decorate([
    (0, common_1.Injectable)(),
    __param(0, (0, mongoose_1.InjectModel)('Report')),
    __metadata("design:paramtypes", [mongoose_2.Model])
], ReportsService);
//# sourceMappingURL=reports.service.js.map