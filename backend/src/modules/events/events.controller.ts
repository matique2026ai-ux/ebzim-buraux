import {
  Controller,
  Get,
  Post,
  Patch,
  Delete,
  Body,
  Headers,
  Query,
  UseGuards,
  Request,
  Param,
} from '@nestjs/common';
import {
  ApiTags,
  ApiOperation,
  ApiBearerAuth,
  ApiHeader,
  ApiQuery,
} from '@nestjs/swagger';
import { EventsService } from './events.service';
import { RolesGuard } from '../../common/guards/roles.guard';
import { JwtAuthGuard } from '../../common/guards/jwt-auth.guard';
import { Roles } from '../../common/decorators/roles.decorator';
import { Role } from '../../common/enums/role.enum';

import { CreateEventDto } from './dto/create-event.dto';

@ApiTags('Events & RSVP')
@Controller('events')
export class EventsController {
  @Get('test-route')
  async testRoute() {
    return { message: 'Route is active' };
  }

  constructor(private readonly eventsService: EventsService) {}

  @Get()
  @ApiOperation({
    summary: 'Public feed of events sorted by approaching dates',
  })
  @ApiHeader({ name: 'Accept-Language', required: false })
  @ApiQuery({
    name: 'cursor',
    required: false,
    description: 'Pass previous Event Date for pagination',
  })
  @ApiQuery({ name: 'limit', required: false })
  async getPublicFeed(
    @Headers('Accept-Language') lang: string,
    @Query('cursor') cursor: string,
    @Query('limit') limit: number,
  ) {
    const locale = ['ar', 'fr', 'en'].includes(lang) ? lang : 'en';
    return this.eventsService.getPublicFeed(locale, {
      cursor,
      limit: Number(limit),
    });
  }

  @Get('admin')
  @UseGuards(JwtAuthGuard, RolesGuard)
  @Roles(Role.SUPER_ADMIN, Role.ADMIN)
  @ApiBearerAuth()
  @ApiOperation({ summary: 'Admin offset table query' })
  async getAdminTable(
    @Query('page') page: number,
    @Query('limit') limit: number,
  ) {
    return this.eventsService.getAdminTable({
      page: Number(page),
      limit: Number(limit),
    });
  }

  @Post()
  @UseGuards(JwtAuthGuard, RolesGuard)
  @Roles(Role.SUPER_ADMIN, Role.ADMIN)
  @ApiBearerAuth()
  @ApiOperation({ summary: 'Admin create event entry' })
  async createEvent(@Body() dto: CreateEventDto) {
    return this.eventsService.createEvent(dto);
  }

  @Patch(':id')
  @UseGuards(JwtAuthGuard, RolesGuard)
  @Roles(Role.SUPER_ADMIN, Role.ADMIN)
  @ApiBearerAuth()
  @ApiOperation({ summary: 'Update an existing event' })
  async updateEvent(@Param('id') id: string, @Body() updateData: any) {
    return this.eventsService.updateEvent(id, updateData);
  }

  @Delete(':id')
  @UseGuards(JwtAuthGuard, RolesGuard)
  @Roles(Role.SUPER_ADMIN, Role.ADMIN)
  @ApiBearerAuth()
  @ApiOperation({ summary: 'Delete an event' })
  async deleteEvent(@Param('id') id: string) {
    return this.eventsService.deleteEvent(id);
  }

  @Get('detail/:id')
  @ApiOperation({ summary: 'Get single event details' })
  async findOne(@Param('id') id: string) {
    return this.eventsService.findOne(id);
  }

  @Post(':id/rsvp')
  @UseGuards(JwtAuthGuard, RolesGuard)
  @Roles(Role.SUPER_ADMIN, Role.ADMIN, Role.AUTHORITY, Role.MEMBER, Role.PUBLIC)
  @ApiBearerAuth()
  @ApiOperation({ summary: 'Any authenticated user can RSVP' })
  async rsvpToEvent(
    @Param('id') eventId: string,
    @Request() req: { user?: any },
  ) {
    return this.eventsService.rsvp(eventId, req.user.userId);
  }
}
