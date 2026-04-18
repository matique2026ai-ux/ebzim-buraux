import { Injectable, OnModuleInit } from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';
import { Model } from 'mongoose';
import { Settings, SettingsDocument } from './schemas/settings.schema';

@Injectable()
export class SettingsService implements OnModuleInit {
  constructor(
    @InjectModel(Settings.name) private settingsModel: Model<SettingsDocument>,
  ) {}

  async onModuleInit() {
    // Ensure a settings document exists
    const count = await this.settingsModel.countDocuments();
    if (count === 0) {
      await this.settingsModel.create({});
    }
  }

  async getSettings() {
    return this.settingsModel.findOne().exec();
  }

  async updateMembershipFee(fee: number) {
    return this.settingsModel
      .findOneAndUpdate({}, { annualMembershipFee: fee }, { new: true })
      .exec();
  }
}
