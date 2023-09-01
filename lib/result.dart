import 'dart:async';

import 'package:color_mixer/high_score.dart';
import 'package:color_mixer/main.dart';
import 'package:flutter/material.dart';
import 'package:color_mixer/game.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Result extends StatefulWidget {
  late int finalScore;
  late int totalTime;
  late int colorMixed;
  late int aveGuess;
  late int hintUsed;
  Result(this.finalScore, this.totalTime, this.colorMixed, this.aveGuess, this.hintUsed);
  
  @override
  State<StatefulWidget> createState() {
    return _ResultState();
  }
}

class _ResultState extends State<Result> {
  bool animated = false;
  late Timer _timer;

  late String _topUser1;
  late int _topScore1;
  late String _topUser2;
  late int _topScore2;
  late String _topUser3;
  late int _topScore3;

  late final rank1;
  late final rank2;
  late final rank3;

  Future<void> checkHighScore() async {
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
      
      if (widget.finalScore > _topScore1) {
        rank1.setString("top_user1", activeUser);
        rank1.setInt("top_score1", widget.finalScore);
        rank2.setString("top_user2", _topUser1);
        rank2.setInt("top_score2", _topScore1);
      } else if (widget.finalScore > _topScore2) {
        rank2.setString("top_user2", activeUser);
        rank2.setInt("top_score2", widget.finalScore);
        rank3.setString("top_user3", _topUser2);
        rank3.setInt("top_score3", _topScore2);
      } else if (widget.finalScore > _topScore3) {
        rank3.setString("top_user3", activeUser);
        rank3.setInt("top_score3", widget.finalScore);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        animated = !animated;
      });
    });
    checkHighScore();

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Result Screen"),
          automaticallyImplyLeading: false,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            // mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              AnimatedDefaultTextStyle(
                style: animated
                    ? const TextStyle(
                        color: Colors.black,
                        fontSize: 36,
                      )
                    : const TextStyle(
                        color: Colors.black,
                        fontSize: 32,
                      ),
                duration: const Duration(milliseconds: 1000),
                child: Center(child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Text(
                      "Final Score: ${widget.finalScore}",
                    ),
                  ),
                ),
              ),
              Text(
                "Total time played:${formatTime(widget.totalTime)}",
                style: TextStyle(fontSize: 18),
              ),
              Text(
                "Color mixed: ${widget.colorMixed}",
                style: TextStyle(fontSize: 18),
              ),
              Text(
                "Average guesses: ${widget.aveGuess}",
                style: TextStyle(fontSize: 18),
              ),
              Text(
                "Hints used: ${widget.hintUsed}",
                style: TextStyle(fontSize: 18),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => Game(),
                      ),
                    );
                  },
                  child: const Text("PLAY AGAIN"),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => HighScore(),
                      ),
                    );
                  },
                  child: const Text("HIGH SCORES"),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => const MyApp(),
                      ),
                    );
                  },
                  child: const Text("MAIN MENU"),
                ),
              ),
            ],
          ),
        ));
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _timer.cancel();
  }

  String formatTime(int waktu) {
    String jam = (waktu ~/ 3600).toString().padLeft(2, "0");
    String menit = ((waktu % 3600) ~/ 60).toString().padLeft(2, "0");
    String detik = (waktu % 60).toString().padLeft(2, "0");
    return "$jam:$menit:$detik";
  }
}
