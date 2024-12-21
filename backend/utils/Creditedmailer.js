const nodemailer = require('nodemailer');
require('dotenv').config();

const senderEmail = process.env.SENDER_EMAIL;
const senderPass = process.env.SENDER_APP_PASS;

const transporter = nodemailer.createTransport({
    service: 'gmail',
    auth: {
        user: senderEmail,
        pass: senderPass
    }
});

const htmlContent = (reciver_name, upi_id, email, mobileNumber) => {
    return `
       <!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Payment Confirmation Email</title>
</head>
<body style="margin: 0; padding: 0; font-family: Arial, sans-serif; background-color: #f4f4f4;">

    <!-- Email Container -->
    <div style="max-width: 600px; margin: 20px auto; background-color: #ffffff; border: 1px solid #ddd; border-radius: 8px; overflow: hidden; box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);">

        <!-- Header Section -->
        

        <!-- Main Content Section -->
        <div style="padding: 20px;">
            <!-- Payment Success Message -->
            <h1 style="text-align: center; font-size: 24px; color: #4CAF50; margin-bottom: 10px;">₹500.27</h1>
            <p style="text-align: center; font-size: 16px; color: #333333; margin-bottom: 20px;">Recived Successfully</p>

            <!-- Payment Details -->
            <div style="margin-bottom: 20px;">
                <div style="display: flex; justify-content: space-between; padding: 8px 0; border-bottom: 1px solid #eee;">
                    <strong>To:</strong>
                    <span>${reciver_name}</span>
                </div>
                <div style="display: flex; justify-content: space-between; padding: 8px 0; border-bottom: 1px solid #eee;">
                    <strong>Method:</strong>
                    <span>UPI</span>
                </div>
                <div style="display: flex; justify-content: space-between; padding: 8px 0; border-bottom: 1px solid #eee;">
                    <strong>UPI id:</strong>
                    <span>${upi_id}</span>
                </div>
                <div style="display: flex; justify-content: space-between; padding: 8px 0; border-bottom: 1px solid #eee;">
                    <strong>Email:</strong>
                    <span>${email}</span>
                </div>
                <div style="display: flex; justify-content: space-between; padding: 8px 0;">
                    <strong>Mobile Number:</strong>
                    <span>${mobileNumber}</span>
                </div>
            </div>
        </div>


    </div>
</body>
</html>

    `;
};

const CreditedMail = async (receiver_email, reciver_name, upi_id, mobileNumber) => {
    const mailOptions = {
        from: senderEmail,
        to: receiver_email,
        subject: `Payment ${reciver_name}`,
        html: htmlContent(reciver_name, upi_id, receiver_email, mobileNumber)
    };

    transporter.sendMail(mailOptions, (error, info) => {
        if (error) {
            console.error('Error sending email:', error);
        } else {
            console.log('Email sent:', info.response);
        }
    });
};

module.exports = CreditedMail;
