import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:furniture_yourbrand_app/pages/checkout_base.dart';
import 'package:furniture_yourbrand_app/pages/home_page.dart';
import 'package:furniture_yourbrand_app/pages/login_page.dart';
import 'package:furniture_yourbrand_app/provider/cart_provider.dart';
import 'package:provider/provider.dart';

class UnAuthWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<CartProvider>(
      builder: (context, orderModel, child) {
        if (orderModel.isOrderCreated) {
          return Center(
            child: Container(
              margin: EdgeInsets.only(top: 100),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Stack(
                    children: <Widget>[
                      Container(
                        width: 150,
                        height: 150,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            begin: Alignment.bottomLeft,
                            end: Alignment.topRight,
                            colors: [
                              Colors.green.withOpacity(1),
                              Colors.green.withOpacity(0.2),
                            ],
                          ),
                        ),
                        child: Icon(
                          Icons.lock,
                          color: Colors.white,
                          size: 90,
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 15),
                  Opacity(
                    opacity: 0.6,
                    child: Text(
                      "You must sign-in to access to this section",
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headline3,
                    ),
                  ),
                  SizedBox(height: 20),
                  FlatButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LoginPage(),
                        ),
                      );
                    },
                    child: Text(
                      "Login",
                      style: TextStyle(color: Colors.white),
                    ),
                    padding: EdgeInsets.all(15),
                    color: Colors.green,
                  ),
                ],
              ),
            ),
          );
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
