import { Model } from 'mongoose';
import { ReportDocument } from './schemas/report.schema';
export declare class ReportsService {
    private reportModel;
    constructor(reportModel: Model<ReportDocument>);
    createReport(dto: any, reporterId: string | null): Promise<import("mongoose").Document<unknown, {}, ReportDocument, {}, import("mongoose").DefaultSchemaOptions> & import("./schemas/report.schema").Report & import("mongoose").Document<import("mongoose").Types.ObjectId, any, any, Record<string, any>, {}> & Required<{
        _id: import("mongoose").Types.ObjectId;
    }> & {
        __v: number;
    } & {
        id: string;
    }>;
    getReports(user: any, options: any): Promise<{
        data: any[];
        meta: {
            total: number;
            page: number;
            limit: number;
            totalPages: number;
            hasNextPage: boolean;
        };
    }>;
    updateStatus(id: string, newStatus: string, user: any): Promise<import("mongoose").Document<unknown, {}, ReportDocument, {}, import("mongoose").DefaultSchemaOptions> & import("./schemas/report.schema").Report & import("mongoose").Document<import("mongoose").Types.ObjectId, any, any, Record<string, any>, {}> & Required<{
        _id: import("mongoose").Types.ObjectId;
    }> & {
        __v: number;
    } & {
        id: string;
    }>;
}
