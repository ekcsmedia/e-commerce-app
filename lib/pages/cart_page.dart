import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:furniture_yourbrand_app/pages/verify_address.dart';
import 'package:furniture_yourbrand_app/provider/cart_provider.dart';
import 'package:furniture_yourbrand_app/provider/loader_provider.dart';
import 'package:furniture_yourbrand_app/shared_service.dart';
import 'package:furniture_yourbrand_app/utils/ProgressHUD.dart';
import 'package:furniture_yourbrand_app/widgets/unauth_widget.dart';
import 'package:furniture_yourbrand_app/widgets/widget_cart_product.dart';
import 'package:provider/provider.dart';

class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    var productsList = Provider.of<CartProvider>(context, listen: false);
    productsList.resetStreams();
    productsList.fetchCartItems();
  }

  @override
  Widget build(BuildContext context) {
    return new FutureBuilder(
      future: SharedService.isLoggedIn(),
      builder: (BuildContext context, AsyncSnapshot<bool> loginModel) {
        if (loginModel.hasData) {
          if (loginModel.data) {
            return Consumer<LoaderProvider>(
              builder: (context, loaderModel, child) {
                return Scaffold(
                  key: scaffoldKey,
                  body: ProgressHUD(
                    child: _productsList(),
                    inAsyncCall: loaderModel.isApiCallProcess,
                    opacity: 0.3,
                  ),
                );
              },
            );
          } else {
            return UnAuthWidget();
          }
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
//    return Consumer<LoaderProvider>(builder: (context, loaderModel, child) {
  //    return Scaffold(
  //      body: ProgressHUD(
  //  child: _productsList(),
  //inAsyncCall: loaderModel.isApiCallProcess,
  //opacity: 0.3,
  //));
  // }
  // return CartProduct(
  //   data: new CartItem(
  //     productId: 1,
  //     productName: "Bed",
  //     thumbnail:
  //         "https://yourbrand.furnitureshops.in/wp-content/uploads/2021/04/king-size-bed-1-300x300.jpg",
  //     productRegularPrice: "50",
  //     productSalePrice: "40",
  //     qty: 10,
  //   ),
  // );

  Widget _productsList() {
    return new Consumer<CartProvider>(builder: (context, cartModel, child) {
      if (cartModel.cartItems != null && cartModel.cartItems.length > 0) {
        return SingleChildScrollView(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                ListView.builder(
                  padding: EdgeInsets.all(5),
                  shrinkWrap: true,
                  physics: ClampingScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  itemCount: cartModel.cartItems.length,
                  itemBuilder: (context, index) {
                    return CartProduct(data: cartModel.cartItems[index]);
                  },
                ),
                Padding(
                    padding: EdgeInsets.all(10),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: FlatButton(
                        child: Wrap(
                          alignment: WrapAlignment.center,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            Icon(
                              Icons.sync,
                              color: Colors.white,
                            ),
                            Text(
                              "Update Cart",
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                        onPressed: () {
                          Provider.of<LoaderProvider>(context, listen: false)
                              .setLoadingStatus(true);
                          var cartProvider =
                              Provider.of<CartProvider>(context, listen: false);
                          cartProvider.updateCart(
                            (val) {
                              Provider.of<LoaderProvider>(context,
                                      listen: false)
                                  .setLoadingStatus(false);
                            },
                          );
                        },
                        padding: EdgeInsets.all(15),
                        color: Colors.green,
                        shape: StadiumBorder(),
                      ),
                    )),
              ],
            ),
            Container(
              color: Colors.white,
              width: MediaQuery.of(context).size.width,
              height: 100,
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        new Text(
                          "Total",
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w400),
                        ),
                        new Text(
                          "₹${cartModel.totalAmount}",
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    FlatButton(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'Checkout',
                            style: TextStyle(color: Colors.white),
                          ),
                          Icon(
                            Icons.chevron_right,
                            color: Colors.white,
                          )
                        ],
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => VerifyAddress(),
                          ),
                        );
                      },
                      padding: EdgeInsets.all(15),
                      color: Colors.redAccent,
                      shape: StadiumBorder(),
                    ),
                  ],
                ),
              ),
            )
          ],
        ));
      } else {
        return Scaffold(
          body: Center(
            child: Text(
              'Loading.... If not loading check your cart, it might be empty',
              textAlign: TextAlign.center,
            ),
          ),
        );
      }
    });
  }
}
