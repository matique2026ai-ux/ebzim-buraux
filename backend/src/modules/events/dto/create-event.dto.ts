import {
  IsNotEmpty,
  IsOptional,
  IsBoolean,
  ValidateNested,
  IsMongoId,
  IsDateString,
  IsEnum,
} from 'class-validator';
import { Type } from 'class-transformer';
import {
  MultilingualTextDto,
  LocationDataDto,
} from '../../../common/dto/shared.dto';

export class CreateEventDto {
  @IsMongoId()
  @IsNotEmpty()
  categoryId: string;

  @ValidateNested()
  @Type(() => MultilingualTextDto)
  title: MultilingualTextDto;

  @ValidateNested()
  @Type(() => MultilingualTextDto)
  description: MultilingualTextDto;

  @IsDateString()
  @IsNotEmpty()
  startDate: string;

  @IsDateString()
  @IsNotEmpty()
  endDate: string;

  @IsOptional()
  @ValidateNested()
  @Type(() => LocationDataDto)
  location?: LocationDataDto;

  @IsBoolean()
  @IsOptional()
  isOnline?: boolean;

  @IsEnum(['DRAFT', 'PUBLISHED', 'CANCELLED'])
  @IsOptional()
  publicationStatus?: string;

  @IsEnum(['UPCOMING', 'ONGOING', 'COMPLETED', 'CANCELLED'])
  @IsOptional()
  eventStatus?: string;

  @IsOptional()
  coverImage?: { url: string; publicId: string };

  @IsBoolean()
  @IsOptional()
  isFeatured?: boolean;
}
