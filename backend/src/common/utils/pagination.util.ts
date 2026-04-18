export interface PaginationOptions {
  limit?: number;
}

export interface OffsetPaginationOptions extends PaginationOptions {
  page?: number;
}

export interface CursorPaginationOptions extends PaginationOptions {
  cursor?: string; // e.g. An ObjectID encoded as string
}

export function buildOffsetPagination(options: OffsetPaginationOptions) {
  const page = options.page && options.page > 0 ? options.page : 1;
  const limit = options.limit && options.limit > 0 ? options.limit : 10;
  const skip = (page - 1) * limit;

  return { skip, limit, page };
}

export function buildCursorPagination(
  options: CursorPaginationOptions,
  cursorField = '_id',
) {
  const limit = options.limit && options.limit > 0 ? options.limit : 10;
  const query: Record<string, any> = {};

  if (options.cursor) {
    query[cursorField] = { $lt: options.cursor }; // Assumes descending sort/fetching older items
  }

  return { query, limit };
}

export function formatOffsetPaginatedResponse(
  data: any[],
  total: number,
  page: number,
  limit: number,
) {
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

export function formatCursorPaginatedResponse(
  data: any[],
  cursorField = '_id',
) {
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
