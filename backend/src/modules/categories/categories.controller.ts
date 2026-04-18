import {
  Controller,
  Get,
  Post,
  Body,
  Headers,
  UseGuards,
} from '@nestjs/common';
import {
  ApiTags,
  ApiOperation,
  ApiBearerAuth,
  ApiHeader,
} from '@nestjs/swagger';
import { CategoriesService } from './categories.service';
import { RolesGuard } from '../../common/guards/roles.guard';
import { JwtAuthGuard } from '../../common/guards/jwt-auth.guard';
import { Roles } from '../../common/decorators/roles.decorator';
import { Role } from '../../common/enums/role.enum';

import { CreateCategoryDto } from './dto/create-category.dto';

@ApiTags('Categories')
@Controller('categories')
export class CategoriesController {
  constructor(private readonly categoriesService: CategoriesService) {}

  @Get()
  @ApiOperation({ summary: 'Public: List all categories (Localized)' })
  @ApiHeader({
    name: 'Accept-Language',
    required: false,
    description: 'ar, fr, or en',
  })
  async getPublicCategories(@Headers('Accept-Language') lang: string) {
    const locale = ['ar', 'fr', 'en'].includes(lang) ? lang : 'en';
    return this.categoriesService.getPublicCategories(locale);
  }

  @Get('admin')
  @UseGuards(JwtAuthGuard, RolesGuard)
  @Roles(Role.SUPER_ADMIN, Role.ADMIN)
  @ApiBearerAuth()
  @ApiOperation({ summary: 'Admin: List all categories (Full Base Object)' })
  async getAdminCategories() {
    return this.categoriesService.getAdminCategories();
  }

  @Post()
  @UseGuards(JwtAuthGuard, RolesGuard)
  @Roles(Role.SUPER_ADMIN, Role.ADMIN)
  @ApiBearerAuth()
  @ApiOperation({ summary: 'Admin: Create a new category' })
  async createCategory(@Body() createDto: CreateCategoryDto) {
    return this.categoriesService.createCategory(createDto);
  }
}
