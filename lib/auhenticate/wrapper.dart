import 'package:citypetro/auhenticate/authenticate.dart';
import 'package:citypetro/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:citypetro/auhenticate/user.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    if(user==null){
      return Authenticate();
    }else{
      return Dashboard();
    }

  }
}
