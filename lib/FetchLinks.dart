import 'package:flutter/material.dart';

import 'dart:async';
import 'dart:convert' show json, utf8;
import 'dart:io';


enum Kind {
  pad, comment, account, link, message, subbreddit, award
}

final List<String> kindPrefixes = ['t1_', 't2_', 't3_', 't4_','t5_','t6_'];
final List<String> kindPrefixesName = ['Comment', 'Account', 'Link', 'Message','Subreddit','Award'];

enum SubStatus {
  blank, checked, starred
}

final List<IconData> SubStatusIcons = [Icons.check_box_outline_blank ,Icons.check_box, Icons.star];

class Sub {
  Sub(this.title, this.subStatus);

  final title;
  final subStatus;

}

class Link {
  Link(this.score, this.title, this.domain, this.num_comments, this.subreddit, this.created_utc, this.author, this.url);

  final score;
  final title;
  final domain; // e.g youtu.be
  final num_comments; // e.g 5
  final subreddit; // e.g pcgaming
  final created_utc; // e.g 1527263886
  final author; // e.g pinkOcto

  final url;

  //final gold; //gilded

  //locked
  //stickied
  //spoiler
  //thumbnail
  //over_18

}




class Comment {
  Comment(this.score, this.body, this.created_utc, this.author, this.edited);

  final score;
  final body;
  final created_utc; // e.g 1527263886
  final author; // e.g pinkOcto
  final edited;

  List <Comment> children;
}




class LinkAndComments {
  Link link;
  Comment comment;
}


class Api {
  final Client = HttpClient();

  final url = 'www.reddit.com';

  Future<List<Link>> fetch () async {

    print("fetching");

    //final uri = Uri.https(url, '/$category/convert', {'amount': amount, 'from' : fromUnit, 'to': toUnit});
    //final uri = Uri.https(url, '/$category/convert', {'amount': amount, 'from' : fromUnit, 'to': toUnit});
    Client.userAgent = "testApp";

    final uri = Uri.https(url, '/r/pcgaming/new.json', {'sort': 'new'}); // new hot top best rising controversial gilded

    ///*
    final httpRequest = await Client.getUrl(uri);
    final httpResponse = await httpRequest.close();

    if (httpResponse.statusCode != HttpStatus.OK) {
      return null;
    }

    final responseBody = await httpResponse.transform(utf8.decoder).join();
    final jsonResponse = json.decode(responseBody);

    List<Link> links = <Link>[];

    print(jsonResponse['data']['children'][0]['data']['title']);
    print(jsonResponse);

    //for (int i = 0; i < jsonResponse['data']['children'].length(); i++) {
    for (var d in jsonResponse['data']['children']) {

      var lData = d['data'];
      var link = new Link(lData['score'], lData['title'], lData['domain'],
          lData['num_comments'], lData['subreddit'],
          lData['created_utc'], lData['author'], lData['url']);
      links.add(link);
    };
    //}
    //json.

    /*
    var lData = jsonResponse['data']['children'][0]['data'];
    var link = new Link(lData['title'], lData['domain'],
        lData['num_comments'], lData['subreddit'],
        lData['created_utc'], lData['author']);
    links.add(link);
    */

    //}
    //print(data['data']['children'][i]['data']['title']  + ' (' + data['data']['children'][i]['data']['domain'] +')')
    //print();

    //return jsonResponse['conversion'].toDouble();
    //return jsonResponse['conversion'].toDouble();
    //*/
    return links;

  }




  Future<List<Comment>> fetchComments () async {

    // best top new controversial old q&a

    print("fetching comments");
    Client.userAgent = "testApp";

    //'sort': 'new'
    final uri = Uri.https(url, '/r/opengl/comments/8myqys/normals_of_a_heightmap_terrain/.json', {}); // new hot top best rising controversial gilded

    final httpRequest = await Client.getUrl(uri);
    final httpResponse = await httpRequest.close();

    if (httpResponse.statusCode != HttpStatus.OK) {
      return null;
    }

    final responseBody = await httpResponse.transform(utf8.decoder).join();
    final jsonResponse = json.decode(responseBody);

    List<Comment> comments = <Comment>[];

    //print(jsonResponse['data']['children'][0]['data']['title']);
    //print(jsonResponse);

    for (var d in jsonResponse[1]['data']['children']) {
      final String kind = d['kind'];

      if (kindPrefixes.indexOf(kind) != Kind.comment) {
      }


      var lData = d['data'];
      Comment comment = new Comment(lData['score'], lData['body'], lData['created_utc'], lData['author'], lData['edited']);
      comments.add(comment);
      //print(lData['body']);
    };

    return comments;

  }
}