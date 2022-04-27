import 'package:flutter/material.dart';
import 'package:furniture_yourbrand_app/api_service.dart';
import 'package:furniture_yourbrand_app/models/login_model.dart';
import 'package:furniture_yourbrand_app/models/product.dart';
import 'package:furniture_yourbrand_app/models/variable_product.dart';
import 'package:furniture_yourbrand_app/pages/base_page.dart';
import 'package:furniture_yourbrand_app/widgets/widget_product_details.dart';

class ProductDetails extends BasePage {
  ProductDetails({Key key, this.product}) : super(key: key);

  Product product;
  @override
  _ProductDetailsState createState() => _ProductDetailsState();
}

class _ProductDetailsState extends BasePageState<ProductDetails> {
  APIService apiService;
  @override
  Widget pageUI() {
    return this.widget.product.type == "variable"
        ? _variableProductList()
        : ProductDetailsWidget(data: this.widget.product);
  }

  Widget _variableProductList() {
    apiService = new APIService();
    return new FutureBuilder(
      future: apiService.getVariableProducts(this.widget.product.id),
      builder:
          (BuildContext context, AsyncSnapshot<List<VariableProduct>> model) {
        if (model.hasData) {
          return ProductDetailsWidget(
            data: this.widget.product,
            variableProducts: model.data,
          );
        }

        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
