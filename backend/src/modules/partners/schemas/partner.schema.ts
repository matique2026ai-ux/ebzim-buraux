import { Prop, Schema, SchemaFactory } from '@nestjs/mongoose';
import { Document } from 'mongoose';
import {
  MultilingualTextSchema,
  MultilingualText,
} from '../../institutions/schemas/institution.schema';

export type PartnerDocument = Partner & Document;

@Schema({ timestamps: true })
export class Partner {
  @Prop({ type: MultilingualTextSchema, required: true })
  name: MultilingualText;

  @Prop({ type: String, required: true })
  logoUrl: string;

  @Prop({ type: MultilingualTextSchema, required: true })
  goalsSummary: MultilingualText;

  @Prop({ type: String })
  websiteUrl?: string;

  @Prop({ type: String, default: '#052011' })
  color: string;

  @Prop({ type: Number, default: 0 })
  order: number;

  @Prop({ type: Boolean, default: true })
  isActive: boolean;
}

export const PartnerSchema = SchemaFactory.createForClass(Partner);
