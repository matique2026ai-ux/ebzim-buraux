require('dotenv').config();
const mongoose = require('mongoose');

async function checkUsers() {
    console.log("Connecting to MongoDB...");
    try {
        await mongoose.connect(process.env.MONGODB_URI);
        console.log("Connected.");
        
        const db = mongoose.connection.db;
        const users = await db.collection('users').find({}).toArray();
        console.log("Total users in DB:", users.length);
        if (users.length > 0) {
            console.log("Existing emails:", users.map(u => u.email));
        }

        mongoose.connection.close();
    } catch (err) {
        console.error(err);
    }
}

checkUsers();
