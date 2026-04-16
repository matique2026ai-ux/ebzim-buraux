import { Injectable } from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';
import { Model } from 'mongoose';
import { MembershipDocument } from '../memberships/schemas/membership.schema';
import { ReportDocument } from '../reports/schemas/report.schema';
import { EventDocument } from '../events/schemas/event.schema';
import { ContributionDocument } from '../contributions/schemas/contribution.schema';
import { PostDocument } from '../posts/schemas/post.schema';

@Injectable()
export class AdminService {
  constructor(
    @InjectModel('Membership') private membershipModel: Model<MembershipDocument>,
    @InjectModel('Report') private reportModel: Model<ReportDocument>,
    @InjectModel('Event') private eventModel: Model<EventDocument>,
    @InjectModel('Contribution') private contributionModel: Model<ContributionDocument>,
    @InjectModel('Post') private postModel: Model<PostDocument>,
  ) {}

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
    };
  }
}
