import { LocationDataDto } from '../../../common/dto/shared.dto';
export declare class CreateReportDto {
    isAnonymous?: boolean;
    guestContactInfo?: {
        name?: string;
        email?: string;
        phone?: string;
    };
    title: string;
    description: string;
    incidentCategory: string;
    severity?: string;
    priority?: string;
    locationData?: LocationDataDto;
}
export declare class UpdateReportStatusDto {
    status: string;
}
