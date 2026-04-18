import { Model } from 'mongoose';
import { MembershipDocument } from '../memberships/schemas/membership.schema';
import { ReportDocument } from '../reports/schemas/report.schema';
import { EventDocument } from '../events/schemas/event.schema';
import { ContributionDocument } from '../contributions/schemas/contribution.schema';
import { PostDocument } from '../posts/schemas/post.schema';
import { UserDocument } from '../users/schemas/user.schema';
export declare class AdminService {
    private membershipModel;
    private reportModel;
    private eventModel;
    private contributionModel;
    private postModel;
    private userModel;
    constructor(membershipModel: Model<MembershipDocument>, reportModel: Model<ReportDocument>, eventModel: Model<EventDocument>, contributionModel: Model<ContributionDocument>, postModel: Model<PostDocument>, userModel: Model<UserDocument>);
    getStats(): Promise<{
        membersCount: number;
        pendingReportsCount: number;
        activeEventsCount: number;
        totalContributions: number;
        pinnedPostsCount: number;
        totalPostsCount: number;
        totalUsersCount: number;
    }>;
    getAllUsers(): Promise<(import("mongoose").Document<unknown, {}, UserDocument, {}, import("mongoose").DefaultSchemaOptions> & import("../users/schemas/user.schema").User & import("mongoose").Document<import("mongoose").Types.ObjectId, any, any, Record<string, any>, {}> & Required<{
        _id: import("mongoose").Types.ObjectId;
    }> & {
        __v: number;
    } & {
        id: string;
    })[]>;
    updateUserStatus(userId: string, status: string): Promise<(import("mongoose").Document<unknown, {}, UserDocument, {}, import("mongoose").DefaultSchemaOptions> & import("../users/schemas/user.schema").User & import("mongoose").Document<import("mongoose").Types.ObjectId, any, any, Record<string, any>, {}> & Required<{
        _id: import("mongoose").Types.ObjectId;
    }> & {
        __v: number;
    } & {
        id: string;
    }) | null>;
    deleteUser(userId: string): Promise<(import("mongoose").Document<unknown, {}, UserDocument, {}, import("mongoose").DefaultSchemaOptions> & import("../users/schemas/user.schema").User & import("mongoose").Document<import("mongoose").Types.ObjectId, any, any, Record<string, any>, {}> & Required<{
        _id: import("mongoose").Types.ObjectId;
    }> & {
        __v: number;
    } & {
        id: string;
    }) | null>;
    updateUser(userId: string, data: any): Promise<(import("mongoose").Document<unknown, {}, UserDocument, {}, import("mongoose").DefaultSchemaOptions> & import("../users/schemas/user.schema").User & import("mongoose").Document<import("mongoose").Types.ObjectId, any, any, Record<string, any>, {}> & Required<{
        _id: import("mongoose").Types.ObjectId;
    }> & {
        __v: number;
    } & {
        id: string;
    }) | null>;
}
