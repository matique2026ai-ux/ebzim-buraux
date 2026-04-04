import { MultilingualTextDto } from '../../../common/dto/shared.dto';
export declare class CreateCategoryDto {
    slug: string;
    name: MultilingualTextDto;
    description?: MultilingualTextDto;
    coverImage?: {
        url: string;
        publicId: string;
    };
}
