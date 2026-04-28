import { Prop, Schema, SchemaFactory } from '@nestjs/mongoose';
import { Document } from 'mongoose';

export enum PublicationCategory {
  HERITAGE = 'HERITAGE',
  RESEARCH = 'RESEARCH',
  REPORTS = 'REPORTS',
  HISTORY = 'HISTORY',
  LEGAL = 'LEGAL',
  CULTURAL = 'CULTURAL',
}

@Schema({ timestamps: true })
export class Publication extends Document {
  @Prop({ type: Map, of: String, required: true })
  title: Map<string, string>; // { ar, en, fr }

  @Prop({ type: Map, of: String, required: true })
  author: Map<string, string>;

  @Prop({ type: Map, of: String, required: true })
  summary: Map<string, string>;

  @Prop({ required: true })
  thumbnailUrl: string;

  @Prop({ required: true })
  pdfUrl: string;

  @Prop({
    type: String,
    enum: PublicationCategory,
    default: PublicationCategory.CULTURAL,
  })
  category: PublicationCategory;

  @Prop({ default: Date.now })
  publishedDate: Date;

  @Prop({ type: String, default: 'SYSTEM' })
  createdBy: string;
}

export const PublicationSchema = SchemaFactory.createForClass(Publication);
