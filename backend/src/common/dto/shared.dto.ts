import { IsString, IsOptional, IsNotEmpty, ValidateNested } from 'class-validator';
import { Type } from 'class-transformer';

export class MultilingualTextDto {
  @IsString()
  @IsNotEmpty()
  ar: string;

  @IsString()
  @IsNotEmpty()
  fr: string;

  @IsString()
  @IsNotEmpty()
  en: string;
}

export class LocationDataDto {
  @IsString()
  @IsOptional()
  type?: string;

  @IsOptional()
  coordinates?: number[]; // [longitude, latitude]

  @IsString()
  @IsOptional()
  formattedAddress?: string;
}

export class MediaAttachmentDto {
  @IsString()
  @IsNotEmpty()
  type: string;

  @IsString()
  @IsNotEmpty()
  cloudinaryUrl: string;

  @IsString()
  @IsNotEmpty()
  publicId: string;
}
