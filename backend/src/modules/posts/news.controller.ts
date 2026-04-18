import { Controller, Get, Query, Headers } from '@nestjs/common';
import { ApiTags, ApiOperation, ApiHeader, ApiQuery } from '@nestjs/swagger';
import { PostsService } from './posts.service';

@ApiTags('News & Announcements')
@Controller('news')
export class NewsController {
  constructor(private readonly postsService: PostsService) {}

  @Get()
  @ApiOperation({ summary: 'Public News Feed (Alias for /posts)' })
  @ApiHeader({
    name: 'Accept-Language',
    required: false,
    description: 'ar, fr, or en',
  })
  @ApiQuery({
    name: 'lang',
    required: false,
    description: 'Optional language code to filter content',
  })
  async getNews(
    @Headers('Accept-Language') headerLang: string,
    @Query('lang') queryLang: string,
  ) {
    // Frontend sometimes sends lang in query, sometimes in header
    const lang = queryLang || headerLang || 'en';
    const locale = ['ar', 'fr', 'en'].includes(lang) ? lang : 'en';

    // We call the same public feed as posts
    return this.postsService.getPublicFeed(locale, { limit: 10 });
  }
}
