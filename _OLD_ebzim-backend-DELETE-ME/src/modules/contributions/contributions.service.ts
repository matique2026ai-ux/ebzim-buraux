import { Injectable, NotFoundException } from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';
import { Model, Types } from 'mongoose';
import { Contribution, ContributionDocument } from './schemas/contribution.schema';
import { SettingsService } from '../settings/settings.service';

@Injectable()
export class ContributionsService {
  constructor(
    @InjectModel(Contribution.name) private contributionModel: Model<ContributionDocument>,
    private readonly settingsService: SettingsService,
  ) {}

  async submitContribution(userId: string, dto: any) {
    return this.contributionModel.create({
      ...dto,
      userId: new Types.ObjectId(userId),
      status: 'PENDING',
    });
  }

  async getMyContributions(userId: string) {
    return this.contributionModel.find({ userId: new Types.ObjectId(userId) }).sort({ createdAt: -1 }).exec();
  }

  async getAllContributions() {
    return this.contributionModel.find().populate('userId', 'fullName email').sort({ createdAt: -1 }).exec();
  }

  async verifyContribution(id: string, adminId: string, status: string, notes?: string) {
    const contribution = await this.contributionModel.findById(id);
    if (!contribution) throw new NotFoundException('Contribution record not found');

    contribution.status = status;
    contribution.reviewedBy = new Types.ObjectId(adminId);
    contribution.internalReviewNotes = notes;

    if (status === 'VERIFIED' && contribution.type === 'ANNUAL_MEMBERSHIP') {
       // TODO: Update user membership expiry date.
       // This would involve linking to the UsersService or MembershipsService
    }

    return contribution.save();
  }
}
