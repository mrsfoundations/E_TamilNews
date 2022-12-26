import 'dart:convert';

import 'package:flutter/material.dart';
import '../common/constants.dart';
import '../pages/category_articles.dart';
import 'package:http/http.dart' as http;
Widget searchBoxes(BuildContext context,cat) {

 return GridView.builder(
   itemCount: cat.length,
    padding: EdgeInsets.all(16),
    shrinkWrap: true,
    physics: ScrollPhysics(),
    //crossAxisCount: 3,
    gridDelegate:SliverGridDelegateWithFixedCrossAxisCount(
     crossAxisCount: 3, crossAxisSpacing: 5, mainAxisSpacing: 5),
    itemBuilder: (BuildContext context, int index) {

      return Card(
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CategoryArticles(cat[index].id, cat[index].name,),
            ),
          );
        },
        child: Container(
          padding: EdgeInsets.fromLTRB(8, 16, 8, 8),
          child: Column(
            children: <Widget>[
              //SizedBox(width: 100, height: 45, child: Image.asset(image)),
              Spacer(),
              Text(
                cat[index].name,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 10,
                  height: 1.2,
                  fontWeight: FontWeight.w500,
                ),
              )

            ],
          ),

        ),
      ),
    );
      },
  );
}
