const { MongoMemoryServer } = require('mongodb-memory-server-core');
const fs = require('fs');
const path = require('path');

async function setup() {
  console.log('Starting MongoDB Memory Server...');
  const mongo = await MongoMemoryServer.create();
  const uri = mongo.getUri();
  console.log('MongoDB Memory Server started at:', uri);

  const envPath = path.join(__dirname, '..', '.env');
  let envContent = fs.readFileSync(envPath, 'utf8');
  
  // Replace MONGODB_URI
  envContent = envContent.replace(/MONGODB_URI=.*/, `MONGODB_URI=${uri}ebzimapp`);
  
  fs.writeFileSync(envPath, envContent);
  console.log('Updated .env with local memory server URI');
  
  // Keep process alive to keep DB alive
  process.stdin.resume();
}

setup().catch(err => {
  console.error('Failed to setup memory server:', err);
  process.exit(1);
});
