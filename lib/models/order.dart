import 'package:furniture_yourbrand_app/models/customer_detail_model.dart';

class OrderModel {
  int customerId;
  String paymentMethod;
  String paymentMethodTitle;
  bool setPaid;
  String transactionId;
  List<LineItems> lineItems;

  int orderId;
  String orderNumber;
  String status;
  DateTime orderDate;
  Shipping shipping;

  OrderModel({
    this.customerId,
    this.paymentMethod,
    this.paymentMethodTitle,
    this.setPaid,
    this.transactionId,
    this.lineItems,
    this.orderId,
    this.orderNumber,
    this.status,
    this.orderDate,
  });

  OrderModel.fromJson(Map<String, dynamic> json) {
    customerId = json['customer_id'];
    orderId = json['id'];
    status = json['status'];
    orderNumber = json['order_key'];
    orderDate = DateTime.parse(json['date_created']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['customer_id'] = customerId;
    data['payment_method'] = paymentMethod;
    data['payment_method_title'] = paymentMethodTitle;
    data['set_paid'] = setPaid;
    data['transaction_id'] = transactionId;
    data['shipping'] = shipping.toJson();

    if (lineItems != null) {
      data['line_items'] = lineItems.map((v) => v.toJson()).toList();
    }

    return data;
  }
}

class LineItems {
  int productId;
  int quantity;
  int variationId;

  LineItems({this.productId, this.quantity, this.variationId});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['product_id'] = this.productId;
    data['quantity'] = this.quantity;
    if (this.variationId != null) {
      data['variation_id'] = this.variationId;
    }
    return data;
  }
}
