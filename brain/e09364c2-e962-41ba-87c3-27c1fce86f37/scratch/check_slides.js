
const mongoose = require('mongoose');

async function checkSlides() {
  try {
    await mongoose.connect('mongodb+srv://matique2026ai_db_user:toufikmouni74@cluster0.d1ewjhf.mongodb.net/ebzimapp?retryWrites=true&w=majority');
    console.log('Connected to MongoDB');
    
    const db = mongoose.connection.db;
    // The collection name might be hero-slides or heroslides or slides
    // In Mongoose it's usually pluralized from the model name 'HeroSlide' -> 'heroslides'
    const slides = await db.collection('heroslides').find({}).toArray();
    
    console.log('Total Slides Found:', slides.length);
    slides.forEach(s => {
      console.log(`- ID: ${s._id}, Title: ${s.title?.ar || 'N/A'}, Active: ${s.isActive}, Location: ${s.location}`);
    });
    
    // Force active all slides
    const result = await db.collection('heroslides').updateMany({}, { $set: { isActive: true } });
    console.log(`Updated ${result.modifiedCount} slides to active.`);
    
    process.exit(0);
  } catch (err) {
    console.error(err);
    process.exit(1);
  }
}

checkSlides();
