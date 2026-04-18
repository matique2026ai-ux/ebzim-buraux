import { Prop, Schema, SchemaFactory } from '@nestjs/mongoose';
import { Document } from 'mongoose';
import {
  MultilingualTextSchema,
  MultilingualText,
} from '../../institutions/schemas/institution.schema'; // Re-use embedded pattern

export type CategoryDocument = Category & Document;

@Schema({ timestamps: true })
export class Category {
  @Prop({ required: true, unique: true })
  slug: string; // e.g., 'heritage', 'events'

  @Prop({ type: MultilingualTextSchema, required: true })
  name: MultilingualText;

  @Prop({ type: MultilingualTextSchema })
  description?: MultilingualText;

  @Prop({ type: Object })
  coverImage?: { url: string; publicId: string };
}

export const CategorySchema = SchemaFactory.createForClass(Category);
