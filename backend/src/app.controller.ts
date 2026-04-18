import { Controller, Get } from '@nestjs/common';
import { AppService } from './app.service';

@Controller()
export class AppController {
  constructor(private readonly appService: AppService) {}

  @Get('debug/test')
  getDebug() {
    return { status: 'OK', version: 'STABLE_V3_DEBUG', timestamp: new Date().toISOString() };
  }

  @Get()
  getHello(): string {
    return this.appService.getHello();
  }
}
