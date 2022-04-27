import 'package:carousel_pro/carousel_pro.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:furniture_yourbrand_app/models/cart_request_model.dart';
import 'package:furniture_yourbrand_app/models/product.dart';
import 'package:furniture_yourbrand_app/models/variable_product.dart';
import 'package:furniture_yourbrand_app/provider/cart_provider.dart';
import 'package:furniture_yourbrand_app/provider/loader_provider.dart';
import 'package:furniture_yourbrand_app/utils/custom_stepper.dart';
import 'package:furniture_yourbrand_app/utils/expand_text.dart';
import 'package:furniture_yourbrand_app/widgets/widget_related_product.dart';
import 'package:provider/provider.dart';

class ProductDetailsWidget extends StatelessWidget {
  ProductDetailsWidget({Key key, this.data, this.variableProducts})
      : super(key: key);

  Product data;
  List<VariableProduct> variableProducts;

  CartProducts cartProducts = new CartProducts();

  final CarouselController _controller = CarouselController();

  @override
  Widget build(BuildContext context) {
    cartProducts.quantity = 0;
    return SingleChildScrollView(
        child: Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
      child: Stack(children: [
        Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              productImages(data.images, context),
              SizedBox(height: 10),
              Visibility(
                  visible: data.calculateDiscount() > 0,
                  child: Align(
                      alignment: Alignment.topLeft,
                      child: Container(
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(color: Colors.green),
                        child: Text(
                          '${data.calculateDiscount()}%OFF',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ))),
              SizedBox(height: 5),
              Text(
                data.name,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 25,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
              ),
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Visibility(
                      visible: data.type != "variable",
                      child: Text(
                        data.attributes != null && data.attributes.length > 0
                            ? (data.attributes[0].options.join("-").toString() +
                                "" +
                                data.attributes[0].name)
                            : "",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 15,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                    Visibility(
                      visible: data.type == "variable",
                      child: selectDropDown(context, "", this.variableProducts,
                          (VariableProduct value) {
                        this.data.price = value.price;
                        this.data.variableProduct = value;
                      }),
                    ),
                    Text(
                      'Rs.${data.price}',
                      style: TextStyle(
                          fontSize: 25,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    )
                  ]),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomStepper(
                    lowerLimit: 0,
                    upperLimit: 20,
                    stepValue: 1,
                    iconSize: 22.0,
                    value: this.cartProducts.quantity,
                    onChanged: (value) {
                      cartProducts.quantity = value;
                    },
                  ),
                  FlatButton(
                    child: Text(
                      "Add to Cart",
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () {
                      Provider.of<LoaderProvider>(context, listen: false)
                          .setLoadingStatus(true);

                      var cartProvider =
                          Provider.of<CartProvider>(context, listen: false);

                      cartProducts.productId = data.id;
                      cartProducts.variationId = data.variableProduct != null
                          ? data.variableProduct.id
                          : 0;

                      cartProvider.addtoCart(
                        cartProducts,
                        (val) {
                          Provider.of<LoaderProvider>(context, listen: false)
                              .setLoadingStatus(false);
                          print(val);
                        },
                      );
                    },
                    color: Colors.redAccent,
                    padding: EdgeInsets.all(15),
                    shape: StadiumBorder(),
                  )
                ],
              ),
              SizedBox(height: 5),
              ExpandText(
                labelHeader: "Product Details",
                shortDesc: data.shortDescription,
                desc: data.description,
              ),
              Divider(),
              SizedBox(height: 10),
              WidgetRelatedProducts(
                  labelName: "Related Products",
                  products: this.data.relatedIds),
            ]),
      ]),
    ));
  }

  Widget productImages(List<Images> images, BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: 250,
      child: Stack(
        children: [
          Container(
            alignment: Alignment.center,
            child: CarouselSlider.builder(
              itemCount: images.length,
              itemBuilder: (BuildContext context, int index, int) {
                return Container(
                  child: Center(
                    child: Image.network(
                      images[index].src,
                      fit: BoxFit.fill,
                    ),
                  ),
                );
              },
              options: CarouselOptions(
                  autoPlay: false,
                  enlargeCenterPage: true,
                  viewportFraction: 1,
                  aspectRatio: 1.0),
              carouselController: _controller,
            ),
          ),
          Positioned(
            top: 100,
            child: IconButton(
              icon: Icon(Icons.arrow_back_ios),
              onPressed: () {
                _controller.previousPage();
              },
            ),
          ),
          Positioned(
            top: 100,
            left: MediaQuery.of(context).size.width - 80,
            child: IconButton(
              icon: Icon(Icons.arrow_forward_ios),
              onPressed: () {
                _controller.nextPage();
              },
            ),
          ),
        ],
      ),
    );
  }

  static Widget selectDropDown(
    BuildContext context,
    Object initialValue,
    dynamic data,
    Function onChanged, {
    Function onValidate,
  }) {
    return Align(
      alignment: Alignment.topLeft,
      child: Container(
        height: 75,
        width: 100,
        padding: EdgeInsets.only(top: 5),
        child: new DropdownButtonFormField<VariableProduct>(
          hint: new Text("Select"),
          value: null,
          isDense: true,
          decoration: fieldDecoration(context, "", ""),
          onChanged: (VariableProduct newValue) {
            FocusScope.of(context).requestFocus(new FocusNode());
            onChanged(newValue);
          },
          items: data != null
              ? data.map<DropdownMenuItem<VariableProduct>>(
                  (VariableProduct data) {
                    return DropdownMenuItem<VariableProduct>(
                      value: data,
                      child: new Text(
                        data.attributes.first.option +
                            " " +
                            data.attributes.first.name,
                        style: new TextStyle(color: Colors.black),
                      ),
                    );
                  },
                ).toList()
              : null,
        ),
      ),
    );
  }

  static InputDecoration fieldDecoration(
    BuildContext context,
    String hintText,
    String helperText, {
    Widget prefixIcon,
    Widget suffixIcon,
  }) {
    return InputDecoration(
      contentPadding: EdgeInsets.all(6),
      hintText: hintText,
      helperText: helperText,
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: Theme.of(context).primaryColor,
          width: 1,
        ),
      ),
      border: OutlineInputBorder(
        borderSide: BorderSide(
          color: Theme.of(context).primaryColor,
          width: 1,
        ),
      ),
    );
  }
}
