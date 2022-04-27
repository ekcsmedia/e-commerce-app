import 'package:flutter/material.dart';
import 'package:furniture_yourbrand_app/pages/login_page.dart';
import 'package:furniture_yourbrand_app/provider/cart_provider.dart';
import 'package:furniture_yourbrand_app/provider/loader_provider.dart';
import 'package:furniture_yourbrand_app/utils/ProgressHUD.dart';
import 'package:provider/provider.dart';

class BasePage extends StatefulWidget {
  BasePage({Key key}) : super(key: key);
  @override
  BasePageState createState() => BasePageState();
}

class BasePageState<T extends BasePage> extends State<T> {
  bool isApiCallProcess = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LoaderProvider>(builder: (context, loaderModel, child) {
      return Scaffold(
        appBar: _buildAppBar() as PreferredSizeWidget,
        body: ProgressHUD(
          child: pageUI(),
          inAsyncCall: loaderModel.isApiCallProcess,
          opacity: 0.3,
        ),
      );
    });
  }

  Widget pageUI() {
    return null;
  }

  Widget _buildAppBar() {
    return AppBar(
      centerTitle: true,
      brightness: Brightness.dark,
      elevation: 0,
      backgroundColor: Colors.redAccent,
      automaticallyImplyLeading: true,
      title: Text("Furniture Shop App", style: TextStyle(color: Colors.white)),
      actions: <Widget>[
        SizedBox(
          width: 20,
        ),
        IconButton(
          icon: Icon(
            Icons.notifications_none,
            color: Colors.white,
          ),
          onPressed: () {
            /* 
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => LoginPage()),
            ); */
          },
        ),
        SizedBox(
          width: 2,
        ),
        IconButton(
          icon: Icon(
            Icons.shopping_cart,
            color: Colors.white,
          ),
          onPressed: null,
        ),
        Provider.of<CartProvider>(context, listen: false).cartItems.length == 0
            ? new Container()
            : new Positioned(
                child: new Stack(
                children: <Widget>[
                  new Icon(
                    Icons.brightness_1,
                    size: 20.0,
                    color: Colors.green[800],
                  ),
                  new Positioned(
                    top: 4.0,
                    right: 4.0,
                    child: new Center(
                      child: new Text(
                        Provider.of<CartProvider>(context, listen: false)
                            .cartItems
                            .length
                            .toString(),
                        style: new TextStyle(
                          color: Colors.white,
                          fontSize: 11.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  )
                ],
              ))
      ],
    );
  }

}
