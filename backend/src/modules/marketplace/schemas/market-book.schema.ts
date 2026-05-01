import { Prop, Schema, SchemaFactory } from '@nestjs/mongoose';
import { Document, Types } from 'mongoose';

export type MarketBookDocument = MarketBook & Document;

@Schema({ timestamps: true })
export class MarketBook {
  @Prop({ type: Object, required: true })
  title: Record<string, string>;

  @Prop({ required: true })
  author: string;

  @Prop({ type: Object, required: true })
  description: Record<string, string>;

  @Prop({ required: true })
  price: number;

  @Prop({ required: true, default: 0 })
  deliveryCost: number;

  @Prop({ required: true, enum: ['NEW', 'USED'], default: 'NEW' })
  condition: string;

  @Prop({ required: true })
  coverImage: string;

  @Prop({ required: true })
  contactInfo: string;

  @Prop({ type: Types.ObjectId, ref: 'User' })
  sellerId: Types.ObjectId;

  @Prop({ default: true })
  isAvailable: boolean;
}

export const MarketBookSchema = SchemaFactory.createForClass(MarketBook);
