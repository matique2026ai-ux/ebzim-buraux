import { Injectable, NotFoundException } from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';
import { Model, Types } from 'mongoose';
import {
  Contribution,
  ContributionDocument,
} from './schemas/contribution.schema';
import { SettingsService } from '../settings/settings.service';
import { UsersService } from '../users/users.service';

interface ContributionDto {
  amount: number;
  type: string;
  proofUrl?: string;
  projectId?: string;
}

@Injectable()
export class ContributionsService {
  constructor(
    @InjectModel(Contribution.name)
    private contributionModel: Model<ContributionDocument>,
    private readonly settingsService: SettingsService,
    private readonly usersService: UsersService,
  ) {}

  async submitContribution(userId: string, dto: ContributionDto) {
    return this.contributionModel.create({
      amount: dto.amount,
      type: dto.type,
      proofUrl: dto.proofUrl,
      projectId: dto.projectId,
      userId: new Types.ObjectId(userId),
      status: 'PENDING',
    });
  }

  async getMyContributions(userId: string) {
    return this.contributionModel
      .find({ userId: new Types.ObjectId(userId) })
      .sort({ createdAt: -1 })
      .exec();
  }

  async getAllContributions() {
    return this.contributionModel
      .find()
      .populate('userId', 'fullName email')
      .sort({ createdAt: -1 })
      .exec();
  }

  async verifyContribution(
    id: string,
    adminId: string,
    status: string,
    notes?: string,
  ) {
    const contribution = await this.contributionModel.findById(id);
    if (!contribution)
      throw new NotFoundException('Contribution record not found');

    contribution.status = status;
    contribution.reviewedBy = new Types.ObjectId(adminId);
    contribution.internalReviewNotes = notes;

    if (status === 'VERIFIED' && contribution.type === 'ANNUAL_MEMBERSHIP') {
      const now = new Date();
      const expiry = new Date(
        now.getFullYear() + 1,
        now.getMonth(),
        now.getDate(),
      );
      await this.usersService.update(contribution.userId.toString(), {
        membershipExpiry: expiry,
        status: 'APPROVED', // Ensure member is approved upon payment verification
      });
    }

    return contribution.save();
  }
}
