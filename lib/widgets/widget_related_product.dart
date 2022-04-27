import 'package:flutter/material.dart';
import 'package:furniture_yourbrand_app/api_service.dart';
import 'package:furniture_yourbrand_app/models/product.dart';

class WidgetRelatedProducts extends StatefulWidget {
  String labelName;
  List<int> products;

  WidgetRelatedProducts({
    this.labelName,
    this.products,
  });

  @override
  _WidgetRelatedProductsState createState() => _WidgetRelatedProductsState();
}

class _WidgetRelatedProductsState extends State<WidgetRelatedProducts> {
  APIService apiService;

  @override
  void initState() {
    super.initState();
    apiService = new APIService();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xffF4F7FA),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Padding(
                  padding: EdgeInsets.only(left: 16, top: 4),
                  child: Text(
                    this.widget.labelName,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  )),
              Padding(
                padding: EdgeInsets.only(left: 16, top: 4),
                child: TextButton(
                  onPressed: () {},
                  child: Text(
                    'View All',
                    style: TextStyle(color: Colors.redAccent),
                  ),
                ),
              ),
            ],
          ),
          _productsList(),
        ],
      ),
    );
  }

  Widget _productsList() {
    return new FutureBuilder(
      future: apiService.getProducts(productsIDs: this.widget.products),
      builder: (BuildContext context, AsyncSnapshot<List<Product>> model) {
        if (model.hasData) {
          return _buildList(model.data);
        }

        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  Widget _buildList(List<Product> items) {
    return Container(
        height: 200,
        alignment: Alignment.centerLeft,
        child: ListView.builder(
            shrinkWrap: true,
            physics: ClampingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            itemCount: items.length,
            itemBuilder: (context, index) {
              var data = items[index];
              return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.all(10),
                      width: 130,
                      height: 120,
                      alignment: Alignment.center,
                      child: Image.network(
                        data.images[0].src,
                        height: 120,
                      ),
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(4),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            offset: Offset(0, 5),
                            blurRadius: 15,
                          )
                        ],
                      ),
                    ),
                    Container(
                      width: 130,
                      alignment: Alignment.centerLeft,
                      child: Text(
                        data.name,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    Container(
                        margin: EdgeInsets.only(top: 4, left: 4),
                        width: 130,
                        alignment: Alignment.centerLeft,
                        child: Row(children: [
                          Text(
                            '₹${data.regularPrice}',
                            style: TextStyle(
                              fontSize: 14,
                              decoration: TextDecoration.lineThrough,
                              decorationColor: Colors.black,
                              decorationThickness: 2.0,
                              color: Colors.redAccent,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '₹${data.salePrice}',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ])),
                  ]);
            }));
  }
}
