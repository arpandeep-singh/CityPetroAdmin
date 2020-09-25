import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:citypetro/auhenticate/user.dart';
import './allUsers.dart';

class ReportsHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    return AllUsers();
  }
}
