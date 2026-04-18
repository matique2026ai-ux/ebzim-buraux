import { Document } from 'mongoose';
import { MultilingualText } from '../../institutions/schemas/institution.schema';
export type LeaderDocument = Leader & Document;
export declare class Leader {
    name: MultilingualText;
    role: MultilingualText;
    photoUrl?: string;
    order: number;
    isActive: boolean;
}
export declare const LeaderSchema: import("mongoose").Schema<Leader, import("mongoose").Model<Leader, any, any, any, any, any, Leader>, {}, {}, {}, {}, import("mongoose").DefaultSchemaOptions, Leader, Document<unknown, {}, Leader, {
    id: string;
}, import("mongoose").DefaultSchemaOptions> & Omit<Leader & {
    _id: import("mongoose").Types.ObjectId;
} & {
    __v: number;
}, "id"> & {
    id: string;
}, {
    name?: import("mongoose").SchemaDefinitionProperty<MultilingualText, Leader, Document<unknown, {}, Leader, {
        id: string;
    }, import("mongoose").DefaultSchemaOptions> & Omit<Leader & {
        _id: import("mongoose").Types.ObjectId;
    } & {
        __v: number;
    }, "id"> & {
        id: string;
    }> | undefined;
    role?: import("mongoose").SchemaDefinitionProperty<MultilingualText, Leader, Document<unknown, {}, Leader, {
        id: string;
    }, import("mongoose").DefaultSchemaOptions> & Omit<Leader & {
        _id: import("mongoose").Types.ObjectId;
    } & {
        __v: number;
    }, "id"> & {
        id: string;
    }> | undefined;
    photoUrl?: import("mongoose").SchemaDefinitionProperty<string | undefined, Leader, Document<unknown, {}, Leader, {
        id: string;
    }, import("mongoose").DefaultSchemaOptions> & Omit<Leader & {
        _id: import("mongoose").Types.ObjectId;
    } & {
        __v: number;
    }, "id"> & {
        id: string;
    }> | undefined;
    order?: import("mongoose").SchemaDefinitionProperty<number, Leader, Document<unknown, {}, Leader, {
        id: string;
    }, import("mongoose").DefaultSchemaOptions> & Omit<Leader & {
        _id: import("mongoose").Types.ObjectId;
    } & {
        __v: number;
    }, "id"> & {
        id: string;
    }> | undefined;
    isActive?: import("mongoose").SchemaDefinitionProperty<boolean, Leader, Document<unknown, {}, Leader, {
        id: string;
    }, import("mongoose").DefaultSchemaOptions> & Omit<Leader & {
        _id: import("mongoose").Types.ObjectId;
    } & {
        __v: number;
    }, "id"> & {
        id: string;
    }> | undefined;
}, Leader>;
