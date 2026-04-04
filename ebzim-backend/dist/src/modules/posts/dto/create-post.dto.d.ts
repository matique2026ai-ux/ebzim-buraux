import { MultilingualTextDto, MediaAttachmentDto } from '../../../common/dto/shared.dto';
export declare class CreatePostDto {
    categoryId: string;
    title: MultilingualTextDto;
    summary: MultilingualTextDto;
    content: MultilingualTextDto;
    media?: MediaAttachmentDto[];
    status?: string;
    isFeatured?: boolean;
}
