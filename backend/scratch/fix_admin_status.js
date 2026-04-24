const mongoose = require('mongoose');

const MONGODB_URI = 'mongodb+srv://matique2026ai_db_user:toufikmouni74@cluster0.d1ewjhf.mongodb.net/ebzimapp?retryWrites=true&w=majority';

async function fixAdminStatus() {
    try {
        console.log('Connecting to MongoDB...');
        await mongoose.connect(MONGODB_URI);
        console.log('Connected.');

        const email = 'matique2025@gmail.com';
        
        // Update user status to ACTIVE
        const result = await mongoose.connection.db.collection('users').updateOne(
            { email: email },
            { $set: { status: 'ACTIVE' } }
        );

        if (result.matchedCount > 0) {
            console.log(`Success: User ${email} is now ACTIVE.`);
        } else {
            console.log(`Error: User ${email} not found.`);
        }

    } catch (err) {
        console.error('Error:', err);
    } finally {
        await mongoose.disconnect();
        console.log('Disconnected.');
    }
}

fixAdminStatus();
