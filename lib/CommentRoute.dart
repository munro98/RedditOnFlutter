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
  const Choice(title: 'Car', icon: Icons.directions_car),
  const Choice(title: 'Refresh', icon: Icons.refresh),
  const Choice(title: 'Boat', icon: Icons.directions_boat),
  const Choice(title: 'Bus', icon: Icons.directions_bus),
  const Choice(title: 'Train', icon: Icons.directions_railway),
  const Choice(title: 'Walk', icon: Icons.directions_walk),
];


class CommentRoute extends StatefulWidget {

  const CommentRoute();

  @override
  CommentRouteState createState() => CommentRouteState();

}

class CommentRouteState extends State<CommentRoute> {

  final api = Api();
  //var _comments = <Comment>[];
  var _comments = <Comment>[new Comment(65, 'This is a test comments', 0, 'pinkOcto', false), new Comment(78, 'This is anorher test comment', 0, 'pinkOcto', false)];
  var _subs = <String>['all', 'popular', 'AskReddit', 'worldnews'];

  Choice _selectedChoice = choices[0]; // The app's "state".

  @override
  void initState() {
    super.initState();

    _comments = <Comment>[new Comment(65, 'This is a test comments', 0, 'pinkOcto', false), new Comment(78, 'This is anorher test comment', 0, 'pinkOcto', false)];

    //print( " initState" + _comments.length.toString());
    //TODO fix me
  }

  void _select(Choice choice) {
    setState(() {
      _selectedChoice = choice;
    });
  }

  void _openLink() {
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new Scaffold(

        drawer:

        new Drawer(

          //child: new Padding(
          //    padding: new EdgeInsets.only(top: MediaQuery.of(context).padding.top),
            child: TextField(
              keyboardType: TextInputType.text,
              style: Theme.of(context).textTheme.display1,
              onChanged: (s) {

              },
              onSubmitted: (s) {

              },
            )//Text('test')

          //)
        ),

        appBar: new AppBar(
            title: const Text('Reddit on Flutter'),
            actions: <Widget>[
              new IconButton(
                icon: new Icon(choices[1].icon),
                onPressed: () async {

                  ///*
                  final comments = await api.fetchComments() ;

                  setState(() {
                    _comments = comments;
                    //_comments = <Comment>[new Comment(65, 'ghjkghjkhgjkghjk', 0, 'pinkOcto', false),
                    //new Comment(78, 'hjkhjkhjkhjkhjk', 0, 'pinkOcto', false)];
                  });
                  //*/

                },
              ),new IconButton(
                icon: new Icon(Icons.short_text),
                onPressed: () async {
                  //Utils.testFunc();

                },
              ),
              new PopupMenuButton<Choice>(
                onSelected: _select,
                itemBuilder: (BuildContext context) {
                  return choices.skip(2).map((Choice choice) {
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
      ),
    );
  }
}



class CommentItem extends StatelessWidget {
  const CommentItem(this.c, this.crt);

  final Comment c;
  final CommentRouteState crt;

  Widget _buildTiles(Comment root, BuildContext context) {

    return GestureDetector(
        onHorizontalDragStart: (DragStartDetails d) {
          print("dragStart");
        },
        onHorizontalDragEnd: (DragEndDetails d) async {
          print("dragEnd");

        },

        child :
        Row(children: [
          Column(children: [
            Icon(Icons.arrow_upward),
            Text(c.score.toString()),
            Icon(Icons.arrow_downward)
          ]),

          new Flexible( child:
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
                        Text( (c.author + ' ' + Utils.getTimeSincePost(c.created_utc) + 'ago') )
                        ,
                      ])),

                )
                ,
                Text(c.body)
              ]))
        ]
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildTiles(c, context);
  }
}