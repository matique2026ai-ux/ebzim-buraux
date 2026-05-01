import { MongoClient } from 'mongodb';

async function run() {
  const uri = 'mongodb+srv://ebzim:ebzim2024@cluster0.p7v8p.mongodb.net/ebzim-db';
  const client = await MongoClient.connect(uri);
  const db = client.db('ebzim-db');
  
  console.log('--- STARTING GLOBAL SYNC ---');
  
  // Fix Hero Slides
  const r1 = await db.collection('heroslides').updateMany(
    {}, 
    { $set: { isActive: true, location: 'HOME' } }
  );
  console.log(`HeroSlides updated: ${r1.modifiedCount}`);
  
  // Fix Projects/News
  const r2 = await db.collection('posts').updateMany(
    {}, 
    { $set: { status: 'PUBLISHED' } }
  );
  console.log(`Posts updated: ${r2.modifiedCount}`);
  
  // Check if any categories are missing
  const categories = await db.collection('categories').countDocuments();
  console.log(`Total categories in DB: ${categories}`);

  await client.close();
  console.log('--- SYNC COMPLETED ---');
}

run().catch(console.error);
