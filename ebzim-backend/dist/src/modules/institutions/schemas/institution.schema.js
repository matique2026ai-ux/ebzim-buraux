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
exports.InstitutionSchema = exports.Institution = exports.MultilingualTextSchema = exports.MultilingualText = void 0;
const mongoose_1 = require("@nestjs/mongoose");
let MultilingualText = class MultilingualText {
    ar;
    fr;
    en;
};
exports.MultilingualText = MultilingualText;
__decorate([
    (0, mongoose_1.Prop)({ required: true }),
    __metadata("design:type", String)
], MultilingualText.prototype, "ar", void 0);
__decorate([
    (0, mongoose_1.Prop)({ required: false, default: '' }),
    __metadata("design:type", String)
], MultilingualText.prototype, "fr", void 0);
__decorate([
    (0, mongoose_1.Prop)({ required: false, default: '' }),
    __metadata("design:type", String)
], MultilingualText.prototype, "en", void 0);
exports.MultilingualText = MultilingualText = __decorate([
    (0, mongoose_1.Schema)({ _id: false })
], MultilingualText);
exports.MultilingualTextSchema = mongoose_1.SchemaFactory.createForClass(MultilingualText);
let Institution = class Institution {
    name;
    type;
    description;
    logo;
    contactInfo;
    partnershipDetails;
};
exports.Institution = Institution;
__decorate([
    (0, mongoose_1.Prop)({ type: exports.MultilingualTextSchema, required: true }),
    __metadata("design:type", MultilingualText)
], Institution.prototype, "name", void 0);
__decorate([
    (0, mongoose_1.Prop)({ type: String, enum: ['MUSEUM', 'UNIVERSITY', 'NETWORK', 'GOVERNMENT', 'NGO'], required: true }),
    __metadata("design:type", String)
], Institution.prototype, "type", void 0);
__decorate([
    (0, mongoose_1.Prop)({ type: exports.MultilingualTextSchema }),
    __metadata("design:type", MultilingualText)
], Institution.prototype, "description", void 0);
__decorate([
    (0, mongoose_1.Prop)({ type: Object }),
    __metadata("design:type", Object)
], Institution.prototype, "logo", void 0);
__decorate([
    (0, mongoose_1.Prop)({ type: Object }),
    __metadata("design:type", Object)
], Institution.prototype, "contactInfo", void 0);
__decorate([
    (0, mongoose_1.Prop)({ type: exports.MultilingualTextSchema }),
    __metadata("design:type", MultilingualText)
], Institution.prototype, "partnershipDetails", void 0);
exports.Institution = Institution = __decorate([
    (0, mongoose_1.Schema)({ timestamps: true })
], Institution);
exports.InstitutionSchema = mongoose_1.SchemaFactory.createForClass(Institution);
//# sourceMappingURL=institution.schema.js.map