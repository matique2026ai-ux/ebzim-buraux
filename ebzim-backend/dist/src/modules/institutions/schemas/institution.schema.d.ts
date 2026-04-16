import { Document } from 'mongoose';
export type InstitutionDocument = Institution & Document;
export declare class MultilingualText {
    ar: string;
    fr: string;
    en: string;
}
export declare const MultilingualTextSchema: import("mongoose").Schema<MultilingualText, import("mongoose").Model<MultilingualText, any, any, any, any, any, MultilingualText>, {}, {}, {}, {}, import("mongoose").DefaultSchemaOptions, MultilingualText, Document<unknown, {}, MultilingualText, {
    id: string;
}, import("mongoose").DefaultSchemaOptions> & Omit<MultilingualText & {
    _id: import("mongoose").Types.ObjectId;
} & {
    __v: number;
}, "id"> & {
    id: string;
}, {
    ar?: import("mongoose").SchemaDefinitionProperty<string, MultilingualText, Document<unknown, {}, MultilingualText, {
        id: string;
    }, import("mongoose").DefaultSchemaOptions> & Omit<MultilingualText & {
        _id: import("mongoose").Types.ObjectId;
    } & {
        __v: number;
    }, "id"> & {
        id: string;
    }> | undefined;
    fr?: import("mongoose").SchemaDefinitionProperty<string, MultilingualText, Document<unknown, {}, MultilingualText, {
        id: string;
    }, import("mongoose").DefaultSchemaOptions> & Omit<MultilingualText & {
        _id: import("mongoose").Types.ObjectId;
    } & {
        __v: number;
    }, "id"> & {
        id: string;
    }> | undefined;
    en?: import("mongoose").SchemaDefinitionProperty<string, MultilingualText, Document<unknown, {}, MultilingualText, {
        id: string;
    }, import("mongoose").DefaultSchemaOptions> & Omit<MultilingualText & {
        _id: import("mongoose").Types.ObjectId;
    } & {
        __v: number;
    }, "id"> & {
        id: string;
    }> | undefined;
}, MultilingualText>;
export declare class Institution {
    name: MultilingualText;
    type: string;
    description?: MultilingualText;
    logo?: {
        cloudinaryUrl: string;
        publicId: string;
    };
    contactInfo?: {
        email?: string;
        phone?: string;
        address?: string;
    };
    partnershipDetails?: MultilingualText;
}
export declare const InstitutionSchema: import("mongoose").Schema<Institution, import("mongoose").Model<Institution, any, any, any, any, any, Institution>, {}, {}, {}, {}, import("mongoose").DefaultSchemaOptions, Institution, Document<unknown, {}, Institution, {
    id: string;
}, import("mongoose").DefaultSchemaOptions> & Omit<Institution & {
    _id: import("mongoose").Types.ObjectId;
} & {
    __v: number;
}, "id"> & {
    id: string;
}, {
    name?: import("mongoose").SchemaDefinitionProperty<MultilingualText, Institution, Document<unknown, {}, Institution, {
        id: string;
    }, import("mongoose").DefaultSchemaOptions> & Omit<Institution & {
        _id: import("mongoose").Types.ObjectId;
    } & {
        __v: number;
    }, "id"> & {
        id: string;
    }> | undefined;
    type?: import("mongoose").SchemaDefinitionProperty<string, Institution, Document<unknown, {}, Institution, {
        id: string;
    }, import("mongoose").DefaultSchemaOptions> & Omit<Institution & {
        _id: import("mongoose").Types.ObjectId;
    } & {
        __v: number;
    }, "id"> & {
        id: string;
    }> | undefined;
    description?: import("mongoose").SchemaDefinitionProperty<MultilingualText | undefined, Institution, Document<unknown, {}, Institution, {
        id: string;
    }, import("mongoose").DefaultSchemaOptions> & Omit<Institution & {
        _id: import("mongoose").Types.ObjectId;
    } & {
        __v: number;
    }, "id"> & {
        id: string;
    }> | undefined;
    logo?: import("mongoose").SchemaDefinitionProperty<{
        cloudinaryUrl: string;
        publicId: string;
    } | undefined, Institution, Document<unknown, {}, Institution, {
        id: string;
    }, import("mongoose").DefaultSchemaOptions> & Omit<Institution & {
        _id: import("mongoose").Types.ObjectId;
    } & {
        __v: number;
    }, "id"> & {
        id: string;
    }> | undefined;
    contactInfo?: import("mongoose").SchemaDefinitionProperty<{
        email?: string;
        phone?: string;
        address?: string;
    } | undefined, Institution, Document<unknown, {}, Institution, {
        id: string;
    }, import("mongoose").DefaultSchemaOptions> & Omit<Institution & {
        _id: import("mongoose").Types.ObjectId;
    } & {
        __v: number;
    }, "id"> & {
        id: string;
    }> | undefined;
    partnershipDetails?: import("mongoose").SchemaDefinitionProperty<MultilingualText | undefined, Institution, Document<unknown, {}, Institution, {
        id: string;
    }, import("mongoose").DefaultSchemaOptions> & Omit<Institution & {
        _id: import("mongoose").Types.ObjectId;
    } & {
        __v: number;
    }, "id"> & {
        id: string;
    }> | undefined;
}, Institution>;
