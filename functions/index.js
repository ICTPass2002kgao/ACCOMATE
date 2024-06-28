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

exports.sendNotification = functions.https.onRequest(async (req, res) => {
  
  if (req.method !== "POST") {
    return res.status(405).send("Method Not Allowed");
  }
 
  const { title, body, token } = req.body;

  if (!title || !body || !token) {
    return res.status(400).send("Missing parameters");
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
    console.log(`Notification sent to token: ${token}`);
    return res.status(200).send("Notification sent successfully");
  } catch (error) {
    console.error("Error sending notification:", error);
    return res.status(500).send("Error sending notification");
  }
});


//payments  
const express = require('express');
const cors = require('cors');
const bodyParser = require('body-parser');
const axios = require('axios');

const app = express();
app.use(cors({ origin: true }));
app.use(bodyParser.json());

// PayFast credentials
const merchantId = 'YOUR_MERCHANT_ID';
const merchantKey = 'YOUR_MERCHANT_KEY';
const passphrase = 'YOUR_PASSPHRASE';

// Route to generate token URL
app.post('/generate-token-url', (req, res) => {
  const { amount, item_name, return_url, cancel_url, notify_url } = req.body;

  const data = {
    merchant_id: merchantId,
    merchant_key: merchantKey,
    amount: amount,
    item_name: item_name,
    return_url: return_url,
    cancel_url: cancel_url,
    notify_url: notify_url,
    payment_type: 'CC', // Specify credit card payment type
  };

  // Sort and encode data for PayFast
  const queryString = Object.keys(data)
    .sort()
    .map(key => `${key}=${encodeURIComponent(data[key])}`)
    .join('&');

  const signature = require('crypto').createHash('md5').update(queryString + '&passphrase=' + passphrase).digest('hex');

  const tokenUrl = `https://www.payfast.co.za/eng/process?${queryString}&signature=${signature}`;

  res.send({ url: tokenUrl });
});

// Route to handle recurring payment
app.post('/recurring-payment', async (req, res) => {
  const { token, amount } = req.body;

  try {
    const response = await axios.post('https://api.payfast.co.za/subscriptions', {
      token: token,
      amount: amount,
      frequency: 3, // Monthly
      cycles: 0, // Indefinite
    }, {
      auth: {
        username: merchantId,
        password: passphrase,
      },
    });

    res.send(response.data);
  } catch (error) {
    res.status(500).send(error.response.data);
  }
});

exports.api = functions.https.onRequest(app);

