import { Controller, Get } from '@nestjs/common';
import { AppService } from './app.service';

@Controller()
export class AppController {
  constructor(private readonly appService: AppService) {}

  @Get('debug/test')
  getDebug() {
    return {
      status: 'EBZIM_DEPLOY_SYNCED',
      version: 'STABLE_V4_FINAL_CHECK',
      timestamp: new Date().toISOString(),
      deploymentTag: '11e55c2_force_update',
    };
  }

  @Get()
  getHello(): string {
    return this.appService.getHello();
  }
}
