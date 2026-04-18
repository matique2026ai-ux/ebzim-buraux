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
exports.HeroSlideSchema = exports.HeroSlide = void 0;
const mongoose_1 = require("@nestjs/mongoose");
const institution_schema_1 = require("../../institutions/schemas/institution.schema");
let HeroSlide = class HeroSlide {
    title;
    subtitle;
    imageUrl;
    buttonText;
    buttonLink;
    order;
    isActive;
};
exports.HeroSlide = HeroSlide;
__decorate([
    (0, mongoose_1.Prop)({ type: institution_schema_1.MultilingualTextSchema, required: true }),
    __metadata("design:type", institution_schema_1.MultilingualText)
], HeroSlide.prototype, "title", void 0);
__decorate([
    (0, mongoose_1.Prop)({ type: institution_schema_1.MultilingualTextSchema, required: true }),
    __metadata("design:type", institution_schema_1.MultilingualText)
], HeroSlide.prototype, "subtitle", void 0);
__decorate([
    (0, mongoose_1.Prop)({ type: String, required: true }),
    __metadata("design:type", String)
], HeroSlide.prototype, "imageUrl", void 0);
__decorate([
    (0, mongoose_1.Prop)({ type: String }),
    __metadata("design:type", String)
], HeroSlide.prototype, "buttonText", void 0);
__decorate([
    (0, mongoose_1.Prop)({ type: String }),
    __metadata("design:type", String)
], HeroSlide.prototype, "buttonLink", void 0);
__decorate([
    (0, mongoose_1.Prop)({ type: Number, default: 0 }),
    __metadata("design:type", Number)
], HeroSlide.prototype, "order", void 0);
__decorate([
    (0, mongoose_1.Prop)({ type: Boolean, default: true }),
    __metadata("design:type", Boolean)
], HeroSlide.prototype, "isActive", void 0);
exports.HeroSlide = HeroSlide = __decorate([
    (0, mongoose_1.Schema)({ timestamps: true })
], HeroSlide);
exports.HeroSlideSchema = mongoose_1.SchemaFactory.createForClass(HeroSlide);
//# sourceMappingURL=hero-slide.schema.js.map