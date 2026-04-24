import { Injectable } from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';
import { Model } from 'mongoose';
import { PostDocument } from './schemas/post.schema';
import {
  buildCursorPagination,
  formatCursorPaginatedResponse,
  buildOffsetPagination,
  formatOffsetPaginatedResponse,
} from '../../common/utils/pagination.util';

@Injectable()
export class PostsService {
  constructor(@InjectModel('Post') private postModel: Model<PostDocument>) {}

  async getPublicFeed(locale: string, options: any) {
    const pagination = buildCursorPagination(options);
    const query: Record<string, any> = pagination.query;
    const limit = pagination.limit;

    // Public feed constraints
    query['status'] = 'PUBLISHED';

    const posts = await this.postModel
      .find(query)
      .sort({ _id: -1 }) // Newest first
      .limit(limit)
      .exec();

    // Multilingual payload map: Strip unneeded languages to save mobile parsing speed
    const localizedPosts = posts.map((post) => {
      const p = post.toObject();
      return {
        _id: p._id,
        title: p.title,
        summary: p.summary,
        content: p.content,
        imageUrl: p.media?.find((m: any) => m.type === 'IMAGE')?.cloudinaryUrl || '',
        publishedAt: p.publishedAt || (p as any).createdAt,
        category: p.category || 'ANNOUNCEMENT',
        projectStatus: p.projectStatus || 'GENERAL',
        metadata: p.metadata || {},
      };
    });

    return {
      version: '1.2.1-metadata-fix',
      ...formatCursorPaginatedResponse(localizedPosts)
    };
  }

  async getAdminTable(options: any) {
    const { skip, limit, page } = buildOffsetPagination(options);

    const [posts, total] = await Promise.all([
      this.postModel
        .find()
        .sort({ createdAt: -1 })
        .skip(skip)
        .limit(limit)
        .exec(),
      this.postModel.countDocuments(),
    ]);

    // Admin receives the full DB object to edit all languages globally
    return formatOffsetPaginatedResponse(posts, total, page, limit);
  }

  async createPost(dto: any, authorId: string) {
    // Implementation uses native mongoose creation
    return this.postModel.create({ ...dto, authorId });
  }

  async updatePost(id: string, dto: any) {
    return this.postModel.findByIdAndUpdate(id, dto, { new: true }).exec();
  }

  async findOne(id: string) {
    return this.postModel.findById(id).exec();
  }

  async deletePost(id: string) {
    return this.postModel.findByIdAndDelete(id).exec();
  }
}
