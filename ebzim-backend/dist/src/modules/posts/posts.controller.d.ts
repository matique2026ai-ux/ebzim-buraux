import { PostsService } from './posts.service';
import { CreatePostDto } from './dto/create-post.dto';
export declare class PostsController {
    private readonly postsService;
    constructor(postsService: PostsService);
    getPublicFeed(lang: string, cursor: string, limit: number): Promise<{
        data: any[];
        meta: {
            nextCursor: any;
            hasNextPage: boolean;
        };
    }>;
    getAdminPosts(page: number, limit: number): Promise<{
        data: any[];
        meta: {
            total: number;
            page: number;
            limit: number;
            totalPages: number;
            hasNextPage: boolean;
        };
    }>;
    createPost(createPostDto: CreatePostDto, req: {
        user?: any;
    }): Promise<import("mongoose").Document<unknown, {}, import("./schemas/post.schema").PostDocument, {}, import("mongoose").DefaultSchemaOptions> & import("./schemas/post.schema").Post & import("mongoose").Document<import("mongoose").Types.ObjectId, any, any, Record<string, any>, {}> & Required<{
        _id: import("mongoose").Types.ObjectId;
    }> & {
        __v: number;
    } & {
        id: string;
    }>;
    updatePost(id: string, updateData: any): Promise<(import("mongoose").Document<unknown, {}, import("./schemas/post.schema").PostDocument, {}, import("mongoose").DefaultSchemaOptions> & import("./schemas/post.schema").Post & import("mongoose").Document<import("mongoose").Types.ObjectId, any, any, Record<string, any>, {}> & Required<{
        _id: import("mongoose").Types.ObjectId;
    }> & {
        __v: number;
    } & {
        id: string;
    }) | null>;
    deletePost(id: string): Promise<(import("mongoose").Document<unknown, {}, import("./schemas/post.schema").PostDocument, {}, import("mongoose").DefaultSchemaOptions> & import("./schemas/post.schema").Post & import("mongoose").Document<import("mongoose").Types.ObjectId, any, any, Record<string, any>, {}> & Required<{
        _id: import("mongoose").Types.ObjectId;
    }> & {
        __v: number;
    } & {
        id: string;
    }) | null>;
}
