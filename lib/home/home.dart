import 'package:flutter/material.dart';
import 'package:app_tactics/tactics/tactics.dart';
import '../db/db_tactics.dart';

class HomePage extends StatefulWidget{
  const HomePage({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState(){
    return _HomePage();
  }
}

class _HomePage extends State<HomePage>{
  late List<Tactics> tacticsList = [];

  @override
  Widget build(BuildContext context){
    getDatas();// データ取得
    return Scaffold(
      appBar:AppBar(
        title:const Text('Home'),
      ),
      floatingActionButton:Row(
        mainAxisAlignment:  MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            child:const Icon(Icons.add)
            ,onPressed:(){
              Navigator.push(context,MaterialPageRoute(
                builder:(context) =>  const InputTacticsPage(recId: 0)
              ));
          })
        ],
      ),
      body: Column(
        children:[
          Flexible(
            child:ListView.builder(
              itemCount: tacticsList.length,
              itemBuilder: (BuildContext context,int index){
                return dataRow(context,index,tacticsList[index]);
              },
            ),
          ),
        ],
      ),
    );
  }
  /// データ
  static Widget dataRow(BuildContext context,int index,Tactics tactics){
    return TextButton(
      child:Container(decoration:const BoxDecoration(border:Border(bottom:BorderSide(color:Colors.white))),child:Row(
        children:[
          Container(alignment:Alignment.topLeft,height:70,width:20,margin:const EdgeInsets.only(right:5),color:Colors.yellow[800]),
          Text(tactics.title,style:const TextStyle(color:Colors.black54)),
        ]
      ),height:70),
      style:TextButton.styleFrom(
        backgroundColor: Colors.yellow[200],
        padding:const EdgeInsets.all(0),
      ),
      onPressed:(){
        Navigator.push(context,MaterialPageRoute(
          builder:(context) =>  InputTacticsPage(recId: tactics.recId)
        ));
      },
      onLongPress:(){
        dialog(context,tactics.recId);
      },
    );
  }
  /// データ取得
  void getDatas() async{
    List<Tactics> tac = await Tactics.getDatas();
    setState((){
      tacticsList = tac.isNotEmpty ? tac : [];
    });
  }
  /// ダイアログ
  static void dialog(BuildContext context,int recId) async{
    var _res = await showDialog<int>(
      context:context,
      barrierDismissible:false,
      builder:(BuildContext context){
        return AlertDialog(
          title:const Text('確認'),
          content:const Text('削除します。よろしいですか？'),
          actions:<Widget>[
            TextButton(
              child:const Text('OK'),
              onPressed:() => Navigator.of(context).pop(1),
            ),
            TextButton(
              child:const Text('CANCEL'),
              onPressed:() => Navigator.of(context).pop(0),
            )
          ]
        );
      }
    );
    if(1 == _res){
      Tactics.deleteData(recId);
    }
  }
}