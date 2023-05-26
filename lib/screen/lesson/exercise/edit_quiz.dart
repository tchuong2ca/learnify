
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:online_learning/screen/lesson/exercise/presenter/edit_quiz_presenter.dart';

import '../../../common/colors.dart';
import '../../../common/functions.dart';
import '../../../common/widgets.dart';
import '../../../languages/languages.dart';
import '../../../res/images.dart';
import '../model/question.dart';
import 'add_question.dart';
import 'edit_question.dart';

class EditQuiz extends StatefulWidget {

  final String quizId;
  EditQuiz(this.quizId);

  @override
  _EditQuizState createState() => _EditQuizState();
}

class _EditQuizState extends State<EditQuiz> {
  QuerySnapshot? querySnapshot;

  bool _isLoading = true;
  EditQuizPresenter? _presenter;
  QuestionModel getQuestionModelFromSnapshot(DocumentSnapshot questionSnapshot){

    QuestionModel questionModel = new QuestionModel();

    Map<String, dynamic> data = questionSnapshot.data() as Map<String, dynamic>;
    questionModel.questionId = data["questionId"];
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

  _deleteQuizSet(){
    _presenter!.deleteQuizData(widget.quizId).then((value){
      Navigator.pop(context);
      setState(() {

      });
    });
  }

  @override
  void initState() {
    _presenter = EditQuizPresenter();

    _presenter?.getQuestionData(widget.quizId).then((value){
      querySnapshot = value;
      _isLoading = false;
      setState(() {

      });
    });

    // TODO: implement initState
    super.initState();
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
      SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              Container(
                width: getWidthDevice(context),
                height: 52,
                decoration:  BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(Images.tabBar),
                    fit: BoxFit.fill,
                  ),
                ),
                child: Stack(
                  children: [
                    Positioned(
                        left: 0,
                        child: IconButton(onPressed: ()=>Navigator.pop(context), icon: Icon(Icons.arrow_back, color: AppColors.blue,))),
                    Center(child: NeoText(Languages.of(context).editQuiz,  textStyle: TextStyle(color: AppColors.lightBlue, fontSize: 18, fontWeight: FontWeight.bold), textAlign: TextAlign.center)),
                  Positioned(
                    right: 0,
                    top: 0,
                    bottom: 0,
                    child: Row(
                      children: [
                        Padding(
                            padding: EdgeInsets.only(right: 20.0),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(context, MaterialPageRoute(builder: (context) => AddQuestion(widget.quizId)));
                              },
                              child: Icon(
                                Icons.add,
                                size: 26.0,
                                color: AppColors.blue,
                              ),
                            )
                        ),
                        Padding(
                            padding: EdgeInsets.only(right: 20.0),
                            child: GestureDetector(
                              onTap: () {
                                _deleteQuizSet();
                              },
                              child: Icon(
                                  Icons.delete,
                                color: AppColors.redAccent,
                              ),
                            )
                        ),
                      ],
                    ),
                  )
                  ],
                ),
              ),
              querySnapshot!.docs == null ? Container(
                child: Center(child: Text("No Quiz Available", style: TextStyle(fontSize: 18, color: Colors.red),)),
              ) :
              ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  shrinkWrap: true,
                  physics: ClampingScrollPhysics(),
                  itemCount: querySnapshot!.docs.length,
                  itemBuilder: (context, index){
                    return QuizEditTile(
                        questionModel: getQuestionModelFromSnapshot(querySnapshot!.docs[index]),
                        index: index,
                        quizId : widget.quizId
                    );
                  }
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class QuizEditTile extends StatefulWidget {

  final QuestionModel? questionModel;
  final int? index;
  final String? quizId;
  QuizEditTile({this.questionModel, this.index, this.quizId});

  @override
  _QuizEditTileState createState() => _QuizEditTileState();
}

class _QuizEditTileState extends State<QuizEditTile> {

  EditQuizPresenter? _presenter;
  @override
  void initState(){
    _presenter = EditQuizPresenter();
  }
  _deleteQuestionData(String questionId){
    _presenter?.deleteQuestionData(widget.quizId!, questionId).then((value){
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => EditQuiz(widget.quizId!)));
      setState(() {
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Câu ${widget.index!+1}: ${widget.questionModel!.question}", style: TextStyle(fontSize: 18, color: Colors.black87),),
          SizedBox(height: 10,),
          Row(
            children: [
              IconButton(
                onPressed: (){
                  _deleteQuestionData(widget.questionModel!.questionId!);
                },
                icon: Icon(Icons.delete_forever_sharp, color: AppColors.redAccent,),
              ),
              Spacer(),
              IconButton(
                onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => EditQuestion(widget.quizId!, widget.questionModel!.questionId!)));
                },
                icon: Icon(Icons.edit_note_outlined, color: AppColors.lightBlue,),
              )
            ],
          ),

          Divider(color: AppColors.redAccent,),

          SizedBox(height: 20,)
        ],
      ),
    );
  }
}