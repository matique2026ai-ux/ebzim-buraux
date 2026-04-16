import { Model } from 'mongoose';
import { MembershipDocument } from './schemas/membership.schema';
import { UserDocument } from '../users/schemas/user.schema';
export declare class MembershipsService {
    private membershipModel;
    private userModel;
    constructor(membershipModel: Model<MembershipDocument>, userModel: Model<UserDocument>);
    submit(userId: string, applicationData: any): Promise<import("mongoose").Document<unknown, {}, MembershipDocument, {}, import("mongoose").DefaultSchemaOptions> & import("./schemas/membership.schema").Membership & import("mongoose").Document<import("mongoose").Types.ObjectId, any, any, Record<string, any>, {}> & Required<{
        _id: import("mongoose").Types.ObjectId;
    }> & {
        __v: number;
    } & {
        id: string;
    }>;
    getStatusByUser(userId: string): Promise<{
        status: string;
    }>;
    getAdminTable(options: any): Promise<{
        data: any[];
        meta: {
            total: number;
            page: number;
            limit: number;
            totalPages: number;
            hasNextPage: boolean;
        };
    }>;
    processReview(id: string, updateDto: any, adminUser: any): Promise<import("mongoose").Document<unknown, {}, MembershipDocument, {}, import("mongoose").DefaultSchemaOptions> & import("./schemas/membership.schema").Membership & import("mongoose").Document<import("mongoose").Types.ObjectId, any, any, Record<string, any>, {}> & Required<{
        _id: import("mongoose").Types.ObjectId;
    }> & {
        __v: number;
    } & {
        id: string;
    }>;
}
