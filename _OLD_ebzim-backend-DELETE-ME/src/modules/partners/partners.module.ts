import { Module } from '@nestjs/common';
import { MongooseModule } from '@nestjs/mongoose';
import { PartnersController } from './partners.controller';
import { PartnersService } from './partners.service';
import { PartnerSchema } from './schemas/partner.schema';

@Module({
  imports: [
    MongooseModule.forFeature([{ name: 'Partner', schema: PartnerSchema }]),
  ],
  controllers: [PartnersController],
  providers: [PartnersService],
  exports: [PartnersService],
})
export class PartnersModule {}
