import { Injectable } from '@nestjs/common';
import { MailerService } from '@nestjs-modules/mailer';

@Injectable()
export class MailService {
  constructor(private readonly mailerService: MailerService) {}

  async sendWelcomeEmail(email: string, userName: string) {
    await this.mailerService.sendMail({
      to: email,
      subject: 'مرحباً بك في جمعية إبزيم للثقافة والمواطنة',
      template: './welcome', // will point to templates/welcome.hbs
      context: {
        name: userName,
      },
      // Fallback if template engine fails or for simple testing:
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

  async sendPasswordResetOtp(email: string, otp: string) {
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

  async sendEmailVerificationOtp(email: string, otp: string) {
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
}
