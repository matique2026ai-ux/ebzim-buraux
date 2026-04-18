import { Document } from 'mongoose';
import { MultilingualText } from '../../institutions/schemas/institution.schema';
export type PartnerDocument = Partner & Document;
export declare class Partner {
    name: MultilingualText;
    logoUrl: string;
    goalsSummary: MultilingualText;
    websiteUrl?: string;
    color: string;
    order: number;
    isActive: boolean;
}
export declare const PartnerSchema: import("mongoose").Schema<Partner, import("mongoose").Model<Partner, any, any, any, any, any, Partner>, {}, {}, {}, {}, import("mongoose").DefaultSchemaOptions, Partner, Document<unknown, {}, Partner, {
    id: string;
}, import("mongoose").DefaultSchemaOptions> & Omit<Partner & {
    _id: import("mongoose").Types.ObjectId;
} & {
    __v: number;
}, "id"> & {
    id: string;
}, {
    name?: import("mongoose").SchemaDefinitionProperty<MultilingualText, Partner, Document<unknown, {}, Partner, {
        id: string;
    }, import("mongoose").DefaultSchemaOptions> & Omit<Partner & {
        _id: import("mongoose").Types.ObjectId;
    } & {
        __v: number;
    }, "id"> & {
        id: string;
    }> | undefined;
    logoUrl?: import("mongoose").SchemaDefinitionProperty<string, Partner, Document<unknown, {}, Partner, {
        id: string;
    }, import("mongoose").DefaultSchemaOptions> & Omit<Partner & {
        _id: import("mongoose").Types.ObjectId;
    } & {
        __v: number;
    }, "id"> & {
        id: string;
    }> | undefined;
    goalsSummary?: import("mongoose").SchemaDefinitionProperty<MultilingualText, Partner, Document<unknown, {}, Partner, {
        id: string;
    }, import("mongoose").DefaultSchemaOptions> & Omit<Partner & {
        _id: import("mongoose").Types.ObjectId;
    } & {
        __v: number;
    }, "id"> & {
        id: string;
    }> | undefined;
    websiteUrl?: import("mongoose").SchemaDefinitionProperty<string | undefined, Partner, Document<unknown, {}, Partner, {
        id: string;
    }, import("mongoose").DefaultSchemaOptions> & Omit<Partner & {
        _id: import("mongoose").Types.ObjectId;
    } & {
        __v: number;
    }, "id"> & {
        id: string;
    }> | undefined;
    color?: import("mongoose").SchemaDefinitionProperty<string, Partner, Document<unknown, {}, Partner, {
        id: string;
    }, import("mongoose").DefaultSchemaOptions> & Omit<Partner & {
        _id: import("mongoose").Types.ObjectId;
    } & {
        __v: number;
    }, "id"> & {
        id: string;
    }> | undefined;
    order?: import("mongoose").SchemaDefinitionProperty<number, Partner, Document<unknown, {}, Partner, {
        id: string;
    }, import("mongoose").DefaultSchemaOptions> & Omit<Partner & {
        _id: import("mongoose").Types.ObjectId;
    } & {
        __v: number;
    }, "id"> & {
        id: string;
    }> | undefined;
    isActive?: import("mongoose").SchemaDefinitionProperty<boolean, Partner, Document<unknown, {}, Partner, {
        id: string;
    }, import("mongoose").DefaultSchemaOptions> & Omit<Partner & {
        _id: import("mongoose").Types.ObjectId;
    } & {
        __v: number;
    }, "id"> & {
        id: string;
    }> | undefined;
}, Partner>;
