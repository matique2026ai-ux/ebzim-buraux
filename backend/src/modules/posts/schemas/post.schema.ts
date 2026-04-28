import { Prop, Schema, SchemaFactory } from '@nestjs/mongoose';
import { Document, Types } from 'mongoose';
import {
  MultilingualTextSchema,
  MultilingualText,
} from '../../institutions/schemas/institution.schema';

export type PostDocument = Post & Document;

@Schema({ _id: false })
export class MediaAttachment {
  @Prop({ type: String, enum: ['IMAGE', 'VIDEO', 'DOCUMENT'], required: true })
  type: string;

  @Prop({ required: true })
  cloudinaryUrl: string;

  @Prop({ required: true })
  publicId: string;
}
const MediaAttachmentSchema = SchemaFactory.createForClass(MediaAttachment);

@Schema({ timestamps: true })
export class Post {
  @Prop({ type: Types.ObjectId, ref: 'User', required: true })
  authorId: Types.ObjectId;

  @Prop({ type: Types.ObjectId, ref: 'Category', required: true })
  categoryId: Types.ObjectId;

  @Prop({ type: MultilingualTextSchema, required: true })
  title: MultilingualText;

  @Prop({ type: MultilingualTextSchema, required: true })
  summary: MultilingualText;

  @Prop({ type: MultilingualTextSchema, required: true })
  content: MultilingualText; // Will hold Tiptap HTML/JSON

  @Prop({ type: [MediaAttachmentSchema], default: [] })
  media: MediaAttachment[];

  @Prop({
    type: String,
    enum: ['DRAFT', 'PUBLISHED', 'ARCHIVED'],
    default: 'DRAFT',
  })
  status: string;

  @Prop({ type: Boolean, default: false })
  isFeatured: boolean;

  @Prop({ type: Boolean, default: false })
  isPinned: boolean;

  @Prop({ type: String, default: 'ANNOUNCEMENT' })
  category: string;

  @Prop({
    type: String,
    enum: ['NEWS', 'PROJECT'],
    default: 'NEWS',
  })
  contentType: string;

  @Prop({
    type: String,
    enum: ['NORMAL', 'URGENT', 'IMPORTANT'],
    default: 'NORMAL',
  })
  newsType: string;

  @Prop({
    type: String,
    enum: [
      'PREPARING',
      'LAUNCHING',
      'ACTIVE',
      'ON_HOLD',
      'COMPLETED',
      'GENERAL',
    ],
    default: 'GENERAL',
  })
  projectStatus: string;

  @Prop({ type: Number, default: 0, min: 0, max: 100 })
  progressPercentage: number;

  @Prop({ type: [Object], default: [] })
  milestones: any[];

  @Prop({ type: Object, default: {} })
  metadata: Record<string, any>;

  @Prop({ type: Date })
  publishedAt?: Date;
}

export const PostSchema = SchemaFactory.createForClass(Post);
