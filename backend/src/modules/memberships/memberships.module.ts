import { Module } from '@nestjs/common';
import { MongooseModule } from '@nestjs/mongoose';
import { MembershipsController } from './memberships.controller';
import { MembershipsService } from './memberships.service';
import { MembershipSchema } from './schemas/membership.schema';
import { UserSchema } from '../users/schemas/user.schema';

@Module({
  imports: [
    MongooseModule.forFeature([
      { name: 'Membership', schema: MembershipSchema },
      { name: 'User', schema: UserSchema },
    ]),
  ],
  controllers: [MembershipsController],
  providers: [MembershipsService],
})
export class MembershipsModule {}
