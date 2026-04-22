import {
  IsString,
  IsObject,
  IsOptional,
  IsBoolean,
  IsNumber,
} from 'class-validator';

export class CreateHeroSlideDto {
  @IsObject()
  title: { ar: string; en: string; fr: string };

  @IsObject()
  subtitle: { ar: string; en: string; fr: string };

  @IsString()
  imageUrl: string;

  @IsString()
  @IsOptional()
  buttonText?: string;

  @IsString()
  @IsOptional()
  buttonLink?: string;

  @IsNumber()
  @IsOptional()
  order?: number;

  @IsBoolean()
  @IsOptional()
  isActive?: boolean;

  @IsString()
  @IsOptional()
  videoUrl?: string;

  @IsString()
  @IsOptional()
  overlayColor?: string;

  @IsNumber()
  @IsOptional()
  overlayOpacity?: number;

  @IsString()
  @IsOptional()
  location?: string;
}

export class UpdateHeroSlideDto extends CreateHeroSlideDto {}
