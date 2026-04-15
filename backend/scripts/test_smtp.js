require('dotenv').config();
const nodemailer = require('nodemailer');

async function testMail() {
    console.log("Starting SMTP Test...");
    const transporter = nodemailer.createTransport({
        host: process.env.MAIL_HOST || 'smtp.gmail.com',
        secure: false, // fallback from mail.module.ts
        auth: {
            user: process.env.MAIL_USER,
            pass: process.env.MAIL_PASS, // could have spaces
        }
    });

    try {
        console.log("Verifying connection to:", process.env.MAIL_HOST, process.env.MAIL_USER);
        await transporter.verify();
        console.log("Connection verified successfully!");

        console.log("Attempting to send email...");
        const info = await transporter.sendMail({
            from: process.env.MAIL_FROM || `"جمعية إبزيم" <${process.env.MAIL_USER}>`,
            to: process.env.MAIL_USER, // Send to self
            subject: 'SMTP Test Diagnosis',
            text: 'If you see this, SMTP is working.'
        });
        console.log("Email sent successfully: " + info.messageId);
    } catch (error) {
        console.error("SMTP Error Diagnostics:");
        console.error(error.message);
        console.error(error.response);
        console.error("Code:", error.code);
        console.error("Command:", error.command);
    }
}

testMail();
