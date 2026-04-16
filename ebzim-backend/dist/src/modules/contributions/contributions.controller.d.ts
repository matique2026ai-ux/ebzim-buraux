import { ContributionsService } from './contributions.service';
export declare class ContributionsController {
    private readonly contributionsService;
    constructor(contributionsService: ContributionsService);
    submit(req: any, dto: any): Promise<import("mongoose").Document<unknown, {}, import("./schemas/contribution.schema").ContributionDocument, {}, import("mongoose").DefaultSchemaOptions> & import("./schemas/contribution.schema").Contribution & import("mongoose").Document<import("mongoose").Types.ObjectId, any, any, Record<string, any>, {}> & Required<{
        _id: import("mongoose").Types.ObjectId;
    }> & {
        __v: number;
    } & {
        id: string;
    }>;
    getMy(req: any): Promise<(import("mongoose").Document<unknown, {}, import("./schemas/contribution.schema").ContributionDocument, {}, import("mongoose").DefaultSchemaOptions> & import("./schemas/contribution.schema").Contribution & import("mongoose").Document<import("mongoose").Types.ObjectId, any, any, Record<string, any>, {}> & Required<{
        _id: import("mongoose").Types.ObjectId;
    }> & {
        __v: number;
    } & {
        id: string;
    })[]>;
    getAll(): Promise<(import("mongoose").Document<unknown, {}, import("./schemas/contribution.schema").ContributionDocument, {}, import("mongoose").DefaultSchemaOptions> & import("./schemas/contribution.schema").Contribution & import("mongoose").Document<import("mongoose").Types.ObjectId, any, any, Record<string, any>, {}> & Required<{
        _id: import("mongoose").Types.ObjectId;
    }> & {
        __v: number;
    } & {
        id: string;
    })[]>;
    verify(id: string, req: any, status: string, notes?: string): Promise<import("mongoose").Document<unknown, {}, import("./schemas/contribution.schema").ContributionDocument, {}, import("mongoose").DefaultSchemaOptions> & import("./schemas/contribution.schema").Contribution & import("mongoose").Document<import("mongoose").Types.ObjectId, any, any, Record<string, any>, {}> & Required<{
        _id: import("mongoose").Types.ObjectId;
    }> & {
        __v: number;
    } & {
        id: string;
    }>;
}
