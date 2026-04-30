import { Module } from '@nestjs/common';
import { MongooseModule } from '@nestjs/mongoose';
import { AdminController } from './admin.controller';
import { PublicStatsController } from './public-stats.controller';
import { AdminService } from './admin.service';
import { MembershipSchema } from '../memberships/schemas/membership.schema';
import { ReportSchema } from '../reports/schemas/report.schema';
import { EventSchema, EventRsvpSchema } from '../events/schemas/event.schema';
import { ContributionSchema } from '../contributions/schemas/contribution.schema';
import { PostSchema } from '../posts/schemas/post.schema';
import { UserSchema } from '../users/schemas/user.schema';
import { PartnerSchema } from '../partners/schemas/partner.schema';
import { PublicationSchema } from '../publications/schemas/publication.schema';
import { HeroSlideSchema } from '../hero/schemas/hero-slide.schema';

@Module({
  imports: [
    MongooseModule.forFeature([
      { name: 'Membership', schema: MembershipSchema },
      { name: 'Report', schema: ReportSchema },
      { name: 'Event', schema: EventSchema },
      { name: 'EventRsvp', schema: EventRsvpSchema },
      { name: 'Contribution', schema: ContributionSchema },
      { name: 'Post', schema: PostSchema },
      { name: 'User', schema: UserSchema },
      { name: 'Partner', schema: PartnerSchema },
      { name: 'Publication', schema: PublicationSchema },
      { name: 'Hero', schema: HeroSlideSchema },
    ]),
  ],
  controllers: [AdminController, PublicStatsController],
  providers: [AdminService],
})
export class AdminModule {}
