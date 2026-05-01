import { Injectable, NotFoundException } from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';
import { Model, UpdateQuery } from 'mongoose';
import { Publication } from './schemas/publication.schema';

@Injectable()
export class PublicationsService {
  constructor(
    @InjectModel(Publication.name)
    private readonly publicationModel: Model<Publication>,
  ) {}

  async create(createDto: any, userId: string): Promise<Publication> {
    const plainDto = JSON.parse(JSON.stringify(createDto));
    const newPub = new this.publicationModel({
      ...plainDto,
      createdBy: userId,
    });
    return newPub.save();
  }

  async findAll(): Promise<Publication[]> {
    return this.publicationModel.find().sort({ publishedDate: -1 }).exec();
  }

  async findOne(id: string): Promise<Publication> {
    const pub = await this.publicationModel.findById(id).exec();
    if (!pub) throw new NotFoundException('Publication not found');
    return pub;
  }

  async update(
    id: string,
    updateDto: any,
  ): Promise<Publication> {
    const plainDto = JSON.parse(JSON.stringify(updateDto));
    const updated = await this.publicationModel
      .findByIdAndUpdate(id, plainDto, { new: true })
      .exec();
    if (!updated) throw new NotFoundException('Publication not found');
    return updated;
  }

  async remove(id: string): Promise<{ deleted: boolean }> {
    const result = await this.publicationModel.findByIdAndDelete(id).exec();
    if (!result) throw new NotFoundException('Publication not found');
    return { deleted: true };
  }
}
