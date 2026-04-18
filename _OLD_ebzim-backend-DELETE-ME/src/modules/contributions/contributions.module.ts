import { Module } from '@nestjs/common';
import { MongooseModule } from '@nestjs/mongoose';
import { ContributionsController } from './contributions.controller';
import { ContributionsService } from './contributions.service';
import { Contribution, ContributionSchema } from './schemas/contribution.schema';
import { SettingsModule } from '../settings/settings.module';

@Module({
  imports: [
    MongooseModule.forFeature([{ name: Contribution.name, schema: ContributionSchema }]),
    SettingsModule,
  ],
  controllers: [ContributionsController],
  providers: [ContributionsService],
})
export class ContributionsModule {}
