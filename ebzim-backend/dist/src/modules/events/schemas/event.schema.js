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
exports.EventRsvpSchema = exports.EventRsvp = exports.EventSchema = exports.Event = exports.LocationDataSchema = exports.LocationData = void 0;
const mongoose_1 = require("@nestjs/mongoose");
const mongoose_2 = require("mongoose");
const institution_schema_1 = require("../../institutions/schemas/institution.schema");
let LocationData = class LocationData {
    type;
    coordinates;
    formattedAddress;
};
exports.LocationData = LocationData;
__decorate([
    (0, mongoose_1.Prop)({ type: String, enum: ['Point'], default: 'Point' }),
    __metadata("design:type", String)
], LocationData.prototype, "type", void 0);
__decorate([
    (0, mongoose_1.Prop)({ type: [Number], required: false }),
    __metadata("design:type", Array)
], LocationData.prototype, "coordinates", void 0);
__decorate([
    (0, mongoose_1.Prop)({ type: String }),
    __metadata("design:type", String)
], LocationData.prototype, "formattedAddress", void 0);
exports.LocationData = LocationData = __decorate([
    (0, mongoose_1.Schema)({ _id: false })
], LocationData);
exports.LocationDataSchema = mongoose_1.SchemaFactory.createForClass(LocationData);
let Event = class Event {
    categoryId;
    title;
    description;
    startDate;
    endDate;
    location;
    isOnline;
    coverImage;
    publicationStatus;
    eventStatus;
    isFeatured;
};
exports.Event = Event;
__decorate([
    (0, mongoose_1.Prop)({ type: mongoose_2.Types.ObjectId, ref: 'Category', required: true }),
    __metadata("design:type", mongoose_2.Types.ObjectId)
], Event.prototype, "categoryId", void 0);
__decorate([
    (0, mongoose_1.Prop)({ type: institution_schema_1.MultilingualTextSchema, required: true }),
    __metadata("design:type", institution_schema_1.MultilingualText)
], Event.prototype, "title", void 0);
__decorate([
    (0, mongoose_1.Prop)({ type: institution_schema_1.MultilingualTextSchema, required: true }),
    __metadata("design:type", institution_schema_1.MultilingualText)
], Event.prototype, "description", void 0);
__decorate([
    (0, mongoose_1.Prop)({ type: Date, required: true, index: true }),
    __metadata("design:type", Date)
], Event.prototype, "startDate", void 0);
__decorate([
    (0, mongoose_1.Prop)({ type: Date, required: true }),
    __metadata("design:type", Date)
], Event.prototype, "endDate", void 0);
__decorate([
    (0, mongoose_1.Prop)({ type: exports.LocationDataSchema }),
    __metadata("design:type", LocationData)
], Event.prototype, "location", void 0);
__decorate([
    (0, mongoose_1.Prop)({ type: Boolean, default: false }),
    __metadata("design:type", Boolean)
], Event.prototype, "isOnline", void 0);
__decorate([
    (0, mongoose_1.Prop)({ type: Object }),
    __metadata("design:type", Object)
], Event.prototype, "coverImage", void 0);
__decorate([
    (0, mongoose_1.Prop)({ type: String, enum: ['DRAFT', 'PUBLISHED', 'CANCELLED'], default: 'DRAFT', index: true }),
    __metadata("design:type", String)
], Event.prototype, "publicationStatus", void 0);
__decorate([
    (0, mongoose_1.Prop)({ type: String, enum: ['UPCOMING', 'ONGOING', 'COMPLETED', 'CANCELLED'], default: 'UPCOMING', index: true }),
    __metadata("design:type", String)
], Event.prototype, "eventStatus", void 0);
__decorate([
    (0, mongoose_1.Prop)({ type: Boolean, default: false }),
    __metadata("design:type", Boolean)
], Event.prototype, "isFeatured", void 0);
exports.Event = Event = __decorate([
    (0, mongoose_1.Schema)({ timestamps: true })
], Event);
exports.EventSchema = mongoose_1.SchemaFactory.createForClass(Event);
let EventRsvp = class EventRsvp {
    eventId;
    userId;
    status;
};
exports.EventRsvp = EventRsvp;
__decorate([
    (0, mongoose_1.Prop)({ type: mongoose_2.Types.ObjectId, ref: 'Event', required: true, index: true }),
    __metadata("design:type", mongoose_2.Types.ObjectId)
], EventRsvp.prototype, "eventId", void 0);
__decorate([
    (0, mongoose_1.Prop)({ type: mongoose_2.Types.ObjectId, ref: 'User', required: true }),
    __metadata("design:type", mongoose_2.Types.ObjectId)
], EventRsvp.prototype, "userId", void 0);
__decorate([
    (0, mongoose_1.Prop)({ type: String, enum: ['REGISTERED', 'ATTENDED', 'CANCELLED'], default: 'REGISTERED' }),
    __metadata("design:type", String)
], EventRsvp.prototype, "status", void 0);
exports.EventRsvp = EventRsvp = __decorate([
    (0, mongoose_1.Schema)({ timestamps: true })
], EventRsvp);
exports.EventRsvpSchema = mongoose_1.SchemaFactory.createForClass(EventRsvp);
exports.EventRsvpSchema.index({ eventId: 1, userId: 1 }, { unique: true });
//# sourceMappingURL=event.schema.js.map