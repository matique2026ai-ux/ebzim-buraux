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
exports.ReportSchema = exports.Report = exports.TimelineEvent = void 0;
const mongoose_1 = require("@nestjs/mongoose");
const mongoose_2 = require("mongoose");
const event_schema_1 = require("../../events/schemas/event.schema");
let TimelineEvent = class TimelineEvent {
    actorId;
    action;
    details;
    timestamp;
};
exports.TimelineEvent = TimelineEvent;
__decorate([
    (0, mongoose_1.Prop)({ type: mongoose_2.Types.ObjectId, ref: 'User', required: true }),
    __metadata("design:type", mongoose_2.Types.ObjectId)
], TimelineEvent.prototype, "actorId", void 0);
__decorate([
    (0, mongoose_1.Prop)({ type: String, required: true }),
    __metadata("design:type", String)
], TimelineEvent.prototype, "action", void 0);
__decorate([
    (0, mongoose_1.Prop)({ type: String }),
    __metadata("design:type", String)
], TimelineEvent.prototype, "details", void 0);
__decorate([
    (0, mongoose_1.Prop)({ type: Date, default: Date.now }),
    __metadata("design:type", Date)
], TimelineEvent.prototype, "timestamp", void 0);
exports.TimelineEvent = TimelineEvent = __decorate([
    (0, mongoose_1.Schema)({ _id: false })
], TimelineEvent);
const TimelineEventSchema = mongoose_1.SchemaFactory.createForClass(TimelineEvent);
let Report = class Report {
    reporterId;
    isAnonymous;
    guestContactInfo;
    title;
    description;
    incidentCategory;
    severity;
    priority;
    locationData;
    observationDate;
    attachments;
    status;
    reviewedBy;
    institutionId;
    assignedAuthorityId;
    timeline;
    resolutionNotes;
    closureNotes;
};
exports.Report = Report;
__decorate([
    (0, mongoose_1.Prop)({ type: mongoose_2.Types.ObjectId, ref: 'User' }),
    __metadata("design:type", mongoose_2.Types.ObjectId)
], Report.prototype, "reporterId", void 0);
__decorate([
    (0, mongoose_1.Prop)({ type: Boolean, default: false }),
    __metadata("design:type", Boolean)
], Report.prototype, "isAnonymous", void 0);
__decorate([
    (0, mongoose_1.Prop)({ type: Object }),
    __metadata("design:type", Object)
], Report.prototype, "guestContactInfo", void 0);
__decorate([
    (0, mongoose_1.Prop)({ required: true }),
    __metadata("design:type", String)
], Report.prototype, "title", void 0);
__decorate([
    (0, mongoose_1.Prop)({ required: true }),
    __metadata("design:type", String)
], Report.prototype, "description", void 0);
__decorate([
    (0, mongoose_1.Prop)({
        type: String,
        enum: ['VANDALISM', 'DEGRADATION', 'ILLEGAL_INTERVENTION', 'URGENT_OBSERVATION', 'OTHER'],
        required: true
    }),
    __metadata("design:type", String)
], Report.prototype, "incidentCategory", void 0);
__decorate([
    (0, mongoose_1.Prop)({ type: String, enum: ['LOW', 'MEDIUM', 'HIGH', 'CRITICAL'], default: 'MEDIUM' }),
    __metadata("design:type", String)
], Report.prototype, "severity", void 0);
__decorate([
    (0, mongoose_1.Prop)({ type: String, enum: ['LOW', 'NORMAL', 'URGENT'], default: 'NORMAL' }),
    __metadata("design:type", String)
], Report.prototype, "priority", void 0);
__decorate([
    (0, mongoose_1.Prop)({ type: event_schema_1.LocationDataSchema }),
    __metadata("design:type", event_schema_1.LocationData)
], Report.prototype, "locationData", void 0);
__decorate([
    (0, mongoose_1.Prop)({ type: Date }),
    __metadata("design:type", Date)
], Report.prototype, "observationDate", void 0);
__decorate([
    (0, mongoose_1.Prop)({ type: [{ type: Object }] }),
    __metadata("design:type", Array)
], Report.prototype, "attachments", void 0);
__decorate([
    (0, mongoose_1.Prop)({
        type: String,
        enum: [
            'SUBMITTED',
            'TRIAGED_BY_ASSOCIATION',
            'UNDER_REVIEW',
            'ASSIGNED_TO_AUTHORITY',
            'IN_INTERVENTION',
            'NEEDS_MORE_INFO',
            'RESOLVED',
            'CLOSED',
            'REJECTED',
        ],
        default: 'SUBMITTED',
        index: true,
    }),
    __metadata("design:type", String)
], Report.prototype, "status", void 0);
__decorate([
    (0, mongoose_1.Prop)({ type: mongoose_2.Types.ObjectId, ref: 'User' }),
    __metadata("design:type", mongoose_2.Types.ObjectId)
], Report.prototype, "reviewedBy", void 0);
__decorate([
    (0, mongoose_1.Prop)({ type: mongoose_2.Types.ObjectId, ref: 'Institution' }),
    __metadata("design:type", mongoose_2.Types.ObjectId)
], Report.prototype, "institutionId", void 0);
__decorate([
    (0, mongoose_1.Prop)({ type: mongoose_2.Types.ObjectId, ref: 'User' }),
    __metadata("design:type", mongoose_2.Types.ObjectId)
], Report.prototype, "assignedAuthorityId", void 0);
__decorate([
    (0, mongoose_1.Prop)({ type: [TimelineEventSchema], default: [] }),
    __metadata("design:type", Array)
], Report.prototype, "timeline", void 0);
__decorate([
    (0, mongoose_1.Prop)({ type: String }),
    __metadata("design:type", String)
], Report.prototype, "resolutionNotes", void 0);
__decorate([
    (0, mongoose_1.Prop)({ type: String }),
    __metadata("design:type", String)
], Report.prototype, "closureNotes", void 0);
exports.Report = Report = __decorate([
    (0, mongoose_1.Schema)({ timestamps: true })
], Report);
exports.ReportSchema = mongoose_1.SchemaFactory.createForClass(Report);
//# sourceMappingURL=report.schema.js.map