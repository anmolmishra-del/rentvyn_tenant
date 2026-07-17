import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class RazorpayService {
  static final RazorpayService _instance = RazorpayService._internal();
  factory RazorpayService() => _instance;

  late Razorpay _razorpay;
  void Function(PaymentSuccessResponse)? _onSuccess;
  void Function(PaymentFailureResponse)? _onFailure;

  RazorpayService._internal() {
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    _onSuccess?.call(response);
  }

 void _handlePaymentError(PaymentFailureResponse response) {
  print("Code: ${response.code}");
  print("Message: ${response.message}");
  print("Error: ${response.error}");

  _onFailure?.call(response);
}

  void openCheckout({
    required double amount,
    required String name,
    required String description,
    required String phone,
    required String email,
    required void Function(PaymentSuccessResponse) onSuccess,
    required void Function(PaymentFailureResponse) onFailure,
     required String orderId,
  }) {
    _onSuccess = onSuccess;
    _onFailure = onFailure;

    final activeKey =  dotenv.env['RAZORPAY_KEY_ID'] ?? '';

    // Clean phone number (extract digits only). If empty or invalid length, use fallback.
    String sanitizedPhone = phone.replaceAll(RegExp(r'\D'), '');
    if (sanitizedPhone.length < 10) {
      sanitizedPhone = '9966267177';
    }

    // Clean email. If empty or invalid, use fallback.
    String sanitizedEmail = email.trim();
    if (sanitizedEmail.isEmpty || !sanitizedEmail.contains('@')) {
      sanitizedEmail = 'tenant@rentvyn.com';
    }

    final options = {
      'key': activeKey,
      'amount': (amount * 100).toInt(), // amount in paise
      'currency': 'INR',
      'name': name,
      'order_id': orderId,
      'description': description,
      'prefill': {
        'contact': sanitizedPhone,
        'email': sanitizedEmail,
      },
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint('Razorpay Checkout Open Error: $e');
    }
  }
}
