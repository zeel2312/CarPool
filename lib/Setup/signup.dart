
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:email_validator/email_validator.dart';
import 'package:pool_car1/Setup/signin.dart';



class SignUpPage extends StatefulWidget {

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {

  String _password,_email,_username,_contactNo;
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Sign Up"),
        ),
        body:
        Form(
            key: _formkey,
            child: SingleChildScrollView(
                child : Column(
                  children: <Widget>[
                    SizedBox(height: 20),
                    Padding(
                      padding : const EdgeInsets.all(10),
                      child: TextFormField(
                        validator:(input){
                          if(input.isEmpty) {
                            return 'Please fill the email';
                          }
                          if(EmailValidator.validate(input) == true)
                            {
                              return 'Email invalid';
                            }
                          return null;

                        } ,
                        onSaved: (input) => _email = input,
                        decoration: InputDecoration(
                            fillColor: Colors.lightBlueAccent,
                            filled: true,
                            contentPadding: EdgeInsets.fromLTRB(
                                10.0, 30.0, 10.0, 10.0),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            labelText: ' Email '),
                      ),
                    ),

                    Padding(
                      padding : const EdgeInsets.all(10),
                      child: TextFormField(
                        validator:(input){
                          if(input.length < 6) {
                            return 'Password not strong';
                          }
                          if(input.length > 20) {
                            return 'Password too long please limit';
                          }
                          return null;
                        } ,
                        onSaved: (input) => _password = input,
                        decoration: InputDecoration(
                            fillColor: Colors.lightBlueAccent,
                            filled: true,
                            contentPadding: EdgeInsets.fromLTRB(
                                10.0, 30.0, 10.0, 10.0),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            labelText: ' Password '),
                        obscureText: true,
                      ),
                    ),
                    Padding(
                      padding : const EdgeInsets.all(10),
                      child: TextFormField(
                        validator:(input){
                          if(input.isEmpty) {
                            return 'Please fill the Username';
                          }
                          return null;
                        } ,
                        onSaved: (input) => _username = input,
                        decoration: InputDecoration(
                            fillColor: Colors.lightBlueAccent,
                            filled: true,
                            contentPadding: EdgeInsets.fromLTRB(
                                10.0, 30.0, 10.0, 10.0),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            labelText: ' Username '),
                      ),
                    ),
                    Padding(
                      padding : const EdgeInsets.all(10),
                      child: TextFormField(
                        validator:(input){
                          if(input.isEmpty) {
                            return 'Please fill the contact';
                          }
                          return null;
                        } ,
                        onSaved: (input) => _contactNo = input,
                        decoration: InputDecoration(
                            fillColor: Colors.lightBlueAccent,
                            filled: true,
                            contentPadding: EdgeInsets.fromLTRB(
                                10.0, 30.0, 10.0, 10.0),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            labelText: ' Contact No. '),
                      ),
                    ),
                    SizedBox(height: 30),
                    ButtonTheme(
                      minWidth: 200.0,
                      height: 50.0,
                      child: RaisedButton(
                        color: Colors.blue,
                        onPressed:signUp,
                        child: Text("Sign Up"),
                      ),
                    ),
                  ],
                ),
            )
        )
    );
  }

  Future<void> signUp() async{
    final formstate = _formkey.currentState;
    if(formstate.validate() == true){
      formstate.save();
      var userUid;
      try
      {
        AuthResult result = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: _email, password: _password);
        FirebaseUser user = result.user;
        user.sendEmailVerification();
        Navigator.of(context).pop();
        Navigator.pushReplacement(context,MaterialPageRoute(builder: (context)=> LoginPage()));
        userUid = user.uid;
      }
      catch(e)
      {
        print(e.message);
      }

      final databaseReference = FirebaseDatabase.instance.reference();

      databaseReference.child("passenger").child(userUid).set({
           'username':_username,
            'contactNo':_contactNo,
            'email':_email,
        });
    }
  }

}
