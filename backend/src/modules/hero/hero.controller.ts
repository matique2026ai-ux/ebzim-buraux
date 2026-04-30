import {
  Controller,
  Get,
  Post,
  Patch,
  Delete,
  Body,
  Param,
  Query,
  UseGuards,
} from '@nestjs/common';
import { HeroService } from './hero.service';
import {
  CreateHeroSlideDto,
  UpdateHeroSlideDto,
} from './dto/create-hero-slide.dto';
import { JwtAuthGuard } from '../../common/guards/jwt-auth.guard';
import { RolesGuard } from '../../common/guards/roles.guard';
import { Roles } from '../../common/decorators/roles.decorator';
import { Role } from '../../common/enums/role.enum';

@Controller('hero-slides')
export class HeroController {
  constructor(private readonly heroService: HeroService) {}

  @Get()
  async findAll(@Query('location') location: string = 'HOME') {
    console.log(`[HERO] GET /hero-slides request for location: ${location}`);
    const slides = await this.heroService.findAll(location);
    console.log(`[HERO] Found ${slides.length} active slides for ${location}`);
    if (slides.length > 0) {
      console.log(`[HERO] Slide 0: ID=${slides[0]._id}, Active=${slides[0].isActive}`);
    }
    return slides;
  }

  @Get('admin')
  @UseGuards(JwtAuthGuard, RolesGuard)
  @Roles(Role.SUPER_ADMIN, Role.ADMIN)
  async getAdminTable() {
    return this.heroService.getAdminTable();
  }

  @Get('admin/all')
  @UseGuards(JwtAuthGuard, RolesGuard)
  @Roles(Role.SUPER_ADMIN, Role.ADMIN)
  async getAdminByLocation(@Query('location') location: string = 'HOME') {
    return this.heroService.getAdminByLocation(location);
  }

  @Post()
  @UseGuards(JwtAuthGuard, RolesGuard)
  @Roles(Role.SUPER_ADMIN, Role.ADMIN)
  async create(@Body() dto: CreateHeroSlideDto) {
    return this.heroService.create(dto);
  }

  @Patch(':id')
  @UseGuards(JwtAuthGuard, RolesGuard)
  @Roles(Role.SUPER_ADMIN, Role.ADMIN)
  async update(@Param('id') id: string, @Body() dto: UpdateHeroSlideDto) {
    return this.heroService.update(id, dto);
  }

  @Get(':id')
  async findOne(@Param('id') id: string) {
    return this.heroService.findOne(id);
  }

  @Delete(':id')
  @UseGuards(JwtAuthGuard, RolesGuard)
  @Roles(Role.SUPER_ADMIN, Role.ADMIN)
  async delete(@Param('id') id: string) {
    return this.heroService.delete(id);
  }
}
