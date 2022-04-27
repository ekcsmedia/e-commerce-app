import 'package:flutter/material.dart';
import 'package:furniture_yourbrand_app/models/login_model.dart';
import 'package:furniture_yourbrand_app/pages/orders_page.dart';
import 'package:furniture_yourbrand_app/shared_service.dart';
import 'package:furniture_yourbrand_app/utils/cart_icons.dart';
import 'package:furniture_yourbrand_app/widgets/unauth_widget.dart';

class MyAccount extends StatefulWidget {
  @override
  _MyAccountState createState() => _MyAccountState();
}

class OptionList {
  String optionTitle;
  String optionSubTitle;
  IconData optionIcon;
  Function onTap;

  OptionList(
      {this.optionIcon, this.optionTitle, this.optionSubTitle, this.onTap});
}

class _MyAccountState extends State<MyAccount> {
  List<OptionList> options = [];

  @override
  void initState() {
    super.initState();
    options.add(new OptionList(
        optionIcon: CartIcons.cart,
        optionTitle: "Orders",
        optionSubTitle: "Check my orders",
        onTap: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => OrdersPage()));
        }));

    options.add(new OptionList(
        optionIcon: Icons.edit,
        optionTitle: "Edit Profile",
        optionSubTitle: "Update your profile",
        onTap: () {}));

    options.add(new OptionList(
        optionIcon: Icons.notifications,
        optionTitle: "Notifications",
        optionSubTitle: "Check the latest notifications",
        onTap: () {}));

    options.add(new OptionList(
        optionIcon: Icons.power_settings_new,
        optionTitle: "Sign Out",
        optionSubTitle: "Check the latest notifications",
        onTap: () {
          SharedService.logout().then((value) => {setState(() {})});
        }));
  }

  @override
  Widget build(BuildContext context) {
    return new FutureBuilder(
      future: SharedService.isLoggedIn(),
      builder: (
        BuildContext context,
        AsyncSnapshot<bool> loginModel,
      ) {
        if (loginModel.hasData) {
          if (loginModel.data) {
            return _listView(context);
          } else {
            return UnAuthWidget();
          }
        }
      },
    );
  }

  Widget _buildRow(OptionList optionList, int index) {
    return new Padding(
      padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
      child: ListTile(
        leading: Container(
          padding: EdgeInsets.all(10),
          child: Icon(
            optionList.optionIcon,
            size: 30,
          ),
        ),
        onTap: () {
          return optionList.onTap();
        },
        title: new Text(
          optionList.optionTitle,
          style: new TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Padding(
          padding: EdgeInsets.only(top: 5),
          child: Text(
            optionList.optionSubTitle,
            style: new TextStyle(
              color: Colors.redAccent,
              fontSize: 14,
            ),
          ),
        ),
        trailing: Icon(Icons.keyboard_arrow_right),
      ),
    );
  }

  Widget _listView(BuildContext context) {
    return new FutureBuilder(
      future: SharedService.loginDetails(),
      builder:
          (BuildContext context, AsyncSnapshot<LoginResponseModel> loginModel) {
        if (loginModel.hasData) {
          return ListView(
            children: [
              Container(
                margin: EdgeInsets.fromLTRB(15, 15, 0, 0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Welcome, ${loginModel.data.data.displayName}",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  ],
                ),
              ),
              ListView.builder(
                itemCount: options.length,
                physics: ScrollPhysics(),
                padding: EdgeInsets.all(8.0),
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 0,
                    shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(16.0),
                    ),
                    child: _buildRow(options[index], index),
                  );
                },
              )
            ],
          );
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
