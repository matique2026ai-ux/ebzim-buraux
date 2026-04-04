"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.buildOffsetPagination = buildOffsetPagination;
exports.buildCursorPagination = buildCursorPagination;
exports.formatOffsetPaginatedResponse = formatOffsetPaginatedResponse;
exports.formatCursorPaginatedResponse = formatCursorPaginatedResponse;
function buildOffsetPagination(options) {
    const page = options.page && options.page > 0 ? options.page : 1;
    const limit = options.limit && options.limit > 0 ? options.limit : 10;
    const skip = (page - 1) * limit;
    return { skip, limit, page };
}
function buildCursorPagination(options, cursorField = '_id') {
    const limit = options.limit && options.limit > 0 ? options.limit : 10;
    const query = {};
    if (options.cursor) {
        query[cursorField] = { $lt: options.cursor };
    }
    return { query, limit };
}
function formatOffsetPaginatedResponse(data, total, page, limit) {
    return {
        data,
        meta: {
            total,
            page,
            limit,
            totalPages: Math.ceil(total / limit),
            hasNextPage: page * limit < total,
        },
    };
}
function formatCursorPaginatedResponse(data, cursorField = '_id') {
    const hasNextPage = data.length > 0;
    const nextCursor = hasNextPage ? data[data.length - 1][cursorField] : null;
    return {
        data,
        meta: {
            nextCursor,
            hasNextPage,
        },
    };
}
//# sourceMappingURL=pagination.util.js.map