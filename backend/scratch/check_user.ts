import { MongoClient } from 'mongodb';

const uri = 'mongodb+srv://matique2026ai_db_user:toufikmouni74@cluster0.d1ewjhf.mongodb.net/ebzimapp?retryWrites=true&w=majority';

async function checkUser() {
  const client = new MongoClient(uri);
  try {
    await client.connect();
    const db = client.db('ebzimapp');
    const user = await db.collection('users').findOne({ email: 'matique2025@gmail.com' });
    if (user) {
      console.log('User FOUND:', user.email, 'Role:', user.role);
    } else {
      console.log('User NOT FOUND');
    }
  } catch (err) {
    console.error(err);
  } finally {
    await client.close();
  }
}

checkUser();
