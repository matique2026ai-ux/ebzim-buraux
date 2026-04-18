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
exports.LeadershipService = void 0;
const common_1 = require("@nestjs/common");
const mongoose_1 = require("@nestjs/mongoose");
const mongoose_2 = require("mongoose");
let LeadershipService = class LeadershipService {
    leaderModel;
    constructor(leaderModel) {
        this.leaderModel = leaderModel;
    }
    async findAll() {
        return this.leaderModel.find({ isActive: true }).sort({ order: 1 }).exec();
    }
    async create(dto) {
        return this.leaderModel.create(dto);
    }
    async update(id, dto) {
        return this.leaderModel.findByIdAndUpdate(id, dto, { new: true }).exec();
    }
    async delete(id) {
        return this.leaderModel.findByIdAndDelete(id).exec();
    }
};
exports.LeadershipService = LeadershipService;
exports.LeadershipService = LeadershipService = __decorate([
    (0, common_1.Injectable)(),
    __param(0, (0, mongoose_1.InjectModel)('Leader')),
    __metadata("design:paramtypes", [mongoose_2.Model])
], LeadershipService);
//# sourceMappingURL=leadership.service.js.map