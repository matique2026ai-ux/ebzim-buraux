const mongoose = require('mongoose');

async function promoteToSuperAdmin() {
  const uri = 'mongodb+srv://matique2026ai_db_user:toufikmouni74@cluster0.d1ewjhf.mongodb.net/ebzimapp?retryWrites=true&w=majority';
  
  try {
    await mongoose.connect(uri);
    console.log('Connected to MongoDB');
    
    // We update the collection directly via the connection object to avoid schema issues in a simple script
    const result = await mongoose.connection.db.collection('users').updateOne(
      { email: 'matique2025@gmail.com' },
      { $set: { role: 'SUPER_ADMIN' } }
    );

    console.log(`Matched ${result.matchedCount} documents and updated ${result.modifiedCount} documents.`);
  } catch (err) {
    console.error('Error:', err);
  } finally {
    await mongoose.disconnect();
  }
}

promoteToSuperAdmin();
