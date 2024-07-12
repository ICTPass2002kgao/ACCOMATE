// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:flutter/material.dart';
// import 'package:flutter_credit_card/flutter_credit_card.dart';


// class PaymentPage extends StatefulWidget {
//   @override
//   _PaymentPageState createState() => _PaymentPageState();
// }

// class _PaymentPageState extends State<PaymentPage> {
//   final PayFastService _payFastService = PayFastService();
//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

//   String cardNumber = '';
//   String expiryDate = '';
//   String cardHolderName = '';
//   String cvvCode = '';
//   bool isCvvFocused = false;

//   void onCreditCardModelChange(CreditCardModel? model) {
//     setState(() {
//       cardNumber = model?.cardNumber ?? '';
//       expiryDate = model?.expiryDate ?? '';
//       cardHolderName = model?.cardHolderName ?? '';
//       cvvCode = model?.cvvCode ?? '';
//       isCvvFocused = model?.isCvvFocused ?? false;
//     });
//   }

//   Future<void> _startTokenization(int num_of_students) async {

//     try {
//       final expiryParts = expiryDate.split('/');
//       final tokenData = await _payFastService.createToken(
//         cardNumber: cardNumber.replaceAll(' ', ''),
//         cardExpiryMonth: expiryParts[0],
//         cardExpiryYear: '20' + expiryParts[1], 
//         cardCvv: cvvCode,
//         amount: 14.00*num_of_students,
//         itemName: 'Subscription Fee',
//       );

//       final token = tokenData['token'];
//       if (token != null) {
//         _startRecurringPayment(token);
//       }
//     } catch (e) {
//       print('Error starting tokenization: $e');
//     }
//   }

//   Future<void> _startRecurringPayment(String token) async {
//     try {
//       await _payFastService.createRecurringPayment(token, 100.0);
      
//     } catch (e) {
//       print('Error starting recurring payment: $e');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Join Monthly subscription'),
//       ),
//       body: SafeArea(
//         child: Column(
//           children: [
//             CreditCardWidget(
              
//               cardNumber: cardNumber,
//               expiryDate: expiryDate,
//               cardHolderName: cardHolderName,
//               cvvCode: cvvCode,
//               showBackView: isCvvFocused,
//               obscureCardNumber: true,
//               obscureCardCvv: true,
//               onCreditCardWidgetChange: (CreditCardBrand brand) {},
//             ),
//             CreditCardForm(
//               cardNumber: cardNumber,
//               expiryDate: expiryDate,
//               cardHolderName: cardHolderName,
//               cvvCode: cvvCode,
//               formKey: _formKey,  
//               onCreditCardModelChange: onCreditCardModelChange,
//               obscureCvv: true,
//               obscureNumber: true,
             
//             ),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () {
//                 if (_formKey.currentState!.validate()) {
//                   _startTokenization(14);
//                 } else {
//                   print('Invalid card information');
//                 }
//               },
//               child: Text('Pay Now'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class PayFastService {
//   final String baseUrl = 'https://us-central1-accomodationapp-9d851.cloudfunctions.net/api';

//   Future<Map<String, dynamic>> createToken({
//     required String cardNumber,
//     required String cardExpiryMonth,
//     required String cardExpiryYear,
//     required String cardCvv,
//     required double amount,
//     required String itemName,
//   }) async {
//     final response = await http.post(
//       Uri.parse('$baseUrl/create-token'),
//       headers: {
//         'Content-Type': 'application/json',
//       },
//       body: jsonEncode({
//         'card_number': cardNumber,
//         'card_expiry_month': cardExpiryMonth,
//         'card_expiry_year': cardExpiryYear,
//         'card_cvv': cardCvv,
//         'amount': amount.toString(),
//         'item_name': itemName,
//       }),
//     );

//     if (response.statusCode == 200) {
//       return jsonDecode(response.body);
//     } else {
//       throw Exception('Failed to create token');
//     }
//   }

//   Future<void> createRecurringPayment(String token, double amount) async {
//     final response = await http.post(
//       Uri.parse('$baseUrl/recurring-payment'),
//       headers: {
//         'Content-Type': 'application/json',
//       },
//       body: jsonEncode({
//         'token': token,
//         'amount': amount.toString(),
//       }),
//     );

//     if (response.statusCode != 200) {
//       throw Exception('Failed to create recurring payment');
//     }
//   }

//   Future<void> registerLandlord({
//     required bool requiresDeposit,
//     String? accountHolderName,
//     String? bankName,
//     String? accountNumber,
//     String? branchCode,
//   }) async {
//     final response = await http.post(
//       Uri.parse('$baseUrl/register-landlord'),
//       headers: {
//         'Content-Type': 'application/json',
//       },
//       body: jsonEncode({
//         'requires_deposit': requiresDeposit,
//         'account_holder_name': accountHolderName,
//         'bank_name': bankName,
//         'account_number': accountNumber,
//         'branch_code': branchCode,
//       }),
//     );

//     if (response.statusCode != 200) {
//       throw Exception('Failed to register landlord');
//     }
//   }

//   Future<Map<String, dynamic>> getLandlordDetails(String landlordId) async {
//     final response = await http.get(
//       Uri.parse('$baseUrl/landlord-details/$landlordId'),
//       headers: {
//         'Content-Type': 'application/json',
//       },
//     );

//     if (response.statusCode == 200) {
//       return jsonDecode(response.body);
//     } else {
//       throw Exception('Failed to get landlord details');
//     }
//   }

//   Future<Map<String, dynamic>> makeOneTimePayment({
//     required String cardNumber,
//     required String cardExpiryMonth,
//     required String cardExpiryYear,
//     required String cardCvv,
//     required double amount,
//     required Map<String, dynamic> landlordBankDetails,
//   }) async {
//     final response = await http.post(
//       Uri.parse('$baseUrl/make-one-time-payment'),
//       headers: {
//         'Content-Type': 'application/json',
//       },
//       body: jsonEncode({
//         'card_number': cardNumber,
//         'card_expiry_month': cardExpiryMonth,
//         'card_expiry_year': cardExpiryYear,
//         'card_cvv': cardCvv,
//         'amount': amount.toString(),
//         'landlord_bank_details': landlordBankDetails,
//       }),
//     );

//     if (response.statusCode == 200) {
//       return jsonDecode(response.body);
//     } else {
//       throw Exception('Failed to make one-time payment');
//     }
//   }
// }
