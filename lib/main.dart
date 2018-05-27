import 'package:flutter/material.dart';
import 'FetchLinks.dart';
import 'package:url_launcher/url_launcher.dart';

import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

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

class CategoryRoute extends StatefulWidget {

  const CategoryRoute();

  @override
  _CategoryRouteState createState() => _CategoryRouteState();

}

class _CategoryRouteState extends State<CategoryRoute> {

  final api = Api();
  var _posts = <Link>[];

  Choice _selectedChoice = choices[0]; // The app's "state".

  @override
  void initState() {
    super.initState();

    _posts.add(new Link(99, 'titlesdfsdfsdfsdfsdfdddddddddddddddddddddfgsdfgdfgsdfgdfg plz wrap', 'site', 132, 'asb', 51231, 'pinkOcto', 'https://google.com'));
  }




  void _select(Choice choice) {
    setState(() {
      _selectedChoice = choice;
    });
  }

  void _openLink() {
  }

  void _darkTheme(BuildContext context) async {
    // obtain shared preferences
    final prefs = await SharedPreferences.getInstance();

    // set new value
    prefs.setInt('darkTheme', 1);

    Theme.of(context).textTheme.apply(
      bodyColor: Colors.black,
      displayColor: Colors.grey[600],
    );

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new Scaffold(
        appBar: new AppBar(
          title: const Text('Reddit on Flutter'),
            actions: <Widget>[
              new IconButton(
                icon: new Icon(choices[1].icon),
                onPressed: () async {
                  final links = await api.fetch() ;

                  setState(() {
                    _posts = links;
                  });

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
        body: new ListView.builder(
          itemBuilder: (BuildContext context, int index) =>
          new EntryItem(_posts[index], this),
          itemCount: _posts.length,
        ),
      ),
    );
  }
}

// One entry in the multilevel list displayed by this app.
class Entry {
  Entry(this.title, [this.score = 0]);

  final String title;
  final int score;
}

// The entire multilevel list displayed by this app.
List<Entry> data = <Entry>[
  new Entry(
    'This is a test post',
  ),
  new Entry(
    'Chapter B',
  ),
  new Entry(
    'Chapter C',
  ),
];

/*
Icon(Icons.font_download, size: 60.0),
Icon(Icons.http, size: 60.0),
Icon(Icons.movie, size: 60.0),
Image.asset()
Image.file()
Image.network( width, fit BoxFit.fitWidth)
surround with aspectRatio
* */

// Displays one Entry. If the entry has children then it's displayed
// with an ExpansionTile.
class EntryItem extends StatelessWidget {
  const EntryItem(this.l, this.crt);

  final Link l;
  final _CategoryRouteState crt;

  Widget _buildTiles(Link root, BuildContext context) {
    //return new ListTile(title: new Text(root.title));

    return GestureDetector(
        onHorizontalDragStart: (DragStartDetails d) {
          print("dragStart");
          },
      onHorizontalDragEnd: (DragEndDetails d) async {
        print("dragEnd");

        /*
        final api = crt.api;
        final links = await api.fetch() ;

        crt.setState(() {
          crt._posts = links;
        });


        crt.setState( () {
          var newPosts = crt._posts;
          newPosts.add(new Entry('This is a new entry'));
          crt._posts = crt._posts;
        }
        );


        crt.setState( () {
          var newPosts = crt._posts;
          newPosts.add(new Link('titlesdfsdfsdfsdfsdfdddddddddddddddddddddfgsdfgdfgsdfgdfg plz wrap', 'site', 132, 'pickOcto', 51231, 'asb'));
          crt._posts = crt._posts;
        }
        );
        */


      },

      child :
      Row(children: [
      Column(children: [
        Icon(Icons.arrow_upward),
        Text(l.score.toString()),//l.score.toString()
        Icon(Icons.arrow_downward)
      ]),
    InkWell(
    splashColor: Colors.deepOrange,
    highlightColor: Colors.deepPurple,
    onTap: () {
    print('openLink');
    _navigateToLink(l.url);
    },
    child:
      Icon(Icons.font_download, size: 60.0),
    ),

    new Flexible( child:
      Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              splashColor: Colors.deepOrange,
              highlightColor: Colors.deepPurple,
              onTap: () {
                print('tap2!');
                _navigateToComments(context);
              },

              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(l.title + ' (' + l.domain + ')', style: new TextStyle(fontWeight: FontWeight.bold),),//Text('<title> (<site>)'),
                    Text(Utils.getTimeSincePost(l.created_utc)+ ' ago by ' + l.author)//Text('<hrs> ago by (<user>)')
                  ]),

            )
            ,
            Text(l.num_comments.toString() + ' ' + '💬' + ' ' + l.subreddit)//Text('<cmts> (<sub>)')
          ]))
    ]
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildTiles(l, context);
  }
}

void _navigateToComments(BuildContext context) {
  if (Navigator.of(context).canPop()) {
    Navigator.of(context).pop();
  }

  Navigator
      .of(context)
      .push(MaterialPageRoute<Null>(
      builder: (BuildContext context) {
        return
          MaterialApp(
          home : Scaffold(
            appBar:
            AppBar(
                elevation: 1.0,
                title: Text('test', style: Theme
                    .of(context)
                    .textTheme
                    .display1),
                centerTitle: true,
                backgroundColor: Colors.green,
                //
            ),
              body: Column(
                children: <Widget>[
                  InkWell (
                      onTap: () {
                        print("pressed");
                      },
                      child: Text('Hi')
                  ),
                  TextField(keyboardType: TextInputType.text,)
                ],
              )

          ),

          );
      }
  ));
}

void _navigateToLink(url) async {
  //const url = 'https://flutter.io';
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

void _navigateToImage(BuildContext context) {
  if (Navigator.of(context).canPop()) {
    Navigator.of(context).pop();
  }

  Navigator
      .of(context)
      .push(MaterialPageRoute<Null>(
      builder: (BuildContext context) {
        return
          Image.asset('food.jpg');
      }
  ));
}

void main() {
  runApp(new CategoryRoute());
}


/*
MaterialApp
theme : ThemeData
fontFamily
textTheme Theme.of(context).textTheme.apply(
bodyColor:
displayColor
)
* */