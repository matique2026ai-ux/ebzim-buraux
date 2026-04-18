"use strict";
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.AdminModule = void 0;
const common_1 = require("@nestjs/common");
const mongoose_1 = require("@nestjs/mongoose");
const admin_controller_1 = require("./admin.controller");
const admin_service_1 = require("./admin.service");
const membership_schema_1 = require("../memberships/schemas/membership.schema");
const report_schema_1 = require("../reports/schemas/report.schema");
const event_schema_1 = require("../events/schemas/event.schema");
const contribution_schema_1 = require("../contributions/schemas/contribution.schema");
const post_schema_1 = require("../posts/schemas/post.schema");
const user_schema_1 = require("../users/schemas/user.schema");
let AdminModule = class AdminModule {
};
exports.AdminModule = AdminModule;
exports.AdminModule = AdminModule = __decorate([
    (0, common_1.Module)({
        imports: [
            mongoose_1.MongooseModule.forFeature([
                { name: 'Membership', schema: membership_schema_1.MembershipSchema },
                { name: 'Report', schema: report_schema_1.ReportSchema },
                { name: 'Event', schema: event_schema_1.EventSchema },
                { name: 'Contribution', schema: contribution_schema_1.ContributionSchema },
                { name: 'Post', schema: post_schema_1.PostSchema },
                { name: 'User', schema: user_schema_1.UserSchema },
            ]),
        ],
        controllers: [admin_controller_1.AdminController],
        providers: [admin_service_1.AdminService],
    })
], AdminModule);
//# sourceMappingURL=admin.module.js.map