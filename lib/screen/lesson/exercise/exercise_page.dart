import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:online_learning/common/keys.dart';
import 'package:online_learning/screen/lesson/exercise/edit_quiz.dart';
import 'package:online_learning/screen/lesson/exercise/presenter/exercise_presenter.dart';
import 'package:online_learning/screen/lesson/exercise/result_page.dart';
import '../../../common/colors.dart';
import '../../../common/functions.dart';
import '../../../common/play_quiz_widget.dart';
import '../../../common/widgets.dart';
import '../model/question.dart';
class ExercisePage extends StatefulWidget {

  final String quizId;
  String role;
  ExercisePage(this.quizId, this.role);

  @override
  _ExercisePageState createState() => _ExercisePageState(this.role);
}

int? total = 0;
int _correct = 0;
int _incorrect = 0;


Stream? infoStream;

class _ExercisePageState extends State<ExercisePage> {
  String _role;
  _ExercisePageState( this._role);
  ExercisePresenter? _presenter;
  QuerySnapshot? querySnapshot;

  bool _isLoading = true;

  QuestionModel getQuestionModelFromSnapshot(DocumentSnapshot questionSnapshot){

    QuestionModel questionModel = new QuestionModel();
    Map<String, dynamic> data = questionSnapshot.data() as Map<String, dynamic>;
    questionModel.question = data["question"];

    List<String> options =
    [
      data["option1"],
      data["option2"],
      data["option3"],
      data["option4"],
    ];
    options.shuffle();

    questionModel.option1 = options[0];
    questionModel.option2 = options[1];
    questionModel.option3 = options[2];
    questionModel.option4 = options[3];

    questionModel.correctOption = data["correctAnswer"];
    questionModel.correctAnswer = data["correctAnswer"];
    questionModel.answered = false;

    return questionModel;
  }

  @override
  void initState() {
    _presenter = ExercisePresenter();
    _presenter!.getQuestionData(widget.quizId).then((value){
      querySnapshot = value;
      _correct = 0;
      _incorrect = 0;
      total = querySnapshot!.docs.length;
      _isLoading = false;
      setState(() {

      });
    });

    if(infoStream == null){
      infoStream = Stream<List<int>>.periodic(
          Duration(milliseconds: 100), (x){

        return [_correct, _incorrect] ;
      });
    }
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    infoStream = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        toolbarHeight: 0,
      ),
      body: _isLoading? Container(
        child: Center(child: CircularProgressIndicator()),
      ) :
      Column(
        children: [
          InfoHeader(
            length: querySnapshot!.docs.length,
          ),
          SizedBox(
            height: 10,
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Container(
                child: Column(
                  children: [

                    querySnapshot!.docs == null ? Container(
                      child: Center(child: Text("Không có câu hỏi nào", style: TextStyle(fontSize: 18, color: Colors.red)),),
                    ) :
                    ListView.builder(
                        padding: EdgeInsets.symmetric(horizontal: 24),
                        shrinkWrap: true,
                        physics: ClampingScrollPhysics(),
                        itemCount: querySnapshot!.docs.length,
                        itemBuilder: (context, index){
                          return QuizPlayTile(
                            questionModel: getQuestionModelFromSnapshot(querySnapshot!.docs[index]),
                            index: index,
                          );
                        }
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),

      floatingActionButton: _role==CommonKey.ADMIN||_role==CommonKey.TEACHER?
      FloatingActionButton(
          child: Icon(Icons.edit_note),onPressed: (){
        Navigator.push(context, MaterialPageRoute(builder: (context)=>EditQuiz(widget.quizId)));
      })
          :FloatingActionButton(
        child: Icon(Icons.done_outline_sharp),
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context) => Results(
              correct: _correct,
              incorrect: _incorrect,
              total: total
          )));
        },
      ),
    );
  }
}

class InfoHeader extends StatefulWidget {

  final int? length;

  InfoHeader({@required this.length});

  @override
  _InfoHeaderState createState() => _InfoHeaderState();
}

class _InfoHeaderState extends State<InfoHeader> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: infoStream,
        builder: (context, snapshot){
          return snapshot.hasData ?
          Column(
            children: [
              Container(
                height: 40,
                margin: EdgeInsets.only(left: 14),
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  children: <Widget>[
                    NumberOfQuestionTile(
                      text: "Câu hỏi",
                      number: widget.length,
                    ),
                    NumberOfQuestionTile(
                      text: "Đúng",
                      number: _correct,
                    ),
                    NumberOfQuestionTile(
                      text: "Sai",
                      number: _incorrect,
                    ),

                  ],
                ),
              ),
              SizedBox(
                width: getWidthDevice(context)/1.5,
                child:  NeoText('Chú ý: Suy nghĩ kỹ trước khi chọn vì bạn chỉ được chọn 1 lần',
                    textStyle: TextStyle(color: AppColors.red),
                    textAlign: TextAlign.center),
              )
            ],
          ) : SizedBox();
        }
    );
  }
}


class QuizPlayTile extends StatefulWidget {

  final QuestionModel? questionModel;
  final int? index;
  QuizPlayTile({this.questionModel, this.index});

  @override
  _QuizPlayTileState createState() => _QuizPlayTileState();
}

class _QuizPlayTileState extends State<QuizPlayTile> {

  String optionSelected = "";

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Câu ${widget.index!+1}: ${widget.questionModel!.question}", style: TextStyle(fontSize: 18, color: Colors.black87),),
          SizedBox(height: 12,),
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: (){
                if(!widget.questionModel!.answered!){
                  if(widget.questionModel!.option1 == widget.questionModel!.correctOption){

                    optionSelected = widget.questionModel!.option1!;
                    widget.questionModel!.answered = true;
                    _correct = _correct + 1;

                    setState(() {

                    });

                  }else{

                    optionSelected = widget.questionModel!.option1!;
                    widget.questionModel!.answered = true;
                    _incorrect = _incorrect + 1;
                    setState(() {

                    });

                  }
                }
              },
              child: OptionTile(
                  option: "A",
                  description: widget.questionModel!.option1,
                  correctAnswer: widget.questionModel!.correctAnswer,
                  optionSelected: optionSelected
              ),
            ),
            SizedBox(height: 4,),
            GestureDetector(
              onTap: (){
                if(!widget.questionModel!.answered!){
                  if(widget.questionModel!.option2 == widget.questionModel!.correctOption!){

                    optionSelected = widget.questionModel!.option2!;
                    widget.questionModel!.answered = true;
                    _correct = _correct + 1;
                    setState(() {

                    });

                  }else{

                    optionSelected = widget.questionModel!.option2!;
                    widget.questionModel!.answered = true;
                    _incorrect = _incorrect + 1;
                    setState(() {

                    });

                  }
                }
              },
              child: OptionTile(
                  option: "B",
                  description: widget.questionModel!.option2!,
                  correctAnswer: widget.questionModel!.correctAnswer,
                  optionSelected: optionSelected
              ),
            ),
            SizedBox(height: 4,),
          ],
        ),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: (){
                  if(!widget.questionModel!.answered!){
                    if(widget.questionModel!.option3 == widget.questionModel!.correctOption){

                      optionSelected = widget.questionModel!.option3!;
                      widget.questionModel!.answered = true;
                      _correct = _correct + 1;
                      setState(() {

                      });

                    }else{

                      optionSelected = widget.questionModel!.option3!;
                      widget.questionModel!.answered = true;
                      _incorrect = _incorrect + 1;
                      setState(() {

                      });

                    }
                  }
                },
                child: OptionTile(
                    option: "C",
                    description: widget.questionModel!.option3,
                    correctAnswer: widget.questionModel!.correctAnswer,
                    optionSelected: optionSelected
                ),
              ),
              SizedBox(height: 4,),
              GestureDetector(
                onTap: (){
                  if(!widget.questionModel!.answered!){
                    if(widget.questionModel!.option4 == widget.questionModel!.correctOption){

                      optionSelected = widget.questionModel!.option4!;
                      widget.questionModel!.answered = true;
                      _correct = _correct + 1;
                      setState(() {

                      });

                    }else{

                      optionSelected = widget.questionModel!.option4!;
                      widget.questionModel!.answered = true;
                      _incorrect = _incorrect + 1;
                      setState(() {

                      });

                    }
                  }
                },
                child: OptionTile(
                    option: "D",
                    description: widget.questionModel!.option4,
                    correctAnswer: widget.questionModel!.correctAnswer,
                    optionSelected: optionSelected
                ),
              ),
              SizedBox(height: 4,),
            ],
          ),

          SizedBox(height: 20,)
        ],
      ),
    );
  }
}
