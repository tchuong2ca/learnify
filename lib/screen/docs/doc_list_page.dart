import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:online_learning/common/widgets.dart';
import 'package:online_learning/screen/docs/presenter/doc_presenter.dart';

import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../../common/colors.dart';
import '../../common/functions.dart';
import '../../common/keys.dart';
import '../../languages/languages.dart';
import '../../res/images.dart';
import 'create_doc_page.dart';
import 'doc_detail_page.dart';
import 'model/doc_content.dart';

class DocListPage extends StatefulWidget {
  Map<String, dynamic>? _dataUser;

  DocListPage(this._dataUser);

  @override
  State<DocListPage> createState() => _DocListPageState();
}

class _DocListPageState extends State<DocListPage> {

  Stream<QuerySnapshot>? _stream;
  CreateDocPresenter? _presenter;

  @override
  void initState() {
    _stream = FirebaseFirestore.instance.collection('documents').snapshots();
    _presenter = CreateDocPresenter();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
        backgroundColor: AppColors.ultraRed,
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
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
                IconButton(onPressed: ()=>Navigator.pop(context), icon: Icon(Icons.arrow_back, color: AppColors.ultraRed,)),
                SizedBox(width: 8,),
                Expanded(child: NeoText(Languages.of(context).document, textStyle: TextStyle(color: AppColors.ultraRed, fontSize: 18, fontWeight: FontWeight.bold), textAlign: TextAlign.center)),
                SizedBox(width: 52,)
              ],
            ),
          ),
          Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _stream,
                builder: (context, snapshot){
                  if(snapshot.connectionState==ConnectionState.waiting){
                    return Center(
                      child: LoadingAnimationWidget.staggeredDotsWave(color: AppColors.ultraRed, size: 50),
                    );
                  }else if(snapshot.hasError){
                    return Center(
                      child: Text('No data...'),
                    );
                  }else if(!snapshot.hasData){
                    return Center(
                      child: Text('No data...'),
                    );
                  }else{
                    return Wrap(
                      children: snapshot.data!.docs.map((e) {
                        DocContent doc = DocContent.fromJson(e.data());
                        return CommonKey.ADMIN==widget._dataUser!['role']||CommonKey.TEACHER==widget._dataUser!['role']
                            ?_itemDocumentAdmin(doc)
                            :_itemDocument(doc);
                      }).toList(),
                    );
                  }
                },
              )
          )
        ],
      ),
      floatingActionButton: Visibility(
        visible: CommonKey.TEACHER==widget._dataUser!['role']||CommonKey.ADMIN==widget._dataUser!['role']?true:false,
        child: FloatingActionButton(
          onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (_)=>CreateDocPage('', null)));
          },
          child: Icon(
            Icons.add,
            color: AppColors.white,
          ),
        ),
      ),
    );
  }

  Widget _itemDocument(DocContent document){
    return InkWell(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (_)=>DocDetailsPage(document)));
      },
      child: Container(
        height: 220,
        margin: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        width: getWidthDevice(context)/2-16,
        padding: EdgeInsets.all(4),
        decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.all(Radius.circular(8)),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 1,
                blurRadius: 7,
                offset: const Offset(0, 3),
              )
            ]
        ),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            loadPhoto.networkImage('${document.imageUrl}', 150, getWidthDevice(context)),
            SizedBox(height: 16,),
            NeoText('${document.name}', textStyle: TextStyle(color: AppColors.black, fontWeight: FontWeight.bold, fontSize: 16, overflow: TextOverflow.ellipsis), maxline: 2),
            NeoText('GV: ${document.teacher}', textStyle: TextStyle(color: AppColors.black,  fontSize: 14, overflow: TextOverflow.ellipsis), maxline: 2),
          ],
        ),
      ),
    );
  }

  Widget _itemDocumentAdmin(DocContent document){
    return InkWell(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (_)=>DocDetailsPage(document)));
      },
      child: Container(
        height: 270,
        margin: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        width: getWidthDevice(context)/2-16,
        padding: EdgeInsets.all(4),
        decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.all(Radius.circular(8)),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 1,
                blurRadius: 7,
                offset: const Offset(0, 3),
              )
            ]
        ),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            loadPhoto.networkImage('${document.imageUrl}', 150, getWidthDevice(context)),
            SizedBox(height: 16,),
            NeoText('${document.name}', textStyle: TextStyle(color: AppColors.black, fontWeight: FontWeight.bold, fontSize: 16, overflow: TextOverflow.ellipsis), maxline: 2),
            NeoText('GV: ${document.teacher}', textStyle: TextStyle(color: AppColors.black,  fontSize: 14, overflow: TextOverflow.ellipsis), maxline: 2),
            SizedBox(height: 4,),
            document.createdBy==widget._dataUser!['phone']||CommonKey.ADMIN==widget._dataUser!['role']?Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                  icon: Icon(
                    Icons.edit,
                    color: AppColors.ultraRed,
                  ),
                  onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (_)=>CreateDocPage(CommonKey.EDIT, document)));
                  },
                ),
                SizedBox(width: 8,),
                IconButton(
                  icon: Icon(
                    Icons.delete,
                    color: AppColors.ultraRed,
                  ),
                  onPressed: (){
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text('Chắc chứ?'),
                        content: Text('Bạn muốn xóa tài liệu này?'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(false),
                            child: Text('Thôi'),
                          ),
                          TextButton(
                            onPressed: (){
                    _presenter!.DeleteDoc(document);
                    Navigator.pop(context);
                    },
                            child: Text('Xóa'),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ):SizedBox()
          ],
        ),
      ),
    );
  }
}
