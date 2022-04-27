import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:furniture_yourbrand_app/models/order.dart';
import 'package:furniture_yourbrand_app/provider/cart_provider.dart';
import 'package:furniture_yourbrand_app/widgets/widget_order_success.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class RazorPaymentService {
  Razorpay _razorpay;
  BuildContext _buildContext;

  initPaymentGateway(BuildContext buildContext) {
    this._buildContext = buildContext;
    _razorpay = new Razorpay();
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, externalWallet);
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, paymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, paymentError);
  }

  void externalWallet(ExternalWalletResponse response) {
    print(response.walletName);
  }

  void paymentSuccess(PaymentSuccessResponse response) {
    print("SUCCESS: " + response.paymentId.toString());
    var orderProvider = Provider.of<CartProvider>(_buildContext, listen: false);
    OrderModel orderModel = new OrderModel();
    orderModel.paymentMethod = "razorpay";
    orderModel.paymentMethodTitle = "RazorPay";
    orderModel.setPaid = true;
    orderModel.transactionId = response.paymentId.toString();

    orderProvider.processOrder(orderModel);

    Navigator.pushAndRemoveUntil(
        _buildContext,
        MaterialPageRoute(builder: (context) => OrderSuccessWidget()),
        ModalRoute.withName("/OrderSuccess"));
  }

  void paymentError(PaymentFailureResponse response) {
    print("ERROR: " +
        response.message.toString() +
        " - " +
        response.code.toString());
  }

  getPayment(BuildContext context) {
    var cartItems = Provider.of<CartProvider>(context, listen: false);
    cartItems.fetchCartItems();

    var options = {
      'key': 'rzp_test_YZOIQS0vqsU06i',
      'amount': cartItems.totalAmount * 100,
      'description': 'Payment for our Products',
      'prefill': {
        "contact": "8925450309",
        "email": "ekcsmedia@gmail.com",
      },
      'name': 'KCS Education'
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      print('$e');
    }
  }
}
