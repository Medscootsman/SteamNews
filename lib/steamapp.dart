import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
class SteamItem {
  int id;
  List<Article> newsitems;
  int count;

  SteamItem({this.id, this.newsitems, this.count});

  Future<http.Response> fetchTF2() async {
    final response =
        await http.get("http://api.steampowered.com/ISteamNews/GetNewsForApp/v0002?appid=440");

        if(response.statusCode == 200) {
          print("200 GET CONFIRMED");

          //Decode them into a map
          Map<String, dynamic> vals = json.decode(response.body);

          //add base attributes
          var appid = vals['appnews']['appid'];
          this.id = appid;
          
          this.newsitems = new List<Article>();

          var count =vals['appnews']['count'];
          this.count = count;

          //test to see if there's items
          //print(vals['appnews']['newsitems'][0]);

          //loop through all newsitems and create article objects.
          for(Map article in vals['appnews']['newsitems']) {
            Article newArticle = new Article();

            //doing this the property way cuz.

            newArticle.gid = int.parse(article['gid']);
            newArticle.title = article['title'];
            newArticle.url = article['url'];

            //boolean shenanigans. use a var to sorta guess what it is. bit shaky.
            var urlbool = article['is_external_url'];

            newArticle.is_External_Url = urlbool;

            newArticle.contents = article['contents'];

            this.newsitems.add(newArticle);

            print(newArticle.gid.toString() + " was added. The title is " + newArticle.title);

          }

        } else {
          print("ERROR: " + response.statusCode.toString());
        }
  }
}
class Article {
  int gid;
  String title;
  String url;
  bool is_External_Url;
  String contents;

}

void main() {
  SteamItem Item = new SteamItem();

  Item.fetchTF2();
}