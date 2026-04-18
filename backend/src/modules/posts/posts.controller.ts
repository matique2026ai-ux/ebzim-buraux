import {
  Controller,
  Get,
  Post,
  Patch,
  Delete,
  Body,
  Query,
  Headers,
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
import { PostsService } from './posts.service';
import { RolesGuard } from '../../common/guards/roles.guard';
import { JwtAuthGuard } from '../../common/guards/jwt-auth.guard';
import { Roles } from '../../common/decorators/roles.decorator';
import { Role } from '../../common/enums/role.enum';

import { CreatePostDto } from './dto/create-post.dto';

@ApiTags('Posts & CMS')
@Controller('posts')
export class PostsController {
  constructor(private readonly postsService: PostsService) {}

  @Get()
  @ApiOperation({
    summary: 'Public Feed: Fetch published posts with cursor pagination',
  })
  @ApiHeader({
    name: 'Accept-Language',
    required: false,
    description: 'ar, fr, or en',
  })
  @ApiQuery({ name: 'cursor', required: false })
  @ApiQuery({ name: 'limit', required: false })
  async getPublicFeed(
    @Headers('Accept-Language') lang: string,
    @Query('cursor') cursor: string,
    @Query('limit') limit: number,
  ) {
    const locale = ['ar', 'fr', 'en'].includes(lang) ? lang : 'en'; // Default fallback
    return this.postsService.getPublicFeed(locale, {
      cursor,
      limit: Number(limit),
    });
  }

  @Get('admin')
  @UseGuards(JwtAuthGuard, RolesGuard)
  @Roles(Role.SUPER_ADMIN, Role.ADMIN)
  @ApiBearerAuth()
  @ApiOperation({
    summary: 'Admin Dashboard: Fetch all posts with offset pagination',
  })
  @ApiQuery({ name: 'page', required: false })
  async getAdminPosts(
    @Query('page') page: number,
    @Query('limit') limit: number,
  ) {
    // Returns full multilingual payload
    return this.postsService.getAdminTable({
      page: Number(page),
      limit: Number(limit),
    });
  }

  @Post()
  @UseGuards(JwtAuthGuard, RolesGuard)
  @Roles(Role.SUPER_ADMIN, Role.ADMIN)
  @ApiBearerAuth()
  @ApiOperation({ summary: 'Create a new multilingual post' })
  async createPost(
    @Body() createPostDto: CreatePostDto,
    @Request() req: { user?: any },
  ) {
    return this.postsService.createPost(createPostDto, req.user.userId);
  }

  @Patch(':id')
  @UseGuards(JwtAuthGuard, RolesGuard)
  @Roles(Role.SUPER_ADMIN, Role.ADMIN)
  @ApiBearerAuth()
  @ApiOperation({ summary: 'Update an existing multilingual post' })
  async updatePost(@Param('id') id: string, @Body() updateData: any) {
    return this.postsService.updatePost(id, updateData);
  }

  @Delete(':id')
  @UseGuards(JwtAuthGuard, RolesGuard)
  @Roles(Role.SUPER_ADMIN, Role.ADMIN)
  @ApiBearerAuth()
  @ApiOperation({ summary: 'Delete a post' })
  async deletePost(@Param('id') id: string) {
    return this.postsService.deletePost(id);
  }
}
