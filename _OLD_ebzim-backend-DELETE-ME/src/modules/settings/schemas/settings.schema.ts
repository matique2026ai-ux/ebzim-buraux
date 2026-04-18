import { Prop, Schema, SchemaFactory } from '@nestjs/mongoose';
import { Document } from 'mongoose';

export type SettingsDocument = Settings & Document;

@Schema({ timestamps: true })
export class Settings {
  @Prop({ default: 2000 })
  annualMembershipFee: number;

  @Prop({ default: 'DZD' })
  currency: string;

  @Prop({ type: Object, default: {} })
  otherConfigs: Record<string, any>;
}

export const SettingsSchema = SchemaFactory.createForClass(Settings);
