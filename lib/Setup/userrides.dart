import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:pool_car1/Setup/userhome.dart';

import 'feedback.dart';

//import 'package:flutter_email_sender/flutter_email_sender.dart';

/*class UserRideDataPage extends StatelessWidget {


  // This widget is the root of your application.
  UserRideDataPage({Key key,}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home:new MyCard(),
    );
  }
}*/

class MyCard extends StatefulWidget{

  MyCard({Key key,}) : super(key: key);

  static final databaseReference = FirebaseDatabase.instance.reference();
  static int numRides = 0;

  @override
  _MyCardState createState() => _MyCardState();
}

class _MyCardState extends State<MyCard> with AutomaticKeepAliveClientMixin<MyCard>{
  final databaseReferenceCarOwner = FirebaseDatabase.instance.reference().child("carowner");

  @override
  bool get wantKeepAlive => true;

  Future<List<CustomCard>> _rideList;
  @override
  void initState(){
    _rideList = _getData();
    super.initState();
  }


  Future<List<CustomCard>> _getData() async{
    print("Inside");
    var data;
    var dataCarowner;
    List<Ride> rides = [];

    print("Inside1");

    await MyCard.databaseReference.once().then((DataSnapshot snapshot) {
      data = snapshot.value;
    });


    await databaseReferenceCarOwner.once().then((DataSnapshot snapshot) {
      dataCarowner = snapshot.value;
    });

    print("Inside2");

    var carOwnerDetails = Map();

    dataCarowner.forEach((k ,v){
      carOwnerDetails[k] = v["username"];
    });

    final databaseReferencePassengerStop = FirebaseDatabase.instance.reference().child("bookings");
    var dataBookings;
    await databaseReferenceCarOwner.once().then((DataSnapshot snapshot) {
      dataBookings = snapshot.value;
    });

    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    var userUid = user.uid;

    var rideDetails = data['rides'];

    List<CustomCard> newCards = [];

    rideDetails.forEach((k ,v) {
      if(true)
      {

        var passengers = v["passengers"];
        if(passengers != null)
        {
          passengers.forEach((key,value){
            if(value.toString() == userUid.toString())
            {
              int cr = 1;

              DateTime rideDate = DateTime.parse(v["date"] + " " + v["time"]);

              if(rideDate.isAfter(DateTime.now()))
                {
                  cr = 0;
                }

              CustomCard c = CustomCard(username :carOwnerDetails[v["driverUid"]],preferences:v["preferences"],time:v["time"],pricepp:v["pricepp"],source:v["source"],dest:v["dest"],driveruid:v["driverUid"],numberofppl:v["numberofppl"],date:v["date"],rideId:k,canrate:cr);
              newCards.add(c);
            }
          });
        }
      }
      print("HHEHH");
      }

    );
    return newCards;
  }

  @override
  Widget build(BuildContext context) {

    return Container(
          child: FutureBuilder(
            future: _rideList,
            builder:(BuildContext context ,AsyncSnapshot snapshot ){
              if(snapshot.data == null)
              {
                return Container(
                  child: Center(
                      child:Text("Please wait wheels are rolling  ....")
                  ),
                );
              }
              else {
                return Column(
                  children: <Widget>[
                    Card(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          const ListTile(
                            leading: Icon(Icons.album),
                            title: Text('Book Your Rides Here !'),
                            subtitle: Text('Travel to Unravel'),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                        child: ListView(
                          shrinkWrap: true,
                          children: snapshot.data,
                        )
                    )
                  ],
                );
              }
            },
          )
      );
  }
}

class CustomCard extends StatelessWidget {

  CustomCard({
    this.rideId,
    this.username,
    this.preferences,
    this.time,
    this.pricepp,
    this.source,
    this.dest,
    this.driveruid,
    this.numberofppl,
    this.date,
    this.canrate
  });

  final String username;
  final String time;
  final String date;
  final String preferences;
  final int pricepp;
  final String source;
  final String dest;
  final String driveruid;
  final int numberofppl;
  final String rideId;
  String user;
  int canrate;

  Future<int> _isUser(carOwnerId) async{

    // final databaseReferenceCarOwner = FirebaseDatabase.instance.reference().child("carowner");
    // var dataCarOwner;
    // await databaseReferenceCarOwner.once().then((DataSnapshot snapshot) {
    //   dataCarOwner = snapshot.value;
    // });


    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    //var userUid = user.uid;
    //var flag = 0;
    // dataCarOwner.forEach((k,v){
    //   if(userUid.toString() == k.toString()){
    //     flag = 1;
    //   }
    // });

    if(carOwnerId == user.uid.toString()){
      return 1;
    }

    return 0;

  }
  Future<int> _canCancel() async{

    final databaseReferenceCarOwner = FirebaseDatabase.instance.reference().child("carowner");
    var dataCarOwner;
    await databaseReferenceCarOwner.once().then((DataSnapshot snapshot) {
      dataCarOwner = snapshot.value;
    });


    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    var userUid = user.uid;
    var flag = 0;
    dataCarOwner.forEach((k,v){
      if(userUid.toString() == k.toString()){
        flag = 1;
      }
    });

    return flag;

  }





  @override
  Widget build(BuildContext context)  {

    Future<String> _getUser () async
    {
      FirebaseUser user =  await FirebaseAuth.instance.currentUser();
      String userUid = user.uid.toString();
      return userUid;
    }

    return Card(
      child: Column(
        children: <Widget>[
          ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage(
                  "https://img.icons8.com/bubbles/50/000000/user.png",
                ),
                radius: 35,
              ),
              title: Text(username),
              subtitle: Text("Pref : " + preferences)
          ),
//         new Image.network("https://img.icons8.com/bubbles/50/000000/user.png"),
          Padding(
            padding: EdgeInsets.all(7.0),
            child: Row(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(7.0),
                ),
                Padding(
                  padding: EdgeInsets.all(7.0),
                  child: Text("Departure: "+ time.toString() +"      Date: " + date.toString() ,style: TextStyle(fontSize: 12.0),),
                ),
                Padding(
                  padding: EdgeInsets.all(7.0),
                  child: Text("  Ride Price: "+ pricepp.toString(),style: TextStyle(fontSize: 12.0)),
                ),
              ],
            ),

          ),
          Padding(
            padding: EdgeInsets.all(7.0),
            child: Row(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(7.0),
                ),
                Padding(
                  padding: EdgeInsets.all(7.0),
                  child: Text('From: ' + source,style: TextStyle(fontSize: 12.0),),
                ),
                Padding(
                  padding: EdgeInsets.all(7.0),
                  child: Text('To: ' + dest.toString(),style: TextStyle(fontSize: 12.0)),
                ),
                Spacer(),
                Padding(
                    padding: EdgeInsets.all(7.0),
                    child: Container(
                      child: FutureBuilder(
                          future: _isUser(driveruid),
                          builder:(BuildContext context ,AsyncSnapshot snapshot ){
                            if(snapshot.data == 1)
                            {
                              return Column(
                                children: <Widget>[
                                  RaisedButton(
                                    onPressed:(){
                                      //deleteRide(rideId);
                                      return showDialog(context: context, 
      barrierDismissible: true,
      builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Confirm'),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text('Please confirm if you want create ride')
            ],
          ),
        ),
        actions: <Widget>[
          FlatButton(
            onPressed: () => _confirmResultForDeleteRide(true,context),
            child: Text('confirm'),
          ),
          FlatButton(
            onPressed: () => _confirmResultForDeleteRide(false, context),
            child: Text('cancel'),
          )

        ],
      );
      });
                                    },
                                    child: Text("Delete"),
                                  ),
                                  RaisedButton(
                                    onPressed:(){
                                    },
                                    child: Text("Rate Ride"),
                                  ),
                                ],
                              );
                            }
                            else {
                              return Container(
                              );
                            }
                          }

                      ),
                    )

                ),
                if(canrate == 0)
                FloatingActionButton(
                  //heroTag: rideId.toString(),
                  heroTag: rideId + "1",
                  onPressed:(){
                    
                    return showDialog(context: context, 
      barrierDismissible: true,
      builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Confirm'),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text('Please confirm if you want Cancel Booking')
            ],
          ),
        ),
        actions: <Widget>[
          FlatButton(
            onPressed: () => _confirmResultForCancelBooking(true,context),
            child: Text('confirm'),
          ),
          FlatButton(
            onPressed: () => _confirmResultForCancelBooking(false, context),
            child: Text('No'),
          )

        ],
      );
      });
                                    },
                  child: Text("Cancel"),
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
                  Padding(
                  padding: EdgeInsets.all(7.0),
                ),
                Container(
                  child: FutureBuilder(
                      future: _getUser(),
                      builder:(BuildContext context ,AsyncSnapshot snapshot ){
                        if(snapshot.data != null)
                        {
                          user = snapshot.data;
                          print(user);
                          return Container(
                          );

                        }
                        return Container();
                      }

                  ),
                ),
                if(canrate == 1)
                  FloatingActionButton(
                    heroTag: rideId + "2",
                    onPressed:(){
                      Navigator.push(context,MaterialPageRoute(builder: (context)=> FeedbackPage(rideId : rideId),fullscreenDialog: true));
                      },
                      child: Text("Rate!"),
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                ),
              ],
            ),

          )
        ],
      ),

    );

  }

_confirmResultForCancelBooking(bool isTrue, BuildContext context) {
    if (isTrue) {
deleteBooking(rideId);
      Navigator.pop(context);
      final snackBar =
          new SnackBar(content: new Text('Your Booking has been cancelled!'));
      Scaffold.of(context).showSnackBar(snackBar);
    } else {
      Navigator.pop(context);
    }
  }
  Future writeBooking(rideId,driveruid,source,dest,date,time,BuildContext context,numberofppl) async {

    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    final ridedbref = FirebaseDatabase.instance.reference().child("bookings");
    String k = ridedbref.push().key;
    ridedbref.child(k).set({
      'ride_id':rideId,
      'user_id': user.uid,
      'timestamp created': DateTime.now().millisecondsSinceEpoch,
    });

    final rideRefPushBookings = FirebaseDatabase.instance.reference().child("rides").child(rideId.toString()).child("passengers");
    rideRefPushBookings.update({
      'passenger_id$numberofppl': user.uid,
    });

    final sendOwner = FirebaseDatabase.instance.reference().child("carowner");
    var dataCarowner;
    await sendOwner.once().then((DataSnapshot snapshot) {
      dataCarowner = snapshot.value;
    });

    dataCarowner.forEach((k,v) async {
      if(driveruid.toString() == k.toString())
      {
        var mailId = v["email"];

        final databaseUpdate = FirebaseDatabase.instance.reference();
        databaseUpdate.child("rides").child(rideId.toString()).update({
          'numberofppl': numberofppl - 1,
        });

        print(numberofppl);
      }
    });
    Navigator.push(context,MaterialPageRoute(builder: (context)=> UserHomePage(),fullscreenDialog: true));

  }

  Future deleteRide(rideId)
  async {
    final ridedbref = FirebaseDatabase.instance.reference().child("rides");
    print("deleteride : id"+ rideId.toString());
    await ridedbref.child(rideId).remove().then((_) {
      print('Transaction  committed.');
    });
    

  }

  Future deleteBooking(rideId) async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    final bookings = FirebaseDatabase.instance.reference().child("bookings");
    final ridedbref = FirebaseDatabase.instance.reference().child("rides");
    var bookingdata, passengerdata;
    await bookings.once().then((DataSnapshot snapshot) {
       //Map<dynamic, dynamic> bookingdata = snapshot.value;
      bookingdata = snapshot.value;
    });

    print(bookingdata.toString());
    if(bookingdata != null){
    bookingdata.forEach((k,v) async {
        print(v);
        var ride = v['ride_id'];
        if(ride == rideId){
          print("ride to be deleted :"+k);
            await bookings.child(k).remove().then((_) {
            print('Transaction  committed.');
      });
          await ridedbref.child(ride).child("passengers").once().then((DataSnapshot snapshot) {
            passengerdata = snapshot.value;
          });
          print(passengerdata);
          if(passengerdata != null) {
            passengerdata.forEach((key,value) {
              print(value);
              print(user.uid.toString());
              print(value.toString() == user.uid.toString());
              if(value.toString() == user.uid.toString())
              {
                print("ridedbref.childkey: "+ ridedbref.child(ride).child("passengers").child(key).toString());
                ridedbref.child(ride).child("passengers").child(key).remove();
              }
            });
          }
        }

    });
    }

  }

  void _confirmResultForDeleteRide(bool isTrue, BuildContext context) {
    if (isTrue) {
      deleteRide(rideId);
      Navigator.pop(context);
      final snackBar =
          new SnackBar(content: new Text('Your Ride has been created!'));
      Scaffold.of(context).showSnackBar(snackBar);
    } else {
      Navigator.pop(context);
    }
  }


}

class Ride
{
  final int index;
  final int numberofppl;
  final String driverUid;
  final String source;
  final String dest;
  final int pricepp;
  final String time;
  final String rideId;
  final String date;
  Ride(this.index,this.numberofppl,this.driverUid,this.source,this.dest,this.pricepp,this.date,this.rideId,this.time);
}

class SourceDest
{
  String source;
  String dest;
  DateTime dateTime;

  SourceDest(this.source,this.dest,this.dateTime);
}
