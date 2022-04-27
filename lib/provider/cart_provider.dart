import 'package:flutter/material.dart';
import 'package:furniture_yourbrand_app/api_service.dart';
import 'package:furniture_yourbrand_app/models/cart_request_model.dart';
import 'package:furniture_yourbrand_app/models/cart_response_model.dart';
import 'package:furniture_yourbrand_app/models/customer_detail_model.dart';
import 'package:furniture_yourbrand_app/models/order.dart';
import 'package:furniture_yourbrand_app/shared_service.dart';

class CartProvider with ChangeNotifier {
  APIService _apiService;
  List<CartItem> _cartItems;
  CustomerDetailsModel _customerDetailsModel;
  OrderModel _orderModel;
  bool _isOrderCreated = false;

  List<CartItem> get cartItems => _cartItems;
  double get totalRecords => _cartItems.length.toDouble();
  double get totalAmount => _cartItems != null
      ? _cartItems.map<double>((m) => m.lineSubtotal).reduce((a, b) => a + b)
      : 0;

  CustomerDetailsModel get customerDetailsModel => _customerDetailsModel;
  OrderModel get orderModel => _orderModel;
  bool get isOrderCreated => _isOrderCreated;

  CartProvider() {
    _apiService = new APIService();
    _cartItems = [];
  }

  void resetStreams() {
    _apiService = new APIService();
    _cartItems = [];
  }

  void addtoCart(
    CartProducts product,
    Function onCallback,
  ) async {
    CartRequestModel requestModel = new CartRequestModel();
    requestModel.products = [];

    if (_cartItems == null) {
      await fetchCartItems();
    }

    _cartItems.forEach((element) {
      requestModel.products.add(new CartProducts(
          productId: element.productId, quantity: element.qty));
    });

    var isProductExist = requestModel.products.firstWhere(
      (prd) =>
          prd.productId == product.productId &&
          prd.variationId == product.variationId,
      orElse: () => null,
    );

    if (isProductExist != null) {
      requestModel.products.remove(isProductExist);
    }

    requestModel.products.add(product);

    await _apiService.addtoCart(requestModel).then((cartResponseModel) {
      if (cartResponseModel.data != null) {
        _cartItems = [];
        _cartItems.addAll(cartResponseModel.data);
      }
      onCallback(cartResponseModel);
      notifyListeners();
    });
  }

  fetchCartItems() async {
    bool isLoggedIn = await SharedService.isLoggedIn();
    if (_cartItems == null) resetStreams();

    if (isLoggedIn) {
      await _apiService.getCartItems().then((cartResponseModel) {
        if (cartResponseModel.data != null) {
          _cartItems.clear();
          _cartItems.addAll(cartResponseModel.data);
        }

        notifyListeners();
      });
    }
  }

  void updateQty(int productId, int qty, {int variationId = 0}) {
    var isProductExist = _cartItems.firstWhere(
        (prd) => prd.productId == productId && prd.variationId == variationId,
        orElse: () => null);

    if (isProductExist != null) {
      isProductExist.qty = qty;
    }

    notifyListeners();
  }

  void updateCart(Function onCallback) async {
    CartRequestModel requestModel = new CartRequestModel();
    requestModel.products = [];

    //if (_cartItems == null) resetStreams();

    _cartItems.forEach((v) {
      requestModel.products.add(new CartProducts(
        productId: v.productId,
        quantity: v.qty,
        variationId: v.variationId,
      ));
    });

    await _apiService.addtoCart(requestModel).then((cartResponseModel) {
      if (cartResponseModel.data != null) {
        _cartItems = [];
        _cartItems.addAll(cartResponseModel.data);
      }
      onCallback(cartResponseModel);
      notifyListeners();
    });
  }

  void removeItem(int productId) {
    var isProductExist = _cartItems
        .firstWhere((prd) => prd.productId == productId, orElse: () => null);

    if (isProductExist != null) {
      _cartItems.remove(isProductExist);
    }

    notifyListeners();
  }

  fetchShippingDetails() async {
    if (_customerDetailsModel == null) {
      _customerDetailsModel = new CustomerDetailsModel();
    }

    _customerDetailsModel = await _apiService.customerDetails();
    notifyListeners();
  }

  processOrder(OrderModel orderModel) {
    this._orderModel = orderModel;
    notifyListeners();
  }

  void createOrder() async {
    if (orderModel.shipping == null) {
      _orderModel.shipping = new Shipping();
    }

    if (this.customerDetailsModel.shipping != null) {
      _orderModel.shipping = this.customerDetailsModel.shipping;
    }

    if (orderModel.lineItems == null) {
      _orderModel.lineItems = [];
    }

    _cartItems.forEach((v) {
      _orderModel.lineItems.add(
        new LineItems(
          productId: v.productId,
          quantity: v.qty,
          variationId: v.variationId,
        ),
      );
    });
    await _apiService.createOrder(orderModel).then((value) {
      if (value) {
        _isOrderCreated = true;
        notifyListeners();
      }
    });
  }
}
