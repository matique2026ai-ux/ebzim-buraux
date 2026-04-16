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
const core_1 = require("@nestjs/core");
const app_module_1 = require("../src/app.module");
const mongoose_1 = require("@nestjs/mongoose");
const role_enum_1 = require("../src/common/enums/role.enum");
const bcrypt = __importStar(require("bcrypt"));
async function bootstrap() {
    const app = await core_1.NestFactory.createApplicationContext(app_module_1.AppModule);
    const userModel = app.get((0, mongoose_1.getModelToken)('User'));
    const categoryModel = app.get((0, mongoose_1.getModelToken)('Category'));
    console.log('Seeding Database...');
    const existingAdmin = await userModel.findOne({ email: 'admin@ebzim.org' });
    if (!existingAdmin) {
        const passwordHash = await bcrypt.hash('AdminPassword123!', 10);
        await userModel.create({
            email: 'admin@ebzim.org',
            passwordHash,
            role: role_enum_1.Role.SUPER_ADMIN,
            profile: {
                firstName: 'System',
                lastName: 'Admin',
            },
        });
        console.log('SUPER_ADMIN created: admin@ebzim.org');
    }
    else {
        console.log('SUPER_ADMIN already exists.');
    }
    const defaults = [
        { slug: 'heritage', name: { ar: 'التراث', fr: 'Patrimoine', en: 'Heritage' } },
        { slug: 'culture', name: { ar: 'ثقافة', fr: 'Culture', en: 'Culture' } },
        { slug: 'citizenship', name: { ar: 'مواطنة', fr: 'Citoyenneté', en: 'Citizenship' } },
    ];
    for (const cat of defaults) {
        const existing = await categoryModel.findOne({ slug: cat.slug });
        if (!existing) {
            await categoryModel.create(cat);
            console.log(`Seeded Category: ${cat.slug}`);
        }
    }
    console.log('Seeding Execution Finished!');
    await app.close();
}
bootstrap();
//# sourceMappingURL=seed.js.map