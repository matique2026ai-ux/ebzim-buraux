import {
  IsString,
  IsOptional,
  IsNotEmpty,
} from 'class-validator';

export class MultilingualTextDto {
  @IsString()
  @IsNotEmpty()
  ar: string;

  @IsString()
  fr: string;

  @IsString()
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
