import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:share/share.dart';
import '../models/Article.dart';

Widget articleBox(BuildContext context, Article article, String heroId) {
  return ConstrainedBox(
    constraints: new BoxConstraints(
      maxHeight: 90.0,
    ),
    child: Stack(
      children: <Widget>[
        Container(
          alignment: Alignment.bottomRight,
          child: Card(
            elevation: 3,
            child: Padding(
              padding: EdgeInsets.fromLTRB(105, 0, 0, 0),
              child: Column(
                children: <Widget>[
                  Container(
                    child: Html(
                      data: article.title!.length > 100
                          ? "<h2>" +
                          article.title!.substring(0, 100) +
                          "...</h2>"
                          : "<h2>" + article.title.toString() + "</h2>",
                      style: {
                        "h2": Style(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: FontSize.percent(65),
                          margin: EdgeInsets.fromLTRB(0,13, 0, 0),
                          padding: EdgeInsets.fromLTRB(25, 0, 0, 0),
                        )
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Container(
          alignment: Alignment.topLeft,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(139, 49, 0, 3),
                child: Container(
                  decoration: BoxDecoration(
                      color: Color(0xFFE3E3E3),
                      borderRadius: BorderRadius.circular(3)),
                  padding: const EdgeInsets.fromLTRB(3, 3, 3, 3),
                  margin:  EdgeInsets.fromLTRB(4, 3, 4, 3),
                  child: Text(
                    article.category.toString(),
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 7,
                        fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
            padding: const EdgeInsets.fromLTRB(250, 63, 0, 0),
            child: Row(children: <Widget>[
              Icon(
                Icons.timer,
                color: Colors.black45,
                size: 12,
              ),
            ])),
        Padding(
          padding: const EdgeInsets.fromLTRB(265,66,0,0),
          child: Container(
            child: Text(
              article.date.toString(),
              style:TextStyle(fontSize:8),
              textAlign: TextAlign.left,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(315, 45, 0, 0),
          child: IconButton(
            icon: Icon(Icons.share, color: Colors.black45, size: 15.0),
            onPressed: () {
              Share.share(article.link.toString());
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: SizedBox(
            height: 85,
            width: 140,
            child: Card(
              elevation: 0,
              margin: EdgeInsets.all(10),
              child: Hero(
                tag: heroId,
                child: ClipRRect(
                  borderRadius: new BorderRadius.circular(8.0),
                  child: Image.network(
                    article.image.toString(),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
        ),
        //   article.video != ""
        //       ? Positioned(
        //           left: 12,
        //           top: 12,
        //           child: Card(
        //             child: CircleAvatar(
        //               radius: 14,
        //               backgroundColor: Colors.transparent,
        //               child: Image.asset("assets/play-button.png"),
        //             ),
        //             elevation: 8,
        //             shape: CircleBorder(),
        //             clipBehavior: Clip.antiAlias,
        //           ),
        //         )
        //       : Container(),
      ],
    ),
  );
}