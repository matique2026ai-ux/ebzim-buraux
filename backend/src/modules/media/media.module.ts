import { Module } from '@nestjs/common';
import { MediaService } from './media.service';
import { CloudinaryProvider } from './cloudinary.provider';
import { MediaController } from './media.controller';

@Module({
  controllers: [MediaController],
  providers: [CloudinaryProvider, MediaService],
  exports: [MediaService], // Highly reusable service
})
export class MediaModule {}
