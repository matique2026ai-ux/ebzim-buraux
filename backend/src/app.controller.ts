import { Controller, Get } from '@nestjs/common';
import { AppService } from './app.service';

@Controller()
export class AppController {
  constructor(private readonly appService: AppService) {}

  @Get('debug/test')
  getDebug() {
    return {
      status: 'EBZIM_DEPLOY_SYNCED',
      version: '1.2.1-STABLE',
      timestamp: new Date().toISOString(),
      deploymentTag: 'APRIL_25_PRODUCTION_SYNC',
    };
  }

  @Get()
  getHello(): string {
    return this.appService.getHello();
  }
}
