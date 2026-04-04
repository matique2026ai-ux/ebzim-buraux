import { ReportsService } from './reports.service';
import { CreateReportDto, UpdateReportStatusDto } from './dto/create-report.dto';
export declare class ReportsController {
    private readonly reportsService;
    constructor(reportsService: ReportsService);
    createReport(createReportDto: CreateReportDto, req: {
        user?: any;
    }): Promise<import("mongoose").Document<unknown, {}, import("./schemas/report.schema").ReportDocument, {}, import("mongoose").DefaultSchemaOptions> & import("./schemas/report.schema").Report & import("mongoose").Document<import("mongoose").Types.ObjectId, any, any, Record<string, any>, {}> & Required<{
        _id: import("mongoose").Types.ObjectId;
    }> & {
        __v: number;
    } & {
        id: string;
    }>;
    getReports(req: {
        user?: any;
    }, page: number): Promise<{
        data: any[];
        meta: {
            total: number;
            page: number;
            limit: number;
            totalPages: number;
            hasNextPage: boolean;
        };
    }>;
    updateStatus(id: string, updateDto: UpdateReportStatusDto, req: {
        user?: any;
    }): Promise<import("mongoose").Document<unknown, {}, import("./schemas/report.schema").ReportDocument, {}, import("mongoose").DefaultSchemaOptions> & import("./schemas/report.schema").Report & import("mongoose").Document<import("mongoose").Types.ObjectId, any, any, Record<string, any>, {}> & Required<{
        _id: import("mongoose").Types.ObjectId;
    }> & {
        __v: number;
    } & {
        id: string;
    }>;
}
