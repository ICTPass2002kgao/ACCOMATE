const functions = require('firebase-functions');
const nodemailer = require('nodemailer');
const admin = require('firebase-admin');

admin.initializeApp();


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


// Function for sending notifications to landlords using FCM
exports.sendNotification = functions.https.onRequest(async (req, res) => {
  // Retrieve title, body, and token from the request body
  const { title, body, token } = req.body;

  if (!title || !body || !token) {
    return res.status(400).send('Missing parameters');
  }

  const message = {
    notification: {
      title: title,
      body: body,
    },
    token: token, // Use the token received from the request body
  };

  try {
    await admin.messaging().send(message);
    return res.status(200).send('Notification sent successfully');
  } catch (error) {
    console.error('Error sending notification:', error);
    return res.status(500).send('Error sending notification');
  }
});
