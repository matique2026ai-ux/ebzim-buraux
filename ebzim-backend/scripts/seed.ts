import { NestFactory } from '@nestjs/core';
import { AppModule } from '../src/app.module';
import { getModelToken } from '@nestjs/mongoose';
import { Model } from 'mongoose';
import { UserDocument } from '../src/modules/users/schemas/user.schema';
import { CategoryDocument } from '../src/modules/categories/schemas/category.schema';
import { Role } from '../src/common/enums/role.enum';
import * as bcrypt from 'bcrypt';

async function bootstrap() {
  // Headless application for script execution
  const app = await NestFactory.createApplicationContext(AppModule);

  const userModel = app.get<Model<UserDocument>>(getModelToken('User'));
  const categoryModel = app.get<Model<CategoryDocument>>(getModelToken('Category'));

  console.log('Seeding Database...');

  // 1. Seed SUPER_ADMIN
  const existingAdmin = await userModel.findOne({ email: 'admin@ebzim.org' });
  if (!existingAdmin) {
    const passwordHash = await bcrypt.hash('AdminPassword123!', 10);
    await userModel.create({
      email: 'admin@ebzim.org',
      passwordHash,
      role: Role.SUPER_ADMIN,
      profile: {
        firstName: 'System',
        lastName: 'Admin',
      },
    });
    console.log('SUPER_ADMIN created: admin@ebzim.org');
  } else {
    console.log('SUPER_ADMIN already exists.');
  }

  // 2. Seed Default Categories
  const defaults = [
    { slug: 'heritage', name: { ar: 'التراث', fr: 'Patrimoine', en: 'Heritage' } },
    { slug: 'culture', name: { ar: 'ثقافة', fr: 'Culture', en: 'Culture' } },
    { slug: 'citizenship', name: { ar: 'مواطنة', fr: 'Citoyenneté', en: 'Citizenship' } },
  ];

  for (const cat of defaults) {
    const existing = await categoryModel.findOne({ slug: cat.slug });
    if (!existing) {
      await categoryModel.create(cat);
      console.log(`Seeded Category: ${cat.slug}`);
    }
  }

  console.log('Seeding Execution Finished!');
  await app.close();
}

bootstrap();
