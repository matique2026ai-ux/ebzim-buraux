import {
  IsString,
  IsNotEmpty,
  IsOptional,
  ValidateNested,
} from 'class-validator';
import { Type } from 'class-transformer';
import { MultilingualTextDto } from '../../../common/dto/shared.dto';

export class CreateCategoryDto {
  @IsString()
  @IsNotEmpty()
  slug: string;

  @ValidateNested()
  @Type(() => MultilingualTextDto)
  name: MultilingualTextDto;

  @IsOptional()
  @ValidateNested()
  @Type(() => MultilingualTextDto)
  description?: MultilingualTextDto;

  @IsOptional()
  coverImage?: { url: string; publicId: string };
}
