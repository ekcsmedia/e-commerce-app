import 'package:flutter/material.dart';
import 'package:furniture_yourbrand_app/models/product.dart';
import 'package:furniture_yourbrand_app/pages/product_details.dart';

class ProductCard extends StatelessWidget {
  ProductCard({Key key, this.data}) : super(key: key);

  final Product data;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProductDetails(
                product: data,
              ),
            ),
          );
        },
        child: Container(
          decoration: BoxDecoration(
            color: Color(0XFFFFFFFF),
            borderRadius: BorderRadius.all(Radius.circular(20)),
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: Color(0xfff8f8f8), blurRadius: 15, spreadRadius: 10),
            ],
          ),
          margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          child: Container(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              child: Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  Visibility(
                    visible: data.calculateDiscount() > 0,
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Container(
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: Text(
                          '${data.calculateDiscount()}%OFF',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Flexible(
                        child: Stack(
                          alignment: Alignment.center,
                          children: <Widget>[
                            CircleAvatar(
                              radius: 30,
                              backgroundColor: Color(0xffE65829).withAlpha(40),
                            ),
                            Image.network(
                              data.images.length > 0
                                  ? data.images[0].src
                                  : "https://yourbrand.furnitureshops.in/wp-content/uploads/2021/04/bar-cabinet.jpg",
                              height: 160,
                            )
                          ],
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        data.name,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Visibility(
                            visible: data.salePrice != data.regularPrice,
                            child: Text(
                              'Rs.${data.regularPrice}',
                              style: TextStyle(
                                fontSize: 14,
                                decoration: TextDecoration.lineThrough,
                                color: Colors.redAccent,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Text(
                            'Rs.${data.salePrice}',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  )
                ],
              )),
        ));
  }
}
