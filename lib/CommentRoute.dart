import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';


import 'FetchLinks.dart';
import 'Utils.dart';

class Choice {
  const Choice({this.title, this.icon});

  final String title;
  final IconData icon;
}

const List<Choice> choices = const <Choice>[
  const Choice(title: 'best'),
  const Choice(title: 'hot'),
  const Choice(title: 'top'),
  const Choice(title: 'new'),
  const Choice(title: 'controversial'),
];


class CommentRoute extends StatefulWidget {

  final String permalink;

  const CommentRoute({
    @required this.permalink,
  }) : assert(permalink != null);

  //const CommentRoute(this.permalink);

  @override
  CommentRouteState createState() => CommentRouteState();

}

class CommentRouteState extends State<CommentRoute> {

  List<Comment> _comments;
  String permalink;
  String sortOrder = "best";

  @override
  void initState() {
    super.initState();

    _comments = <Comment>[new Comment(1, 'Looks like the comments did not load.', 0, 'TheDeveloper', false, new List<Comment>())];
    _comments[0].children.add(new Comment(1, 'Child comment', 0, 'TheDeveloper', false, new List<Comment>()));

    _comments[0].children.add(new Comment(1, 'Child comment', 0, 'TheDeveloper', false, new List<Comment>()));


    if (widget.permalink != null) {
      Api.fetchComments(widget.permalink, sortOrder).then((result)
      {
      setState(() {
      _comments = result;
      });
      }
      );
    }



    //_loadComments();


  }

  void _select(Choice choice) {

    setState(() {
      sortOrder = choice.title;
    });

    _loadComments();
  }

  void _loadComments() async {

    final comments = await Api.fetchComments(widget.permalink, sortOrder);
    setState(() {
      _comments = comments;
    });

  }


  void _openLink() {
  }

  @override
  Widget build(BuildContext context) {
    return
      new Scaffold(
        appBar: new AppBar(
            title: const Text('Reddit on Flutter'),
            actions: <Widget>[
              new IconButton(
                icon: new Icon(Icons.refresh),
                onPressed: () async {

                  _loadComments();
                },
              ),
              new PopupMenuButton<Choice>(
                onSelected: _select,
                itemBuilder: (BuildContext context) {
                  return choices.map((Choice choice) {
                    return new PopupMenuItem<Choice>(
                      value: choice,
                      child: new Text(choice.title),
                    );
                  }).toList();
                },
              )

            ]

        ),


        body: //const Text('Reddit on Flutter')

        new ListView.builder(
          itemBuilder: (BuildContext context, int index) =>
          //new Text('Reddit on Flutter'),
          new CommentItem(_comments[index],this),
          itemCount: _comments.length,//_comments.length,
        )

        ,
      )
    ;
  }
}



class CommentItem extends StatelessWidget {
  const CommentItem(this.c, this.crt);

  final Comment c;
  final CommentRouteState crt;

  Widget _buildTiles(Comment root) {

    if (root.children.isEmpty) {
      return _buildSingle(root);
    }

    else {
      return
        /*
        new Column(
          children: [
            Text('tes'),
        new Column(
        children: [Text('tes')],
        )
          ],
        );
        */

        new Column(
          /*
          children: ((root) {
            List<Widget> result = [_buildSingle(root)];
            for (Widget value in root.children.map(_buildTiles).toList() ) {
            result.add(value);
            }
           return result;
          }
        )(root)
        */
          children: f(root)
        )


      ;


    }
  }

  Iterable<Widget> f (root) {
    List<Widget> result = [_buildSingle(root)];
    for (Widget value in root.children.map(_buildTiles).toList() ) {
      result.add(
        Padding(
          padding: new EdgeInsets.only(left: 10.0),
          child: value
        )

      );
    }
    return result;
  }

  Widget _buildSingle(Comment root) {

      return GestureDetector(
          onHorizontalDragStart: (DragStartDetails d) {
            print("dragStart");
          },
          onHorizontalDragEnd: (DragEndDetails d) async {
            print("dragEnd");
          },

          child:
          Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

            Align(
                alignment: Alignment.topLeft,
                child:
                Column(children: [
                  Icon(Icons.arrow_upward),
                  Text(root.score.toString()),
                  Icon(Icons.arrow_downward)
                ]
                )

            ),

            new Flexible(child:
            Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InkWell(
                    splashColor: Colors.deepOrange,
                    highlightColor: Colors.deepPurple,
                    onTap: () {
                      print('tap2!');
                      //_navigateToComments(context);
                    },

                    child: Align(alignment: Alignment.topLeft,
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,

                            children: [

                              //child:
                              Text((root.author + ' ' +
                                  Utils.getTimeSincePost(root.created_utc) +
                                  ' ago'),
                                style: new TextStyle(fontWeight: FontWeight.bold),

                              )
                              ,
                            ])),

                  )
                  ,
                  Text(root.body)
                ]))
          ]
          )
      );

  }

  @override
  Widget build(BuildContext context) {
    return _buildTiles(c);
  }
}