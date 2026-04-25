import { Injectable, ConflictException } from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';
import { Model } from 'mongoose';
import { EventDocument, EventRsvpDocument } from './schemas/event.schema';
import {
  buildOffsetPagination,
  formatOffsetPaginatedResponse,
} from '../../common/utils/pagination.util';
import { CreateEventDto } from './dto/create-event.dto';

@Injectable()
export class EventsService {
  constructor(
    @InjectModel('Event') private eventModel: Model<EventDocument>,
    @InjectModel('EventRsvp') private rsvpModel: Model<EventRsvpDocument>,
  ) {}

  async getPublicFeed(
    locale: string,
    options: { limit?: number; cursor?: string },
  ) {
    const limit = options.limit && options.limit > 0 ? options.limit : 10;
    
    // Explicitly type the query to avoid 'any' member access errors
    const query: Record<string, any> = { publicationStatus: 'PUBLISHED' };

    if (options.cursor) {
      query.startDate = { $lt: new Date(options.cursor) };
    }

    const events = await this.eventModel
      .find(query as Record<string, any>)
      .sort({ startDate: -1 })
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

  async getAdminTable(options: { page?: number; limit?: number }) {
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

  async createEvent(dto: CreateEventDto) {
    return this.eventModel.create(dto);
  }

  async updateEvent(id: string, dto: Record<string, any>) {
    return this.eventModel.findByIdAndUpdate(id, dto, { new: true }).exec();
  }

  async deleteEvent(id: string) {
    return this.eventModel.findByIdAndDelete(id).exec();
  }

  async findOne(id: string) {
    return this.eventModel.findById(id).exec();
  }

  async rsvp(eventId: string, userId: string) {
    try {
      return await this.rsvpModel.create({
        eventId,
        userId,
        status: 'REGISTERED',
      });
    } catch (e: unknown) {
      // Use type guard or cast to handle 'code' property
      const error = e as { code?: number };
      if (error.code === 11000) {
        throw new ConflictException(
          'User already formally registered for this event',
        );
      }
      throw e;
    }
  }
}
