import { Prop, Schema, SchemaFactory } from '@nestjs/mongoose';
import { Document, Types } from 'mongoose';
import {
  LocationData,
  LocationDataSchema,
} from '../../events/schemas/event.schema';

export type ReportDocument = Report & Document;

@Schema({ _id: false })
export class TimelineEvent {
  @Prop({ type: Types.ObjectId, ref: 'User', required: true })
  actorId: Types.ObjectId;

  @Prop({ type: String, required: true }) // e.g., STATUS_CHANGE, NOTE_ADDED
  action: string;

  @Prop({ type: String })
  details?: string;

  @Prop({ type: Date, default: Date.now })
  timestamp: Date;
}
const TimelineEventSchema = SchemaFactory.createForClass(TimelineEvent);

@Schema({ timestamps: true })
export class Report {
  // Can be null if totally anonymous guest
  @Prop({ type: Types.ObjectId, ref: 'User' })
  reporterId?: Types.ObjectId;

  @Prop({ type: Boolean, default: false })
  isAnonymous: boolean;

  // Track optional info if guest submits without an account
  @Prop({ type: Object })
  guestContactInfo?: { name?: string; email?: string; phone?: string };

  @Prop({ required: true })
  title: string;

  @Prop({ required: true })
  description: string;

  @Prop({
    type: String,
    enum: [
      'VANDALISM',
      'THEFT',
      'ILLEGAL_CONSTRUCTION',
      'NEGLECT',
      'PUBLIC_SPACE',
      'OTHER',
    ],
    required: true,
  })
  incidentCategory: string;

  @Prop({
    type: String,
    enum: ['LOW', 'MEDIUM', 'HIGH', 'CRITICAL'],
    default: 'MEDIUM',
  })
  severity: string;

  @Prop({ type: String, enum: ['LOW', 'NORMAL', 'URGENT'], default: 'NORMAL' })
  priority: string;

  @Prop({ type: LocationDataSchema })
  locationData?: LocationData;

  @Prop({ type: Date })
  observationDate?: Date;

  @Prop({ type: [{ type: Object }] }) // Array of Media assets
  attachments?: { url: string; publicId: string }[];

  @Prop({
    type: String,
    enum: [
      'SUBMITTED',
      'TRIAGED_BY_ASSOCIATION',
      'UNDER_REVIEW',
      'ASSIGNED_TO_AUTHORITY',
      'IN_INTERVENTION',
      'NEEDS_MORE_INFO',
      'RESOLVED',
      'CLOSED',
      'REJECTED',
    ],
    default: 'SUBMITTED',
    index: true,
  })
  status: string;

  // Workflow Tracing
  @Prop({ type: Types.ObjectId, ref: 'User' }) // Admin who handles it
  reviewedBy?: Types.ObjectId;

  @Prop({ type: Types.ObjectId, ref: 'Institution' }) // The specific police/museum linked
  institutionId?: Types.ObjectId;

  @Prop({ type: Types.ObjectId, ref: 'User' }) // The specific Authority account assigned
  assignedAuthorityId?: Types.ObjectId;

  @Prop({ type: [TimelineEventSchema], default: [] })
  timeline: TimelineEvent[];

  @Prop({ type: String })
  resolutionNotes?: string;

  @Prop({ type: String })
  closureNotes?: string;
}

export const ReportSchema = SchemaFactory.createForClass(Report);
