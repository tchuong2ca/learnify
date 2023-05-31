import 'package:flutter/material.dart';
import 'package:online_learning/screen/lesson/exercise/presenter/edit_quiz_presenter.dart';

import '../../../common/colors.dart';
import '../../../common/functions.dart';
import '../../../common/widgets.dart';
import '../../../languages/languages.dart';
import '../../../res/images.dart';
import 'edit_quiz.dart';
class EditQuestion extends StatefulWidget {

  final String quizId, questionId;
  EditQuestion(this.quizId, this.questionId);

  @override
  _EditQuestionState createState() => _EditQuestionState();
}

class _EditQuestionState extends State<EditQuestion> {

  final _formKey = GlobalKey<FormState>();
  String question='';
  String option1='';
  String option2 ='';
  String option3 ='';
  String option4 ='';
  String correctAnswer ='';
  String questionId  ='';

  bool _isLoading = false;

  EditQuizPresenter? _presenter;
  @override
  void initState(){
    _presenter= EditQuizPresenter();
  }
  _updateQuestionData() async{
    if(_formKey.currentState!.validate()){

      setState(() {
        _isLoading = true;
      });

      Map<String, String> questionData = {
        "question" : question,
        "option1" : option1,
        "option2" : option2,
        "option3" : option3,
        "option4" : option4,
        "correctAnswer" : correctAnswer,
        "questionId" : widget.questionId
      };

      await _presenter!.updateQuestionData(questionData, widget.quizId, widget.questionId).then((value) => {
        setState(() {
          _isLoading = false;
          Navigator.pop(context);
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => EditQuiz(widget.quizId)));
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
      ) : Form(
        key: _formKey,
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 24),
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
                Center(
                  child: NeoText(Languages.of(context).editQuestion,
                      textStyle: TextStyle(color: AppColors.ultraRed, fontSize: 18,
                          fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                ),
                Positioned(child:  IconButton(onPressed: (){
                  Navigator.pop(context);
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=>EditQuiz(widget.quizId)));
                }, icon: Icon(Icons.arrow_back, color: AppColors.ultraRed,)),
                  left: 0,)
              ],
            )
        ),
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
                    hintText: "Đáp án đúng"
                ),
                onChanged: (val){
                  correctAnswer = val;
                },
                validator: (val){
                  return val!.isEmpty ? "Nhập đáp án đúng" : null;
                },
              ),
              Spacer(),

              GestureDetector(
                  onTap: (){
                    _updateQuestionData();
                  },
                  child: button(context, "Cập nhật", MediaQuery.of(context).size.width/2 - 36, Colors.blueAccent)
              ),
              SizedBox(height: 40.0)
            ],
          ),
        ),
      ),
    );
  }
}