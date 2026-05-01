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
  @IsOptional()
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

  @IsBoolean()
  @IsOptional()
  isPinned?: boolean;

  @IsString()
  @IsOptional()
  category?: string;

  @IsEnum(['NEWS', 'PROJECT'])
  @IsOptional()
  contentType?: string;

  @IsEnum(['NORMAL', 'URGENT', 'IMPORTANT'])
  @IsOptional()
  newsType?: string;

  @IsEnum([
    'PREPARING',
    'LAUNCHING',
    'ACTIVE',
    'ON_HOLD',
    'COMPLETED',
    'GENERAL',
  ])
  @IsOptional()
  projectStatus?: string;

  @IsOptional()
  metadata?: Record<string, any>;
}
