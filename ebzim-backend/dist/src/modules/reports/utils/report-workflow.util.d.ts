import { Report } from '../schemas/report.schema';
export declare class ReportWorkflowUtil {
    static validateAuthorityAccess(user: any, report: Report): void;
    static validateStatusTransition(currentStatus: string, newStatus: string, user: any): void;
}
