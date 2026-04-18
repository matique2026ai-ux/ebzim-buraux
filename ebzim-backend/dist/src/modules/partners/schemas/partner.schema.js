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
exports.PartnerSchema = exports.Partner = void 0;
const mongoose_1 = require("@nestjs/mongoose");
const institution_schema_1 = require("../../institutions/schemas/institution.schema");
let Partner = class Partner {
    name;
    logoUrl;
    goalsSummary;
    websiteUrl;
    color;
    order;
    isActive;
};
exports.Partner = Partner;
__decorate([
    (0, mongoose_1.Prop)({ type: institution_schema_1.MultilingualTextSchema, required: true }),
    __metadata("design:type", institution_schema_1.MultilingualText)
], Partner.prototype, "name", void 0);
__decorate([
    (0, mongoose_1.Prop)({ type: String, required: true }),
    __metadata("design:type", String)
], Partner.prototype, "logoUrl", void 0);
__decorate([
    (0, mongoose_1.Prop)({ type: institution_schema_1.MultilingualTextSchema, required: true }),
    __metadata("design:type", institution_schema_1.MultilingualText)
], Partner.prototype, "goalsSummary", void 0);
__decorate([
    (0, mongoose_1.Prop)({ type: String }),
    __metadata("design:type", String)
], Partner.prototype, "websiteUrl", void 0);
__decorate([
    (0, mongoose_1.Prop)({ type: String, default: '#052011' }),
    __metadata("design:type", String)
], Partner.prototype, "color", void 0);
__decorate([
    (0, mongoose_1.Prop)({ type: Number, default: 0 }),
    __metadata("design:type", Number)
], Partner.prototype, "order", void 0);
__decorate([
    (0, mongoose_1.Prop)({ type: Boolean, default: true }),
    __metadata("design:type", Boolean)
], Partner.prototype, "isActive", void 0);
exports.Partner = Partner = __decorate([
    (0, mongoose_1.Schema)({ timestamps: true })
], Partner);
exports.PartnerSchema = mongoose_1.SchemaFactory.createForClass(Partner);
//# sourceMappingURL=partner.schema.js.map