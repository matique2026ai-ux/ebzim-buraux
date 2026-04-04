import { Prop, Schema, SchemaFactory } from '@nestjs/mongoose';
import { Document, Types } from 'mongoose';

export type MembershipDocument = Membership & Document;

@Schema({ _id: false })
export class MembershipProfileData {
  @Prop({ required: true })
  firstName: string;

  @Prop({ required: true })
  lastName: string;

  @Prop({ required: true })
  profession: string;

  @Prop({ required: true })
  phone: string;

  @Prop({ type: [String], required: true })
  domainsOfInterest: string[];

  @Prop({ required: true })
  desiredContribution: string;
}
const MembershipProfileDataSchema = SchemaFactory.createForClass(MembershipProfileData);

@Schema({ timestamps: true })
export class Membership {
  @Prop({ type: Types.ObjectId, ref: 'User', required: true, index: true })
  userId: Types.ObjectId;

  @Prop({ type: MembershipProfileDataSchema, required: true })
  applicationData: MembershipProfileData;

  @Prop({
    type: String,
    enum: ['SUBMITTED', 'UNDER_REVIEW', 'NEEDS_INFO', 'APPROVED', 'REJECTED'],
    default: 'SUBMITTED',
    index: true,
  })
  status: string;

  @Prop({ type: Types.ObjectId, ref: 'User' })
  reviewedBy?: Types.ObjectId;

  @Prop({ type: String })
  internalReviewNotes?: string;

  @Prop({ type: Date, default: Date.now })
  submissionDate: Date;

  @Prop({ type: Date })
  reviewDate?: Date;
}

export const MembershipSchema = SchemaFactory.createForClass(Membership);
