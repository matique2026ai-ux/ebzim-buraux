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
  publicId: string;
}

interface PostData {
  _id: any;
  id?: string;
  authorId: any;
  categoryId: any;
  title: any;
  summary: any;
  content: any;
  media: PostMedia[];
  status: string;
  isFeatured: boolean;
  isPinned: boolean;
  category: string;
  contentType: string;
  newsType: string;
  projectStatus: string;
  progressPercentage: number;
  milestones: any[];
  metadata: Record<string, any>;
  publishedAt?: Date;
  createdAt: Date;
}

@Injectable()
export class PostsService {
  constructor(@InjectModel('Post') private postModel: Model<PostDocument>) {}

  private _normalizePost(post: PostDocument): Record<string, any> {
    const p = post.toObject() as PostData;
    const media = p.media || [];
    const image = media.find((m) => m.type === 'IMAGE');
    const metadata = p.metadata || {};

    // Logic Bridge: Lift metadata fields to root if root is empty
    const progress =
      p.progressPercentage ||
      metadata.progress ||
      metadata.progressPercentage ||
      0;

    const milestones =
      p.milestones && p.milestones.length > 0
        ? p.milestones
        : metadata.milestones || [];

    const projectStatus =
      p.projectStatus && p.projectStatus !== 'GENERAL'
        ? p.projectStatus
        : metadata.projectStatus || 'GENERAL';

    return {
      ...p,
      _id: p._id.toString(),
      id: p._id.toString(),
      createdAt: p.createdAt,
      imageUrl: image?.cloudinaryUrl || '',
      publishedAt: p.publishedAt || p.createdAt,
      category: p.category || 'ANNOUNCEMENT',
      contentType: p.contentType || 'NEWS',
      newsType: p.newsType || 'NORMAL',
      projectStatus: projectStatus,
      progressPercentage: Number(progress),
      milestones: milestones as any[],
      metadata: metadata,
    };
  }

  async getPublicFeedSystemFixed(
    locale: string,
    options: OffsetPaginationOptions,
  ) {
    const pagination = buildCursorPagination(
      options as CursorPaginationOptions,
    );
    const query: Record<string, any> = pagination.query;
    const limit = pagination.limit;

    query['status'] = 'PUBLISHED';

    const posts = await this.postModel
      .find(query)
      .sort({ _id: -1 })
      .limit(limit)
      .exec();

    const localizedPosts = posts.map((post) => this._normalizePost(post));

    return {
      version: '1.3.0-professional-logic',
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
