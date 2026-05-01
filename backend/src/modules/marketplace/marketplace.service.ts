import { Injectable, NotFoundException } from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';
import { Model } from 'mongoose';
import { MarketBook, MarketBookDocument } from './schemas/market-book.schema';
import { CreateMarketBookDto } from './dto/create-market-book.dto';
import { UpdateMarketBookDto } from './dto/update-market-book.dto';

@Injectable()
export class MarketplaceService {
  constructor(
    @InjectModel(MarketBook.name)
    private readonly marketBookModel: Model<MarketBookDocument>,
  ) {}

  async findAll(availableOnly = false): Promise<MarketBook[]> {
    const query = availableOnly ? { isAvailable: true } : {};
    return this.marketBookModel.find(query).sort({ createdAt: -1 }).exec();
  }

  async findOne(id: string): Promise<MarketBook> {
    const book = await this.marketBookModel.findById(id).exec();
    if (!book) {
      throw new NotFoundException(`MarketBook #${id} not found`);
    }
    return book;
  }

  async create(createMarketBookDto: CreateMarketBookDto, sellerId: string): Promise<MarketBook> {
    // Convert DTO to plain object to avoid Mongoose casting issues
    const plainDto = JSON.parse(JSON.stringify(createMarketBookDto));
    const newBook = new this.marketBookModel({
      ...plainDto,
      sellerId,
    });
    return newBook.save();
  }

  async update(id: string, updateMarketBookDto: UpdateMarketBookDto): Promise<MarketBook> {
    const plainDto = JSON.parse(JSON.stringify(updateMarketBookDto));
    const existingBook = await this.marketBookModel
      .findByIdAndUpdate(id, plainDto, { new: true })
      .exec();

    if (!existingBook) {
      throw new NotFoundException(`MarketBook #${id} not found`);
    }

    return existingBook;
  }

  async remove(id: string): Promise<void> {
    const result = await this.marketBookModel.findByIdAndDelete(id).exec();
    if (!result) {
      throw new NotFoundException(`MarketBook #${id} not found`);
    }
  }
}
