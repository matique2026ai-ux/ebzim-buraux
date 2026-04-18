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
exports.PartnersService = void 0;
const common_1 = require("@nestjs/common");
const mongoose_1 = require("@nestjs/mongoose");
const mongoose_2 = require("mongoose");
const pagination_util_1 = require("../../common/utils/pagination.util");
let PartnersService = class PartnersService {
    partnerModel;
    constructor(partnerModel) {
        this.partnerModel = partnerModel;
    }
    async findAll() {
        return this.partnerModel.find({ isActive: true }).sort({ order: 1 }).exec();
    }
    async getAdminTable(options) {
        const { skip, limit, page } = (0, pagination_util_1.buildOffsetPagination)(options);
        const [partners, total] = await Promise.all([
            this.partnerModel.find().sort({ order: 1 }).skip(skip).limit(limit).exec(),
            this.partnerModel.countDocuments(),
        ]);
        return (0, pagination_util_1.formatOffsetPaginatedResponse)(partners, total, page, limit);
    }
    async create(dto) {
        return this.partnerModel.create(dto);
    }
    async update(id, dto) {
        return this.partnerModel.findByIdAndUpdate(id, dto, { new: true }).exec();
    }
    async delete(id) {
        return this.partnerModel.findByIdAndDelete(id).exec();
    }
};
exports.PartnersService = PartnersService;
exports.PartnersService = PartnersService = __decorate([
    (0, common_1.Injectable)(),
    __param(0, (0, mongoose_1.InjectModel)('Partner')),
    __metadata("design:paramtypes", [mongoose_2.Model])
], PartnersService);
//# sourceMappingURL=partners.service.js.map