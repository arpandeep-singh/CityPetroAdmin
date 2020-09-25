
import 'package:citypetro/addLoad/dailyReport.dart';
import 'package:citypetro/dashboardCard.dart';
import 'package:citypetro/dipCharts/dipChartsHomePage.dart';
import 'package:citypetro/reports/reports.dart';
import 'package:citypetro/services/Database.dart';
import 'package:citypetro/services/auth.dart';
import 'package:citypetro/siteMaps/siteMapsHomePage.dart';
import 'package:citypetro/widgets/bottom_nav_bar.dart';
import 'package:citypetro/widgets/fancy_tab_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:citypetro/auhenticate/user.dart';

class Dashboard extends StatelessWidget {
  final AuthService _auth = AuthService();
  DatabaseService database= DatabaseService();
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    var size = MediaQuery
        .of(context)
        .size;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Color(0xFF7e60e4),
        actions: <Widget>[
          FlatButton.icon(
              icon: Icon(Icons.directions_run,color: Colors.white,),
              label: Text('Logout',style: TextStyle(color: Colors.white),),
            onPressed: () async{
             await _auth.signOut();
            },
            ),
        ],
      ),


        body: Stack(
          children: <Widget>[
            Container(
              height: size.height * .33,
              decoration: BoxDecoration(
                color: Color(0xFF7e60e4),
                  image: DecorationImage(
                      image: AssetImage("assets/images/thind1.jpg"),
                      fit: BoxFit.cover
                  )
              ),
            ),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 70),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[

                    Text(
                      //'Hello, \n${user.uid}',
                      'Hello,',
                      style: Theme.of(context)
                      .textTheme.display1
                      .copyWith(fontWeight: FontWeight.w600,color: Colors.white,fontSize: 30),
                    ),
                    Text(
                      //'Hello, \n${user.uid}',
                      '${user.name}',
                      style: Theme.of(context)
                          .textTheme.display1
                          .copyWith(fontWeight: FontWeight.w900,color: Colors.white,fontSize: 36),
                    ),
                    SizedBox(height: 40,),
                    Expanded(
                      child: GridView.count(
                          crossAxisCount: 2,
                        childAspectRatio: 0.95,
                        crossAxisSpacing: 20,
                        mainAxisSpacing: 20,
                        children: <Widget>[
                           DashboardCard(
                             title: 'Add Load',
                             svgSrc: 'assets/icons/add_load.svg',
                             press: () {
                               Navigator.push(
                                 context,
                                 MaterialPageRoute(builder: (context) {
                                   return DailyReport();
                                 }),
                               );
                             },
                           ),
                          DashboardCard(
                            title: 'Reports',
                            svgSrc: 'assets/icons/invoice.svg',
                            press: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) {
                                  return ReportsHomePage();
                                }),
                              );
                            },
                          ),
                          DashboardCard(
                            title: 'Site Maps',
                            svgSrc: 'assets/icons/site_map.svg',
                            press: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) {
                                  return SiteMapsHomePage();
                                }),
                              );
                            },
                          ),
                          DashboardCard(
                            title: 'Dip Charts',
                            svgSrc: 'assets/icons/dip_chart.svg',
                            press: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) {
                                  return DipChartsHomePage();
                                }),
                              );
                            },
                          ),



                        ],
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),


    );
  }
}
