import 'package:flutter/material.dart';
import 'package:furniture_yourbrand_app/models/order.dart';
import 'package:furniture_yourbrand_app/pages/base_page.dart';
import 'package:furniture_yourbrand_app/provider/order_provider.dart';
import 'package:furniture_yourbrand_app/widgets/widget_order_item.dart';
import 'package:provider/provider.dart';

class OrdersPage extends BasePage {
  @override
  _OrdersPageState createState() => _OrdersPageState();
}

class _OrdersPageState extends BasePageState<OrdersPage> {
  @override
  void initState() {
    super.initState();
    var ordersList = Provider.of<OrderProvider>(context, listen: false);
    ordersList.fetchOrders();
  }

  @override
  Widget pageUI() {
    return new Consumer<OrderProvider>(builder: (
      context,
      ordersModel,
      child,
    ) {
      if (ordersModel.allOrders != null && ordersModel.allOrders.length > 0) {
        return _listView(context, ordersModel.allOrders);
      }
      return Center(
        child: CircularProgressIndicator(),
      );
    });
  }

  Widget _listView(BuildContext context, List<OrderModel> orders) {
    return ListView(
      children: [
        ListView.builder(
            itemCount: orders.length,
            physics: ScrollPhysics(),
            padding: EdgeInsets.all(8),
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(16.0),
                ),
                child: WidgetOrderItem(orderModel: orders[index]),
              );
            })
      ],
    );
  }
}
