import { Injectable } from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';
import { Model } from 'mongoose';
import { HeroSlideDocument } from './schemas/hero-slide.schema';
import {
  CreateHeroSlideDto,
  UpdateHeroSlideDto,
} from './dto/create-hero-slide.dto';

@Injectable()
export class HeroService {
  constructor(
    @InjectModel('HeroSlide') private slideModel: Model<HeroSlideDocument>,
  ) {}

  async findAll(location: string = 'HOME') {
    return this.slideModel
      .find({ isActive: true, location })
      .sort({ order: 1 })
      .exec();
  }

  async getAdminTable() {
    return this.slideModel.find().sort({ order: 1 }).exec();
  }

  async getAdminByLocation(location: string = 'HOME') {
    return this.slideModel.find({ location }).sort({ order: 1 }).exec();
  }

  async create(dto: CreateHeroSlideDto) {
    return this.slideModel.create(dto);
  }

  async update(id: string, dto: UpdateHeroSlideDto) {
    return this.slideModel
      .findByIdAndUpdate(id, { $set: dto }, { new: true })
      .exec();
  }

  async findOne(id: string) {
    return this.slideModel.findById(id).exec();
  }

  async delete(id: string) {
    return this.slideModel.findByIdAndDelete(id).exec();
  }

  async syncEmergency() {
    // Force all hero slides to be active and on HOME
    await this.slideModel.updateMany({}, { $set: { isActive: true, location: 'HOME' } });
    // Force all posts to be PUBLISHED
    await this.slideModel.db.collection('posts').updateMany({}, { $set: { status: 'PUBLISHED' } });
    return { success: true, timestamp: new Date() };
  }
}
