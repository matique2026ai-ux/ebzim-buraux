import { MailerService } from '@nestjs-modules/mailer';
export declare class MailService {
    private readonly mailerService;
    constructor(mailerService: MailerService);
    sendWelcomeEmail(email: string, userName: string): Promise<void>;
    sendPasswordResetOtp(email: string, otp: string): Promise<void>;
    sendEmailVerificationOtp(email: string, otp: string): Promise<void>;
}
