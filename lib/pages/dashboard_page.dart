import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';
import 'package:furniture_yourbrand_app/widgets/widget_home_categories.dart';
import 'package:furniture_yourbrand_app/widgets/widget_home_products.dart';

import '../config.dart';

class DashboardPage extends StatefulWidget {
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: ListView(
          children: [
            imageCarousel(context),
            WidgetCategories(),
            WidgetHomeProducts(
              labelName: "Top Savers Today!",
              tagId: Config.todayOffersTagId,
            ),
            WidgetHomeProducts(
              labelName: "Top Selling Products",
              tagId: Config.topSellingProductsTagId,
            )
          ],
        ),
      ),
    );
  }

  Widget imageCarousel(BuildContext context) {
    return new Container(
      width: MediaQuery.of(context).size.width,
      height: 200.0,
      child: new Carousel(
          overlayShadow: false,
          borderRadius: true,
          boxFit: BoxFit.none,
          autoplay: true,
          dotSize: 4.0,
          images: [
            FittedBox(
                fit: BoxFit.fill,
                child: Image.network(
                    "https://yourbrand.furnitureshops.in/wp-content/uploads/2021/04/KB-1.jpg")),
            FittedBox(
                fit: BoxFit.fill,
                child: Image.network(
                    "https://yourbrand.furnitureshops.in/wp-content/uploads/2021/04/2-seater-velvet.jpg")),
            FittedBox(
                fit: BoxFit.fill,
                child: Image.network(
                    "https://yourbrand.furnitureshops.in/wp-content/uploads/2021/04/black-leather-sofa-set-500x500-1.jpg")),
            FittedBox(
                fit: BoxFit.fill,
                child: Image.network(
                    "https://yourbrand.furnitureshops.in/wp-content/uploads/2021/03/furniture.jpg"))
          ]),
    );
  }
}
