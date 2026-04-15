import { MongoMemoryServer } from 'mongodb-memory-server-core';

async function startMongo() {
  const mongo = await MongoMemoryServer.create();
  const uri = mongo.getUri();
  console.log('MongoDB Memory Server started at:', uri);
  // Keep it running
}

startMongo();
