import { Injectable, ConflictException } from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';
import { Model } from 'mongoose';
import { EventDocument, EventRsvpDocument } from './schemas/event.schema';
import {
  buildCursorPagination,
  formatCursorPaginatedResponse,
  buildOffsetPagination,
  formatOffsetPaginatedResponse,
} from '../../common/utils/pagination.util';

@Injectable()
export class EventsService {
  constructor(
    @InjectModel('Event') private eventModel: Model<EventDocument>,
    @InjectModel('EventRsvp') private rsvpModel: Model<EventRsvpDocument>,
  ) {}

  async getPublicFeed(locale: string, options: any) {
    // For events, cursor could reasonably be startDate instead of _id to fetch approaching ones
    const limit = options.limit && options.limit > 0 ? options.limit : 10;
    const query: any = { publicationStatus: 'PUBLISHED' };

    if (options.cursor) {
      query.startDate = { $gte: new Date(options.cursor) }; // Fetch upcoming
    } else {
      query.startDate = { $gte: new Date() }; // Default: From now
    }

    const events = await this.eventModel
      .find(query)
      .sort({ startDate: 1 }) // Chronological order
      .limit(limit)
      .exec();

    const localizedEvents = events.map((event) => ({
      _id: event._id,
      title: event.title,
      description: event.description,
      startDate: event.startDate,
      location: event.location,
      coverImage: event.coverImage,
    }));

    const hasNextPage = localizedEvents.length > 0;
    const nextCursor = hasNextPage
      ? localizedEvents[localizedEvents.length - 1].startDate.toISOString()
      : null;

    return { data: localizedEvents, meta: { nextCursor, hasNextPage } };
  }

  async getAdminTable(options: any) {
    const { skip, limit, page } = buildOffsetPagination(options);
    const [events, total] = await Promise.all([
      this.eventModel
        .find()
        .sort({ startDate: -1 })
        .skip(skip)
        .limit(limit)
        .exec(),
      this.eventModel.countDocuments(),
    ]);
    return formatOffsetPaginatedResponse(events, total, page, limit);
  }

  async createEvent(dto: any) {
    return this.eventModel.create(dto);
  }

  async updateEvent(id: string, dto: any) {
    return this.eventModel.findByIdAndUpdate(id, dto, { new: true }).exec();
  }

  async deleteEvent(id: string) {
    return this.eventModel.findByIdAndDelete(id).exec();
  }

  async rsvp(eventId: string, userId: string) {
    try {
      return await this.rsvpModel.create({
        eventId,
        userId,
        status: 'REGISTERED',
      });
    } catch (e) {
      if (e.code === 11000) {
        throw new ConflictException(
          'User already formally registered for this event',
        );
      }
      throw e;
    }
  }
}
