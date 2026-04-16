import { Document, Types } from 'mongoose';
import { LocationData } from '../../events/schemas/event.schema';
export type ReportDocument = Report & Document;
export declare class TimelineEvent {
    actorId: Types.ObjectId;
    action: string;
    details?: string;
    timestamp: Date;
}
export declare class Report {
    reporterId?: Types.ObjectId;
    isAnonymous: boolean;
    guestContactInfo?: {
        name?: string;
        email?: string;
        phone?: string;
    };
    title: string;
    description: string;
    incidentCategory: string;
    severity: string;
    priority: string;
    locationData?: LocationData;
    observationDate?: Date;
    attachments?: {
        url: string;
        publicId: string;
    }[];
    status: string;
    reviewedBy?: Types.ObjectId;
    institutionId?: Types.ObjectId;
    assignedAuthorityId?: Types.ObjectId;
    timeline: TimelineEvent[];
    resolutionNotes?: string;
    closureNotes?: string;
}
export declare const ReportSchema: import("mongoose").Schema<Report, import("mongoose").Model<Report, any, any, any, any, any, Report>, {}, {}, {}, {}, import("mongoose").DefaultSchemaOptions, Report, Document<unknown, {}, Report, {
    id: string;
}, import("mongoose").DefaultSchemaOptions> & Omit<Report & {
    _id: Types.ObjectId;
} & {
    __v: number;
}, "id"> & {
    id: string;
}, {
    reporterId?: import("mongoose").SchemaDefinitionProperty<Types.ObjectId | undefined, Report, Document<unknown, {}, Report, {
        id: string;
    }, import("mongoose").DefaultSchemaOptions> & Omit<Report & {
        _id: Types.ObjectId;
    } & {
        __v: number;
    }, "id"> & {
        id: string;
    }> | undefined;
    isAnonymous?: import("mongoose").SchemaDefinitionProperty<boolean, Report, Document<unknown, {}, Report, {
        id: string;
    }, import("mongoose").DefaultSchemaOptions> & Omit<Report & {
        _id: Types.ObjectId;
    } & {
        __v: number;
    }, "id"> & {
        id: string;
    }> | undefined;
    guestContactInfo?: import("mongoose").SchemaDefinitionProperty<{
        name?: string;
        email?: string;
        phone?: string;
    } | undefined, Report, Document<unknown, {}, Report, {
        id: string;
    }, import("mongoose").DefaultSchemaOptions> & Omit<Report & {
        _id: Types.ObjectId;
    } & {
        __v: number;
    }, "id"> & {
        id: string;
    }> | undefined;
    title?: import("mongoose").SchemaDefinitionProperty<string, Report, Document<unknown, {}, Report, {
        id: string;
    }, import("mongoose").DefaultSchemaOptions> & Omit<Report & {
        _id: Types.ObjectId;
    } & {
        __v: number;
    }, "id"> & {
        id: string;
    }> | undefined;
    description?: import("mongoose").SchemaDefinitionProperty<string, Report, Document<unknown, {}, Report, {
        id: string;
    }, import("mongoose").DefaultSchemaOptions> & Omit<Report & {
        _id: Types.ObjectId;
    } & {
        __v: number;
    }, "id"> & {
        id: string;
    }> | undefined;
    incidentCategory?: import("mongoose").SchemaDefinitionProperty<string, Report, Document<unknown, {}, Report, {
        id: string;
    }, import("mongoose").DefaultSchemaOptions> & Omit<Report & {
        _id: Types.ObjectId;
    } & {
        __v: number;
    }, "id"> & {
        id: string;
    }> | undefined;
    severity?: import("mongoose").SchemaDefinitionProperty<string, Report, Document<unknown, {}, Report, {
        id: string;
    }, import("mongoose").DefaultSchemaOptions> & Omit<Report & {
        _id: Types.ObjectId;
    } & {
        __v: number;
    }, "id"> & {
        id: string;
    }> | undefined;
    priority?: import("mongoose").SchemaDefinitionProperty<string, Report, Document<unknown, {}, Report, {
        id: string;
    }, import("mongoose").DefaultSchemaOptions> & Omit<Report & {
        _id: Types.ObjectId;
    } & {
        __v: number;
    }, "id"> & {
        id: string;
    }> | undefined;
    locationData?: import("mongoose").SchemaDefinitionProperty<LocationData | undefined, Report, Document<unknown, {}, Report, {
        id: string;
    }, import("mongoose").DefaultSchemaOptions> & Omit<Report & {
        _id: Types.ObjectId;
    } & {
        __v: number;
    }, "id"> & {
        id: string;
    }> | undefined;
    observationDate?: import("mongoose").SchemaDefinitionProperty<Date | undefined, Report, Document<unknown, {}, Report, {
        id: string;
    }, import("mongoose").DefaultSchemaOptions> & Omit<Report & {
        _id: Types.ObjectId;
    } & {
        __v: number;
    }, "id"> & {
        id: string;
    }> | undefined;
    attachments?: import("mongoose").SchemaDefinitionProperty<{
        url: string;
        publicId: string;
    }[] | undefined, Report, Document<unknown, {}, Report, {
        id: string;
    }, import("mongoose").DefaultSchemaOptions> & Omit<Report & {
        _id: Types.ObjectId;
    } & {
        __v: number;
    }, "id"> & {
        id: string;
    }> | undefined;
    status?: import("mongoose").SchemaDefinitionProperty<string, Report, Document<unknown, {}, Report, {
        id: string;
    }, import("mongoose").DefaultSchemaOptions> & Omit<Report & {
        _id: Types.ObjectId;
    } & {
        __v: number;
    }, "id"> & {
        id: string;
    }> | undefined;
    reviewedBy?: import("mongoose").SchemaDefinitionProperty<Types.ObjectId | undefined, Report, Document<unknown, {}, Report, {
        id: string;
    }, import("mongoose").DefaultSchemaOptions> & Omit<Report & {
        _id: Types.ObjectId;
    } & {
        __v: number;
    }, "id"> & {
        id: string;
    }> | undefined;
    institutionId?: import("mongoose").SchemaDefinitionProperty<Types.ObjectId | undefined, Report, Document<unknown, {}, Report, {
        id: string;
    }, import("mongoose").DefaultSchemaOptions> & Omit<Report & {
        _id: Types.ObjectId;
    } & {
        __v: number;
    }, "id"> & {
        id: string;
    }> | undefined;
    assignedAuthorityId?: import("mongoose").SchemaDefinitionProperty<Types.ObjectId | undefined, Report, Document<unknown, {}, Report, {
        id: string;
    }, import("mongoose").DefaultSchemaOptions> & Omit<Report & {
        _id: Types.ObjectId;
    } & {
        __v: number;
    }, "id"> & {
        id: string;
    }> | undefined;
    timeline?: import("mongoose").SchemaDefinitionProperty<TimelineEvent[], Report, Document<unknown, {}, Report, {
        id: string;
    }, import("mongoose").DefaultSchemaOptions> & Omit<Report & {
        _id: Types.ObjectId;
    } & {
        __v: number;
    }, "id"> & {
        id: string;
    }> | undefined;
    resolutionNotes?: import("mongoose").SchemaDefinitionProperty<string | undefined, Report, Document<unknown, {}, Report, {
        id: string;
    }, import("mongoose").DefaultSchemaOptions> & Omit<Report & {
        _id: Types.ObjectId;
    } & {
        __v: number;
    }, "id"> & {
        id: string;
    }> | undefined;
    closureNotes?: import("mongoose").SchemaDefinitionProperty<string | undefined, Report, Document<unknown, {}, Report, {
        id: string;
    }, import("mongoose").DefaultSchemaOptions> & Omit<Report & {
        _id: Types.ObjectId;
    } & {
        __v: number;
    }, "id"> & {
        id: string;
    }> | undefined;
}, Report>;
