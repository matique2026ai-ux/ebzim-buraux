import { Module } from '@nestjs/common';
import { MongooseModule } from '@nestjs/mongoose';
import { PostsController } from './posts.controller';
import { NewsController } from './news.controller';
import { PostsDebugController } from './posts-debug.controller';
import { PostsService } from './posts.service';
import { PostSchema } from './schemas/post.schema';

@Module({
  imports: [MongooseModule.forFeature([{ name: 'Post', schema: PostSchema }])],
  controllers: [PostsController, NewsController, PostsDebugController],
  providers: [PostsService],
})
export class PostsModule {}
