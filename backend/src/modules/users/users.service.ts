import { Injectable, NotFoundException } from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';
import { Model } from 'mongoose';
import { User, UserDocument } from './schemas/user.schema';

interface ProfileUpdateDto {
  imageUrl?: string;
  avatarUrl?: string;
  [key: string]: any;
}

@Injectable()
export class UsersService {
  constructor(@InjectModel(User.name) private userModel: Model<UserDocument>) {}

  async findOne(id: string): Promise<UserDocument> {
    const user = await this.userModel.findById(id).exec();
    if (!user) throw new NotFoundException('User not found');
    return user;
  }

  async updateProfile(
    id: string,
    profileData: ProfileUpdateDto,
  ): Promise<UserDocument> {
    // Map imageUrl to avatarUrl if the frontend sends it
    if (profileData.imageUrl && !profileData.avatarUrl) {
      profileData.avatarUrl = profileData.imageUrl;
    }

    const update: Record<string, any> = {};
    Object.entries(profileData).forEach(([key, value]) => {
      update[`profile.${key}`] = value;
    });

    const user = await this.userModel
      .findByIdAndUpdate(id, { $set: update }, { new: true })
      .exec();

    if (!user) throw new NotFoundException('User not found');
    return user;
  }

  async update(
    id: string,
    updateData: Record<string, any>,
  ): Promise<UserDocument> {
    const user = await this.userModel
      .findByIdAndUpdate(id, { $set: updateData }, { new: true })
      .exec();

    if (!user) throw new NotFoundException('User not found');
    return user;
  }
}
