"use strict";
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
var __metadata = (this && this.__metadata) || function (k, v) {
    if (typeof Reflect === "object" && typeof Reflect.metadata === "function") return Reflect.metadata(k, v);
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.MailService = void 0;
const common_1 = require("@nestjs/common");
const mailer_1 = require("@nestjs-modules/mailer");
let MailService = class MailService {
    mailerService;
    constructor(mailerService) {
        this.mailerService = mailerService;
    }
    async sendWelcomeEmail(email, userName) {
        await this.mailerService.sendMail({
            to: email,
            subject: 'مرحباً بك في جمعية إبزيم للثقافة والمواطنة',
            template: './welcome',
            context: {
                name: userName,
            },
            html: `
        <div style="direction: rtl; font-family: Arial, sans-serif; padding: 20px;">
          <h2 style="color: #006654;">مرحباً بك في إبزيم، ${userName}!</h2>
          <p>يسعدنا انضمامك إلينا في مسيرة حفظ التراث والمواطنة في ولاية سطيف.</p>
          <p>تم تفعيل حسابك بنجاح، يمكنك الآن استكشاف أنشطة الجمعية والمشاركة في فعالياتنا.</p>
          <br/>
          <p>مع تحيات،</p>
          <p><b>المكتب التنفيذي للجمعية</b></p>
        </div>
      `,
        });
    }
    async sendPasswordResetOtp(email, otp) {
        await this.mailerService.sendMail({
            to: email,
            subject: 'طلب استعادة كلمة المرور - جمعية إبزيم',
            html: `
        <div style="direction: rtl; font-family: Arial, sans-serif; padding: 20px;">
          <h2 style="color: #006654;">استعادة كلمة المرور</h2>
          <p>تلقينا طلباً لاستعادة كلمة المرور الخاصة بحسابك.</p>
          <p>يرجى استخدام الرمز التالي لتفعيل طلبك:</p>
          <div style="background: #f4f4f4; padding: 15px; text-align: center; font-size: 24px; font-weight: bold; letter-spacing: 5px; color: #006654; border-radius: 8px;">
            ${otp}
          </div>
          <p>هذا الرمز صالح لمدة ساعة واحدة فقط.</p>
          <br/>
          <p>إذا لم تطلب هذا الرمز، يمكنك تجاهل هذه الرسالة.</p>
        </div>
      `,
        });
    }
    async sendEmailVerificationOtp(email, otp) {
        await this.mailerService.sendMail({
            to: email,
            subject: 'تأكيد البريد الإلكتروني - جمعية إبزيم',
            html: `
        <div style="direction: rtl; font-family: Arial, sans-serif; padding: 20px;">
          <h2 style="color: #006654;">مرحباً بك في إبزيم!</h2>
          <p>شكراً لتسجيلك. يرجى استخدام الرمز التالي لتأكيد بريدك الإلكتروني وتفعيل حسابك:</p>
          <div style="background: #f4f4f4; padding: 15px; text-align: center; font-size: 24px; font-weight: bold; letter-spacing: 5px; color: #006654; border-radius: 8px;">
            ${otp}
          </div>
          <p>هذا الرمز صالح لمدة ساعة واحدة.</p>
        </div>
      `,
        });
    }
};
exports.MailService = MailService;
exports.MailService = MailService = __decorate([
    (0, common_1.Injectable)(),
    __metadata("design:paramtypes", [mailer_1.MailerService])
], MailService);
//# sourceMappingURL=mail.service.js.map