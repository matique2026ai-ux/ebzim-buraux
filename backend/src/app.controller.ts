import { Controller, Get } from '@nestjs/common';
import { AppService } from './app.service';

@Controller()
export class AppController {
  constructor(private readonly appService: AppService) {}

  @Get('debug/test')
  getDebug() {
    return {
      status: 'OK',
      version: '1.2.1-FORCED',
      timestamp: new Date().toISOString(),
      deploymentTag: '11e55c2_force_update',
    };
  }

  @Get()
  getHello(): string {
    return this.appService.getHello();
  }
}
