const functions = require('firebase-functions');
const nodemailer = require('nodemailer');

// Create a transporter for sending emails
const transporter = nodemailer.createTransport({
  service: 'gmail',
  port:485,
  secure: true,
  logger: true,
  debug: true,
  secureConnection: false,
  auth: {
    user: 'accomate33@gmail.com', // Replace with your email
    pass: 'nhle ndut leqq baho', // Replace with your email password or app-specific password
  },
  tls: {
    rejectUnauthorized: true
  }
});

// Define your Cloud Function
exports.sendEmail = functions.https.onCall(async (data) => {
  const { to, subject, body } = data;

  try {
    // Send email
    await transporter.sendMail({  // Fixed: Use sendMail instead of confirmationEmail
      from: 'Accomate', // Replace with your email
      to,
      subject,
      text: body,
    });

    console.log(`Email sent to ${to}: ${body}`);
    return { success: true };
  } catch (error) {
    console.error(`Error sending email to ${to}: ${error}`);
    return { success: false, error: error.message };
  }
});
