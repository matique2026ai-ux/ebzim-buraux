import { Module } from '@nestjs/common';
import { MongooseModule } from '@nestjs/mongoose';
import { LeadershipController } from './leadership.controller';
import { LeadershipService } from './leadership.service';
import { LeaderSchema } from './schemas/leader.schema';

@Module({
  imports: [
    MongooseModule.forFeature([{ name: 'Leader', schema: LeaderSchema }]),
  ],
  controllers: [LeadershipController],
  providers: [LeadershipService],
  exports: [LeadershipService],
})
export class LeadershipModule {}
