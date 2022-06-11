import 'package:flutter/material.dart';
import 'package:watermark/pages/alarms.dart';
import 'package:watermark/pages/analytics.dart';
import 'package:watermark/pages/completed_tasks.dart';
import 'package:watermark/pages/data_entry.dart';
import 'package:watermark/pages/pending_tasks.dart';
import 'package:watermark/pages/settings.dart';
import 'package:watermark/widgets/custom_nav_bar.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);


  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentIndex = 0;
  String title = "Orders";
  @override
  Widget build(BuildContext context) {
    return Scaffold(

        drawer: Drawer(


          // Add a ListView to the drawer. This ensures the user can scroll
          // through the options in the drawer if there isn't enough vertical
          // space to fit everything.
          child: ListView(
            // Important: Remove any padding from the ListView.
            padding: EdgeInsets.zero,
            children: [
              UserAccountsDrawerHeader(
                accountName: Text("Orderio"),
                accountEmail: Text("Order Management System"),
                currentAccountPicture: CircleAvatar(
                  backgroundColor: Colors.blueAccent,
                  child: Text(
                    "O",
                    style: TextStyle(fontSize: 40.0),
                  ),
                ),
              ),
              ListTile(
                leading: Icon(Icons.settings),
                title: const Text('Settings'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) =>  Settings()),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.home), title: Text("Home"),
                onTap: () {

                },
              ),
              ListTile(
                leading: Icon(Icons.home), title: Text("Contact Us"),
                onTap: () {

                },
              ),

            ],
          ),
        ),
        appBar: AppBar(
          leading: Builder(
            builder: (context) => IconButton(
              icon: Icon(Icons.menu_rounded, color: Colors.black,),
              onPressed: () => Scaffold.of(context).openDrawer(),
            ),
          ),
          title: Text(
            title,
            style: TextStyle(
              fontFamily: "Poppins",
              fontStyle: FontStyle.normal,
              fontWeight: FontWeight.bold,
              fontSize: 16.0,
              color: Color(0xff777777),
            ),
          ),
          backgroundColor: Colors.white,
        ),
        body: getBody(),
        bottomNavigationBar: _buildBottomBar());
  }

  Widget _buildBottomBar() {

    return CustomAnimatedBottomBar(
      containerHeight: 60,
      backgroundColor: Color(0xff1C52DB),
      selectedIndex: _currentIndex,
      showElevation: true,
      itemCornerRadius: 7,
      curve: Curves.easeIn,
      onItemSelected: (index) => setState((){
        _currentIndex = index;
        setTitle();
      }),
      items: <BottomNavyBarItem>[
        BottomNavyBarItem(
          icon: Icons.data_usage,
          title: 'Data Entry',
          activeColor: Colors.white,
          inactiveColor: Colors.white,
          textAlign: TextAlign.center,
        ),
        BottomNavyBarItem(
          icon: Icons.assignment_late,
          title: 'Pending',
          activeColor: Colors.white,
          inactiveColor: Colors.white,
          textAlign: TextAlign.center,
        ),
        BottomNavyBarItem(
          icon: Icons.access_time,
          title: 'Completed',
          activeColor: Colors.white,
          inactiveColor: Colors.white,
          textAlign: TextAlign.center,
        ),
        BottomNavyBarItem(
          icon: Icons.bar_chart,
          title: 'Analytics',
          activeColor: Colors.white,
          inactiveColor: Colors.white,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  void setTitle(){
    List<String> titles = ["Orders", "Pending Tasks", "Completed Tasks", "Analytics"];
    setState(() {
      this.title = titles[_currentIndex];
    });
  }


  Widget getBody() {
    List<Widget> pages = [
      DataEntry(),
      PendingTasks(),
      CompletedTasks(),
      Analytics(),
    ];
    return IndexedStack(
      index: _currentIndex,
      children: pages,
    );
  }
}
