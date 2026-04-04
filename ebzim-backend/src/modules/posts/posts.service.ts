import { Injectable } from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';
import { Model } from 'mongoose';
import { PostDocument } from './schemas/post.schema';
import { 
  buildCursorPagination, 
  formatCursorPaginatedResponse, 
  buildOffsetPagination, 
  formatOffsetPaginatedResponse 
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
    const localizedPosts = posts.map((post) => ({
      _id: post._id,
      title: post.title[locale as keyof typeof post.title] || post.title.en,
      summary: post.summary[locale as keyof typeof post.summary] || post.summary.en,
      coverImage: post.media.find(m => m.type === 'IMAGE') || null,
      publishedAt: post.publishedAt,
    }));

    return formatCursorPaginatedResponse(localizedPosts);
  }

  async getAdminTable(options: any) {
    const { skip, limit, page } = buildOffsetPagination(options);
    
    const [posts, total] = await Promise.all([
      this.postModel.find().sort({ createdAt: -1 }).skip(skip).limit(limit).exec(),
      this.postModel.countDocuments(),
    ]);

    // Admin receives the full DB object to edit all languages globally
    return formatOffsetPaginatedResponse(posts, total, page, limit);
  }

  async createPost(dto: any, authorId: string) {
    // Implementation uses native mongoose creation
    return this.postModel.create({ ...dto, authorId });
  }
}
