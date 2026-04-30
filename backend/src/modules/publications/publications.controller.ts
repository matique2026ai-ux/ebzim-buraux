import {
  Controller,
  Get,
  Post,
  Patch,
  Delete,
  Body,
  Param,
  UseGuards,
  Request,
} from '@nestjs/common';
import { PublicationsService } from './publications.service';
import { JwtAuthGuard } from '../../common/guards/jwt-auth.guard';
import { RolesGuard } from '../../common/guards/roles.guard';
import { Roles } from '../../common/decorators/roles.decorator';
import { Role } from '../../common/enums/role.enum';
import { ApiTags, ApiOperation, ApiBearerAuth } from '@nestjs/swagger';
import { PublicationCategory } from './schemas/publication.schema';
import {
  IsString,
  IsObject,
  IsEnum,
  IsOptional,
  IsDateString,
  ValidateNested,
} from 'class-validator';
import { Type } from 'class-transformer';

export class MultilingualString {
  @IsString()
  ar: string;
  @IsString()
  en: string;
  @IsString()
  fr: string;
}

export class CreatePublicationDto {
  @IsObject()
  @ValidateNested()
  @Type(() => MultilingualString)
  title: MultilingualString;

  @IsObject()
  @ValidateNested()
  @Type(() => MultilingualString)
  author: MultilingualString;

  @IsObject()
  @ValidateNested()
  @Type(() => MultilingualString)
  summary: MultilingualString;

  @IsString()
  thumbnailUrl: string;

  @IsString()
  pdfUrl: string;

  @IsEnum(PublicationCategory)
  category: PublicationCategory;

  @IsOptional()
  @IsDateString()
  publishedDate?: Date;
}

interface AuthenticatedRequest extends Request {
  user: {
    userId: string;
    role: string;
  };
}

@ApiTags('Publications & Digital Library')
@Controller('publications')
export class PublicationsController {
  constructor(private readonly publicationsService: PublicationsService) {}

  @Get()
  @ApiOperation({ summary: 'Fetch all publications' })
  async findAll() {
    return this.publicationsService.findAll();
  }

  @Get(':id')
  @ApiOperation({ summary: 'Get single publication' })
  async findOne(@Param('id') id: string) {
    return this.publicationsService.findOne(id);
  }

  @Post()
  @UseGuards(JwtAuthGuard, RolesGuard)
  @Roles(Role.SUPER_ADMIN, Role.ADMIN)
  @ApiBearerAuth()
  @ApiOperation({ summary: 'Create publication (Admin only)' })
  async create(
    @Body() createDto: CreatePublicationDto,
    @Request() req: AuthenticatedRequest,
  ) {
    try {
      const result = await this.publicationsService.create(
        createDto,
        req.user.userId,
      );
      return result;
    } catch (e: any) {
      require('fs').appendFileSync(
        'publication_error.log',
        new Date().toISOString() +
          ' ERROR: ' +
          e.message +
          '\n' +
          e.stack +
          '\n',
      );
      throw e;
    }
  }

  @Patch(':id')
  @UseGuards(JwtAuthGuard, RolesGuard)
  @Roles(Role.SUPER_ADMIN, Role.ADMIN)
  @ApiBearerAuth()
  @ApiOperation({ summary: 'Update publication (Admin only)' })
  async update(
    @Param('id') id: string,
    @Body() updateDto: Partial<CreatePublicationDto>,
  ) {
    return this.publicationsService.update(id, updateDto);
  }

  @Delete(':id')
  @UseGuards(JwtAuthGuard, RolesGuard)
  @Roles(Role.SUPER_ADMIN, Role.ADMIN)
  @ApiBearerAuth()
  @ApiOperation({ summary: 'Delete publication (Admin only)' })
  async remove(@Param('id') id: string): Promise<{ deleted: boolean }> {
    return this.publicationsService.remove(id);
  }
}
