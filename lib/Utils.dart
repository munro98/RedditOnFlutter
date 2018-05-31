import 'dart:math';

import 'package:shared_preferences/shared_preferences.dart';

class Utils {

  //static List<String> subs = <String>['all', 'popular', 'AskReddit', 'worldnews'];

  static List<String> subs = <String>['all', 'popular', 'AskReddit', 'worldnews','videos','todayilearned','pics','gaming','movies','news','gifs','mildlyinteresting','aww','Showerthoughts','television','Jokes','Jokes','science','sports','explainlikeimfive'];

  static List<String> cat = <String>['best', 'hot', 'new', 'top','controversial']; // best hot new saved top controversial rising gilded



  static String getTimeSincePost(created_utc) {
    //var created_utc = 1493216909;
    final currentUTC = new DateTime.now().millisecondsSinceEpoch / 1000;

    final secsAgo = ((currentUTC - created_utc) ).floor();
    final minsAgo = (secsAgo / 60).floor();

    //print('s'+secsAgo.toString());
    //print('m'+minsAgo.toString());

    var result = '0 mins';

    if (minsAgo >= 60 ) {
      final hrsAgo = (minsAgo / 60).floor();

      if (hrsAgo >= 24) {
        final daysAgo = (hrsAgo / 24).floor();

        if (daysAgo >= 7) {
          final weeksAgo = (daysAgo / 7).floor();

          if (weeksAgo >= 4) {
            final monthsAgo = (daysAgo / 30).floor();

            if (monthsAgo >= 12) {
              final yearsAgo = (daysAgo / 365).floor();

              result = yearsAgo.toString() + ' yrs';
            } else
            result = monthsAgo.toString() + ' mnths';
          } else
          result = weeksAgo.toString() + ' wks';
        } else
        result = daysAgo.toString() + ' days';
      }
      else
        result = hrsAgo.toString() + ' hrs';
    } else
      result = minsAgo.toString() + ' mins';

    //print('res'+result);
    //print('res'+secsAgo.toString());
    return result;
  }


  static void addSubReddits(String sub) async {
    subs.add(sub);
  }

  static void removeSubReddits(String sub) async {
    subs.removeAt(subs.indexOf(sub));
  }

  static void saveSubReddits() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList('sub_reddits', subs);
  }

  static void loadSubReddits() async {
    final prefs = await SharedPreferences.getInstance();
    subs = prefs.getStringList('sub_reddits');
  }


}