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

export class CreatePublicationDto {
  title: { ar: string; en: string; fr: string };
  author: { ar: string; en: string; fr: string };
  summary: { ar: string; en: string; fr: string };
  thumbnailUrl: string;
  pdfUrl: string;
  category: PublicationCategory;
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
    return this.publicationsService.create(createDto, req.user.userId);
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
