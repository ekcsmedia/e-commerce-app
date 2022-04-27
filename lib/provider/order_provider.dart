import 'package:flutter/foundation.dart';
import 'package:furniture_yourbrand_app/api_service.dart';
import 'package:furniture_yourbrand_app/models/order.dart';

class OrderProvider with ChangeNotifier {
  APIService _apiService;

  List<OrderModel> _orderList;
  List<OrderModel> get allOrders => _orderList;
  double get totalRecords => _orderList.length.toDouble();

  OrderProvider() {
    resetStreams();
  }

  void resetStreams() {
    _apiService = APIService();
  }

  fetchOrders() async {
    List<OrderModel> orderList = await _apiService.getOrders();

    if (_orderList == null) {
      _orderList = [];
    }

    if (orderList.length > 0) {
      _orderList = [];
      _orderList.addAll(orderList);
    }
    notifyListeners();
  }
}
