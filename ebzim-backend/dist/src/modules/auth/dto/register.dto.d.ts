export declare class RegisterProfileDto {
    firstName: string;
    lastName?: string;
    phone?: string;
}
export declare class RegisterDto {
    email: string;
    password: string;
    profile: RegisterProfileDto;
}
