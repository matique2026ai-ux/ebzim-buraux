import {
  IsString,
  IsNotEmpty,
  IsOptional,
  IsBoolean,
  ValidateNested,
  IsMongoId,
  IsEnum,
} from 'class-validator';
import { Type } from 'class-transformer';
import {
  MultilingualTextDto,
  MediaAttachmentDto,
} from '../../../common/dto/shared.dto';

export class CreatePostDto {
  @IsMongoId()
  @IsNotEmpty()
  categoryId: string;

  @ValidateNested()
  @Type(() => MultilingualTextDto)
  title: MultilingualTextDto;

  @ValidateNested()
  @Type(() => MultilingualTextDto)
  summary: MultilingualTextDto;

  @ValidateNested()
  @Type(() => MultilingualTextDto)
  content: MultilingualTextDto;

  @IsOptional()
  @ValidateNested({ each: true })
  @Type(() => MediaAttachmentDto)
  media?: MediaAttachmentDto[];

  @IsEnum(['DRAFT', 'PUBLISHED', 'ARCHIVED'])
  @IsOptional()
  status?: string;

  @IsBoolean()
  @IsOptional()
  isFeatured?: boolean;
}
