import { MongoClient } from 'mongodb';
import * as bcrypt from 'bcrypt';

const uri = "mongodb+srv://matique2026ai_db_user:toufikmouni74@cluster0.d1ewjhf.mongodb.net/ebzimapp?retryWrites=true&w=majority";
const email = "matique2025@gmail.com"; 
const password = "12345678"; 

async function run() {
  const client = new MongoClient(uri);
  try {
    await client.connect();
    console.log("Connected to MongoDB Atlas.");
    const db = client.db("ebzimapp");
    const users = db.collection("users");

    const passwordHash = await bcrypt.hash(password, 10);
    await users.updateOne(
      { email }, 
      { 
        $set: { 
          passwordHash, 
          role: 'ADMIN', 
          status: 'ACTIVE',
          profile: {
            firstName: 'Toufik',
            lastName: 'Ebzim',
            phone: '0550000000',
          }
        } 
      }, 
      { upsert: true }
    );
    console.log(`Account ${email} synchronized to Production successfully!`);
  } catch (err) {
    console.error("Error:", err);
  } finally {
    await client.close();
  }
}

run();
