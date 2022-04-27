import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:furniture_yourbrand_app/provider/paypal_services.dart';

class PaypalPaymentScreen extends StatefulWidget {
  @override
  _PaypalPaymentScreenState createState() => _PaypalPaymentScreenState();
}

class _PaypalPaymentScreenState extends State<PaypalPaymentScreen> {
  InAppWebViewController webView;
  String url = "";
  double progress = 0;
  GlobalKey<ScaffoldState> scaffoldkey;

  String checkoutURL;
  String executeURL;
  String accessToken;

  PaypalServices paypalServices;
  @override
  void initState() {
    super.initState();
    paypalServices = new PaypalServices();
    this.scaffoldkey = new GlobalKey<ScaffoldState>();

    Future.delayed(Duration.zero, () async {
      try {
        accessToken = await paypalServices.getAccessToken();

        final transactions = paypalServices.getOrderParams(context);
        final res =
            await paypalServices.createPaypalPayment(transactions, accessToken);

        if (res != null) {
          setState(() {
            checkoutURL = res["approvalUrl"];
            executeURL = res["executeUrl"];
          });
        }
      } catch (e) {
        print('Exception: ' + e.toString());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (checkoutURL != null) {
      return Scaffold(
        key: scaffoldkey,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          title: Text(
            "Paypal Payment",
            style: Theme.of(context).textTheme.headline6.merge(
                  TextStyle(
                    letterSpacing: 1.3,
                  ),
                ),
          ),
        ),
        body: Stack(
          children: [
            InAppWebView(
              initialUrl: checkoutURL,
              initialOptions: new InAppWebViewGroupOptions(
                android: AndroidInAppWebViewOptions(
                  textZoom: 120,
                ),
              ),
              onWebViewCreated: (InAppWebViewController controller) {
                webView = controller;
              },
              onLoadStart:
                  (InAppWebViewController controller, String requestURL) async {
                if (requestURL.contains(paypalServices.returnURL)) {
                  final uri = Uri.parse(requestURL);
                  final payerId = uri.queryParameters['PayerID'];
                  if (payerId != null) {
                    await paypalServices
                        .executePayment(executeURL, payerId, accessToken)
                        .then(
                      (id) {
                        print(id);
                        Navigator.of(context).pop();
                      },
                    );
                  } else {
                    Navigator.of(context).pop();
                  }
                  Navigator.of(context).pop();
                }
                if (requestURL.contains(paypalServices.cancelURL)) {
                  Navigator.of(context).pop();
                }
              },
              onProgressChanged:
                  (InAppWebViewController controller, int progress) {
                setState(() {
                  this.progress = progress / 100;
                });
              },
            ),
            progress < 1
                ? SizedBox(
                    height: 3,
                    child: LinearProgressIndicator(
                      value: progress,
                      backgroundColor:
                          Theme.of(context).accentColor.withOpacity(0.2),
                    ),
                  )
                : SizedBox()
          ],
        ),
      );
    } else {
      return Scaffold(
        key: scaffoldkey,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          title: Text(
            "Paypal Payment",
            style: Theme.of(context).textTheme.headline6.merge(
                  TextStyle(
                    letterSpacing: 1.3,
                  ),
                ),
          ),
        ),
        body: Center(
          child: Container(
            child: CircularProgressIndicator(),
          ),
        ),
      );
    }
  }
}
