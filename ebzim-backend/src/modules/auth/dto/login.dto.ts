import { IsEmail, IsString, MinLength } from 'class-validator';
import { ApiProperty } from '@nestjs/swagger';

export class LoginDto {
  @ApiProperty({ example: 'admin@ebzim.org' })
  @IsEmail()
  email: string;

  @ApiProperty({ example: 'AdminPassword123!' })
  @IsString()
  @MinLength(6)
  password: string;
}
