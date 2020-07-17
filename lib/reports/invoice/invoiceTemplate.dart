import 'package:citypetro/reports/invoice/driver.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
class HtmlFile{
  final QuerySnapshot load;
  final String dateFrom;
  final String dateTo;
  final int bonus;
  final Driver driver;
  final String company;
  String fullCompanyName='';
  final double rate;
  final double waitingCost;
  final double adjustment;

  HtmlFile({
    @required
    this.load,this.dateFrom,this.dateTo,
    this.bonus,this.driver,this.company,
    this.rate,this.waitingCost,this.adjustment
     }
    );

  String getCompany(){
    if(company.contains('CITY')){
      fullCompanyName='CITY PETROLEUM TRANSPORT INC.';
    }else{
      fullCompanyName=company;
    }
    return fullCompanyName;
  }
  String getDate(QuerySnapshot load,int i){
    return new DateFormat('yyyy-MM-dd').format((load.documents[i].data['date'] as Timestamp).toDate());
  }
  String getWaiting(double waiting){
    return waiting.toStringAsFixed(2);
  }
  String getTotalRate(double rate,double waiting,double adjustment){
    print(adjustment-100);
    print('Rate: $rate Waiting $waiting Ad $adjustment');
    print((rate+waiting+adjustment)*1.13);
    return ((rate+waiting+adjustment)*1.13).toStringAsFixed(2);
  }
  String getTotalHST(double rate,double waiting,double adjustment){
    return ((rate+waiting+adjustment)*0.13).toStringAsFixed(2);
  }
  String getAdjustment(double adjustment){
    return adjustment>0?'\+\$$adjustment':'\-\$${0-adjustment}';
  }


   Future<String> invoiceHtml() async{
    var htmlContent = """
 <!DOCTYPE html>
  <html>
<head>
    <style>
table, th, td {
  
  border-collapse: collapse;
    text-align: center
}
</style>
</head>
<body>
    <div style="background-color: #dff7dc;padding: 3px;padding-left: 15px">
        <div style="float: right;padding-right: 15px;color: ">
        <h1>INVOICE</h1>
        </div>
    <div>
         <p>
            <b>${(driver.name).toUpperCase()}</b><br>
            <b>EMAIL:</b> ${(driver.email).toString()}<br>
            <b>MOB:</b> +1 ${(driver.contact).toString()}
        </p>
    </div>     
    </div>
    <div >
        <div style="float: right;padding-right: 15px">
            <p><b>PERIOD:</b> $dateFrom - $dateTo</p>
        </div>
    <div style="background-color: #e0e8df;padding: 3px;padding-left: 15px">
        <p>
             
            <b style="color: #2e8cb8">$company</b><br>
            Gurwinder Singh Thind<br>
            46 &nbsp;Brookwater Crescent , Caledon,&nbsp;ON,<br>
            L7C 4A4,&nbsp;&nbsp;Canada&nbsp;&nbsp;+1 (416)-829-9860
        </p>
        </div>     
    </div>
  <table style="width:100%">
 <tr style="background-color: #f0ecc2;border: 1px solid black">
     <td colspan="5"><b>DAILY REPORT DETAILS</b></td></tr>
  <tr style="background-color: #f0ecc2">
    <th style="padding: 8px;border: 1px solid black">Date</th>
    <th style="border: 1px solid black">Order No.</th> 
    <th style="border: 1px solid black">Station ID</th>
      <th style="border: 1px solid black">City</th>
      <th style="border: 1px solid black">Rate</th>
  </tr>
  """;
    String header="""
     <tr style="background-color: #f0ecc2">
    <th style="padding: 5px;border: 1px solid black">Date</th>
    <th style="border: 1px solid black">Order No.</th> 
    <th style="border: 1px solid black">Station ID</th>
      <th style="border: 1px solid black">City</th>
      <th style="border: 1px solid black">Rate</th>
  </tr>
    """;
    String tempHeader='';
    String mid='';
    int j=0;
    for(int i=0;i<load.documents.length;i++){
      if(i==22|| i==22+29 || i==22+29+29){
        print(i);
        tempHeader=header;
      }else{
        tempHeader="";
      }


         mid= mid+tempHeader+"""
         <tr style="background-color: #c4ebff">
    <td style="padding: 8px">${getDate(load, i)}</td>
    <td>${load.documents[i].data['order']}</td>
    <td>${load.documents[i].data['stationID']}</td>
      <td>${load.documents[i].data['city']}</td>
      <td>\$${load.documents[i].data['rate']}</td>
  </tr>
         
         """;
    }


var end = """
 <tr style="background-color: #e0e8df">
           <td colspan="4" style="text-align: right;padding-right: 7px"><b>Waiting Cost</b></td>
          <td style="border: 1px solid black;padding: 7px"><b>\$${getWaiting(waitingCost)}</b></td>
      </tr>
       <tr style="background-color: #e0e8df">
           <td colspan="4" style="text-align: right;padding-right: 7px"><b>Adjustment</b></td>
          <td style="border: 1px solid black;padding: 7px"><b>${getAdjustment(adjustment).toString()}</b></td>
      </tr>
       <tr style="background-color: #e0e8df">
           <td colspan="4" style="text-align: right;padding-right: 8px"><b>HST 13%</b></td>
          <td style="border: 1px solid black;padding: 7px;"><b>\$${getTotalHST(rate, waitingCost, adjustment).toString()}</b></td>
      </tr>
       <tr style="background-color: #e0e8df">
           <td colspan="4" style="text-align: right;padding-right: 8px"><b>Total</b></td>
          <td style="border: 1px solid black;padding: 7px"><b>\$${getTotalRate(rate, waitingCost, adjustment).toString()}</b></td>
      </tr>
</table>

</body>
</html>
    """;
    return '$htmlContent $mid $end';
  }

}
