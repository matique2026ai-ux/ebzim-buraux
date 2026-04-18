import { Controller, Post, Get, Patch, Body, Param, UseGuards, Request } from '@nestjs/common';
import { ApiTags, ApiOperation, ApiBearerAuth } from '@nestjs/swagger';
import { ContributionsService } from './contributions.service';
import { JwtAuthGuard } from '../../common/guards/jwt-auth.guard';
import { RolesGuard } from '../../common/guards/roles.guard';
import { Roles } from '../../common/decorators/roles.decorator';
import { Role } from '../../common/enums/role.enum';

@ApiTags('Financial Contributions')
@Controller('contributions')
@UseGuards(JwtAuthGuard)
@ApiBearerAuth()
export class ContributionsController {
  constructor(private readonly contributionsService: ContributionsService) {}

  @Post()
  @ApiOperation({ summary: 'Submit a new contribution (membership or donation)' })
  async submit(@Request() req: any, @Body() dto: any) {
    return this.contributionsService.submitContribution(req.user.userId, dto);
  }

  @Get('my')
  @ApiOperation({ summary: 'Get list of my contributions' })
  async getMy(@Request() req: any) {
    return this.contributionsService.getMyContributions(req.user.userId);
  }

  @Get('admin')
  @UseGuards(RolesGuard)
  @Roles(Role.SUPER_ADMIN, Role.ADMIN)
  @ApiOperation({ summary: 'Admin lists all global contributions' })
  async getAll() {
    return this.contributionsService.getAllContributions();
  }

  @Patch(':id/verify')
  @UseGuards(RolesGuard)
  @Roles(Role.SUPER_ADMIN, Role.ADMIN)
  @ApiOperation({ summary: 'Admin verifies or rejects a contribution' })
  async verify(
    @Param('id') id: string,
    @Request() req: any,
    @Body('status') status: string,
    @Body('notes') notes?: string,
  ) {
    return this.contributionsService.verifyContribution(id, req.user.userId, status, notes);
  }
}
