import 'package:flutter/material.dart';

import '../../../common/widgets.dart';

class Results extends StatefulWidget {

  final int? correct, incorrect, total;
  Results({@required this.correct, @required this.incorrect, @required this.total});

  @override
  _ResultsState createState() => _ResultsState();
}

class _ResultsState extends State<Results> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Số câu đúng / Tổng: ${widget.correct}/${widget.total}", style: TextStyle(fontSize: 25),),
              SizedBox(height: 8,),
              Text("Số câu đúng: ${widget.correct}", style: TextStyle(fontSize: 16, color: Colors.green), textAlign: TextAlign.center,),
              SizedBox(height: 8,),
              Text("Số câu sai: ${widget.incorrect}", style: TextStyle(fontSize: 16, color: Colors.red), textAlign: TextAlign.center,),

              SizedBox(height: 20,),
              GestureDetector(
                  onTap: (){
                    Navigator.pop(context);
                  },
                  child: button(context, "Về trang trước", MediaQuery.of(context).size.width/2, Colors.blueAccent)
              ),
            ],
          ),
        ),
      ),
    );
  }
}