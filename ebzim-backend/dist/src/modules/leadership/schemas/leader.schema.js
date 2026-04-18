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
Object.defineProperty(exports, "__esModule", { value: true });
exports.LeaderSchema = exports.Leader = void 0;
const mongoose_1 = require("@nestjs/mongoose");
const institution_schema_1 = require("../../institutions/schemas/institution.schema");
let Leader = class Leader {
    name;
    role;
    photoUrl;
    order;
    isActive;
};
exports.Leader = Leader;
__decorate([
    (0, mongoose_1.Prop)({ type: institution_schema_1.MultilingualTextSchema, required: true }),
    __metadata("design:type", institution_schema_1.MultilingualText)
], Leader.prototype, "name", void 0);
__decorate([
    (0, mongoose_1.Prop)({ type: institution_schema_1.MultilingualTextSchema, required: true }),
    __metadata("design:type", institution_schema_1.MultilingualText)
], Leader.prototype, "role", void 0);
__decorate([
    (0, mongoose_1.Prop)({ type: String }),
    __metadata("design:type", String)
], Leader.prototype, "photoUrl", void 0);
__decorate([
    (0, mongoose_1.Prop)({ type: Number, default: 0 }),
    __metadata("design:type", Number)
], Leader.prototype, "order", void 0);
__decorate([
    (0, mongoose_1.Prop)({ type: Boolean, default: true }),
    __metadata("design:type", Boolean)
], Leader.prototype, "isActive", void 0);
exports.Leader = Leader = __decorate([
    (0, mongoose_1.Schema)({ timestamps: true })
], Leader);
exports.LeaderSchema = mongoose_1.SchemaFactory.createForClass(Leader);
//# sourceMappingURL=leader.schema.js.map