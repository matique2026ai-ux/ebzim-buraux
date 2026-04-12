import { Prop, Schema, SchemaFactory } from '@nestjs/mongoose';
import { Document, Types } from 'mongoose';

export type ContributionDocument = Contribution & Document;

@Schema({ timestamps: true })
export class Contribution {
  @Prop({ type: Types.ObjectId, ref: 'User', required: true })
  userId: Types.ObjectId;

  @Prop({ required: true })
  amount: number;

  @Prop({ 
    type: String, 
    enum: ['ANNUAL_MEMBERSHIP', 'GENERAL_DONATION', 'PROJECT_SUPPORT'], 
    required: true 
  })
  type: string;

  @Prop()
  projectId?: string; // Optional restoration project ID

  @Prop({ 
    type: String, 
    enum: ['PENDING', 'VERIFIED', 'REJECTED'], 
    default: 'PENDING' 
  })
  status: string;

  @Prop()
  proofUrl?: string; // URL to uploaded payment proof image

  @Prop()
  notes?: string;

  @Prop()
  internalReviewNotes?: string;

  @Prop({ type: Types.ObjectId, ref: 'User' })
  reviewedBy?: Types.ObjectId;
}

export const ContributionSchema = SchemaFactory.createForClass(Contribution);
