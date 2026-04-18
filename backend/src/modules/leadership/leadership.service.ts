import { Injectable } from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';
import { Model } from 'mongoose';
import { LeaderDocument } from './schemas/leader.schema';
import { CreateLeaderDto, UpdateLeaderDto } from './dto/create-leader.dto';

@Injectable()
export class LeadershipService {
  constructor(
    @InjectModel('Leader') private leaderModel: Model<LeaderDocument>,
  ) {}

  async findAll() {
    return this.leaderModel.find({ isActive: true }).sort({ order: 1 }).exec();
  }

  async create(dto: CreateLeaderDto) {
    return this.leaderModel.create(dto);
  }

  async update(id: string, dto: UpdateLeaderDto) {
    return this.leaderModel.findByIdAndUpdate(id, dto, { new: true }).exec();
  }

  async findOne(id: string) {
    return this.leaderModel.findById(id).exec();
  }

  async delete(id: string) {
    return this.leaderModel.findByIdAndDelete(id).exec();
  }
}
