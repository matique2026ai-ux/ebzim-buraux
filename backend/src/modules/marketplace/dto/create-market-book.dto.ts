import { IsString, IsNotEmpty, IsObject, IsNumber, IsEnum, IsBoolean, IsOptional } from 'class-validator';

export class CreateMarketBookDto {
  @IsObject()
  @IsNotEmpty()
  title: Record<string, string>;

  @IsString()
  @IsNotEmpty()
  author: string;

  @IsObject()
  @IsNotEmpty()
  description: Record<string, string>;

  @IsNumber()
  @IsNotEmpty()
  price: number;

  @IsNumber()
  @IsOptional()
  deliveryCost?: number;

  @IsEnum(['NEW', 'USED'])
  @IsOptional()
  condition?: string;

  @IsString()
  @IsNotEmpty()
  coverImage: string;

  @IsString()
  @IsNotEmpty()
  contactInfo: string;

  @IsBoolean()
  @IsOptional()
  isAvailable?: boolean;
}
