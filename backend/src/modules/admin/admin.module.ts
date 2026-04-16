import { Module } from '@nestjs/common';
import { MongooseModule } from '@nestjs/mongoose';
import { AdminController } from './admin.controller';
import { AdminService } from './admin.service';
import { MembershipSchema } from '../memberships/schemas/membership.schema';
import { ReportSchema } from '../reports/schemas/report.schema';
import { EventSchema } from '../events/schemas/event.schema';
import { ContributionSchema } from '../contributions/schemas/contribution.schema';
import { PostSchema } from '../posts/schemas/post.schema';

@Module({
  imports: [
    MongooseModule.forFeature([
      { name: 'Membership', schema: MembershipSchema },
      { name: 'Report', schema: ReportSchema },
      { name: 'Event', schema: EventSchema },
      { name: 'Contribution', schema: ContributionSchema },
      { name: 'Post', schema: PostSchema },
    ]),
  ],
  controllers: [AdminController],
  providers: [AdminService],
})
export class AdminModule {}
