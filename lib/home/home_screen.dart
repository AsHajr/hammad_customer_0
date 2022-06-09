import 'package:flutter/material.dart';
import 'package:hammad_customer_0/Loading/loading_screen.dart';
import 'package:hammad_customer_0/models/user_model.dart';
import 'package:hammad_customer_0/order_screen/product_coupon_page.dart';
import 'package:hammad_customer_0/services/checkLanguage.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/googleMapApp.dart';
import 'components/main_page_body.dart';

class HomeScreen extends StatefulWidget {
  static String routeName = "/";

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  static List<String> pages = [
    '/',
    ProductCouponOrder.routeName,
    '/redeem',
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      Navigator.pushNamed(context, pages[index]);
    });
  }

  UserModel user;
  @override
  Widget build(BuildContext context) {
    user = Provider.of<UserModel>(context, listen: true);
    final textDirection = getTextDir(context);
    if (user != null) {
      return Directionality(
        textDirection: textDirection,
        child: Scaffold(
            drawer: BuildDrawer(),
            bottomNavigationBar: buildBottomNavigationBar(),
            appBar: buildAppBar(context),
            body: HomeScreenBody(
              user: user,
            )),
      );
    }
    return LoadingScreen();
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
        backgroundColor: Colors.orange[100],
        actions: <Widget>[
          IconButton(
              icon: const Icon(Icons.call_outlined),
              tooltip: 'Contact us',
              onPressed: () {
                launch("tel://+962798590055");
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text('Calling Hammad !')));
              }),
          IconButton(
            onPressed: () {
              MapUtils.openMap(32.0019135, 35.9557119);
            },
            icon: Icon(Icons.directions_outlined),
            color: Colors.black,
          ),
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, '/profile');
            },
            icon: Icon(Icons.settings_outlined),
            color: Colors.black,
          ),
        ],
        title: Text(
          'MyHammad',
          style: Theme.of(context).textTheme.headline2,
        ));
  }

  BottomNavigationBar buildBottomNavigationBar() {
    return BottomNavigationBar(
      onTap: _onItemTapped,
      currentIndex: _selectedIndex,
      elevation: 20,
      items: <BottomNavigationBarItem>[
        const BottomNavigationBarItem(
          icon: Icon(Icons.explore),
          label: 'Main',
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.water_drop),
          label: 'Water Products',
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.point_of_sale),
          label: 'Use Points',
        ),
      ],
    );
  }
}

class BuildDrawer extends StatelessWidget {
  const BuildDrawer({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer();
  }
}
