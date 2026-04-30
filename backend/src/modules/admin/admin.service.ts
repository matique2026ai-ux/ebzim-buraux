import { Injectable } from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';
import { Model } from 'mongoose';
import { MembershipDocument } from '../memberships/schemas/membership.schema';
import { ReportDocument } from '../reports/schemas/report.schema';
import {
  EventDocument,
  EventRsvpDocument,
} from '../events/schemas/event.schema';
import { ContributionDocument } from '../contributions/schemas/contribution.schema';
import { PostDocument } from '../posts/schemas/post.schema';
import { UserDocument } from '../users/schemas/user.schema';
import { Role } from '../../common/enums/role.enum';
import { PartnerDocument } from '../partners/schemas/partner.schema';
import { Publication } from '../publications/schemas/publication.schema';
import { HeroSlideDocument } from '../hero/schemas/hero-slide.schema';

@Injectable()
export class AdminService {
  constructor(
    @InjectModel('Membership')
    private membershipModel: Model<MembershipDocument>,
    @InjectModel('Report') private reportModel: Model<ReportDocument>,
    @InjectModel('Event') private eventModel: Model<EventDocument>,
    @InjectModel('EventRsvp')
    private eventRsvpModel: Model<EventRsvpDocument>,
    @InjectModel('Contribution')
    private contributionModel: Model<ContributionDocument>,
    @InjectModel('Post') private postModel: Model<PostDocument>,
    @InjectModel('User') private userModel: Model<UserDocument>,
    @InjectModel('Partner') private partnerModel: Model<PartnerDocument>,
    @InjectModel('Publication') private publicationModel: Model<Publication>,
    @InjectModel('Hero') private heroModel: Model<HeroSlideDocument>,
  ) {}

  async getStats() {
    const [
      membersCount,
      pendingReportsCount,
      activeEventsCount,
      totalContributionsResult,
      pinnedPostsCount,
      totalPostsCount,
      totalUsersCount,
    ] = await Promise.all([
      this.membershipModel.countDocuments({ status: 'APPROVED' }),
      this.reportModel.countDocuments({ status: 'SUBMITTED' }),
      this.eventModel.countDocuments({ startDate: { $gte: new Date() } }),
      this.contributionModel.aggregate([
        { $match: { status: 'VERIFIED' } },
        { $group: { _id: null, total: { $sum: '$amount' } } },
      ]),
      this.postModel.countDocuments({ isPinned: true }),
      this.postModel.countDocuments({}),
      this.userModel.countDocuments({}),
    ]);

    const totalContributions =
      (totalContributionsResult as { total: number }[])[0]?.total || 0;

    return {
      membersCount,
      pendingReportsCount,
      activeEventsCount,
      totalContributions,
      pinnedPostsCount,
      totalPostsCount,
      totalUsersCount,
    };
  }

  async getAllUsers() {
    return this.userModel.find({}, { passwordHash: 0 }).sort({ createdAt: -1 });
  }

  async updateUserStatus(userId: string, status: string) {
    return this.userModel.findByIdAndUpdate(userId, { status }, { new: true });
  }

  async deleteUser(userId: string) {
    const user = await this.userModel.findById(userId);
    if (user && user.role === Role.SUPER_ADMIN) {
      throw new Error('Cannot delete a Super Admin account');
    }

    // Cleanup associated records to avoid orphaned data (Ebzim Logic Audit compliance)
    await Promise.all([
      this.membershipModel.deleteMany({ userId }),
      this.contributionModel.deleteMany({ userId }),
      this.reportModel.deleteMany({ reporterId: userId }),
      this.eventRsvpModel.deleteMany({ userId }),
    ]);

    return this.userModel.findByIdAndDelete(userId);
  }

  async updateUser(userId: string, data: any) {
    const { profile, ...rest } = data;
    const update: Record<string, any> = { ...rest };

    if (profile && typeof profile === 'object') {
      for (const key in profile) {
        if (Object.prototype.hasOwnProperty.call(profile, key)) {
          update[`profile.${key}`] = (profile as Record<string, any>)[key];
        }
      }
    }

    return this.userModel.findByIdAndUpdate(
      userId,
      { $set: update },
      { new: true },
    );
  }

  async wipeAllTestData() {
    // Compliant with user request: Clear all non-critical test data for fresh start
    await Promise.all([
      this.postModel.deleteMany({}),
      this.eventModel.deleteMany({}),
      this.partnerModel.deleteMany({}),
      this.publicationModel.deleteMany({}),
      this.heroModel.deleteMany({}),
      this.reportModel.deleteMany({}),
      this.contributionModel.deleteMany({}),
      this.membershipModel.deleteMany({}),
      this.eventRsvpModel.deleteMany({}),
    ]);
    return { success: true, message: 'All test data wiped successfully' };
  }
}
