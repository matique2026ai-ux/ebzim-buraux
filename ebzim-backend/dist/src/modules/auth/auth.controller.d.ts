import { AuthService } from './auth.service';
import { LoginDto } from './dto/login.dto';
export declare class AuthController {
    private readonly authService;
    constructor(authService: AuthService);
    login(loginDto: LoginDto): Promise<{
        access_token: string;
        user: {
            id: import("mongoose").Types.ObjectId;
            email: string;
            role: import("../../common/enums/role.enum").Role;
            profile: import("../users/schemas/user.schema").UserProfile;
        };
    }>;
}
