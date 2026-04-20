import { Controller, Get } from '@nestjs/common';
import { ApiTags, ApiOperation } from '@nestjs/swagger';
import { AdminService } from './admin.service';

@ApiTags('Public Stats')
@Controller('public/stats')
export class PublicStatsController {
  constructor(private readonly adminService: AdminService) {}

  @Get()
  @ApiOperation({ summary: 'Get public platform statistics for the home screen stats strip' })
  async getStats() {
    return this.adminService.getStats();
  }
}
