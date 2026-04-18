import { Injectable } from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';
import { Model } from 'mongoose';
import { CategoryDocument } from './schemas/category.schema';

@Injectable()
export class CategoriesService {
  constructor(
    @InjectModel('Category') private categoryModel: Model<CategoryDocument>,
  ) {}

  async getPublicCategories(locale: string) {
    const categories = await this.categoryModel.find().exec();

    // Flatten translation tree
    return categories.map((cat) => ({
      _id: cat._id,
      slug: cat.slug,
      name: cat.name[locale as keyof typeof cat.name] || cat.name.en,
      description: cat.description
        ? cat.description[locale as keyof typeof cat.description] ||
          cat.description.en
        : null,
      coverImage: cat.coverImage,
    }));
  }

  async getAdminCategories() {
    return this.categoryModel.find().exec();
  }

  async createCategory(dto: any) {
    return this.categoryModel.create(dto);
  }
}
