"use strict";
var __createBinding = (this && this.__createBinding) || (Object.create ? (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    var desc = Object.getOwnPropertyDescriptor(m, k);
    if (!desc || ("get" in desc ? !m.__esModule : desc.writable || desc.configurable)) {
      desc = { enumerable: true, get: function() { return m[k]; } };
    }
    Object.defineProperty(o, k2, desc);
}) : (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    o[k2] = m[k];
}));
var __setModuleDefault = (this && this.__setModuleDefault) || (Object.create ? (function(o, v) {
    Object.defineProperty(o, "default", { enumerable: true, value: v });
}) : function(o, v) {
    o["default"] = v;
});
var __importStar = (this && this.__importStar) || (function () {
    var ownKeys = function(o) {
        ownKeys = Object.getOwnPropertyNames || function (o) {
            var ar = [];
            for (var k in o) if (Object.prototype.hasOwnProperty.call(o, k)) ar[ar.length] = k;
            return ar;
        };
        return ownKeys(o);
    };
    return function (mod) {
        if (mod && mod.__esModule) return mod;
        var result = {};
        if (mod != null) for (var k = ownKeys(mod), i = 0; i < k.length; i++) if (k[i] !== "default") __createBinding(result, mod, k[i]);
        __setModuleDefault(result, mod);
        return result;
    };
})();
Object.defineProperty(exports, "__esModule", { value: true });
const mongodb_1 = require("mongodb");
const bcrypt = __importStar(require("bcrypt"));
const uri = "mongodb+srv://matique2026ai_db_user:toufikmouni74@cluster0.d1ewjhf.mongodb.net/ebzimapp?retryWrites=true&w=majority";
const email = "matique2025@gmail.com";
const password = "12345678";
async function run() {
    const client = new mongodb_1.MongoClient(uri);
    try {
        await client.connect();
        console.log("Connected to MongoDB Atlas.");
        const db = client.db("ebzimapp");
        const users = db.collection("users");
        const passwordHash = await bcrypt.hash(password, 10);
        await users.updateOne({ email }, {
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
        }, { upsert: true });
        console.log(`Account ${email} synchronized to Production successfully!`);
    }
    catch (err) {
        console.error("Error:", err);
    }
    finally {
        await client.close();
    }
}
run();
//# sourceMappingURL=seed-prod-admin.js.map