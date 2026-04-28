import { Controller, Get } from '@nestjs/common';
import { AppService } from './app.service';

@Controller()
export class AppController {
  constructor(private readonly appService: AppService) {}

  @Get('debug/test')
  getDebug() {
    return {
      status: 'EBZIM_CLOUD_SYNC_V2',
      version: '1.2.2-PRODUCTION',
      timestamp: '2026-04-28T17:40:00Z',
      deploymentTag: 'LIVE_EVENTS_FIX_FINAL',
    };
  }

  @Get()
  getHello(): string {
    return this.appService.getHello();
  }
}
