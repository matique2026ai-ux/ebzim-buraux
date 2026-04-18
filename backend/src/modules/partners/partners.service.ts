import { Injectable } from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';
import { Model } from 'mongoose';
import { PartnerDocument } from './schemas/partner.schema';
import { CreatePartnerDto, UpdatePartnerDto } from './dto/create-partner.dto';
import {
  buildOffsetPagination,
  formatOffsetPaginatedResponse,
} from '../../common/utils/pagination.util';

@Injectable()
export class PartnersService {
  constructor(
    @InjectModel('Partner') private partnerModel: Model<PartnerDocument>,
  ) {}

  async findAll() {
    return this.partnerModel.find({ isActive: true }).sort({ order: 1 }).exec();
  }

  async getAdminTable(options: any) {
    const { skip, limit, page } = buildOffsetPagination(options);
    const [partners, total] = await Promise.all([
      this.partnerModel
        .find()
        .sort({ order: 1 })
        .skip(skip)
        .limit(limit)
        .exec(),
      this.partnerModel.countDocuments(),
    ]);
    return formatOffsetPaginatedResponse(partners, total, page, limit);
  }

  async create(dto: CreatePartnerDto) {
    return this.partnerModel.create(dto);
  }

  async update(id: string, dto: UpdatePartnerDto) {
    return this.partnerModel.findByIdAndUpdate(id, dto, { new: true }).exec();
  }

  async findOne(id: string) {
    return this.partnerModel.findById(id).exec();
  }

  async delete(id: string) {
    return this.partnerModel.findByIdAndDelete(id).exec();
  }
}
