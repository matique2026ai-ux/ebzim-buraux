import { IsString, IsObject, IsOptional, IsBoolean, IsNumber } from 'class-validator';

export class CreateLeaderDto {
  @IsObject()
  name: { ar: string; en: string; fr: string };

  @IsObject()
  role: { ar: string; en: string; fr: string };

  @IsString()
  @IsOptional()
  photoUrl?: string;

  @IsNumber()
  @IsOptional()
  order?: number;

  @IsBoolean()
  @IsOptional()
  isActive?: boolean;
}

export class UpdateLeaderDto extends CreateLeaderDto {}
