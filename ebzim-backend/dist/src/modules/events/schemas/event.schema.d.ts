import { Document, Types } from 'mongoose';
import { MultilingualText } from '../../institutions/schemas/institution.schema';
export type EventDocument = Event & Document;
export declare class LocationData {
    type: string;
    coordinates?: number[];
    formattedAddress?: string;
}
export declare const LocationDataSchema: import("mongoose").Schema<LocationData, import("mongoose").Model<LocationData, any, any, any, any, any, LocationData>, {}, {}, {}, {}, import("mongoose").DefaultSchemaOptions, LocationData, Document<unknown, {}, LocationData, {
    id: string;
}, import("mongoose").DefaultSchemaOptions> & Omit<LocationData & {
    _id: Types.ObjectId;
} & {
    __v: number;
}, "id"> & {
    id: string;
}, {
    type?: import("mongoose").SchemaDefinitionProperty<string, LocationData, Document<unknown, {}, LocationData, {
        id: string;
    }, import("mongoose").DefaultSchemaOptions> & Omit<LocationData & {
        _id: Types.ObjectId;
    } & {
        __v: number;
    }, "id"> & {
        id: string;
    }> | undefined;
    coordinates?: import("mongoose").SchemaDefinitionProperty<number[] | undefined, LocationData, Document<unknown, {}, LocationData, {
        id: string;
    }, import("mongoose").DefaultSchemaOptions> & Omit<LocationData & {
        _id: Types.ObjectId;
    } & {
        __v: number;
    }, "id"> & {
        id: string;
    }> | undefined;
    formattedAddress?: import("mongoose").SchemaDefinitionProperty<string | undefined, LocationData, Document<unknown, {}, LocationData, {
        id: string;
    }, import("mongoose").DefaultSchemaOptions> & Omit<LocationData & {
        _id: Types.ObjectId;
    } & {
        __v: number;
    }, "id"> & {
        id: string;
    }> | undefined;
}, LocationData>;
export declare class Event {
    categoryId: Types.ObjectId;
    title: MultilingualText;
    description: MultilingualText;
    startDate: Date;
    endDate: Date;
    location?: LocationData;
    isOnline: boolean;
    coverImage?: {
        url: string;
        publicId: string;
    };
    publicationStatus: string;
    eventStatus: string;
    isFeatured: boolean;
}
export declare const EventSchema: import("mongoose").Schema<Event, import("mongoose").Model<Event, any, any, any, any, any, Event>, {}, {}, {}, {}, import("mongoose").DefaultSchemaOptions, Event, Document<unknown, {}, Event, {
    id: string;
}, import("mongoose").DefaultSchemaOptions> & Omit<Event & {
    _id: Types.ObjectId;
} & {
    __v: number;
}, "id"> & {
    id: string;
}, {
    categoryId?: import("mongoose").SchemaDefinitionProperty<Types.ObjectId, Event, Document<unknown, {}, Event, {
        id: string;
    }, import("mongoose").DefaultSchemaOptions> & Omit<Event & {
        _id: Types.ObjectId;
    } & {
        __v: number;
    }, "id"> & {
        id: string;
    }> | undefined;
    title?: import("mongoose").SchemaDefinitionProperty<MultilingualText, Event, Document<unknown, {}, Event, {
        id: string;
    }, import("mongoose").DefaultSchemaOptions> & Omit<Event & {
        _id: Types.ObjectId;
    } & {
        __v: number;
    }, "id"> & {
        id: string;
    }> | undefined;
    description?: import("mongoose").SchemaDefinitionProperty<MultilingualText, Event, Document<unknown, {}, Event, {
        id: string;
    }, import("mongoose").DefaultSchemaOptions> & Omit<Event & {
        _id: Types.ObjectId;
    } & {
        __v: number;
    }, "id"> & {
        id: string;
    }> | undefined;
    startDate?: import("mongoose").SchemaDefinitionProperty<Date, Event, Document<unknown, {}, Event, {
        id: string;
    }, import("mongoose").DefaultSchemaOptions> & Omit<Event & {
        _id: Types.ObjectId;
    } & {
        __v: number;
    }, "id"> & {
        id: string;
    }> | undefined;
    endDate?: import("mongoose").SchemaDefinitionProperty<Date, Event, Document<unknown, {}, Event, {
        id: string;
    }, import("mongoose").DefaultSchemaOptions> & Omit<Event & {
        _id: Types.ObjectId;
    } & {
        __v: number;
    }, "id"> & {
        id: string;
    }> | undefined;
    location?: import("mongoose").SchemaDefinitionProperty<LocationData | undefined, Event, Document<unknown, {}, Event, {
        id: string;
    }, import("mongoose").DefaultSchemaOptions> & Omit<Event & {
        _id: Types.ObjectId;
    } & {
        __v: number;
    }, "id"> & {
        id: string;
    }> | undefined;
    isOnline?: import("mongoose").SchemaDefinitionProperty<boolean, Event, Document<unknown, {}, Event, {
        id: string;
    }, import("mongoose").DefaultSchemaOptions> & Omit<Event & {
        _id: Types.ObjectId;
    } & {
        __v: number;
    }, "id"> & {
        id: string;
    }> | undefined;
    coverImage?: import("mongoose").SchemaDefinitionProperty<{
        url: string;
        publicId: string;
    } | undefined, Event, Document<unknown, {}, Event, {
        id: string;
    }, import("mongoose").DefaultSchemaOptions> & Omit<Event & {
        _id: Types.ObjectId;
    } & {
        __v: number;
    }, "id"> & {
        id: string;
    }> | undefined;
    publicationStatus?: import("mongoose").SchemaDefinitionProperty<string, Event, Document<unknown, {}, Event, {
        id: string;
    }, import("mongoose").DefaultSchemaOptions> & Omit<Event & {
        _id: Types.ObjectId;
    } & {
        __v: number;
    }, "id"> & {
        id: string;
    }> | undefined;
    eventStatus?: import("mongoose").SchemaDefinitionProperty<string, Event, Document<unknown, {}, Event, {
        id: string;
    }, import("mongoose").DefaultSchemaOptions> & Omit<Event & {
        _id: Types.ObjectId;
    } & {
        __v: number;
    }, "id"> & {
        id: string;
    }> | undefined;
    isFeatured?: import("mongoose").SchemaDefinitionProperty<boolean, Event, Document<unknown, {}, Event, {
        id: string;
    }, import("mongoose").DefaultSchemaOptions> & Omit<Event & {
        _id: Types.ObjectId;
    } & {
        __v: number;
    }, "id"> & {
        id: string;
    }> | undefined;
}, Event>;
export type EventRsvpDocument = EventRsvp & Document;
export declare class EventRsvp {
    eventId: Types.ObjectId;
    userId: Types.ObjectId;
    status: string;
}
export declare const EventRsvpSchema: import("mongoose").Schema<EventRsvp, import("mongoose").Model<EventRsvp, any, any, any, any, any, EventRsvp>, {}, {}, {}, {}, import("mongoose").DefaultSchemaOptions, EventRsvp, Document<unknown, {}, EventRsvp, {
    id: string;
}, import("mongoose").DefaultSchemaOptions> & Omit<EventRsvp & {
    _id: Types.ObjectId;
} & {
    __v: number;
}, "id"> & {
    id: string;
}, {
    eventId?: import("mongoose").SchemaDefinitionProperty<Types.ObjectId, EventRsvp, Document<unknown, {}, EventRsvp, {
        id: string;
    }, import("mongoose").DefaultSchemaOptions> & Omit<EventRsvp & {
        _id: Types.ObjectId;
    } & {
        __v: number;
    }, "id"> & {
        id: string;
    }> | undefined;
    userId?: import("mongoose").SchemaDefinitionProperty<Types.ObjectId, EventRsvp, Document<unknown, {}, EventRsvp, {
        id: string;
    }, import("mongoose").DefaultSchemaOptions> & Omit<EventRsvp & {
        _id: Types.ObjectId;
    } & {
        __v: number;
    }, "id"> & {
        id: string;
    }> | undefined;
    status?: import("mongoose").SchemaDefinitionProperty<string, EventRsvp, Document<unknown, {}, EventRsvp, {
        id: string;
    }, import("mongoose").DefaultSchemaOptions> & Omit<EventRsvp & {
        _id: Types.ObjectId;
    } & {
        __v: number;
    }, "id"> & {
        id: string;
    }> | undefined;
}, EventRsvp>;
