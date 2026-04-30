import { MongoClient } from 'mongodb';

const uri = 'mongodb+srv://matique2026ai_db_user:toufikmouni74@cluster0.d1ewjhf.mongodb.net/ebzimapp?retryWrites=true&w=majority';

async function wipe() {
  const client = new MongoClient(uri);
  try {
    await client.connect();
    console.log('Connected to MongoDB');
    const db = client.db('ebzimapp');

    const collectionsToWipe = [
      'posts',
      'events',
      'partners',
      'publications',
      'projects',
      'heroslides',
      'reports',
      'contributions',
      'memberships',
      'leadershipmembers',
      'leaders',
      'eventrsvps'
    ];

    for (const collectionName of collectionsToWipe) {
      const result = await db.collection(collectionName).deleteMany({});
      console.log(`Wiped ${result.deletedCount} documents from ${collectionName}`);
    }

    console.log('Database wipe completed successfully');
  } catch (err) {
    console.error('Error wiping database:', err);
  } finally {
    await client.close();
  }
}

wipe();
