export interface PaginationOptions {
    limit?: number;
}
export interface OffsetPaginationOptions extends PaginationOptions {
    page?: number;
}
export interface CursorPaginationOptions extends PaginationOptions {
    cursor?: string;
}
export declare function buildOffsetPagination(options: OffsetPaginationOptions): {
    skip: number;
    limit: number;
    page: number;
};
export declare function buildCursorPagination(options: CursorPaginationOptions, cursorField?: string): {
    query: Record<string, any>;
    limit: number;
};
export declare function formatOffsetPaginatedResponse(data: any[], total: number, page: number, limit: number): {
    data: any[];
    meta: {
        total: number;
        page: number;
        limit: number;
        totalPages: number;
        hasNextPage: boolean;
    };
};
export declare function formatCursorPaginatedResponse(data: any[], cursorField?: string): {
    data: any[];
    meta: {
        nextCursor: any;
        hasNextPage: boolean;
    };
};
