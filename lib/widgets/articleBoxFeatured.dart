import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:share/share.dart';
import '../models/Article.dart';

Widget articleBoxFeatured(
    BuildContext context, Article article, String heroId) {
  return ConstrainedBox(
    constraints: new BoxConstraints(
        minHeight: 200.0, maxHeight: 225.0, minWidth: 360.0, maxWidth: 360.0),
    child: Stack(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.all(8),
          child: Container(
            height: 175,
            width: 425,
            child: Card(
              child:  Hero(
                tag: heroId,
                child: ClipRRect(
                  borderRadius: new BorderRadius.circular(8.0),
                  child: Image.network(
                    article.image.toString(),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              elevation: 6,
              margin: EdgeInsets.all(10),
            ),
          ),
        ),
        Positioned(
          left: 20,
          top: 90,
          right: 20,
          child: Padding(
            padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
            child: Card(
              elevation: 6,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(
                    child: Html(
                        data: article.title!.length > 65
                            ? "<h2>" +
                                article.title.toString().substring(0, 65) +
                                "...</h2>"
                            : "<h2>" + article.title.toString() + "</h2>",
                        style: {
                          "h2": Style(
                              color: Theme.of(context).primaryColorDark,
                              fontWeight:FontWeight.w900,
                              fontSize: FontSize.percent(95),
                              padding: EdgeInsets.all(2),
                              ),
                        }),
                  ),
                  Container(
                    alignment: Alignment.topLeft,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.fromLTRB(10, 2, 8, 4),
                          child: Container(
                            decoration: BoxDecoration(
                                color: Color(0xFFE3E3E3),
                                borderRadius: BorderRadius.circular(3)),
                            padding: EdgeInsets.fromLTRB(3, 4, 4, 1),
                            margin: EdgeInsets.fromLTRB(2, 0, 0, 8),
                            child: Text(
                              article.category.toString(),
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 8,
                                  fontWeight: FontWeight.w700),
                            ),
                          ),
                        ),

                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(125, 143, 0,0),
          child: Container(
            child: Row(
              children: <Widget>[
                Icon(
                  Icons.timer,
                  color: Colors.black45,
                  size: 12.0,
                ),
                SizedBox(
                  width: 4,
                ),
                Text(
                  article.date.toString(),
                  style: Theme.of(context).textTheme.caption,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(55, 0,0,0),
                  child: IconButton(
                    icon: Icon(Icons.share, color: Colors.black45, size: 20.0),
                    onPressed: () {
                      Share.share(article.link.toString());
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        // Padding(
        //   padding: const EdgeInsets.fromLTRB(280, 150, 0, 0),
        //   child: IconButton(
        //     icon: Icon(Icons.share, color: Colors.black45, size: 25.0),
        //     onPressed: () {
        //       Share.share(article.link.toString());
        //     },
        //   ),
        // ),
  //       article.video != ""
  //           ? Positioned(
  //               left: 18,
  //               top: 18,
  //               child: Card(
  //                 child: CircleAvatar(
  //                   radius: 14,
  //                   backgroundColor: Colors.transparent,
  //                   child: Image.asset("assets/play-button.png"),
  //                 ),
  //                 elevation: 18.0,
  //                 shape: CircleBorder(),
  //                 clipBehavior: Clip.antiAlias,
  //               ),
  //             )
  //           : Container()
  //     ],
  //   ),
  // )
  // )
  // )
  ]
  ));
}
