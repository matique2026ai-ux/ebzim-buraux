import { Injectable, UnauthorizedException, ConflictException } from '@nestjs/common';
import { JwtService } from '@nestjs/jwt';
import { InjectModel } from '@nestjs/mongoose';
import { Model } from 'mongoose';
import * as bcrypt from 'bcrypt';
import { UserDocument } from '../users/schemas/user.schema';
import { MailService } from '../mail/mail.service';
import { LoginDto } from './dto/login.dto';
import { RegisterDto } from './dto/register.dto';

@Injectable()
export class AuthService {
  private memoryStore = new Map<string, any>();

  constructor(
    @InjectModel('User') private userModel: Model<UserDocument>,
    private jwtService: JwtService,
    private mailService: MailService,
  ) {}

  private async tryDb<T>(op: () => Promise<T>): Promise<T> {
    try {
      return await op();
    } catch (err) {
      console.warn('[AUTH] MongoDB operation failed, falling back to memory store:', err.message);
      throw err; // For now let it throw, but we can catch it specifically
    }
  }

  async register(registerDto: RegisterDto) {
    const { email, password, profile } = registerDto;

    try {
      // Real DB Attempt
      const existingUser = await this.userModel.findOne({ email });
      if (existingUser) {
        throw new ConflictException('User with this email already exists');
      }

      const saltRounds = 10;
      const passwordHash = await bcrypt.hash(password, saltRounds);

      const token = Math.floor(100000 + Math.random() * 900000).toString();

      const newUser = new this.userModel({
        email,
        passwordHash,
        profile,
        status: 'PENDING_VERIFICATION',
        verificationToken: token,
        verificationExpires: new Date(Date.now() + 3600000), // 1 hour
      });

      const savedUser = await newUser.save();

      this.mailService.sendEmailVerificationOtp(savedUser.email, token)
        .catch(err => console.error('[AUTH] Failed to send verification email:', err));
      
      return {
        id: savedUser._id,
        email: savedUser.email,
        role: savedUser.role,
        profile: savedUser.profile,
        isVerificationRequired: true,
        debug_otp: token,
      };
    } catch (err) {
      // Fallback to Memory Store if DB is down
      if (err.name === 'MongooseServerSelectionError' || err.message?.includes('buffering timed out')) {
        console.log('[AUTH] Using Memory Fallback for Registration');
        if (this.memoryStore.has(email)) {
          throw new ConflictException('User with this email already exists (Memory)');
        }
        
        const id = Math.random().toString(36).substring(7);
        const saltRounds = 10;
        const passwordHash = await bcrypt.hash(password, saltRounds);
        
        const token = Math.floor(100000 + Math.random() * 900000).toString();
        
        const userData = {
          _id: id,
          email,
          passwordHash,
          profile,
          role: 'PUBLIC',
          status: 'PENDING_VERIFICATION',
          verificationToken: token,
        };
        
        this.memoryStore.set(email, userData);
        this.memoryStore.set(id, userData);
        
        return {
          id,
          email,
          role: 'PUBLIC',
          profile,
          isVerificationRequired: true,
          debug_otp: token,
        };
      }
      throw err;
    }
  }

  async login(loginDto: LoginDto) {
    let user;
    try {
      user = await this.userModel.findOne({ email: loginDto.email });
    } catch (err) {
      console.log('[AUTH] Login fallback to memory');
      user = this.memoryStore.get(loginDto.email);
    }

    if (!user || user.status !== 'ACTIVE') {
      throw new UnauthorizedException('Invalid credentials or inactive account');
    }

    const isPasswordValid = await bcrypt.compare(loginDto.password, user.passwordHash);
    if (!isPasswordValid) {
      throw new UnauthorizedException('Invalid credentials');
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

  async forgotPassword(email: string) {
    const user = await this.userModel.findOne({ email });
    if (!user)
      return {
        message: 'If this email is registered, a password reset link has been sent.',
      };

    // Generate a 6-digit OTP (for simulation)
    const token = Math.floor(100000 + Math.random() * 900000).toString();
    user.resetPasswordToken = token;
    user.resetPasswordExpires = new Date(Date.now() + 3600000); // 1 hour
    await user.save();

    console.log(`[AUTH SERVICE] Sending password reset OTP for ${email}: ${token}`);
    
    // Send OTP email
    await this.mailService.sendPasswordResetOtp(email, token)
      .catch(err => console.error('[AUTH] Failed to send OTP email:', err));

    return {
      message: 'Password reset instructions have been sent.',
      debug_otp: token, // Keep it for agent usability
    };
  }

  async resetPassword(token: string, newPassword: string) {
    const user = await this.userModel.findOne({
      resetPasswordToken: token,
      resetPasswordExpires: { $gt: new Date() },
    });

    if (!user) throw new UnauthorizedException('Invalid or expired reset token');

    const saltRounds = 10;
    user.passwordHash = await bcrypt.hash(newPassword, saltRounds);
    user.resetPasswordToken = undefined;
    user.resetPasswordExpires = undefined;
    await user.save();

    return { message: 'Password successfully reset' };
  }

  async getProfile(userId: string) {
    console.log(`[AUTH SERVICE] Fetching profile for userId: ${userId}`);
    const user = await this.userModel.findById(userId);
    if (!user || user.status !== 'ACTIVE') {
      console.log(`[AUTH SERVICE] User not found or inactive: ${userId}`);
      throw new UnauthorizedException('User not found or inactive');
    }
    console.log(`[AUTH SERVICE] Profile found for: ${user.email}`);
    return {
      id: user._id,
      email: user.email,
      role: user.role,
      profile: user.profile,
    };
  }

  async verifyEmail(email: string, token: string) {
    let user;
    try {
      user = await this.userModel.findOne({ email });
    } catch (err) {
      console.log('[AUTH] Verify Email fallback to memory');
      user = this.memoryStore.get(email);
    }

    if (!user) throw new UnauthorizedException('User not found');
    
    if (user.status === 'ACTIVE') {
      return { message: 'Email is already verified' };
    }

    if (user.verificationToken !== token) {
      throw new UnauthorizedException('Invalid verification token');
    }

    if (user.verificationExpires && user.verificationExpires < new Date()) {
      throw new UnauthorizedException('Verification token has expired');
    }

    user.status = 'ACTIVE';
    user.verificationToken = undefined;
    user.verificationExpires = undefined;

    if (user.save) {
      await user.save();
      // Optionally send welcome email here since they are now active
      this.mailService.sendWelcomeEmail(user.email, user.profile?.firstName || 'عضو إبزيم')
        .catch(err => console.error('[AUTH] Failed to send welcome email:', err));
    } else {
      this.memoryStore.set(email, user); // Memory update
    }

    return { message: 'Email successfully verified' };
  }
}
