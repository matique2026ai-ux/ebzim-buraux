import { Prop, Schema, SchemaFactory } from '@nestjs/mongoose';
import { Document, Types } from 'mongoose';
import {
  MultilingualTextSchema,
  MultilingualText,
} from '../../institutions/schemas/institution.schema';

export type EventDocument = Event & Document;

@Schema({ _id: false })
export class LocationData {
  @Prop({ type: String, enum: ['Point'], default: 'Point' })
  type: string;

  @Prop({ type: [Number], required: false })
  coordinates?: number[]; // [longitude, latitude] array

  @Prop({ type: String })
  formattedAddress?: string;
}
export const LocationDataSchema = SchemaFactory.createForClass(LocationData);

@Schema({ timestamps: true })
export class Event {
  @Prop({ type: Types.ObjectId, ref: 'Category', required: true })
  categoryId: Types.ObjectId;

  @Prop({ type: MultilingualTextSchema, required: true })
  title: MultilingualText;

  @Prop({ type: MultilingualTextSchema, required: true })
  description: MultilingualText;

  @Prop({ type: Date, required: true, index: true })
  startDate: Date;

  @Prop({ type: Date, required: true })
  endDate: Date;

  @Prop({ type: LocationDataSchema })
  location?: LocationData;

  @Prop({ type: Boolean, default: false })
  isOnline: boolean;

  @Prop({ type: Object })
  coverImage?: { url: string; publicId: string };

  @Prop({
    type: String,
    enum: ['DRAFT', 'PUBLISHED', 'CANCELLED'],
    default: 'DRAFT',
    index: true,
  })
  publicationStatus: string;

  @Prop({
    type: String,
    enum: ['UPCOMING', 'ONGOING', 'COMPLETED', 'CANCELLED'],
    default: 'UPCOMING',
    index: true,
  })
  eventStatus: string;

  @Prop({ type: Boolean, default: false })
  isFeatured: boolean;
}

export const EventSchema = SchemaFactory.createForClass(Event);

// RSVPs
export type EventRsvpDocument = EventRsvp & Document;

@Schema({ timestamps: true })
export class EventRsvp {
  @Prop({ type: Types.ObjectId, ref: 'Event', required: true, index: true })
  eventId: Types.ObjectId;

  @Prop({ type: Types.ObjectId, ref: 'User', required: true })
  userId: Types.ObjectId;

  @Prop({
    type: String,
    enum: ['REGISTERED', 'ATTENDED', 'CANCELLED'],
    default: 'REGISTERED',
  })
  status: string;
}

export const EventRsvpSchema = SchemaFactory.createForClass(EventRsvp);
// Enforce unique RSVP per user per event
EventRsvpSchema.index({ eventId: 1, userId: 1 }, { unique: true });
