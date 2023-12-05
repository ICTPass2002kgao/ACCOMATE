// import 'package:flutter/material.dart';
// import 'package:flutter_stripe/flutter_stripe.dart';

// class RegistrationFee extends StatefulWidget {
//   const RegistrationFee({super.key});

//   @override
//   State<RegistrationFee> createState() => _RegistrationFeeState();
// }

// class _RegistrationFeeState extends State<RegistrationFee> {
//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
//   TextEditingController _accountNumberController = TextEditingController();
//   TextEditingController _routingNumberController = TextEditingController();
//   Future<void> _handlePayment() async {
//     try {
//       // Initialize the Stripe API with your publishable key
//       Stripe.publishableKey =
//           'your_publishable_key'; // Replace with your actual publishable key

//       // Create a payment method
//       PaymentMethod paymentMethod = await StripePayment.createPaymentMethod(
//         PaymentMethodParams.card(
//           number: '4242424242424242', // Replace with a test card number
//           expMonth: 12,
//           expYear: 25,
//         ),
//       );

//       // Call your server to create a payment intent and get the client secret
//       // Replace 'createPaymentIntent' with your server endpoint
//       String clientSecret = await createPaymentIntent();

//       // Confirm the payment on the client side
//       PaymentIntentResult paymentIntentResult =
//           await StripePayment.confirmPaymentIntent(
//         PaymentIntentParams.clientSecret(clientSecret),
//         paymentMethodId: paymentMethod.id,
//       );

//       // Handle successful payment
//       print('Payment successful: ${paymentIntentResult.paymentIntentId}');
//       // You can display a success message or navigate to a success screen here
//     } catch (error) {
//       // Handle payment error
//       print('Error during payment: $error');
//       // You can display an error message to the user
//     }
//   }

//   // Replace this function with your server endpoint for creating a payment intent
//   Future<String> createPaymentIntent() async {
//     // Call your server to create a payment intent and return the client secret
//     // This is a placeholder, replace it with your actual server logic
//     // Example: http.post('https://your-server.com/create-payment-intent', body: {...})
//     // Your server should handle the interaction with the Stripe API
//     return 'your_payment_intent_client_secret'; // Replace with your actual payment intent client secret
//   }

//   @override
//   void initState() {
//     super.initState();
//     StripePayment.setOptions(
//       StripeOptions(
//         publishableKey:
//             'your_publishable_key', // Replace with your publishable key
//         merchantId: 'your_merchant_id', // Optional
//         androidPayMode: 'test', // Optional: 'test' or 'production'
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Form(
//       key: _formKey,
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             TextFormField(
//               controller: _accountNumberController,
//               decoration: InputDecoration(labelText: 'Account Number'),
//               validator: (value) {
//                 if (value.isEmpty) {
//                   return 'Please enter account number';
//                 }
//                 return null;
//               },
//             ),
//             TextFormField(
//               controller: _routingNumberController,
//               decoration: InputDecoration(labelText: 'Routing Number'),
//               validator: (value) {
//                 if (value.isEmpty) {
//                   return 'Please enter routing number';
//                 }
//                 return null;
//               },
//             ),
//             SizedBox(height: 16.0),
//             ElevatedButton(
//               onPressed: () async {
//                 if (_formKey.currentState.validate()) {
//                   // Call the function to handle the payment
//                   await _handlePayment();
//                 }
//               },
//               child: Text('Submit Payment'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
