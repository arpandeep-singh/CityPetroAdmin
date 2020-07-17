import 'package:citypetro/constraints.dart';
import 'package:citypetro/services/auth.dart';
import 'package:flutter/material.dart';
class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final AuthService _auth =AuthService();
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  String email='';
  String password='';
  String error='';
  bool _autoValidate = false;
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery
        .of(context)
        .size;
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(''),
        backgroundColor: Color(0xFF7e60e4),
        elevation: 0,
      ),
      body: SafeArea(
        child: Container(
          child: ListView(
            children: <Widget>[
              Stack(
                children: <Widget>[
                  Container(
                    height: size.height*0.4,
                    decoration: BoxDecoration(
                      color:  Color(0xFF7e60e4),
                      image: DecorationImage(
                       image: AssetImage("assets/images/cityTruck3.jpg"),
                        fit: BoxFit.cover
                      )
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 220, 20, 0),
                    child: Align(
                      alignment: Alignment.center,
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(13),
                            //border: Border.all(),
                            boxShadow:[
                              BoxShadow(
                                  offset: Offset(0,30),
                                  blurRadius: 10,
                                  spreadRadius: -20,
                                  color: kShadowColor
                              )
                            ]
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 25,horizontal: 33),
                          child: Form(
                            autovalidate: _autoValidate,
                            key: _formKey,
                            child: Column(
                              children: <Widget>[
                                SizedBox(height: 10,),

                                Padding(
                                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                  child: Center(child: Text('SIGN IN',style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold,color: Colors.grey[700]),)),
                                ),
                                SizedBox(height: 30,),
                                Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey[400]),
                                    borderRadius: BorderRadius.circular(20),

                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 10),
                                    child: TextFormField(
                                      decoration: InputDecoration(
                                          labelText: 'Email',
                                          icon: Icon(Icons.person),
                                          border: InputBorder.none,
                                          hintText: 'Enter your email'

                                      ),
                                      onChanged: (val){
                                              setState(()=>email=val);
                                      },
                                      validator: (val){
                                        if(val.isEmpty) return 'Email is required.';
                                        final RegExp emailExp = new RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
                                        if(!emailExp.hasMatch(val))
                                          return 'Please enter valid email';
                                        return null;
                                      },
                                    ),
                                  ),
                                ),
                                SizedBox(height: 20,),
                                Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey[400]),
                                    borderRadius: BorderRadius.circular(20),

                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 10),
                                    child: TextFormField(
                                      obscureText: true,
                                      decoration: InputDecoration(
                                          labelText: 'Password',
                                          icon: Icon(Icons.vpn_key),
                                          border: InputBorder.none,
                                          hintText: 'Enter your password'

                                      ),
                                      validator: (val){
                                        if(val.isEmpty)return'Password is required';
                                        return null;
                                      },
                                      onChanged: (val){
                                        setState(()=>password=val);
                                      },
                                    ),
                                  ),
                                ),
                                SizedBox(height: 30,),
                                ButtonTheme(
                                  minWidth: MediaQuery.of(context).size.width,
                                  child: RaisedButton(

                                    color: Color(0xFF7e60e4),
                                    elevation: 0,
                                    onPressed: () async{
                                      if(_formKey.currentState.validate()){
                                        dynamic result = await _auth.signInWithEmailAndPassword(email.replaceAll(" ", ""), password);
                                        if(result==null){
                                          _scaffoldKey.currentState
                                              .showSnackBar(new SnackBar(backgroundColor: Color(0xFF7e60e4), content: new Text('USER NOT FOUND')));
                                        }
                                      }else{
                                        print('else');
                                      }

                                    },
                                    child: Text('LOGIN',style: TextStyle(color: Colors.white),),

                                  ),

                                ),
                                SizedBox(height: 10,),
                                Text(
                                  error,
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontSize: 14
                                  ),
                                ),
                                Text('CITY PETROLEUM TRANSPORT INC.',style: TextStyle(fontWeight: FontWeight.bold,),),
                                SizedBox(height: 10,),
                                Text('Gurwinder Thind',style: TextStyle(fontSize: 16),),
                                SizedBox(height: 5,),
                                Text('+1 416-829-9860',style: TextStyle(fontSize: 12),),

                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              //Expanded(child: _loadsList()),
            ],
          ),
        ),
      ),

    );
  }
}
