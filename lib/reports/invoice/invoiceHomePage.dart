import 'package:citypetro/reports/invoice/generateInvoice.dart';
import 'package:flutter/material.dart';
class InvoiceHomePage extends StatelessWidget {
final String uid;
InvoiceHomePage({@required this.uid});
  @override
  Widget build(BuildContext context) {
    final _pages=<Widget>[
      CreateInvoice(),
      Center(child: Icon(Icons.alarm,size: 64,),)

    ];
    return DefaultTabController(
      length: _pages.length,
      child: Builder(
        builder: (BuildContext context)=>Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            children: <Widget>[

              Expanded(
                child: TabBarView(children: _pages,),
              ),
              TabPageSelector(),
            ],

          ),
        ),
      ),
    );
  }
}
