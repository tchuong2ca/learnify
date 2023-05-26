import 'package:flutter/material.dart';
import 'package:online_learning/screen/lesson/exercise/edit_quiz.dart';
import 'package:online_learning/screen/lesson/exercise/presenter/exercise_presenter.dart';
import 'package:random_string/random_string.dart';

import '../../../common/colors.dart';
import '../../../common/functions.dart';
import '../../../common/widgets.dart';
import '../../../languages/languages.dart';
import '../../../res/images.dart';
import '../presenter/create_new_lesson_presenter.dart';

class AddQuestion extends StatefulWidget {

  final String quizId;
  AddQuestion(this.quizId);

  @override
  _AddQuestionState createState() => _AddQuestionState();
}

class _AddQuestionState extends State<AddQuestion> {

  final _addQuestionFormKey = GlobalKey<FormState>();
  String question='';
  String option1='';
  String option2 ='';
  String option3 ='';
  String option4 ='';
  String correctAnswer ='';
  String questionId  ='';

  bool _isLoading = false;
  CreateLessonContentPresenter? _presenter;
  //DatabaseService _databaseService = new DatabaseService();
  @override
  void initState(){
    _presenter= CreateLessonContentPresenter();
  }
  _uploadQuestionData() async{
    if(_addQuestionFormKey.currentState!.validate()){

      setState(() {
        _isLoading = true;
      });

      questionId = randomAlphaNumeric(16);

      Map<String, String> questionData = {
        "question" : question,
        "option1" : option1,
        "option2" : option2,
        "option3" : option3,
        "option4" : option4,
        "correctAnswer" : correctAnswer,
        "questionId" : questionId
      };

      await _presenter!.addQuestionData(questionData, widget.quizId, questionId).then((value) => {
        setState(() {
          _isLoading = false;
        })
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
       toolbarHeight: 0,

      ),
      body: _isLoading ? Container(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      ) : Column(
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
                Center(
                  child: NeoText(Languages.of(context).addQuestion,
                      textStyle: TextStyle(color: AppColors.lightBlue, fontSize: 18,
                          fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                ),
               Positioned(child:  IconButton(onPressed: (){
                 Navigator.pop(context);
                 Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=>EditQuiz(widget.quizId)));
               }, icon: Icon(Icons.arrow_back, color: AppColors.blue,)),
               left: 0,)
              ],
            )
          ),
          Expanded(
            child: Form(
              key: _addQuestionFormKey,
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [

                    TextFormField(
                      decoration: InputDecoration(
                          hintText: "Câu hỏi"
                      ),
                      onChanged: (val){
                        question = val;
                      },
                      validator: (val){
                        return val!.isEmpty ? "Nhập câu hỏi" : null;
                      },
                    ),
                    SizedBox(height: 6,),
                    TextFormField(
                      decoration: InputDecoration(
                          hintText: "Đáp án A"
                      ),
                      onChanged: (val){
                        option1 = val;
                      },
                      validator: (val){
                        return val!.isEmpty ? "Nhập đáp án A" : null;
                      },
                    ),
                    SizedBox(height: 6,),
                    TextFormField(
                      decoration: InputDecoration(
                          hintText: "Đáp án B"
                      ),
                      onChanged: (val){
                        option2 = val;
                      },
                      validator: (val){
                        return val!.isEmpty ? "Nhập đáp án B" : null;
                      },
                    ),
                    SizedBox(height: 6,),
                    TextFormField(
                      decoration: InputDecoration(
                          hintText: "Đáp án C"
                      ),
                      onChanged: (val){
                        option3 = val;
                      },
                      validator: (val){
                        return val!.isEmpty ? "Nhập đáp án C" : null;
                      },
                    ),
                    SizedBox(height: 6,),
                    TextFormField(
                      decoration: InputDecoration(
                          hintText: "Đáp án D"
                      ),
                      onChanged: (val){
                        option4 = val;
                      },
                      validator: (val){
                        return val!.isEmpty ? "Nhập đáp án D" : null;
                      },
                    ),
                    SizedBox(height: 6,),
                    TextFormField(
                      decoration: InputDecoration(
                          hintText: "Câu trả lời"
                      ),
                      onChanged: (val){
                        correctAnswer = val;
                      },
                      validator: (val){
                        return val!.isEmpty||val ==''||(val!=option1&&val!=option2&&val!=option3&&val!=option4) ? "Nhập câu trả lời hợp lệ" : null;
                      },
                    ),
                    SizedBox(height: 20,),

                    GestureDetector(
                        onTap: (){
                          _uploadQuestionData();
                        },
                        child: button(context, "Thêm câu hỏi", MediaQuery.of(context).size.width/2 - 36, Colors.blueAccent)
                    ),
                    SizedBox(height: 40.0)
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}