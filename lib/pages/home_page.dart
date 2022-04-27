import 'package:flutter/material.dart';
import 'package:furniture_yourbrand_app/pages/cart_page.dart';
import 'package:furniture_yourbrand_app/pages/dashboard_page.dart';
import 'package:furniture_yourbrand_app/pages/my_account.dart';
import 'package:furniture_yourbrand_app/utils/cart_icons.dart';

class HomePage extends StatefulWidget {
  int selectedPage;
  HomePage({Key key, this.selectedPage}) : super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Widget> _widgetList = [
    DashboardPage(),
    CartPage(),
    DashboardPage(),
    MyAccount(),
  ];

  /* List<String> _titlelist = [
    "Furniture App",
    "My Cart",
    "My Favourites",
    "My Account",
  ]; */

  int _index = 0;

  @override
  void initState() {
    super.initState();

    if (this.widget.selectedPage != null) {
      _index = this.widget.selectedPage;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar() as PreferredSizeWidget,
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              CartIcons.store,
            ),
            label: 'Store',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              CartIcons.cart,
            ),
            label: 'My Cart',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              CartIcons.favourites,
            ),
            label: 'Favourites',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              CartIcons.account,
            ),
            label: 'My Account',
          ),
        ],
        selectedItemColor: Colors.redAccent,
        unselectedItemColor: Colors.black,
        type: BottomNavigationBarType.shifting,
        currentIndex: _index,
        onTap: (index) {
          setState(() {
            _index = index;
          });
        },
      ),
      body: _widgetList[_index],
    );
  }

  Widget _buildAppBar() {
    return AppBar(
      centerTitle: true,
      brightness: Brightness.dark,
      elevation: 0,
      backgroundColor: Colors.redAccent,
      automaticallyImplyLeading: false,
      title: Text("Furniture Shop", style: TextStyle(color: Colors.white)),
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
            //Navigator.push(
            //  context,
            //  MaterialPageRoute(builder: (context) => LoginPage()),
            //);
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
          onPressed: () {
            //Navigator.push(
            //  context,
            //  MaterialPageRoute(builder: (context) => SignupPage()),
            //);
          },
        ),
        SizedBox(
          width: 2,
        ),
      ],
    );
  }
}
