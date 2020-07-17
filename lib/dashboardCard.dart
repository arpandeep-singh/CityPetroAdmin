import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import './constraints.dart';
class DashboardCard extends StatelessWidget {
  final String svgSrc;
  final String title;
  final Function press;
  const DashboardCard(
    {
    Key key,
    this.svgSrc,
    this.title,
      this.press
     }
     ):super(key:key);

  @override
  Widget build(BuildContext context) {
    return  Container(
     // padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(13),
          boxShadow:[
          BoxShadow(
            offset: Offset(0,30),
            blurRadius: 10,
            spreadRadius: -20,
            color: kShadowColor,
            

          )
        ]
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: press,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: <Widget>[
                Spacer(),
                SvgPicture.asset(svgSrc),
                Spacer(),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.title.copyWith(fontSize: 15),

                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
