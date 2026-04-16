import { EventsService } from './events.service';
import { CreateEventDto } from './dto/create-event.dto';
export declare class EventsController {
    private readonly eventsService;
    constructor(eventsService: EventsService);
    getPublicFeed(lang: string, cursor: string, limit: number): Promise<{
        data: {
            _id: import("mongoose").Types.ObjectId;
            title: import("../institutions/schemas/institution.schema").MultilingualText;
            description: import("../institutions/schemas/institution.schema").MultilingualText;
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
    getAdminTable(page: number, limit: number): Promise<{
        data: any[];
        meta: {
            total: number;
            page: number;
            limit: number;
            totalPages: number;
            hasNextPage: boolean;
        };
    }>;
    createEvent(dto: CreateEventDto): Promise<import("mongoose").Document<unknown, {}, import("./schemas/event.schema").EventDocument, {}, import("mongoose").DefaultSchemaOptions> & import("./schemas/event.schema").Event & import("mongoose").Document<import("mongoose").Types.ObjectId, any, any, Record<string, any>, {}> & Required<{
        _id: import("mongoose").Types.ObjectId;
    }> & {
        __v: number;
    } & {
        id: string;
    }>;
    updateEvent(id: string, updateData: any): Promise<(import("mongoose").Document<unknown, {}, import("./schemas/event.schema").EventDocument, {}, import("mongoose").DefaultSchemaOptions> & import("./schemas/event.schema").Event & import("mongoose").Document<import("mongoose").Types.ObjectId, any, any, Record<string, any>, {}> & Required<{
        _id: import("mongoose").Types.ObjectId;
    }> & {
        __v: number;
    } & {
        id: string;
    }) | null>;
    deleteEvent(id: string): Promise<(import("mongoose").Document<unknown, {}, import("./schemas/event.schema").EventDocument, {}, import("mongoose").DefaultSchemaOptions> & import("./schemas/event.schema").Event & import("mongoose").Document<import("mongoose").Types.ObjectId, any, any, Record<string, any>, {}> & Required<{
        _id: import("mongoose").Types.ObjectId;
    }> & {
        __v: number;
    } & {
        id: string;
    }) | null>;
    rsvpToEvent(eventId: string, req: {
        user?: any;
    }): Promise<import("mongoose").Document<unknown, {}, import("./schemas/event.schema").EventRsvpDocument, {}, import("mongoose").DefaultSchemaOptions> & import("./schemas/event.schema").EventRsvp & import("mongoose").Document<import("mongoose").Types.ObjectId, any, any, Record<string, any>, {}> & Required<{
        _id: import("mongoose").Types.ObjectId;
    }> & {
        __v: number;
    } & {
        id: string;
    }>;
}
