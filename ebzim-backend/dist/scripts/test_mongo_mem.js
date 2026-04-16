"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const mongodb_memory_server_core_1 = require("mongodb-memory-server-core");
async function startMongo() {
    const mongo = await mongodb_memory_server_core_1.MongoMemoryServer.create();
    const uri = mongo.getUri();
    console.log('MongoDB Memory Server started at:', uri);
}
startMongo();
//# sourceMappingURL=test_mongo_mem.js.map