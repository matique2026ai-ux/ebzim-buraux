const mongoose = require('mongoose');

async function makeAdmin() {
  const uri = 'mongodb+srv://matique2026ai_db_user:toufikmouni74@cluster0.d1ewjhf.mongodb.net/ebzimapp?retryWrites=true&w=majority';
  await mongoose.connect(uri);

  const email = 'matique2025@gmail.com';

  const userModel = mongoose.connection.collection('users');
  const user = await userModel.findOne({ email });

  if (!user) {
    console.log('User not found!');
  } else {
    await userModel.updateOne({ email }, { $set: { role: 'SUPER_ADMIN', membershipLevel: 'ADMIN' } });
    console.log(`Successfully upgraded ${email} to SUPER_ADMIN!`);
  }

  process.exit(0);
}

makeAdmin();
