import { Document } from 'mongoose';
import { MultilingualText } from '../../institutions/schemas/institution.schema';
export type HeroSlideDocument = HeroSlide & Document;
export declare class HeroSlide {
    title: MultilingualText;
    subtitle: MultilingualText;
    imageUrl: string;
    buttonText?: string;
    buttonLink?: string;
    order: number;
    isActive: boolean;
}
export declare const HeroSlideSchema: import("mongoose").Schema<HeroSlide, import("mongoose").Model<HeroSlide, any, any, any, any, any, HeroSlide>, {}, {}, {}, {}, import("mongoose").DefaultSchemaOptions, HeroSlide, Document<unknown, {}, HeroSlide, {
    id: string;
}, import("mongoose").DefaultSchemaOptions> & Omit<HeroSlide & {
    _id: import("mongoose").Types.ObjectId;
} & {
    __v: number;
}, "id"> & {
    id: string;
}, {
    title?: import("mongoose").SchemaDefinitionProperty<MultilingualText, HeroSlide, Document<unknown, {}, HeroSlide, {
        id: string;
    }, import("mongoose").DefaultSchemaOptions> & Omit<HeroSlide & {
        _id: import("mongoose").Types.ObjectId;
    } & {
        __v: number;
    }, "id"> & {
        id: string;
    }> | undefined;
    subtitle?: import("mongoose").SchemaDefinitionProperty<MultilingualText, HeroSlide, Document<unknown, {}, HeroSlide, {
        id: string;
    }, import("mongoose").DefaultSchemaOptions> & Omit<HeroSlide & {
        _id: import("mongoose").Types.ObjectId;
    } & {
        __v: number;
    }, "id"> & {
        id: string;
    }> | undefined;
    imageUrl?: import("mongoose").SchemaDefinitionProperty<string, HeroSlide, Document<unknown, {}, HeroSlide, {
        id: string;
    }, import("mongoose").DefaultSchemaOptions> & Omit<HeroSlide & {
        _id: import("mongoose").Types.ObjectId;
    } & {
        __v: number;
    }, "id"> & {
        id: string;
    }> | undefined;
    buttonText?: import("mongoose").SchemaDefinitionProperty<string | undefined, HeroSlide, Document<unknown, {}, HeroSlide, {
        id: string;
    }, import("mongoose").DefaultSchemaOptions> & Omit<HeroSlide & {
        _id: import("mongoose").Types.ObjectId;
    } & {
        __v: number;
    }, "id"> & {
        id: string;
    }> | undefined;
    buttonLink?: import("mongoose").SchemaDefinitionProperty<string | undefined, HeroSlide, Document<unknown, {}, HeroSlide, {
        id: string;
    }, import("mongoose").DefaultSchemaOptions> & Omit<HeroSlide & {
        _id: import("mongoose").Types.ObjectId;
    } & {
        __v: number;
    }, "id"> & {
        id: string;
    }> | undefined;
    order?: import("mongoose").SchemaDefinitionProperty<number, HeroSlide, Document<unknown, {}, HeroSlide, {
        id: string;
    }, import("mongoose").DefaultSchemaOptions> & Omit<HeroSlide & {
        _id: import("mongoose").Types.ObjectId;
    } & {
        __v: number;
    }, "id"> & {
        id: string;
    }> | undefined;
    isActive?: import("mongoose").SchemaDefinitionProperty<boolean, HeroSlide, Document<unknown, {}, HeroSlide, {
        id: string;
    }, import("mongoose").DefaultSchemaOptions> & Omit<HeroSlide & {
        _id: import("mongoose").Types.ObjectId;
    } & {
        __v: number;
    }, "id"> & {
        id: string;
    }> | undefined;
}, HeroSlide>;
