import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:pool_car1/Setup/signin.dart';
import 'package:pool_car1/Setup/signup.dart';
import 'package:pool_car1/Setup/tabs.dart';

import 'AddRide.dart';
import 'feedback.dart';
import 'home.dart';
import 'searchRide.dart';



class UserHomePage extends StatefulWidget {


  UserHomePage({Key key}) : super(key: key);

  @override
  _UserHomePageState createState() => _UserHomePageState();

}


class _UserHomePageState extends State<UserHomePage> with AutomaticKeepAliveClientMixin<UserHomePage>{

  static String username = "";

  @override
  bool get wantKeepAlive => true;

  Future<int> _isCarOwner;

  @override
  void initState(){
    _isCarOwner = _checkIfCarOwner();
    super.initState();
  }
  

  void  _getDataUser() async{
    final FirebaseUser user = await FirebaseAuth.instance.currentUser();

    final databaseReference = FirebaseDatabase.instance.reference().child("passenger");
    databaseReference.once().then((DataSnapshot snapshot){
      Map<dynamic, dynamic> values = snapshot.value;
      values.forEach((key,value) {
        if(key == user.uid )
        {
          username = value["username"];
        }
      });
    });
  }


  final databaseReferenceCarOwner = FirebaseDatabase.instance.reference().child("carowner");

  Future<int> _checkIfCarOwner() async{

    var dataCarowner;
    await databaseReferenceCarOwner.once().then((DataSnapshot snapshot) {
      dataCarowner = snapshot.value;
    });

    int result = 0;
    FirebaseUser user = await FirebaseAuth.instance.currentUser();

    dataCarowner.forEach((k,v){
      if(k.toString() == user.uid.toString()){
        result = 1;
      }
    });
    return result;
  }

  @override
  Widget build(BuildContext context) {

    _getDataUser();

    return Scaffold(
        appBar: AppBar(
          title: Text('PoolMyCar' + "           Welcome:" + username),
        ),
        body: new Center(
            child: new Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("Assets/images/back1.jpg"),
                  fit: BoxFit.cover,
                ),
              ),
              child: new Container(
                margin: EdgeInsets.fromLTRB(100,325,100,0),
                child:new ListView(
                  children: <Widget>[
                    Container(
                      child: FutureBuilder(
                        future: _isCarOwner,
                        builder: (BuildContext context, AsyncSnapshot snapshot){
                          if(snapshot.data == 0)
                          {
                            return Container(
                              child: Padding(
                                padding: EdgeInsets.all(10),
                              ),
                            );
                          }
                          else{
                            return Container(
                              child: ButtonTheme(
                                minWidth: 200,
                                height: 50,
                                child : RaisedButton(
                                  onPressed:createRide,
                                  shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                                  child: Text("Offer A Ride",
                                  style: TextStyle(color: Colors.white),),
                                ),
                              ),
                            );
                          }
                        }
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10),
                    ),
                    ButtonTheme(
                      minWidth: 200,
                      height: 50,
                      child : RaisedButton(
                        onPressed:navigateToSearchRide,
                        shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                        child: Text("Book A Ride",
                        style: TextStyle(color: Colors.white),),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(30),
                    ),
                    ButtonTheme(
                      minWidth: 25,
                      height: 25,
                      child : RaisedButton(
                        onPressed:navigateToHome,
                        shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                        child: Text("Logout",
                        style: TextStyle(color: Colors.white),),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(),
                    ),
                  ],
                ),
              ),
            ),
        )
    );
  }

  void navigateToSignIn()
  {
    Navigator.push(context,MaterialPageRoute(builder: (context)=> LoginPage(),fullscreenDialog: true));
  }

  void navigateToSearchRide()
  {
    Navigator.push(context,MaterialPageRoute(builder: (context)=> SearchRidePage(),fullscreenDialog: true));
    //Navigator.push(context,MaterialPageRoute(builder: (context)=> DriverViewRidePage(),fullscreenDialog: true));
  }

  void navigateToSignUp()
  {
    Navigator.push(context,MaterialPageRoute(builder: (context)=> SignUpPage(),fullscreenDialog: true));

  }

  void createRide()
  {
    Navigator.push(context,MaterialPageRoute(builder: (context)=> NewRidePage(),fullscreenDialog: true));
  }

  void navigateToFeedbackPage()
  {
//    Navigator.push(context,MaterialPageRoute(builder: (context)=> FeedbackPage(),fullscreenDialog: true));
  }

  void navigateToTabs()
  {
    Navigator.push(context,MaterialPageRoute(builder: (context)=> TabPage(),fullscreenDialog: true));
  }

  void navigateToHome()
  {
    var result = FirebaseAuth.instance.signOut().whenComplete((){
      Navigator.pop(context);
    });
    //Navigator.push(context,MaterialPageRoute(builder: (context)=> HomePage(),fullscreenDialog: true));
    
  }

}

