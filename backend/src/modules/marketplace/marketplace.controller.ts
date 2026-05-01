import { Controller, Get, Post, Body, Patch, Param, Delete, Query, UseGuards, Req } from '@nestjs/common';
import { MarketplaceService } from './marketplace.service';
import { CreateMarketBookDto } from './dto/create-market-book.dto';
import { UpdateMarketBookDto } from './dto/update-market-book.dto';
import { JwtAuthGuard } from '../../common/guards/jwt-auth.guard';
import { RolesGuard } from '../../common/guards/roles.guard';
import { Roles } from '../../common/decorators/roles.decorator';
import { Role } from '../../common/enums/role.enum';
import { Request } from 'express';

@Controller('marketplace')
export class MarketplaceController {
  constructor(private readonly marketplaceService: MarketplaceService) {}

  @Get()
  findAll(@Query('availableOnly') availableOnly: string) {
    const isAvailableOnly = availableOnly === 'true';
    return this.marketplaceService.findAll(isAvailableOnly);
  }

  @Get(':id')
  findOne(@Param('id') id: string) {
    return this.marketplaceService.findOne(id);
  }

  @Post()
  @UseGuards(JwtAuthGuard, RolesGuard)
  @Roles(Role.SUPER_ADMIN, Role.SELLER)
  create(@Body() createMarketBookDto: CreateMarketBookDto, @Req() req: Request) {
    const user = req.user as any;
    return this.marketplaceService.create(createMarketBookDto, user.userId);
  }

  @Patch(':id')
  @UseGuards(JwtAuthGuard, RolesGuard)
  @Roles(Role.SUPER_ADMIN, Role.SELLER)
  update(@Param('id') id: string, @Body() updateMarketBookDto: UpdateMarketBookDto) {
    return this.marketplaceService.update(id, updateMarketBookDto);
  }

  @Delete(':id')
  @UseGuards(JwtAuthGuard, RolesGuard)
  @Roles(Role.SUPER_ADMIN, Role.SELLER)
  remove(@Param('id') id: string) {
    return this.marketplaceService.remove(id);
  }
}
