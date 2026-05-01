import { PartialType } from '@nestjs/swagger';
import { CreateMarketBookDto } from './create-market-book.dto';

export class UpdateMarketBookDto extends PartialType(CreateMarketBookDto) {}
