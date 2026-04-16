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
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
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
var __metadata = (this && this.__metadata) || function (k, v) {
    if (typeof Reflect === "object" && typeof Reflect.metadata === "function") return Reflect.metadata(k, v);
};
var __param = (this && this.__param) || function (paramIndex, decorator) {
    return function (target, key) { decorator(target, key, paramIndex); }
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.AuthService = void 0;
const common_1 = require("@nestjs/common");
const jwt_1 = require("@nestjs/jwt");
const mongoose_1 = require("@nestjs/mongoose");
const mongoose_2 = require("mongoose");
const bcrypt = __importStar(require("bcrypt"));
const mail_service_1 = require("../mail/mail.service");
let AuthService = class AuthService {
    userModel;
    jwtService;
    mailService;
    memoryStore = new Map();
    constructor(userModel, jwtService, mailService) {
        this.userModel = userModel;
        this.jwtService = jwtService;
        this.mailService = mailService;
    }
    async tryDb(op) {
        try {
            return await op();
        }
        catch (err) {
            console.warn('[AUTH] MongoDB operation failed, falling back to memory store:', err.message);
            throw err;
        }
    }
    async register(registerDto) {
        const { email, password, profile } = registerDto;
        try {
            const existingUser = await this.userModel.findOne({ email });
            if (existingUser) {
                throw new common_1.ConflictException('User with this email already exists');
            }
            const saltRounds = 10;
            const passwordHash = await bcrypt.hash(password, saltRounds);
            const newUser = new this.userModel({
                email,
                passwordHash,
                profile,
                status: 'ACTIVE',
            });
            const savedUser = await newUser.save();
            this.mailService.sendWelcomeEmail(savedUser.email, profile.firstName || 'عضو إبزيم')
                .catch(err => console.error('[AUTH] Failed to send welcome email:', err));
            return {
                id: savedUser._id,
                email: savedUser.email,
                role: savedUser.role,
                profile: savedUser.profile,
            };
        }
        catch (err) {
            if (err.name === 'MongooseServerSelectionError' || err.message?.includes('buffering timed out')) {
                console.log('[AUTH] Using Memory Fallback for Registration');
                if (this.memoryStore.has(email)) {
                    throw new common_1.ConflictException('User with this email already exists (Memory)');
                }
                const id = Math.random().toString(36).substring(7);
                const saltRounds = 10;
                const passwordHash = await bcrypt.hash(password, saltRounds);
                const userData = {
                    _id: id,
                    email,
                    passwordHash,
                    profile,
                    role: 'PUBLIC',
                    status: 'ACTIVE'
                };
                this.memoryStore.set(email, userData);
                this.memoryStore.set(id, userData);
                return {
                    id,
                    email,
                    role: 'PUBLIC',
                    profile,
                };
            }
            throw err;
        }
    }
    async login(loginDto) {
        let user;
        try {
            user = await this.userModel.findOne({ email: loginDto.email });
        }
        catch (err) {
            console.log('[AUTH] Login fallback to memory');
            user = this.memoryStore.get(loginDto.email);
        }
        if (!user || user.status !== 'ACTIVE') {
            throw new common_1.UnauthorizedException('Invalid credentials or inactive account');
        }
        const isPasswordValid = await bcrypt.compare(loginDto.password, user.passwordHash);
        if (!isPasswordValid) {
            throw new common_1.UnauthorizedException('Invalid credentials');
        }
        const payload = {
            sub: user._id || user.id,
            email: user.email,
            role: user.role,
            institutionId: user.profile?.institutionId || null,
        };
        return {
            access_token: this.jwtService.sign(payload),
            user: {
                id: user._id || user.id,
                email: user.email,
                role: user.role,
                profile: user.profile,
            },
        };
    }
    async forgotPassword(email) {
        const user = await this.userModel.findOne({ email });
        if (!user)
            return {
                message: 'If this email is registered, a password reset link has been sent.',
            };
        const token = Math.floor(100000 + Math.random() * 900000).toString();
        user.resetPasswordToken = token;
        user.resetPasswordExpires = new Date(Date.now() + 3600000);
        await user.save();
        console.log(`[AUTH SERVICE] Sending password reset OTP for ${email}: ${token}`);
        await this.mailService.sendPasswordResetOtp(email, token)
            .catch(err => console.error('[AUTH] Failed to send OTP email:', err));
        return {
            message: 'Password reset instructions have been sent.',
            debug_otp: token,
        };
    }
    async resetPassword(token, newPassword) {
        const user = await this.userModel.findOne({
            resetPasswordToken: token,
            resetPasswordExpires: { $gt: new Date() },
        });
        if (!user)
            throw new common_1.UnauthorizedException('Invalid or expired reset token');
        const saltRounds = 10;
        user.passwordHash = await bcrypt.hash(newPassword, saltRounds);
        user.resetPasswordToken = undefined;
        user.resetPasswordExpires = undefined;
        await user.save();
        return { message: 'Password successfully reset' };
    }
    async getProfile(userId) {
        console.log(`[AUTH SERVICE] Fetching profile for userId: ${userId}`);
        const user = await this.userModel.findById(userId);
        if (!user || user.status !== 'ACTIVE') {
            console.log(`[AUTH SERVICE] User not found or inactive: ${userId}`);
            throw new common_1.UnauthorizedException('User not found or inactive');
        }
        console.log(`[AUTH SERVICE] Profile found for: ${user.email}`);
        return {
            id: user._id,
            email: user.email,
            role: user.role,
            profile: user.profile,
        };
    }
};
exports.AuthService = AuthService;
exports.AuthService = AuthService = __decorate([
    (0, common_1.Injectable)(),
    __param(0, (0, mongoose_1.InjectModel)('User')),
    __metadata("design:paramtypes", [mongoose_2.Model,
        jwt_1.JwtService,
        mail_service_1.MailService])
], AuthService);
//# sourceMappingURL=auth.service.js.map