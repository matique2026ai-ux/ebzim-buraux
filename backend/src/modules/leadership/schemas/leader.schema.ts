import { Prop, Schema, SchemaFactory } from '@nestjs/mongoose';
import { Document } from 'mongoose';
import {
  MultilingualTextSchema,
  MultilingualText,
} from '../../institutions/schemas/institution.schema';

export type LeaderDocument = Leader & Document;

@Schema({ timestamps: true })
export class Leader {
  @Prop({ type: MultilingualTextSchema, required: true })
  name: MultilingualText;

  @Prop({ type: MultilingualTextSchema, required: true })
  role: MultilingualText;

  @Prop({ type: String })
  photoUrl?: string;

  @Prop({ type: Number, default: 0 })
  order: number;

  @Prop({ type: Boolean, default: true })
  isActive: boolean;
}

export const LeaderSchema = SchemaFactory.createForClass(Leader);
