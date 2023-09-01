import 'dart:async';
// import 'dart:ffi';
import 'dart:math';
import 'package:color_mixer/result.dart';
import 'package:flutter/services.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:flutter/material.dart';


class Game extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _GameState();
  }
}

class _GameState extends State<Game> {
  TextEditingController _redController = TextEditingController();
  TextEditingController _greenController = TextEditingController();
  TextEditingController _blueController = TextEditingController();

  int _hitung = 0;
  final int _WAKTU_MAX = 255;
  bool _isRunning = true;
  late Timer _timer;
  late int _totalTime =0;

  late int _rs;
  late int _gs;
  late int _bs;

  int _rp = 255;
  int _gp = 255;
  int _bp = 255;

  var d =0;
  String msg ="";

  late Color tempcol;
  late Color usercol;

  int _jumHint=0;
  bool _isHintActive=true;
  String _hintText="";
  String _userColText="";

  int _numGuess=0;
  int _numGuessPerQues = 0;

  int _guessMultiplier=0;
  double _hintMultiplier=1;
  int _score = 0;

  int _colorMixed=0;

  genrandomSoal(){
    _rs = Random().nextInt(255);
    _gs = Random().nextInt(255);
    _bs = Random().nextInt(255);
    tempcol = Color.fromRGBO(_rs, _gs, _bs, 1);
    print("$_rs $_gs $_bs");
    print(tempcol);
    _colorMixed++;

    usercol = Color.fromRGBO(_rp, _gp, _bp, 1);
    _userColText="#"+usercol.toString().substring(10, 16).toUpperCase();
    // print(usercol);
  }

  @override
  void initState() {
    genrandomSoal();

    super.initState();
    _redController.text = "";
    _greenController.text = "";
    _blueController.text = "";
    _hitung = _WAKTU_MAX;
    // buat sebuah periodic timer
    _timer = Timer.periodic(Duration(milliseconds: 1000), (timer) {
      setState(() {
        if (_isRunning) {
          _hitung--;
          if (_hitung <= 0) {
            // reset timer
            // _hitung = _WAKTU_MAX;
            gameOver();
          }
        }
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _hitung = 0;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: const Text('Color Mixer'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            _isRunning = !_isRunning;
            showDialog(
              context: context, 
              builder: (BuildContext builder) => AlertDialog(
                title: const Text("Pause",textAlign: TextAlign.center,),
                actions: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      _isRunning=!_isRunning;
                    },
                    child: const Text("CONTINUE")
                  ),
                  ElevatedButton(
                    onPressed: () {
                      gameOver();
                    },
                    child: const Text("GIVE UP")
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.push(context, MaterialPageRoute(builder: (context) => Game()));
                    },
                    child: const Text("RESTART")
                  ),
                ],
              ),
            );
          },
        ),
      ),
      body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
            LinearPercentIndicator(
              width: MediaQuery.of(context).size.width,
              lineHeight: 24,
              percent: _hitung / _WAKTU_MAX,
              center: Text(
                formatTime(_hitung),
              ),
              progressColor: tempcol,
            ),
            Padding(
                padding: const EdgeInsets.all(15),
                child: Text(
                  "Score: $_score",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.right,
                )),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Container(
                  width: 200,
                  height: 230,
                  child: Column(children: [
                    const Text(
                      "Guess this color!",
                      style: TextStyle(
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Container(
                        width: 140,
                        height: 140,
                        margin: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.black,
                              width: 3,
                            ),
                            color: tempcol)),
                    Text(
                        _hintText,
                        style: const TextStyle(fontSize: 16)),
                  ]),
                ),
                Container(
                  width: 200,
                  height: 230,
                  child: Column(children: [
                    const Text(
                      "Your color!",
                      style: TextStyle(
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Container(
                      width: 140,
                      height: 140,
                      padding:
                          EdgeInsets.symmetric(vertical: 20, horizontal: 50),
                      margin: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.black,
                              width: 3,
                            ),
                            color: usercol),
                    ),
                    Text(_userColText),
                  ]),
                ),
              ],
            ),
            Text(
              "$msg",
              style: const TextStyle(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                children: [
                  TextField(
                    controller: _redController,
                    keyboardType: TextInputType.number,
                    // inputFormatters:[FilteringTextInputFormatter.allow(RegExp('[0-255]'),)],
                    onChanged: (value) {
                      if(int.parse(value) > 255){
                        // value="255";
                        _redController.text="255";
                      }
                      // print(_redController.text);
                      // print(value);
                    },
                    decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                      hintText: 'Red (0-255)',
                    ),
                  ),
                  TextField(
                    controller: _greenController,
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      if (int.parse(value) > 255) {
                        // value="255";
                        _greenController.text = "255";
                      }
                      // print(_greenController.text);
                      // print(value);
                    },
                    decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                      hintText: 'Green (0-255)',
                    ),
                  ),
                  TextField(
                    controller: _blueController,
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      if (int.parse(value) > 255) {
                        // value="255";
                        _blueController.text = "255";
                      }
                      // print(_blueController.text);
                      // print(value);
                    },
                    decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                      hintText: 'Blue (0-255)',
                    ),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () {
                    cekJawaban();
                  },
                  child: const Text(
                    'GUESS COLOR',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
                ElevatedButton(
                  onPressed: !_isHintActive? null:() {
                    _hintText="#"+tempcol.toString().substring(10, 16).toUpperCase();
                    _countHint();
                  },
                  child: const Text(
                    'SHOW HINT',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
              ],
            )
          ]
        )
      ),
    );
  }

   void _countHint() {
    setState(() {
      _jumHint++;
      _hintMultiplier= 0.5;
      print(_jumHint);
      _isHintActive=!_isHintActive;
      print(_isHintActive);
      _hitung=(_hitung/2).toInt().floor();
    });
  }

  void gameOver() {
    _timer.cancel();
    _isRunning = false;
    if(_hitung==0){
      _totalTime+=_WAKTU_MAX;
    }else{
      _totalTime+=(_WAKTU_MAX-_hitung);
    }
    var aveGuess=(_numGuess/_colorMixed).floor();
    showDialog(
      context: context,
      builder: (BuildContext builder) => AlertDialog(
        title: const Text("Game Over!"),
        content: const Text("Good Game Great Eyes! "),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(context,
                  MaterialPageRoute(
                      builder: (context) => Result(_score, _totalTime, _colorMixed, aveGuess, _jumHint)));
            },
            child: const Text("SHOW RESULT")
          ),
        ],
      )
    );
  }

  void cekJawaban() {
    setState(() {
      _rp = int.parse(_redController.text);
      _gp = int.parse(_greenController.text);
      _bp = int.parse(_blueController.text);
      print("s $_rs $_gs $_bs");
      print("p $_rp $_gp $_bp");

      usercol = Color.fromRGBO(_rp, _gp, _bp, 1);
      print(usercol);
      _userColText="#"+usercol.toString().substring(10, 16).toUpperCase();

      d=sqrt(pow((_rs-_rp), 2)+pow((_gs-_gp), 2)+pow((_bs-_bp), 2)).toInt();
      print("hasil $d");
      
      _numGuess++;
      _numGuessPerQues++;
      if(d>128){
        msg="Try again!";
      }else if(d>64){
        msg="Too far!";
      }else if(d>32){
        msg="You got this!";
      }else if(d>16){
        msg="Close enough...";
      }else if(d>0){
        msg="Almost!";
      }else{
        msg="Correct!";

        if (_numGuessPerQues >= 5) {
          _guessMultiplier = 1;
        } else {
          _guessMultiplier = 5 - _numGuessPerQues;
        }

        _score+=(_hintMultiplier *_guessMultiplier*_hitung).floor();
        print("hintmulti : $_hintMultiplier, guesmulti: $_guessMultiplier, sisawaktu: $_hitung");
        print("Score: $_score");
        _totalTime += (_WAKTU_MAX - _hitung);

        _rp = 255;  _gp = 255; _bp = 255;
        genrandomSoal();
        // Reset waktu
        _hitung = _WAKTU_MAX;
        _hintText="";
        _isHintActive=true;
        _hintMultiplier=1;
        _numGuessPerQues=0;

        _redController.text="";
        _greenController.text = "";
        _blueController.text = "";
        msg="";
      }
    });
  }

  String formatTime(int waktu) {
    String jam = (waktu ~/ 3600).toString().padLeft(2, "0");
    String menit = ((waktu % 3600) ~/ 60).toString().padLeft(2, "0");
    String detik = (waktu % 60).toString().padLeft(2, "0");
    return "$jam:$menit:$detik";
  }
}
