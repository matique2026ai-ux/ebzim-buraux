import { MultilingualTextDto, LocationDataDto } from '../../../common/dto/shared.dto';
export declare class CreateEventDto {
    categoryId: string;
    title: MultilingualTextDto;
    description: MultilingualTextDto;
    startDate: string;
    endDate: string;
    location?: LocationDataDto;
    isOnline?: boolean;
    publicationStatus?: string;
    eventStatus?: string;
}
