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
exports.UpdateReportStatusDto = exports.CreateReportDto = void 0;
const class_validator_1 = require("class-validator");
const class_transformer_1 = require("class-transformer");
const shared_dto_1 = require("../../../common/dto/shared.dto");
class CreateReportDto {
    isAnonymous;
    guestContactInfo;
    title;
    description;
    incidentCategory;
    severity;
    priority;
    locationData;
}
exports.CreateReportDto = CreateReportDto;
__decorate([
    (0, class_validator_1.IsBoolean)(),
    (0, class_validator_1.IsOptional)(),
    __metadata("design:type", Boolean)
], CreateReportDto.prototype, "isAnonymous", void 0);
__decorate([
    (0, class_validator_1.IsObject)(),
    (0, class_validator_1.IsOptional)(),
    __metadata("design:type", Object)
], CreateReportDto.prototype, "guestContactInfo", void 0);
__decorate([
    (0, class_validator_1.IsString)(),
    (0, class_validator_1.IsOptional)(),
    __metadata("design:type", String)
], CreateReportDto.prototype, "title", void 0);
__decorate([
    (0, class_validator_1.IsString)(),
    (0, class_validator_1.IsNotEmpty)(),
    __metadata("design:type", String)
], CreateReportDto.prototype, "description", void 0);
__decorate([
    (0, class_validator_1.IsEnum)(['VANDALISM', 'THEFT', 'ILLEGAL_CONSTRUCTION', 'NEGLECT', 'PUBLIC_SPACE', 'OTHER']),
    (0, class_validator_1.IsNotEmpty)(),
    __metadata("design:type", String)
], CreateReportDto.prototype, "incidentCategory", void 0);
__decorate([
    (0, class_validator_1.IsEnum)(['LOW', 'MEDIUM', 'HIGH', 'CRITICAL']),
    (0, class_validator_1.IsOptional)(),
    __metadata("design:type", String)
], CreateReportDto.prototype, "severity", void 0);
__decorate([
    (0, class_validator_1.IsEnum)(['LOW', 'NORMAL', 'URGENT']),
    (0, class_validator_1.IsOptional)(),
    __metadata("design:type", String)
], CreateReportDto.prototype, "priority", void 0);
__decorate([
    (0, class_validator_1.IsOptional)(),
    (0, class_validator_1.ValidateNested)(),
    (0, class_transformer_1.Type)(() => shared_dto_1.LocationDataDto),
    __metadata("design:type", shared_dto_1.LocationDataDto)
], CreateReportDto.prototype, "locationData", void 0);
class UpdateReportStatusDto {
    status;
}
exports.UpdateReportStatusDto = UpdateReportStatusDto;
__decorate([
    (0, class_validator_1.IsEnum)([
        'TRIAGED_BY_ASSOCIATION',
        'UNDER_REVIEW',
        'ASSIGNED_TO_AUTHORITY',
        'IN_INTERVENTION',
        'NEEDS_MORE_INFO',
        'RESOLVED',
        'CLOSED',
        'REJECTED',
    ]),
    (0, class_validator_1.IsNotEmpty)(),
    __metadata("design:type", String)
], UpdateReportStatusDto.prototype, "status", void 0);
//# sourceMappingURL=create-report.dto.js.map