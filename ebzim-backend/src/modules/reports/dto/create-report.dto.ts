import { IsString, IsNotEmpty, IsOptional, IsBoolean, ValidateNested, IsEnum, IsObject } from 'class-validator';
import { Type } from 'class-transformer';
import { LocationDataDto } from '../../../common/dto/shared.dto';

export class CreateReportDto {
  @IsBoolean()
  @IsOptional()
  isAnonymous?: boolean;

  @IsObject()
  @IsOptional()
  guestContactInfo?: { name?: string; email?: string; phone?: string };

  @IsString()
  @IsNotEmpty()
  title: string;

  @IsString()
  @IsNotEmpty()
  description: string;

  @IsEnum(['VANDALISM', 'DEGRADATION', 'ILLEGAL_INTERVENTION', 'URGENT_OBSERVATION', 'OTHER'])
  @IsNotEmpty()
  incidentCategory: string;

  @IsEnum(['LOW', 'MEDIUM', 'HIGH', 'CRITICAL'])
  @IsOptional()
  severity?: string;

  @IsEnum(['LOW', 'NORMAL', 'URGENT'])
  @IsOptional()
  priority?: string;

  @IsOptional()
  @ValidateNested()
  @Type(() => LocationDataDto)
  locationData?: LocationDataDto;
}

export class UpdateReportStatusDto {
  @IsEnum([
      'TRIAGED_BY_ASSOCIATION',
      'UNDER_REVIEW',
      'ASSIGNED_TO_AUTHORITY',
      'IN_INTERVENTION',
      'NEEDS_MORE_INFO',
      'RESOLVED',
      'CLOSED',
      'REJECTED',
  ])
  @IsNotEmpty()
  status: string;
}
