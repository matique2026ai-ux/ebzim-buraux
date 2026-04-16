import { Document, Types } from 'mongoose';
export type ContributionDocument = Contribution & Document;
export declare class Contribution {
    userId: Types.ObjectId;
    amount: number;
    type: string;
    projectId?: string;
    status: string;
    proofUrl?: string;
    notes?: string;
    internalReviewNotes?: string;
    reviewedBy?: Types.ObjectId;
}
export declare const ContributionSchema: import("mongoose").Schema<Contribution, import("mongoose").Model<Contribution, any, any, any, any, any, Contribution>, {}, {}, {}, {}, import("mongoose").DefaultSchemaOptions, Contribution, Document<unknown, {}, Contribution, {
    id: string;
}, import("mongoose").DefaultSchemaOptions> & Omit<Contribution & {
    _id: Types.ObjectId;
} & {
    __v: number;
}, "id"> & {
    id: string;
}, {
    userId?: import("mongoose").SchemaDefinitionProperty<Types.ObjectId, Contribution, Document<unknown, {}, Contribution, {
        id: string;
    }, import("mongoose").DefaultSchemaOptions> & Omit<Contribution & {
        _id: Types.ObjectId;
    } & {
        __v: number;
    }, "id"> & {
        id: string;
    }> | undefined;
    amount?: import("mongoose").SchemaDefinitionProperty<number, Contribution, Document<unknown, {}, Contribution, {
        id: string;
    }, import("mongoose").DefaultSchemaOptions> & Omit<Contribution & {
        _id: Types.ObjectId;
    } & {
        __v: number;
    }, "id"> & {
        id: string;
    }> | undefined;
    type?: import("mongoose").SchemaDefinitionProperty<string, Contribution, Document<unknown, {}, Contribution, {
        id: string;
    }, import("mongoose").DefaultSchemaOptions> & Omit<Contribution & {
        _id: Types.ObjectId;
    } & {
        __v: number;
    }, "id"> & {
        id: string;
    }> | undefined;
    projectId?: import("mongoose").SchemaDefinitionProperty<string | undefined, Contribution, Document<unknown, {}, Contribution, {
        id: string;
    }, import("mongoose").DefaultSchemaOptions> & Omit<Contribution & {
        _id: Types.ObjectId;
    } & {
        __v: number;
    }, "id"> & {
        id: string;
    }> | undefined;
    status?: import("mongoose").SchemaDefinitionProperty<string, Contribution, Document<unknown, {}, Contribution, {
        id: string;
    }, import("mongoose").DefaultSchemaOptions> & Omit<Contribution & {
        _id: Types.ObjectId;
    } & {
        __v: number;
    }, "id"> & {
        id: string;
    }> | undefined;
    proofUrl?: import("mongoose").SchemaDefinitionProperty<string | undefined, Contribution, Document<unknown, {}, Contribution, {
        id: string;
    }, import("mongoose").DefaultSchemaOptions> & Omit<Contribution & {
        _id: Types.ObjectId;
    } & {
        __v: number;
    }, "id"> & {
        id: string;
    }> | undefined;
    notes?: import("mongoose").SchemaDefinitionProperty<string | undefined, Contribution, Document<unknown, {}, Contribution, {
        id: string;
    }, import("mongoose").DefaultSchemaOptions> & Omit<Contribution & {
        _id: Types.ObjectId;
    } & {
        __v: number;
    }, "id"> & {
        id: string;
    }> | undefined;
    internalReviewNotes?: import("mongoose").SchemaDefinitionProperty<string | undefined, Contribution, Document<unknown, {}, Contribution, {
        id: string;
    }, import("mongoose").DefaultSchemaOptions> & Omit<Contribution & {
        _id: Types.ObjectId;
    } & {
        __v: number;
    }, "id"> & {
        id: string;
    }> | undefined;
    reviewedBy?: import("mongoose").SchemaDefinitionProperty<Types.ObjectId | undefined, Contribution, Document<unknown, {}, Contribution, {
        id: string;
    }, import("mongoose").DefaultSchemaOptions> & Omit<Contribution & {
        _id: Types.ObjectId;
    } & {
        __v: number;
    }, "id"> & {
        id: string;
    }> | undefined;
}, Contribution>;
