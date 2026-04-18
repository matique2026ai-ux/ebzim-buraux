import {
  Controller,
  Get,
  Post,
  Patch,
  Body,
  Param,
  Query,
  UseGuards,
  Request,
} from '@nestjs/common';
import {
  ApiTags,
  ApiOperation,
  ApiBearerAuth,
  ApiQuery,
} from '@nestjs/swagger';
import { MembershipsService } from './memberships.service';
import { RolesGuard } from '../../common/guards/roles.guard';
import { JwtAuthGuard } from '../../common/guards/jwt-auth.guard';
import { Roles } from '../../common/decorators/roles.decorator';
import { Role } from '../../common/enums/role.enum';

import {
  CreateMembershipDto,
  ReviewMembershipDto,
} from './dto/create-membership.dto';

@ApiTags('Memberships & Onboarding')
@Controller('memberships')
export class MembershipsController {
  constructor(private readonly membershipsService: MembershipsService) {}

  @Post()
  @UseGuards(JwtAuthGuard, RolesGuard) // Assuming they must be registered PUBLIC users first
  @ApiBearerAuth()
  @ApiOperation({ summary: 'Submit new membership application form' })
  async submitApplication(
    @Body() appData: CreateMembershipDto,
    @Request() req: { user?: any },
  ) {
    return this.membershipsService.submit(req.user.userId, appData);
  }

  @Get('my-status')
  @UseGuards(JwtAuthGuard, RolesGuard)
  @ApiBearerAuth()
  @ApiOperation({ summary: 'Check personal membership application progress' })
  async getMyStatus(@Request() req: { user?: any }) {
    return this.membershipsService.getStatusByUser(req.user.userId);
  }

  @Get('admin')
  @UseGuards(JwtAuthGuard, RolesGuard)
  @Roles(Role.SUPER_ADMIN, Role.ADMIN)
  @ApiBearerAuth()
  @ApiOperation({ summary: 'List pending/approved applications offset table' })
  @ApiQuery({ name: 'page', required: false })
  async getAdminTable(
    @Query('page') page: number,
    @Query('limit') limit: number,
  ) {
    return this.membershipsService.getAdminTable({
      page: Number(page),
      limit: Number(limit),
    });
  }

  @Patch(':id/review')
  @UseGuards(JwtAuthGuard, RolesGuard)
  @Roles(Role.SUPER_ADMIN, Role.ADMIN)
  @ApiBearerAuth()
  @ApiOperation({ summary: 'Update state via explicit workflow rules' })
  async processReview(
    @Param('id') id: string,
    @Body() updateDto: ReviewMembershipDto,
    @Request() req: { user?: any },
  ) {
    return this.membershipsService.processReview(id, updateDto, req.user);
  }
}
