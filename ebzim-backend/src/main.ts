import { NestFactory } from '@nestjs/core';
import { ValidationPipe } from '@nestjs/common';
import { SwaggerModule, DocumentBuilder } from '@nestjs/swagger';
import { AppModule } from './app.module';

async function bootstrap() {
  const app = await NestFactory.create(AppModule);

  // Set Global API Prefix
  app.setGlobalPrefix('api/v1');

  // Enable CORS
  app.enableCors();

  // Set Global Validation Pipe
  app.useGlobalPipes(
    new ValidationPipe({
      whitelist: true, // strip out unspecified properties
      transform: true, // auto-transform payloads to DTO instances
    }),
  );

  // Configure Swagger OpenAPI
  const config = new DocumentBuilder()
    .setTitle('EBZIM API')
    .setDescription('The EBZIM Culture and Citizenship Platform API')
    .setVersion('1.0')
    .addBearerAuth()
    .build();
    
  const document = SwaggerModule.createDocument(app, config);
  SwaggerModule.setup('api/docs', app, document);

  const port = process.env.PORT || 3000;
  await app.listen(port);
  console.log(`EBZIM API running on port ${port}`);
  console.log(`Swagger Docs available at http://localhost:${port}/api/docs`);
}
bootstrap();
