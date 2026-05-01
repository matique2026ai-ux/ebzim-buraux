import { Module } from '@nestjs/common';
import { MongooseModule } from '@nestjs/mongoose';
import { MarketplaceService } from './marketplace.service';
import { MarketplaceController } from './marketplace.controller';
import { MarketBook, MarketBookSchema } from './schemas/market-book.schema';

@Module({
  imports: [
    MongooseModule.forFeature([
      { name: MarketBook.name, schema: MarketBookSchema },
    ]),
  ],
  controllers: [MarketplaceController],
  providers: [MarketplaceService],
})
export class MarketplaceModule {}
