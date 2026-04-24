import { NestFactory } from '@nestjs/core';
import { ValidationPipe } from '@nestjs/common';
import { SwaggerModule, DocumentBuilder } from '@nestjs/swagger';
import { AppModule } from './app.module';

async function bootstrap() {
  // EBZIM API - Production Boot Sequence
  // Last Sync: 2026-04-18 22:40 (Institutional Project Management Pass)
  const app = await NestFactory.create(AppModule);

  // Set Global API Prefix
  app.setGlobalPrefix('api/v1'); // Ensure all routes are versioned

  // Increase limits for large media uploads
  const bodyParser = require('body-parser');
  app.use(bodyParser.json({ limit: '50mb' }));
  app.use(bodyParser.urlencoded({ limit: '50mb', extended: true }));

  // Enable CORS — Robust policy for local and production sync
  app.enableCors({
    origin: '*',
    methods: 'GET,HEAD,PUT,PATCH,POST,DELETE,OPTIONS',
    credentials: true,
    allowedHeaders: 'Content-Type, Accept, Authorization',
  });

  // Set Global Validation Pipe
  app.useGlobalPipes(
    new ValidationPipe({
      whitelist: true,
      transform: true,
    }),
  );

  // Configure Swagger OpenAPI
  const config = new DocumentBuilder()
    .setTitle('EBZIM API - V1.2.0-STABLE')
    .setDescription('The EBZIM Culture and Citizenship Platform API')
    .setVersion('1.0')
    .addBearerAuth()
    .build();

  const document = SwaggerModule.createDocument(app, config);
  SwaggerModule.setup('api/docs', app, document);

  const port = process.env.PORT || 3000;
  await app.listen(port);

  console.log(`EBZIM API running on port ${port}`);
  console.log(
    `Swagger Docs available at https://ebzim-api-prod.onrender.com/api/docs`,
  );
}
bootstrap();
