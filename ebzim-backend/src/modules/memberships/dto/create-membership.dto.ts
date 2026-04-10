import { IsString, IsNotEmpty, IsArray, IsOptional, IsEnum } from 'class-validator';

export class CreateMembershipDto {
  @IsString()
  @IsNotEmpty()
  fullName: string;

  @IsString()
  @IsOptional()
  dob?: string;

  @IsString()
  @IsOptional()
  gender?: string;

  @IsString()
  @IsNotEmpty()
  wilayaId: string;

  @IsString()
  @IsNotEmpty()
  communeId: string;

  @IsString()
  @IsNotEmpty()
  phone: string;

  @IsString()
  @IsOptional()
  email?: string;

  @IsArray()
  @IsString({ each: true })
  interests: string[];

  @IsArray()
  @IsString({ each: true })
  @IsOptional()
  skills?: string[];

  @IsString()
  @IsNotEmpty()
  motivation: string;
}

export class ReviewMembershipDto {
  @IsEnum(['UNDER_REVIEW', 'NEEDS_INFO', 'APPROVED', 'REJECTED'])
  @IsOptional()
  status?: string;

  @IsString()
  @IsOptional()
  internalReviewNotes?: string;
}
