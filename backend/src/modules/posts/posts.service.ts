import { Injectable } from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';
import { Model, UpdateQuery } from 'mongoose';
import { PostDocument } from './schemas/post.schema';
import {
  buildCursorPagination,
  buildOffsetPagination,
  formatCursorPaginatedResponse,
  formatOffsetPaginatedResponse,
  CursorPaginationOptions,
  OffsetPaginationOptions,
} from '../../common/utils/pagination.util';

interface PostMedia {
  type: string;
  cloudinaryUrl: string;
}

interface PostDocumentObject {
  _id: { toString(): string };
  title: string;
  summary: string;
  content: string;
  media?: PostMedia[];
  publishedAt?: Date;
  createdAt: Date;
  category?: string;
  contentType?: string;
  newsType?: string;
  projectStatus?: string;
  metadata?: Record<string, any>;
}

@Injectable()
export class PostsService {
  constructor(@InjectModel('Post') private postModel: Model<PostDocument>) {}

  async getPublicFeedSystemFixed(locale: string, options: any) {
    const pagination = buildCursorPagination(
      options as CursorPaginationOptions,
    );
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
      const p = post.toObject() as unknown as PostDocumentObject;
      const media = p.media || [];
      const image = media.find((m) => m.type === 'IMAGE');

      return {
        ...p, // Spread the original object to ensure no fields (like metadata) are lost
        _id: p._id.toString(),
        id: p._id.toString(), // Add id for frontend compatibility
        createdAt: p.createdAt, // Ensure createdAt is explicitly present
        title: p.title,
        summary: p.summary,
        content: p.content,
        imageUrl: image?.cloudinaryUrl || '',
        publishedAt: p.publishedAt || p.createdAt,
        category: p.category || 'ANNOUNCEMENT',
        contentType: p.contentType || 'NEWS',
        newsType: p.newsType || 'NORMAL',
        projectStatus: p.projectStatus || 'GENERAL',
        metadata: p.metadata || {},
      };
    });

    return {
      version: '1.2.1-metadata-fix',
      ...formatCursorPaginatedResponse(localizedPosts),
    };
  }

  async getAdminTable(options: any) {
    const { skip, limit, page } = buildOffsetPagination(
      options as OffsetPaginationOptions,
    );

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
    return this.postModel.create({
      ...(dto as Partial<PostDocument>),
      authorId,
    });
  }

  async updatePost(id: string, dto: any) {
    return this.postModel
      .findByIdAndUpdate(
        id,
        { $set: dto as UpdateQuery<PostDocument> },
        { new: true },
      )
      .exec();
  }

  async findOne(id: string) {
    return this.postModel.findById(id).exec();
  }

  async deletePost(id: string) {
    return this.postModel.findByIdAndDelete(id).exec();
  }
}
