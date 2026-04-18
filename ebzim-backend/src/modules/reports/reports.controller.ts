import { Controller, Get, Post, Patch, Body, Param, Query, UseGuards, Request } from '@nestjs/common';
import { ApiTags, ApiOperation, ApiBearerAuth, ApiQuery } from '@nestjs/swagger';
import { RolesGuard } from '../../common/guards/roles.guard';
import { JwtAuthGuard } from '../../common/guards/jwt-auth.guard';
import { Roles } from '../../common/decorators/roles.decorator';
import { Role } from '../../common/enums/role.enum';
import { ReportsService } from './reports.service';

import { CreateReportDto, UpdateReportStatusDto } from './dto/create-report.dto';

@ApiTags('Incident Response Center')
@Controller('reports')
export class ReportsController {
  constructor(private readonly reportsService: ReportsService) {}

  @Post()
  @ApiOperation({ summary: 'Public/Guest submits new report' })
  async createReport(@Body() createReportDto: CreateReportDto, @Request() req: { user?: any }) {
    // Optionally extract user ID if authenticated, else null
    const reporterId = req.user ? req.user.userId : null;
    return this.reportsService.createReport(createReportDto, reporterId);
  }

  @Get()
  @UseGuards(JwtAuthGuard, RolesGuard)
  @Roles(Role.SUPER_ADMIN, Role.ADMIN, Role.AUTHORITY)
  @ApiBearerAuth()
  @ApiOperation({ summary: 'List reports based on Role visibility restrictions' })
  @ApiQuery({ name: 'page', required: false })
  async getReports(@Request() req: { user?: any }, @Query('page') page: number) {
    // Service handles internal offset pagination and enforces Authority visibility boundary
    return this.reportsService.getReports(req.user, { page: Number(page) });
  }

  @Patch(':id/status')
  @UseGuards(JwtAuthGuard, RolesGuard)
  @Roles(Role.SUPER_ADMIN, Role.ADMIN, Role.AUTHORITY)
  @ApiBearerAuth()
  @ApiOperation({ summary: 'Workflow transitions (Triage, Escalate, Resolve)' })
  async updateStatus(@Param('id') id: string, @Body() updateDto: UpdateReportStatusDto, @Request() req: { user?: any }) {
    return this.reportsService.updateStatus(id, updateDto.status, req.user);
  }
}

