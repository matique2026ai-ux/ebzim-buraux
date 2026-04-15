import { Injectable } from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';
import { Model } from 'mongoose';
import { HeroSlideDocument } from './schemas/hero-slide.schema';
import { CreateHeroSlideDto, UpdateHeroSlideDto } from './dto/create-hero-slide.dto';

@Injectable()
export class HeroService {
  constructor(
    @InjectModel('HeroSlide') private slideModel: Model<HeroSlideDocument>,
  ) {}

  async findAll() {
    return this.slideModel.find({ isActive: true }).sort({ order: 1 }).exec();
  }

  async getAdminTable() {
    return this.slideModel.find().sort({ order: 1 }).exec();
  }

  async create(dto: CreateHeroSlideDto) {
    return this.slideModel.create(dto);
  }

  async update(id: string, dto: UpdateHeroSlideDto) {
    return this.slideModel.findByIdAndUpdate(id, dto, { new: true }).exec();
  }

  async delete(id: string) {
    return this.slideModel.findByIdAndDelete(id).exec();
  }
}
