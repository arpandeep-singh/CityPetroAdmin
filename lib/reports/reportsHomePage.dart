import 'package:citypetro/reports/WeeklyReport.dart';
import 'package:citypetro/reports/invoice/generateInvoice.dart';
import 'package:citypetro/reports/invoice/invoiceHomePage.dart';
import 'package:citypetro/reports/weeklyReportOutdated.dart';
import 'package:flutter/material.dart';

class ReportsInvoicesHomePage extends StatelessWidget {
  final String uid;
  ReportsInvoicesHomePage({@required this.uid});
  @override
  Widget build(BuildContext context) {

    final _pages=<Widget>[
      demoList(uid: uid,),
      CreateInvoice(uid: uid,),

    ];
    final _kTabs=<Tab>[
      Tab(text: 'SUMMARY',),
      Tab(text: 'INVOICES',),


    ];

    return DefaultTabController(
        length: _pages.length,
        child: Scaffold(
          appBar: AppBar(
            title: Text('REPORTS'),
            bottom: TabBar(
              tabs: _kTabs,
            ),
          ),
          body: TabBarView(
            children: _pages,
          ),
        )
    );
  }
}
