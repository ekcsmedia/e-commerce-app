// @dart=2.9

import 'package:flutter/material.dart';
import 'package:furniture_yourbrand_app/pages/base_page.dart';
import 'package:furniture_yourbrand_app/pages/home_page.dart';
import 'package:furniture_yourbrand_app/pages/orders_page.dart';
import 'package:furniture_yourbrand_app/pages/paypal_payment.dart';
import 'package:furniture_yourbrand_app/pages/product_details.dart';
import 'package:furniture_yourbrand_app/pages/product_page.dart';
import 'package:furniture_yourbrand_app/provider/cart_provider.dart';
import 'package:furniture_yourbrand_app/provider/loader_provider.dart';
import 'package:furniture_yourbrand_app/provider/order_provider.dart';
import 'package:furniture_yourbrand_app/provider/products_provider.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => ProductsProvider(),
          child: ProductPage(),
        ),
        ChangeNotifierProvider(
          create: (context) => CartProvider(),
          child: ProductDetails(),
        ),
        ChangeNotifierProvider(
          create: (context) => LoaderProvider(),
          child: BasePage(),
        ),
        ChangeNotifierProvider(
          create: (context) => OrderProvider(),
          child: OrdersPage(),
        )
      ],
      child: MaterialApp(
        title: 'WooCommerce App',
        debugShowCheckedModeBanner: false,
        home: HomePage(),
        routes: <String, WidgetBuilder>{
          "/PayPal": (BuildContext context) => new PaypalPaymentScreen()
        },
        theme: ThemeData(
          fontFamily: 'ProductSans',
          primaryColor: Colors.white,
          floatingActionButtonTheme: FloatingActionButtonThemeData(
            elevation: 0,
            foregroundColor: Colors.white,
          ),
          brightness: Brightness.light,
          accentColor: Colors.redAccent,
          dividerColor: Colors.redAccent,
          hintColor: Colors.redAccent,
          focusColor: Colors.redAccent,
          textTheme: TextTheme(
            headline1: TextStyle(fontSize: 22.0, color: Colors.redAccent),
            headline2: TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.w700,
              color: Colors.redAccent,
            ),
            headline4: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.w700,
                color: Colors.redAccent,
                height: 1.3),
            headline3: TextStyle(
                fontSize: 22.0,
                fontWeight: FontWeight.bold,
                color: Colors.black,
                height: 1.3),
            subtitle1: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.w500,
                color: Colors.black,
                height: 1.3),
            caption: TextStyle(
                fontSize: 14.0,
                fontWeight: FontWeight.w300,
                color: Colors.grey,
                height: 1.2),
            bodyText1: TextStyle(
              fontSize: 14.0,
              fontWeight: FontWeight.w400,
              color: Colors.blueAccent,
            ),
          ),
        ),
      ),
    );
  }
}
