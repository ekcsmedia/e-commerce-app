import 'package:flutter/cupertino.dart';
import 'package:furniture_yourbrand_app/provider/razor_payment_service.dart';

class PaymentMethod {
  String id;
  String name;
  String description;
  String logo;
  String route;
  Function onTap;
  bool isRouteRedirect;

  PaymentMethod(
    this.id,
    this.name,
    this.description,
    this.logo,
    this.route,
    this.onTap,
    this.isRouteRedirect,
  );
}

class PaymentMethodList {
  List<PaymentMethod> _paymentsList;
  List<PaymentMethod> _cashList;
  //List<PaymentMethod> _pickupList;

  PaymentMethodList(BuildContext _context) {
    this._paymentsList = [
      new PaymentMethod(
          "razorpay",
          "RazorPay",
          "Click to pay with RazorPay Method",
          "assets/img/razorpay.png",
          "/RazorPay", () {
        RazorPaymentService razorPaymentService = new RazorPaymentService();
        razorPaymentService.initPaymentGateway(_context);
        razorPaymentService.getPayment(_context);
      }, false),
      new PaymentMethod("paypal", "PayPal", "Click to pay with PayPal Method",
          "assets/img/paypal.png", "/PayPal", () {}, false),
    ];
    this._cashList = [
      new PaymentMethod(
          "cod",
          "Cash on Delivery",
          "Click to pay cash on delivery",
          "assets/img/cash.png",
          "/OrderSuccess",
          () {},
          false),
    ];
  }

  List<PaymentMethod> get paymentsList => _paymentsList;
  List<PaymentMethod> get cashList => _cashList;
}
