import 'package:flutter/material.dart';
import 'package:furniture_yourbrand_app/api_service.dart';
import 'package:furniture_yourbrand_app/config.dart';
import 'package:furniture_yourbrand_app/models/order_detail.dart';
import 'package:furniture_yourbrand_app/pages/base_page.dart';
import 'package:furniture_yourbrand_app/utils/widget_checkpoints.dart';

class OrderDetailsPage extends BasePage {
  int orderID;
  OrderDetailsPage({Key key, this.orderID}) : super(key: key);
  @override
  _OrderDetailsPageState createState() => _OrderDetailsPageState();
}

class _OrderDetailsPageState extends BasePageState<OrderDetailsPage> {
  APIService apiService;
  @override
  void initState() {
    super.initState();
    apiService = new APIService();
  }

  @override
  Widget pageUI() {
    return new FutureBuilder(
      future: apiService.getOrderDetails(this.widget.orderID),
      builder: (
        BuildContext context,
        AsyncSnapshot<OrderDetailModel> orderDetailModel,
      ) {
        if (orderDetailModel.hasData) {
          return orderDetailUI(orderDetailModel.data);
        }

        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  Widget orderDetailUI(OrderDetailModel model) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "#${model.orderId.toString()}",
            style: Theme.of(context).textTheme.labelHeading,
          ),
          Text(
            model.orderDate.toString(),
            style: Theme.of(context).textTheme.labelText,
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            "Delivered To",
            style: Theme.of(context).textTheme.labelHeading,
          ),
          Text(
            model.shipping.address1,
            style: Theme.of(context).textTheme.labelText,
          ),
          Text(
            model.shipping.address2,
            style: Theme.of(context).textTheme.labelText,
          ),
          Text(
            "${model.shipping.city}, ${model.shipping.state}",
            style: Theme.of(context).textTheme.labelText,
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            "Payment Method",
            style: Theme.of(context).textTheme.labelHeading,
          ),
          Text(
            model.paymentMethod,
            style: Theme.of(context).textTheme.labelText,
          ),
          Divider(
            color: Colors.grey,
          ),
          SizedBox(
            height: 5,
          ),
          CheckPoints(
            checkedTill: 0,
            checkPoints: ["Processing", "Shipping", "Delivered"],
            checkPointFilledColor: Colors.redAccent,
          ),
          Divider(
            color: Colors.grey,
          ),
          _listOrderItems(model),
          Divider(
            color: Colors.grey,
          ),
          _itemTotal(
            "Item Total",
            "${model.itemTotalAmount}",
            textStyle: Theme.of(context).textTheme.itemTotalText,
          ),
          _itemTotal(
            "Shipping Charges",
            "${model.shippingTotal}",
            textStyle: Theme.of(context).textTheme.itemTotalText,
          ),
          _itemTotal(
            "Paid",
            "${model.totalAmount}",
            textStyle: Theme.of(context).textTheme.itemTotalPaidText,
          ),
        ],
      ),
    );
  }

  Widget _listOrderItems(OrderDetailModel model) {
    return ListView.builder(
      itemCount: model.lineItems.length,
      physics: ScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return _productItems(
          model.lineItems[index],
        );
      },
    );
  }

  Widget _productItems(LineItems product) {
    return ListTile(
      dense: true,
      contentPadding: EdgeInsets.all(2),
      onTap: () {},
      title: new Text(
        product.productName,
        style: Theme.of(context).textTheme.productItemText,
      ),
      subtitle: Padding(
        padding: EdgeInsets.all(1),
        child: new Text("Qty:${product.quantity}"),
      ),
      trailing: new Text("${Config.currency} ${product.totalAmount}"),
    );
  }

  Widget _itemTotal(String label, String value, {TextStyle textStyle}) {
    return ListTile(
      dense: true,
      visualDensity: VisualDensity(horizontal: 0, vertical: -4),
      contentPadding: EdgeInsets.fromLTRB(2, -10, 2, -10),
      title: new Text(
        label,
        style: textStyle,
      ),
      trailing: new Text("${Config.currency}$value"),
    );
  }
}

extension CustomStyles on TextTheme {
  TextStyle get labelHeading {
    return TextStyle(
      fontSize: 16,
      color: Colors.redAccent,
      fontWeight: FontWeight.bold,
    );
  }

  TextStyle get labelText {
    return TextStyle(
      fontSize: 14,
      color: Colors.black,
      fontWeight: FontWeight.bold,
    );
  }

  TextStyle get productItemText {
    return TextStyle(
      fontSize: 14,
      color: Colors.redAccent,
      fontWeight: FontWeight.w700,
    );
  }

  TextStyle get itemTotalText {
    return TextStyle(
      fontSize: 14,
      color: Colors.black,
    );
  }

  TextStyle get itemTotalPaidText {
    return TextStyle(
      fontSize: 16.0,
      color: Colors.black,
      fontWeight: FontWeight.bold,
    );
  }
}
