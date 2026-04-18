import { Prop, Schema, SchemaFactory } from '@nestjs/mongoose';
import { Document } from 'mongoose';

export type InstitutionDocument = Institution & Document;

@Schema({ _id: false })
export class MultilingualText {
  @Prop({ required: true })
  ar: string;

  @Prop({ required: false, default: '' })
  fr: string;

  @Prop({ required: false, default: '' })
  en: string;
}
export const MultilingualTextSchema = SchemaFactory.createForClass(MultilingualText);

@Schema({ timestamps: true })
export class Institution {
  @Prop({ type: MultilingualTextSchema, required: true })
  name: MultilingualText;

  @Prop({ type: String, enum: ['MUSEUM', 'UNIVERSITY', 'NETWORK', 'GOVERNMENT', 'NGO'], required: true })
  type: string;

  @Prop({ type: MultilingualTextSchema })
  description?: MultilingualText;

  @Prop({ type: Object })
  logo?: { cloudinaryUrl: string; publicId: string };

  @Prop({ type: Object })
  contactInfo?: { email?: string; phone?: string; address?: string };

  @Prop({ type: MultilingualTextSchema })
  partnershipDetails?: MultilingualText;
}

export const InstitutionSchema = SchemaFactory.createForClass(Institution);
