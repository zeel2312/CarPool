import 'package:flutter/material.dart';
import 'package:pool_car1/Setup/signin.dart';
import 'package:pool_car1/Setup/tabs.dart';
import 'package:pool_car1/Setup/welcome.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>{

  @override
  Widget build(BuildContext context) {
    
      return Scaffold(
      body: DefaultTabController(
        length: 3,
        child: Scaffold(
          body: TabBarView(
            children: [
              WelcomePage(),
              TabPage(),
              LoginPage(),
            ],
          ),
          bottomNavigationBar: TabBar(
            tabs: [
              Tab(
                icon: Icon(Icons.home),
              ),
              Tab(
                icon: Icon(Icons.rss_feed),
              ),
              Tab(
                icon: Icon(Icons.perm_identity),
              ),
            ],
            labelColor: Colors.blue,
            unselectedLabelColor: Colors.grey,
          ),
          backgroundColor: Colors.white,
        ),
      ),
    );
  }
}