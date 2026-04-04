import { Injectable, NotFoundException } from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';
import { Model } from 'mongoose';
import { ReportDocument } from './schemas/report.schema';
import { ReportWorkflowUtil } from './utils/report-workflow.util';
import { buildOffsetPagination, formatOffsetPaginatedResponse } from '../../common/utils/pagination.util';
import { Role } from '../../common/enums/role.enum';

@Injectable()
export class ReportsService {
  constructor(@InjectModel('Report') private reportModel: Model<ReportDocument>) {}

  async createReport(dto: any, reporterId: string | null) {
    return this.reportModel.create({
      ...dto,
      reporterId,
      status: 'SUBMITTED',
      timeline: [{ actorId: reporterId, action: 'SUBMITTED', timestamp: new Date() }],
    });
  }

  async getReports(user: any, options: any) {
    const { skip, limit, page } = buildOffsetPagination(options);
    const query: any = {};

    // Critical Constraint: Authorities only see what's assigned to their institution
    if (user.role === Role.AUTHORITY) {
      query.institutionId = user.institutionId;
    }

    const [reports, total] = await Promise.all([
      this.reportModel.find(query).sort({ createdAt: -1 }).skip(skip).limit(limit).exec(),
      this.reportModel.countDocuments(query),
    ]);

    return formatOffsetPaginatedResponse(reports, total, page, limit);
  }

  async updateStatus(id: string, newStatus: string, user: any) {
    const report = await this.reportModel.findById(id);
    if (!report) throw new NotFoundException('Report not found');

    // Execute isolated logic guard tests
    ReportWorkflowUtil.validateAuthorityAccess(user, report);
    ReportWorkflowUtil.validateStatusTransition(report.status, newStatus, user);

    report.status = newStatus;
    report.timeline.push({
      actorId: user.userId, // Cast context securely from JWT token
      action: `STATUS_CHANGED_TO_${newStatus}`,
      timestamp: new Date(),
    });

    return report.save();
  }
}
