import { Module } from '@nestjs/common';
import { MongooseModule } from '@nestjs/mongoose';
import { HeroController } from './hero.controller';
import { HeroService } from './hero.service';
import { HeroSlideSchema } from './schemas/hero-slide.schema';

@Module({
  imports: [
    MongooseModule.forFeature([{ name: 'HeroSlide', schema: HeroSlideSchema }]),
  ],
  controllers: [HeroController],
  providers: [HeroService],
  exports: [HeroService],
})
export class HeroModule {}
