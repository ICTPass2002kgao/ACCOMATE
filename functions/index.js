// // Unused variables
// // const { onRequest } = require("firebase-functions/v2/https");
// // const logger = require("firebase-functions/logger");

// const functions = require("firebase-functions");
// const admin = require("firebase-admin");
// const nodemailer = require("nodemailer");

// admin.initializeApp();

// // Set up nodemailer
// const transporter = nodemailer.createTransport({
//   service: "gmail",
//   auth: {
//     user: "kgaogelojoseph33@gmail.com", // replace with your Gmail address
//     pass: "password", // replace with your Gmail password
//   },
// });

// // Firestore function trigger
// exports.sendConfirmationEmail = functions.firestore
//   .document("users/{landlordId}/applications/{studentId}")
//   .onCreate(async (snapshot, context) => {
//     const landlordId = context.params.landlordId;
//     const studentId = context.params.studentId;

//     // Fetch landlord and student details from Firestore
//     const landlordDoc = await admin.firestore().collection("users").doc(landlordId).get();
//     const studentDoc = await admin.firestore().collection("users").doc(studentId).get();

//     const landlordEmail = landlordDoc.data().email;
//     const studentName = studentDoc.data().name;

//     // Email content
//     const mailOptions = {
//       from: "kgaogelojoseph33@gmail.com", // replace with your Gmail address
//       to: landlordEmail,
//       subject: "New Accommodation Application Received",
//       text: `Hello ${studentName},\n\nA new application has been received for your accommodation.\n\nRegards,\nYour App Name`,
//     };

//     // Send the email
//     try {
//       await transporter.sendMail(mailOptions);
//       console.log("Email sent successfully");
//     } catch (error) {
//       console.error("Error sending email:", error);
//       console.log(snapshot);
//     }

//     return null;
//   });

// // Unused function
// // exports.helloWorld = onRequest((request, response) => {
// //   logger.info("Hello logs!", {structuredData: true});
// //   response.send("Hello from Firebase!");
// // });

const functions = require('firebase-functions');
const nodemailer = require('nodemailer');

// Create a transporter for sending emails
const transporter = nodemailer.createTransport({
  service: 'gmail',
  auth: {
    user: 'kgaogelojoseph33@gmail.com', // Replace with your email
    pass: 'ICTPass2002@', // Replace with your email password or app-specific password
  },
});

// Define your Cloud Function
exports.confirmationEmail = functions.https.onCall(async (data, context) => {
  const { to, subject, body } = data;

  try {
    // Send email
    await transporter.confirmationEmail({
      from: 'kgaogelojoseph33@gmail.com', // Replace with your email
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

