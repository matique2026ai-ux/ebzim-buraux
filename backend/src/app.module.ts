import { Module } from '@nestjs/common';
import { ConfigModule, ConfigService } from '@nestjs/config';
import { MongooseModule } from '@nestjs/mongoose';
import { AppController } from './app.controller';
import { AppService } from './app.service';

import { AuthModule } from './modules/auth/auth.module';
import { CategoriesModule } from './modules/categories/categories.module';
import { PostsModule } from './modules/posts/posts.module';
import { MailModule } from './modules/mail/mail.module';
import { EventsModule } from './modules/events/events.module';
import { MembershipsModule } from './modules/memberships/memberships.module';
import { ReportsModule } from './modules/reports/reports.module';
import { MediaModule } from './modules/media/media.module';
import { SettingsModule } from './modules/settings/settings.module';
import { ContributionsModule } from './modules/contributions/contributions.module';
import { PartnersModule } from './modules/partners/partners.module';
import { HeroModule } from './modules/hero/hero.module';
import { LeadershipModule } from './modules/leadership/leadership.module';

@Module({
  imports: [
    ConfigModule.forRoot({ isGlobal: true }),
    MongooseModule.forRootAsync({
      imports: [ConfigModule],
      useFactory: async (configService: ConfigService) => ({
        uri: configService.get<string>('MONGODB_URI'),
        serverSelectionTimeoutMS: 5000, // Fail fast if DB is unreachable
      }),
      inject: [ConfigService],
    }),
    AuthModule,
    CategoriesModule,
    PostsModule,
    EventsModule,
    MailModule,
    MembershipsModule,
    ReportsModule,
    MediaModule,
    SettingsModule,
    ContributionsModule,
    PartnersModule,
    HeroModule,
    LeadershipModule,
  ],
  controllers: [AppController],
  providers: [AppService],
})
export class AppModule {}
