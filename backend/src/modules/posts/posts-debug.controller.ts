import { Controller, Get } from '@nestjs/common';

@Controller('debug-posts')
export class PostsDebugController {
  @Get()
  getDebug() {
    return {
      status: 'OK',
      message: 'NEW_CONTROLLER_DEPLOYED',
      version: '1.2.1-FORCED',
      timestamp: new Date().toISOString(),
    };
  }
}
