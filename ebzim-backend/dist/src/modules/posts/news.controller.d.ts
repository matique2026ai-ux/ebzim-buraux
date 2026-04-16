import { PostsService } from './posts.service';
export declare class NewsController {
    private readonly postsService;
    constructor(postsService: PostsService);
    getNews(headerLang: string, queryLang: string): Promise<{
        data: any[];
        meta: {
            nextCursor: any;
            hasNextPage: boolean;
        };
    }>;
}
