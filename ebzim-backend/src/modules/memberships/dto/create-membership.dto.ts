import { IsString, IsNotEmpty, IsArray, IsOptional, IsEnum } from 'class-validator';

export class CreateMembershipDto {
  @IsString()
  @IsNotEmpty()
  firstName: string;

  @IsString()
  @IsNotEmpty()
  lastName: string;

  @IsString()
  @IsNotEmpty()
  profession: string;

  @IsString()
  @IsNotEmpty()
  phone: string;

  @IsArray()
  @IsString({ each: true })
  domainsOfInterest: string[];

  @IsString()
  @IsNotEmpty()
  desiredContribution: string;
}

export class ReviewMembershipDto {
  @IsEnum(['UNDER_REVIEW', 'NEEDS_INFO', 'APPROVED', 'REJECTED'])
  @IsOptional()
  status?: string;

  @IsString()
  @IsOptional()
  internalReviewNotes?: string;
}
