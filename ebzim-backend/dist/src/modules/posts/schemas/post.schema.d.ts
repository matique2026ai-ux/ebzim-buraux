import { Document, Types } from 'mongoose';
import { MultilingualText } from '../../institutions/schemas/institution.schema';
export type PostDocument = Post & Document;
export declare class MediaAttachment {
    type: string;
    cloudinaryUrl: string;
    publicId: string;
}
export declare class Post {
    authorId: Types.ObjectId;
    categoryId: Types.ObjectId;
    title: MultilingualText;
    summary: MultilingualText;
    content: MultilingualText;
    media: MediaAttachment[];
    status: string;
    isFeatured: boolean;
    publishedAt?: Date;
}
export declare const PostSchema: import("mongoose").Schema<Post, import("mongoose").Model<Post, any, any, any, any, any, Post>, {}, {}, {}, {}, import("mongoose").DefaultSchemaOptions, Post, Document<unknown, {}, Post, {
    id: string;
}, import("mongoose").DefaultSchemaOptions> & Omit<Post & {
    _id: Types.ObjectId;
} & {
    __v: number;
}, "id"> & {
    id: string;
}, {
    authorId?: import("mongoose").SchemaDefinitionProperty<Types.ObjectId, Post, Document<unknown, {}, Post, {
        id: string;
    }, import("mongoose").DefaultSchemaOptions> & Omit<Post & {
        _id: Types.ObjectId;
    } & {
        __v: number;
    }, "id"> & {
        id: string;
    }> | undefined;
    categoryId?: import("mongoose").SchemaDefinitionProperty<Types.ObjectId, Post, Document<unknown, {}, Post, {
        id: string;
    }, import("mongoose").DefaultSchemaOptions> & Omit<Post & {
        _id: Types.ObjectId;
    } & {
        __v: number;
    }, "id"> & {
        id: string;
    }> | undefined;
    title?: import("mongoose").SchemaDefinitionProperty<MultilingualText, Post, Document<unknown, {}, Post, {
        id: string;
    }, import("mongoose").DefaultSchemaOptions> & Omit<Post & {
        _id: Types.ObjectId;
    } & {
        __v: number;
    }, "id"> & {
        id: string;
    }> | undefined;
    summary?: import("mongoose").SchemaDefinitionProperty<MultilingualText, Post, Document<unknown, {}, Post, {
        id: string;
    }, import("mongoose").DefaultSchemaOptions> & Omit<Post & {
        _id: Types.ObjectId;
    } & {
        __v: number;
    }, "id"> & {
        id: string;
    }> | undefined;
    content?: import("mongoose").SchemaDefinitionProperty<MultilingualText, Post, Document<unknown, {}, Post, {
        id: string;
    }, import("mongoose").DefaultSchemaOptions> & Omit<Post & {
        _id: Types.ObjectId;
    } & {
        __v: number;
    }, "id"> & {
        id: string;
    }> | undefined;
    media?: import("mongoose").SchemaDefinitionProperty<MediaAttachment[], Post, Document<unknown, {}, Post, {
        id: string;
    }, import("mongoose").DefaultSchemaOptions> & Omit<Post & {
        _id: Types.ObjectId;
    } & {
        __v: number;
    }, "id"> & {
        id: string;
    }> | undefined;
    status?: import("mongoose").SchemaDefinitionProperty<string, Post, Document<unknown, {}, Post, {
        id: string;
    }, import("mongoose").DefaultSchemaOptions> & Omit<Post & {
        _id: Types.ObjectId;
    } & {
        __v: number;
    }, "id"> & {
        id: string;
    }> | undefined;
    isFeatured?: import("mongoose").SchemaDefinitionProperty<boolean, Post, Document<unknown, {}, Post, {
        id: string;
    }, import("mongoose").DefaultSchemaOptions> & Omit<Post & {
        _id: Types.ObjectId;
    } & {
        __v: number;
    }, "id"> & {
        id: string;
    }> | undefined;
    publishedAt?: import("mongoose").SchemaDefinitionProperty<Date | undefined, Post, Document<unknown, {}, Post, {
        id: string;
    }, import("mongoose").DefaultSchemaOptions> & Omit<Post & {
        _id: Types.ObjectId;
    } & {
        __v: number;
    }, "id"> & {
        id: string;
    }> | undefined;
}, Post>;
