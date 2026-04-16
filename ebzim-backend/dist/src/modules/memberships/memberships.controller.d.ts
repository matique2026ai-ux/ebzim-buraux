import { MembershipsService } from './memberships.service';
import { CreateMembershipDto, ReviewMembershipDto } from './dto/create-membership.dto';
export declare class MembershipsController {
    private readonly membershipsService;
    constructor(membershipsService: MembershipsService);
    submitApplication(appData: CreateMembershipDto, req: {
        user?: any;
    }): Promise<import("mongoose").Document<unknown, {}, import("./schemas/membership.schema").MembershipDocument, {}, import("mongoose").DefaultSchemaOptions> & import("./schemas/membership.schema").Membership & import("mongoose").Document<import("mongoose").Types.ObjectId, any, any, Record<string, any>, {}> & Required<{
        _id: import("mongoose").Types.ObjectId;
    }> & {
        __v: number;
    } & {
        id: string;
    }>;
    getMyStatus(req: {
        user?: any;
    }): Promise<{
        status: string;
    }>;
    getAdminTable(page: number, limit: number): Promise<{
        data: any[];
        meta: {
            total: number;
            page: number;
            limit: number;
            totalPages: number;
            hasNextPage: boolean;
        };
    }>;
    processReview(id: string, updateDto: ReviewMembershipDto, req: {
        user?: any;
    }): Promise<import("mongoose").Document<unknown, {}, import("./schemas/membership.schema").MembershipDocument, {}, import("mongoose").DefaultSchemaOptions> & import("./schemas/membership.schema").Membership & import("mongoose").Document<import("mongoose").Types.ObjectId, any, any, Record<string, any>, {}> & Required<{
        _id: import("mongoose").Types.ObjectId;
    }> & {
        __v: number;
    } & {
        id: string;
    }>;
}
