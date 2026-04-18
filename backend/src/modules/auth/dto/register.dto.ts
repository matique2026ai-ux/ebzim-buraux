import {
  IsEmail,
  IsString,
  MinLength,
  IsOptional,
  ValidateNested,
  IsNotEmpty,
} from 'class-validator';
import { ApiProperty } from '@nestjs/swagger';
import { Type } from 'class-transformer';

export class RegisterProfileDto {
  @ApiProperty({ example: 'Salim' })
  @IsString()
  @IsNotEmpty()
  firstName: string;

  @ApiProperty({ example: 'Al-Mansour', required: false })
  @IsString()
  @IsOptional()
  lastName?: string;

  @ApiProperty({ example: '+213 50 XXX XXXX', required: false })
  @IsString()
  @IsOptional()
  phone?: string;
}

export class RegisterDto {
  @ApiProperty({ example: 'salim@ebzim.org' })
  @IsEmail()
  email: string;

  @ApiProperty({ example: 'strongPassword123' })
  @IsString()
  @MinLength(8)
  password: string;

  @ApiProperty({ type: RegisterProfileDto })
  @ValidateNested()
  @Type(() => RegisterProfileDto)
  profile: RegisterProfileDto;
}
