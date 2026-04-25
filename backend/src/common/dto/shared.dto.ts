import { IsString, IsOptional, IsNotEmpty } from 'class-validator';

export class MultilingualTextDto {
  @IsString()
  @IsOptional()
  ar?: string;

  @IsString()
  @IsOptional()
  fr?: string;

  @IsString()
  @IsOptional()
  en?: string;
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
