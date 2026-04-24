import { Injectable, NotFoundException } from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';
import { Model } from 'mongoose';
import { MembershipDocument } from './schemas/membership.schema';
import { UserDocument } from '../users/schemas/user.schema';
import { Role } from '../../common/enums/role.enum';
import { MembershipWorkflowUtil } from './utils/membership-workflow.util';
import { MailService } from '../mail/mail.service';
import {
  buildOffsetPagination,
  formatOffsetPaginatedResponse,
} from '../../common/utils/pagination.util';

@Injectable()
export class MembershipsService {
  constructor(
    @InjectModel('Membership')
    private membershipModel: Model<MembershipDocument>,
    @InjectModel('User') private userModel: Model<UserDocument>,
    private readonly mailService: MailService,
  ) {}

  async submit(userId: string, applicationData: any) {
    // Upsert equivalent: only 1 active line of membership allowed per user
    return this.membershipModel.findOneAndUpdate(
      { userId },
      { applicationData, status: 'SUBMITTED', submissionDate: new Date() },
      { upsert: true, new: true },
    );
  }

  async getStatusByUser(userId: string) {
    const mem = await this.membershipModel.findOne({ userId });
    return mem ? { status: mem.status } : { status: 'NONE' };
  }

  async getAdminTable(options: any) {
    const { skip, limit, page } = buildOffsetPagination(options);
    const [docs, total] = await Promise.all([
      this.membershipModel
        .find()
        .populate('userId', 'email name')
        .sort({ submissionDate: -1 })
        .skip(skip)
        .limit(limit)
        .exec(),
      this.membershipModel.countDocuments(),
    ]);
    return formatOffsetPaginatedResponse(docs, total, page, limit);
  }

  async processReview(id: string, updateDto: any, adminUser: any) {
    const membership = await this.membershipModel
      .findById(id)
      .populate('userId');
    if (!membership) throw new NotFoundException('Application not found');

    if (updateDto.status) {
      MembershipWorkflowUtil.validateStatusTransition(
        membership.status,
        updateDto.status,
        adminUser,
      );
      membership.status = updateDto.status;
      membership.reviewDate = new Date();
      membership.reviewedBy = adminUser.userId;

      if (updateDto.status === 'APPROVED') {
        await this.userModel.findByIdAndUpdate(membership.userId._id, {
          role: Role.MEMBER,
        });
      }

      // Send the real email
      try {
        const user = membership.userId as any;
        if (user && user.email) {
          await this.mailService.sendMembershipDecisionEmail(
            user.email,
            updateDto.status,
            user.name || 'عضو إبزيم',
          );
        }
      } catch (e) {
        console.error('Failed to send membership decision email:', e);
      }
    }

    if (updateDto.internalReviewNotes) {
      membership.internalReviewNotes = updateDto.internalReviewNotes;
    }

    return membership.save();
  }

  async deleteRequest(id: string) {
    const result = await this.membershipModel.findByIdAndDelete(id);
    if (!result) throw new NotFoundException('Application not found');
    return { success: true, message: 'Membership request deleted permanently' };
  }
}
