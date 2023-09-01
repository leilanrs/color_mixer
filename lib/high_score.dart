import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HighScore extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HighScoreState();
  }
}

class _HighScoreState extends State<HighScore>{

  late String _topUser1="";
  late int _topScore1=0;
  late String _topUser2="";
  late int _topScore2=0;
  late String _topUser3="";
  late int _topScore3=0;

  Future<void> getHighScore() async {
    late final rank1;
    late final rank2;
    late final rank3;
    rank1 = await SharedPreferences.getInstance();
    rank2 = await SharedPreferences.getInstance();
    rank3 = await SharedPreferences.getInstance();
    setState(() {
      _topUser1 = (rank1.getString("top_user1") ?? 'User1');
      _topScore1 = (rank1.getInt("top_score1") ?? 0);
      _topUser2 = (rank2.getString("top_user2") ?? 'User2');
      _topScore2 = (rank2.getInt("top_score2") ?? 0);
      _topUser3 = (rank3.getString("top_user3") ?? 'User3');
      _topScore3 = (rank3.getInt("top_score3") ?? 0);
    });
  }

  @override
  void initState() {
    getHighScore();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("High Score"),
      ),
      body: SingleChildScrollView(
        child: ListView(
        shrinkWrap: true,
        padding: const EdgeInsets.all(20.0),
        children: <Widget>[
          const Padding(
            padding: EdgeInsets.all(20),
            child: Text(
              "HIGH SCORES",
              style: TextStyle(fontSize: 26),textAlign: TextAlign.center,
            ),
          ),
          Card(elevation: 10.0,
            child: ListTile(
              leading: Image.asset(
                "assets/images/1.png",
              ),
              title: Text(_topUser1, style: TextStyle(fontSize: 18)),
              subtitle: Text(_topScore1.toString(), style: TextStyle(fontSize: 16)),
            ),
          ),
          Card(
            elevation: 10.0,
            child: ListTile(
              leading: Image.asset(
                "assets/images/2.png",
              ),
              title: Text(_topUser2, style: TextStyle(fontSize: 18)),
              subtitle: Text(_topScore2.toString(), style: TextStyle(fontSize: 16)),
            ),
          ),
          Card(
            elevation: 10.0,
            child: ListTile(
              leading: Image.asset(
                "assets/images/3.png",
              ),
              title: Text(_topUser3, style: TextStyle(fontSize: 18)),
              subtitle: Text(_topScore3.toString(), style: TextStyle(fontSize: 16)),
            ),
          ),
        ],
      )
      ),
    );
  }
}
