import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'CommentRoute.dart';
import 'FetchLinks.dart';
import 'Utils.dart';

/*

TODO

 * Load additional posts beyond the first page
 * Logging into reddit account
 * Be able to vote on posts and comments
 * Load deeply nested comments
 * Add button to load deeply nested comments
 * Be able to customize subreddits to broswe and save them


 */

class Choice {
  const Choice({this.title, this.icon});

  final String title;
  final IconData icon;
}

const List<Choice> choices = const <Choice>[
  const Choice(title: 'Button1', icon: Icons.directions_car),
  const Choice(title: 'Button2', icon: Icons.directions_boat),
  const Choice(title: 'Button3', icon: Icons.directions_bus),
];

class CategoryRoute extends StatefulWidget {
  const CategoryRoute();

  @override
  _CategoryRouteState createState() => _CategoryRouteState();
}

class _CategoryRouteState extends State<CategoryRoute> {

  List<Link> _posts = <Link>[];
  String currentSub = 'all';
  Choice _selectedChoice = choices[0]; // The app's "state".
  String sortOrder = 'best';

  @override
  void initState() {
    super.initState();

    _posts.add(new Link(99, 'This is a test post', 'google.com', 1337, 'asb', 0,
        'The developer', 'https://google.com', null, null));

    print(" initState" + _posts.length.toString());
  }

  void _select(Choice choice) {
    setState(() {
      _selectedChoice = choice;
    });
  }

  void _openLink() {}


  void refresh() async {

    final links = await Api.fetch(currentSub, sortOrder);

    setState(() {
      _posts = links;
    });

  }

  void _darkTheme(BuildContext context) async {
    // obtain shared preferences
    final prefs = await SharedPreferences.getInstance();

    // set new value
    prefs.setInt('darkTheme', 1);

    //prefs.setStringList(key, value)

    Theme.of(context).textTheme.apply(
          bodyColor: Colors.black,
          displayColor: Colors.grey[600],
        );

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return new DefaultTabController(
        length: 3,
        child: new Scaffold(
      drawer: new Drawer(

          //child: new Padding(
          //    padding: new EdgeInsets.only(top: MediaQuery.of(context).padding.top),
          child:
          Container(
              //height: MediaQuery.of(context).size.height,
              child:

              new ListView.builder(

                //padding: new EdgeInsets.all(8.0),
                itemExtent: 40.0,
                itemCount: Utils.subs.length,
                itemBuilder: (BuildContext context, int index) {
                  return new SubbRedditButton(Utils.subs[index], this);
                },
              )






          )
      ),
      appBar:
          new AppBar(
              title: const Text('Reddit on Flutter'),
              bottom: new PreferredSize(
                preferredSize: const Size.fromHeight(48.0),
                child: new Theme(
                  data: Theme.of(context).copyWith(accentColor: Colors.white),
                  child: new Container(
                    height: 48.0,
                    alignment: Alignment.center,
                    child:
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        new Expanded( child: InkWell ( child: Center(child: Text('Best'),), onTap:() {sortOrder = 'best'; refresh(); } ,)),
                        new Expanded( child: InkWell ( child: Center(child: Text('Hot'),), onTap: () {sortOrder = 'hot'; refresh();   } ,)),
                        new Expanded( child: InkWell ( child: Center(child: Text('New'),), onTap: () {sortOrder = 'new'; refresh();   })),
                        new Expanded( child: InkWell ( child: Center(child: Text('Top'),), onTap: () {sortOrder = 'top'; refresh();   })),

                      ],
                    )

                    ,
                  ),
                ),
              ),
              actions: <Widget>[
        new IconButton(
          icon: new Icon(Icons.refresh),
          onPressed: () async {

            refresh();

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
      ]),
      body: new ListView.builder(
        itemBuilder: (BuildContext context, int index) =>
            new EntryItem(_posts[index], this),
        itemCount: _posts.length,
      ),
    ));
  }
}

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

        },
        child: Row(children: [
          new Align(
            alignment: Alignment.topLeft,
            child: Column(children: [
              Icon(Icons.arrow_upward),
              Text(l.score.toString()), //l.score.toString()
              Icon(Icons.arrow_downward)
            ]),
          ),
          InkWell(
            splashColor: Colors.deepOrange,
            highlightColor: Colors.deepPurple,
            onTap: () {
              print('openLink');
              _navigateToLink(l.url);
            },
            child:
            new Align(
              alignment: Alignment.topLeft,
            child:
            l.thumbnail != null && l.thumbnail != '' ?
            new Image.network(l.thumbnail, fit: BoxFit.fitWidth, width: 60.0,) :
            Icon(Icons.message, size: 60.0) , // Icons.font_download Icons.link
            )

          ),
          new Flexible(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                InkWell(
                  splashColor: Colors.deepOrange,
                  highlightColor: Colors.deepPurple,
                  onTap: () {
                    print('tap2!');
                    _navigateToComments(context, l.permalink);
                  },
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l.title + ' (' + l.domain + ')',
                          style: new TextStyle(fontWeight: FontWeight.bold),
                        ),
                        //Text('<title> (<site>)'),
                        Text(Utils.getTimeSincePost(l.created_utc) +
                            ' ago by ' +
                            l.author) //Text('<hrs> ago by (<user>)')
                      ]),
                ),
                Text(l.num_comments.toString() +
                    ' ' +
                    '💬' +
                    ' ' +
                    l.subreddit) //Text('<cmts> (<sub>)')
              ]))
        ]));
  }

  @override
  Widget build(BuildContext context) {
    return _buildTiles(l, context);
  }
}

/*
void _navigateToComments(BuildContext context) {
  if (Navigator.of(context).canPop()) {
    Navigator.of(context).pop();
  }

  Navigator
      .of(context)
      .push(MaterialPageRoute<Null>(
      builder: (BuildContext context) {
        return new CommentRouteState().build(context);

      }

  ));
}
*/
void _navigateToComments(BuildContext context, String permalink) {

  if (permalink != null) {

    Navigator.push(
      context,
      new MaterialPageRoute(builder: (context) => new CommentRoute(permalink : permalink)),
    );

  }

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
      .push(MaterialPageRoute<Null>(builder: (BuildContext context) {
    return Image.asset('food.jpg');
  }));
}


class SubbRedditButton extends StatelessWidget {

  const SubbRedditButton(this.sub, this.crState);

  final String sub;
  final _CategoryRouteState crState;

  @override
  Widget build(BuildContext context) {
    return InkWell(
          onTap: () async {

            crState.setState(
                    () {
              crState.currentSub = sub;
            }
            );
            crState.refresh();
            print(crState.currentSub);

          },
        child:
      new Container(
        //margin: EdgeInsets.,
      child:
        Text(
            sub,
            style: new TextStyle(fontSize: 32.0)
        )
      )
      ,
    );
  }
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Title',
      //theme: kThemeData,
      home: CategoryRoute(),
      //home: HomePage(),
    );
  }
}

void main() {
  //runApp(new CategoryRoute());
  runApp(new App());
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
