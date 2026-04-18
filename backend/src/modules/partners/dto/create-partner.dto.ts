import {
  IsString,
  IsObject,
  IsOptional,
  IsBoolean,
  IsNumber,
} from 'class-validator';

export class CreatePartnerDto {
  @IsObject()
  name: { ar: string; en: string; fr: string };

  @IsString()
  logoUrl: string;

  @IsObject()
  goalsSummary: { ar: string; en: string; fr: string };

  @IsString()
  @IsOptional()
  websiteUrl?: string;

  @IsString()
  @IsOptional()
  color?: string;

  @IsNumber()
  @IsOptional()
  order?: number;

  @IsBoolean()
  @IsOptional()
  isActive?: boolean;
}

export class UpdatePartnerDto extends CreatePartnerDto {}
