import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:online_learning/common/widgets.dart';
import 'package:online_learning/screen/docs/model/doc_content.dart';
import 'package:online_learning/screen/docs/model/doc_info.dart';
import 'package:online_learning/screen/docs/presenter/doc_presenter.dart';
import 'package:file_picker/file_picker.dart';
import '../../common/colors.dart';
import '../../common/functions.dart';
import '../../common/keys.dart';
import '../../common/themes.dart';
import '../../languages/languages.dart';
import '../../res/images.dart';



class CreateDocPage extends StatefulWidget {
  String? _keyFlow;
  DocContent? _document;

  CreateDocPage(this._keyFlow, this._document);

  @override
  State<CreateDocPage> createState() => _CreateDocPageState();
}

class _CreateDocPageState extends State<CreateDocPage> {

  File? _fileImage;
  String _imageUrl='';
  String _docName='';
  List<DocInfo> _docsList = [DocInfo()];
  Map<String, dynamic>? _dataUser;
  CreateDocPresenter? _presenter;
  TextEditingController _controllerText = TextEditingController();

  @override
  void initState() {
    _presenter = CreateDocPresenter();
    if(CommonKey.EDIT==widget._keyFlow){
      _controllerText = TextEditingController(text: widget._document!.name);
      _docName = widget._document!.name!;
      _docsList = widget._document!.docsList!;
      _imageUrl = widget._document!.imageUrl!;
    }
    getUserInfor();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: getWidthDevice(context),
            height: 52,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(Images.tabBar),
                fit: BoxFit.fill,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(width: 8,),
                IconButton(onPressed: ()=>Navigator.pop(context), icon: Icon(Icons.arrow_back, color: AppColors.blue,)),
                SizedBox(width: 8,),
                Expanded(child: NeoText( Languages.of(context).documentNews, textStyle: TextStyle(color: AppColors.lightBlue, fontSize: 18, fontWeight: FontWeight.bold), textAlign: TextAlign.center)),
                ElevatedButton(
                    onPressed: (){
                      if(_fileImage==null&&CommonKey.EDIT!=widget._keyFlow){
                        Fluttertoast.showToast(msg:Languages.of(context).imageNull);
                      }else if(_docName.isEmpty){
                        Fluttertoast.showToast(msg:Languages.of(context).subjectEmpty);
                      }else if(_docsList.length==0){
                        Fluttertoast.showToast(msg:Languages.of(context).fileEmpty);
                      } else{
                        showLoaderDialog(context);
                        DocContent doc = DocContent(id: getCurrentTime(), name: _docName, docsList: _docsList, teacher: _dataUser!['fullname'], createdBy: _dataUser!['phone']);
                        if(CommonKey.EDIT==widget._keyFlow){
                          widget._document!.name = _docName;
                          widget._document!.docsList = _docsList;
                        }
                        CommonKey.EDIT==widget._keyFlow
                            ?_fileImage==null
                            ?_presenter!.updateDocContent(document: widget._document!,).then((value) {
                          Navigator.pop(context);
                          if(value){
                            Fluttertoast.showToast(msg:Languages.of(context).onSuccess);
                            Navigator.pop(context);
                          }else{
                            Fluttertoast.showToast(msg:Languages.of(context).onFailure);
                          }
                        })
                            :_presenter!.updateDocContent(document: widget._document!, imageFile: _fileImage!).then((value) {
                          Navigator.pop(context);
                          if(value){
                            Fluttertoast.showToast(msg:Languages.of(context).onSuccess);
                            Navigator.pop(context);
                          }else{
                            Fluttertoast.showToast(msg:Languages.of(context).onFailure);
                          }
                        })
                            :_presenter!.createDoc(imageFile: _fileImage!, document: doc).then((value) {
                          Navigator.pop(context);
                          if(value){
                            Fluttertoast.showToast(msg:Languages.of(context).onSuccess);
                            Navigator.pop(context);
                          }else{
                            Fluttertoast.showToast(msg:Languages.of(context).onFailure);
                          }
                        });
                      }
                    },
                    child: NeoText(Languages.of(context).createNew, textStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.white))),
                SizedBox(width: 8,)
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () => cropImage(context,(p0) => setState(()=>_fileImage=p0!), ''),
                      child: Center(child: _fileImage!=null?Image(image: FileImage(_fileImage!),width: 150, height: 150,):(_imageUrl.isNotEmpty&&CommonKey.EDIT==widget._keyFlow!)?loadPhoto.networkImage(_imageUrl, 150, 150):Image.asset(Images.tabBar, width: 150, height: 150,fit: BoxFit.fill,)),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: TextFormField(
                        decoration: AppThemes.textFieldInputDecoration(labelText: Languages.of(context).nameClass, hintText: Languages.of(context).nameClass),
                        onChanged: (value)=>setState(()=> _docName=value),
                        controller: _controllerText,
                      ),
                    ),
                    Wrap(
                        children: List.generate(_docsList.length, (index) => _itemDocument(_docsList[index]))
                    ),
                    IconButton(onPressed: (){setState(()=>_docsList.add(DocInfo()));}, icon: Icon(Icons.add))
                    //ButtonIcon(Icons.add, (data) => setState(()=>_docsList.add(DocumentFile()))),
                  ],
                )
            ),
          )
        ],
      ),
    );
  }

  Widget _itemDocument(DocInfo documentFile){
    return   Padding(
      padding: EdgeInsets.all(8),
      child: Card(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: NeoText('Tên file: ${documentFile.fileName!=null?documentFile.fileName:'Chọn file'}'),
                ),
                IconButton(
                  icon: Icon(Icons.arrow_circle_up_sharp),
                  color: AppColors.blue,
                  onPressed: () async{
                    FilePickerResult? result = await FilePicker.platform.pickFiles(
                      type: FileType.custom,
                      allowedExtensions: ['pdf'],
                    );
                    if(result!=null){
                      showLoaderDialog(context);
                      PlatformFile file = result.files.first;
                      String fileName = result.files.first.name;
                      final File fileForFirebase = File(file.path!);
                      _presenter!.uploadPDFFile(fileForFirebase, fileName).then((value) {
                        Navigator.pop(context);
                        if(value.isNotEmpty){
                          documentFile.id = getCurrentTime();
                          documentFile.fileUrl=value;
                          documentFile.fileName=fileName;
                        }
                        setState(()=>null);
                      });
                    }
                  },
                )
              ],
            ),
            IconButton(onPressed: (){setState(()=>_docsList.remove(documentFile));}, icon: Icon(Icons.delete))
            //ButtonIcon(Icons.delete, (data) => setState(()=>_docsList.remove(documentFile)))
          ],
        ),
      ),
    );
  }

  Future<void> getUserInfor() async{
    _dataUser = await _presenter!.getAccountInfor();
    setState(()=>null);
  }
}
