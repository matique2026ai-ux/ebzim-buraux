import { Model } from 'mongoose';
import { PostDocument } from './schemas/post.schema';
export declare class PostsService {
    private postModel;
    constructor(postModel: Model<PostDocument>);
    getPublicFeed(locale: string, options: any): Promise<{
        data: any[];
        meta: {
            nextCursor: any;
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
    createPost(dto: any, authorId: string): Promise<import("mongoose").Document<unknown, {}, PostDocument, {}, import("mongoose").DefaultSchemaOptions> & import("./schemas/post.schema").Post & import("mongoose").Document<import("mongoose").Types.ObjectId, any, any, Record<string, any>, {}> & Required<{
        _id: import("mongoose").Types.ObjectId;
    }> & {
        __v: number;
    } & {
        id: string;
    }>;
    updatePost(id: string, dto: any): Promise<(import("mongoose").Document<unknown, {}, PostDocument, {}, import("mongoose").DefaultSchemaOptions> & import("./schemas/post.schema").Post & import("mongoose").Document<import("mongoose").Types.ObjectId, any, any, Record<string, any>, {}> & Required<{
        _id: import("mongoose").Types.ObjectId;
    }> & {
        __v: number;
    } & {
        id: string;
    }) | null>;
    deletePost(id: string): Promise<(import("mongoose").Document<unknown, {}, PostDocument, {}, import("mongoose").DefaultSchemaOptions> & import("./schemas/post.schema").Post & import("mongoose").Document<import("mongoose").Types.ObjectId, any, any, Record<string, any>, {}> & Required<{
        _id: import("mongoose").Types.ObjectId;
    }> & {
        __v: number;
    } & {
        id: string;
    }) | null>;
}
