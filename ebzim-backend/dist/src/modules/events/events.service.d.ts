import { Model } from 'mongoose';
import { EventDocument, EventRsvpDocument } from './schemas/event.schema';
export declare class EventsService {
    private eventModel;
    private rsvpModel;
    constructor(eventModel: Model<EventDocument>, rsvpModel: Model<EventRsvpDocument>);
    getPublicFeed(locale: string, options: any): Promise<{
        data: {
            _id: import("mongoose").Types.ObjectId;
            title: string;
            description: string;
            startDate: Date;
            location: import("./schemas/event.schema").LocationData | undefined;
            coverImage: {
                url: string;
                publicId: string;
            } | undefined;
        }[];
        meta: {
            nextCursor: string | null;
            hasNextPage: boolean;
        };
    }>;
    getAdminTable(options: any): Promise<{
        data: any[];
        meta: {
            total: number;
            page: number;
            limit: number;
            totalPages: number;
            hasNextPage: boolean;
        };
    }>;
    createEvent(dto: any): Promise<import("mongoose").Document<unknown, {}, EventDocument, {}, import("mongoose").DefaultSchemaOptions> & import("./schemas/event.schema").Event & import("mongoose").Document<import("mongoose").Types.ObjectId, any, any, Record<string, any>, {}> & Required<{
        _id: import("mongoose").Types.ObjectId;
    }> & {
        __v: number;
    } & {
        id: string;
    }>;
    rsvp(eventId: string, userId: string): Promise<import("mongoose").Document<unknown, {}, EventRsvpDocument, {}, import("mongoose").DefaultSchemaOptions> & import("./schemas/event.schema").EventRsvp & import("mongoose").Document<import("mongoose").Types.ObjectId, any, any, Record<string, any>, {}> & Required<{
        _id: import("mongoose").Types.ObjectId;
    }> & {
        __v: number;
    } & {
        id: string;
    }>;
}
