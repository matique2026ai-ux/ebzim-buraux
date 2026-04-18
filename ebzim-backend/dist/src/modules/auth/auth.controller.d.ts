import { AuthService } from './auth.service';
import { LoginDto } from './dto/login.dto';
import { RegisterDto } from './dto/register.dto';
export declare class AuthController {
    private readonly authService;
    constructor(authService: AuthService);
    register(registerDto: RegisterDto): Promise<{
        id: import("mongoose").Types.ObjectId;
        email: string;
        role: import("../../common/enums/role.enum").Role;
        profile: import("../users/schemas/user.schema").UserProfile;
        isVerificationRequired: boolean;
        debug_otp: string;
    } | {
        id: string;
        email: string;
        role: string;
        profile: import("./dto/register.dto").RegisterProfileDto;
        isVerificationRequired: boolean;
        debug_otp: string;
    }>;
    login(loginDto: LoginDto): Promise<{
        access_token: string;
        user: {
            id: any;
            email: any;
            role: any;
            profile: any;
        };
    }>;
    forgotPassword(email: string): Promise<{
        message: string;
        debug_otp?: undefined;
    } | {
        message: string;
        debug_otp: string;
    }>;
    resetPassword(token: string, password: string): Promise<{
        message: string;
    }>;
    verifyEmail(email: string, token: string): Promise<{
        message: string;
    }>;
    getProfile(req: any): Promise<{
        id: import("mongoose").Types.ObjectId;
        email: string;
        role: import("../../common/enums/role.enum").Role;
        profile: import("../users/schemas/user.schema").UserProfile;
    }>;
}
