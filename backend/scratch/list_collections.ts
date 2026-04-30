import { MongoClient } from 'mongodb';

const uri = 'mongodb+srv://matique2026ai_db_user:toufikmouni74@cluster0.d1ewjhf.mongodb.net/ebzimapp?retryWrites=true&w=majority';

async function listCollections() {
  const client = new MongoClient(uri);
  try {
    await client.connect();
    const db = client.db('ebzimapp');
    const collections = await db.listCollections().toArray();
    console.log('Collections:', collections.map(c => c.name));
  } catch (err) {
    console.error(err);
  } finally {
    await client.close();
  }
}

listCollections();
