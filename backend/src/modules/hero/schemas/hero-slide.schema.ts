import { Prop, Schema, SchemaFactory } from '@nestjs/mongoose';
import { Document } from 'mongoose';
import {
  MultilingualTextSchema,
  MultilingualText,
} from '../../institutions/schemas/institution.schema';

export type HeroSlideDocument = HeroSlide & Document;

@Schema({ timestamps: true })
export class HeroSlide {
  @Prop({ type: MultilingualTextSchema, required: true })
  title: MultilingualText;

  @Prop({ type: MultilingualTextSchema, required: true })
  subtitle: MultilingualText;

  @Prop({ type: String, required: true })
  imageUrl: string;

  @Prop({ type: String })
  buttonText?: string;

  @Prop({ type: String })
  buttonLink?: string;

  @Prop({ type: String, default: '' })
  videoUrl?: string;

  @Prop({ type: String, default: '#1A6B3A' })
  overlayColor?: string;

  @Prop({ type: Number, default: 0.1 })
  overlayOpacity: number;

  @Prop({ type: Number, default: 0 })
  order: number;

  @Prop({ type: String, enum: ['HOME', 'ONBOARDING'], default: 'HOME' })
  location: string;

  @Prop({ type: Boolean, default: true })
  isActive: boolean;
}

export const HeroSlideSchema = SchemaFactory.createForClass(HeroSlide);
