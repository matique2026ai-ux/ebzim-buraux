"use strict";
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
var __metadata = (this && this.__metadata) || function (k, v) {
    if (typeof Reflect === "object" && typeof Reflect.metadata === "function") return Reflect.metadata(k, v);
};
var __param = (this && this.__param) || function (paramIndex, decorator) {
    return function (target, key) { decorator(target, key, paramIndex); }
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.PostsService = void 0;
const common_1 = require("@nestjs/common");
const mongoose_1 = require("@nestjs/mongoose");
const mongoose_2 = require("mongoose");
const pagination_util_1 = require("../../common/utils/pagination.util");
let PostsService = class PostsService {
    postModel;
    constructor(postModel) {
        this.postModel = postModel;
    }
    async getPublicFeed(locale, options) {
        const pagination = (0, pagination_util_1.buildCursorPagination)(options);
        const query = pagination.query;
        const limit = pagination.limit;
        query['status'] = 'PUBLISHED';
        const posts = await this.postModel
            .find(query)
            .sort({ _id: -1 })
            .limit(limit)
            .exec();
        const localizedPosts = posts.map((post) => ({
            _id: post._id,
            title: post.title[locale] || post.title.en,
            summary: post.summary[locale] || post.summary.en,
            coverImage: post.media.find(m => m.type === 'IMAGE') || null,
            publishedAt: post.publishedAt,
        }));
        return (0, pagination_util_1.formatCursorPaginatedResponse)(localizedPosts);
    }
    async getAdminTable(options) {
        const { skip, limit, page } = (0, pagination_util_1.buildOffsetPagination)(options);
        const [posts, total] = await Promise.all([
            this.postModel.find().sort({ createdAt: -1 }).skip(skip).limit(limit).exec(),
            this.postModel.countDocuments(),
        ]);
        return (0, pagination_util_1.formatOffsetPaginatedResponse)(posts, total, page, limit);
    }
    async createPost(dto, authorId) {
        return this.postModel.create({ ...dto, authorId });
    }
};
exports.PostsService = PostsService;
exports.PostsService = PostsService = __decorate([
    (0, common_1.Injectable)(),
    __param(0, (0, mongoose_1.InjectModel)('Post')),
    __metadata("design:paramtypes", [mongoose_2.Model])
], PostsService);
//# sourceMappingURL=posts.service.js.map