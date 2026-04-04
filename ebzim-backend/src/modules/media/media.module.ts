import { Module } from '@nestjs/common';
import { MediaService } from './media.service';
import { CloudinaryProvider } from './cloudinary.provider';

@Module({
  providers: [CloudinaryProvider, MediaService],
  exports: [MediaService], // Highly reusable service 
})
export class MediaModule {}
