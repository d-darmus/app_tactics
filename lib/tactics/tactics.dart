import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';

import '../db/db_tactics.dart';

class InputTacticsPage extends StatefulWidget{
  const InputTacticsPage({Key? key, required this.recId}) : super(key: key);
  final int recId;
  @override
  State<StatefulWidget> createState(){
    return _InputTacticsPage();
  }
}

class _InputTacticsPage extends State<InputTacticsPage>{
  final double boxWidth = 75;
  int radioValue = 1;
  ///  1  2  3
  ///  4  5  6
  ///  7  8  9
  /// 10 11 12
  List<int> targetNumList = [];
  List<int> spinNumList = [];
  final TextEditingController _title = TextEditingController();
  final TextEditingController _detail = TextEditingController();
  var _switchValue = false;
  var _newRecId = 0;

  @override
  void initState(){
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar:AppBar(
        title:const Text('戦術ノート'),
      ),
      backgroundColor:Colors.red[100],
      body:SingleChildScrollView(
        scrollDirection:Axis.vertical
        ,child:Column(
          mainAxisAlignment:MainAxisAlignment.center,
          children:[
            Container(margin:const EdgeInsets.only(top:10,bottom:10),width:double.infinity,child:const Text('  タイトル',style:TextStyle(fontSize:18)))
            ,TextField(
              maxLines: 1,
              minLines: 1,
              controller: _title,
              decoration:const InputDecoration(
                fillColor:Colors.white,
                filled:true,
              ),
            )
            ,SwitchListTile(
              value:_switchValue,
              title:const Text('軌跡表示'),
              onChanged: (bool value){
                setState((){
                  _switchValue = value;
                });
              },
            )
            ,selectArea()
            ,_switchValue && targetNumList.isNotEmpty ? tableWithLine(targetNumList[0]) : table()
            ,LimitedBox(maxHeight:150,child:content())
            ,Container(margin:const EdgeInsets.only(top:20))
            ,Container(margin:const EdgeInsets.only(bottom:10),width:double.infinity,child:const Text('  備考',style:TextStyle(fontSize:18)))
            ,TextField(
              keyboardType: TextInputType.multiline,
              maxLines: null,
              minLines: 5,
              controller: _detail,
              decoration:const InputDecoration(
                fillColor:Colors.white,
                filled:true,
              ),
            )
            ,saveButton()
          ]
        )
      ),
    );
  }
  Widget table(){
    return Column(
      mainAxisAlignment:MainAxisAlignment.center,
      children:[
        Container(color:Colors.white,height:5,width:boxWidth*3+10,)
        ,rowData(1)
        ,rowData(2)
        ,Container(color:Colors.white,height:5,width:boxWidth*3+10,)
        ,rowData(3)
        ,rowData(4)
        ,Container(color:Colors.white,height:5,width:boxWidth*3+10,)
      ]
    );
  }
  Widget rowData(rowNum){
    return Row(
      mainAxisAlignment:MainAxisAlignment.center,
      children:[
        Container(color:Colors.white,height:100,width:5,)
        ,Container(child:course(rowNum,1),width:boxWidth,height:100,color:Colors.blue[400])
        ,Container(child:course(rowNum,2),width:boxWidth,height:100,color:Colors.blue[400])
        ,Container(child:course(rowNum,3),width:boxWidth,height:100,color:Colors.blue[400])
        ,Container(color:Colors.white,height:100,width:5,)
      ],
    );
  }
  Widget selectArea(){
    return Column(
      mainAxisAlignment: MainAxisAlignment.center
      ,children:[
        Row(children: [
          Radio(
            activeColor:Colors.blue
            ,value: 1
            ,groupValue: radioValue
            ,onChanged: (value){
              setState((){radioValue = 1;});
            }
          )
          ,const Text('下回転')
          ,Radio(
            activeColor:Colors.blue
            ,value: 2
            ,groupValue: radioValue
            ,onChanged: (value){
              setState((){radioValue = 2;});
            }
          )
          ,const Text('上回転')
        ])
        ,Row(children: [
          Radio(
            activeColor:Colors.blue
            ,value: 3
            ,groupValue: radioValue
            ,onChanged: (value){
              setState((){radioValue = 3;});
            }
          )
          ,const Text('右横回転')
          ,Radio(
            activeColor:Colors.blue
            ,value: 4
            ,groupValue: radioValue
            ,onChanged: (value){
              setState((){radioValue = 4;});
            }
          )
          ,const Text('左横回転')
        ])
      ]
    );
  }
  Widget course(rowNum,courseNum){
    return TextButton(
      child:const Text('-',style:TextStyle(color:Colors.white)),
      style:TextButton.styleFrom(
        minimumSize:Size(boxWidth,100),
        backgroundColor:Colors.blue[400],
      ),
      onPressed:(){
        setState(() {
          int targetNum = rowNum*3;
          switch(courseNum){
            case 1: targetNum -= 2;break;
            case 2: targetNum -= 1;break;
            case 3: targetNum -= 0;break;
          }
          targetNumList.add(targetNum);
          spinNumList.add(radioValue);
        });
      },
    );
  }
  Widget saveButton(){
    return TextButton(
      child:const Text('確定する',style:TextStyle(color:Colors.white)),
      style:TextButton.styleFrom(
        minimumSize:const Size(250,50),
        backgroundColor:Colors.red,
      ),
      onPressed:(){
        if(widget.recId == 0 && _newRecId == 0){
          regist();
          getData();
        } else {
          update();
        }
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content:Text('登録しました')));
      },
    );
  }
  Widget tableWithLine(targetNum){
    Widget _tmp = const Text('');
    switch(targetNum){
      case 1:
        _tmp = Container(margin:const EdgeInsets.only(top:15,left:80),child:Image.asset('assets/0-1.png'));break;
      case 2:
        _tmp = Container(margin:const EdgeInsets.only(top:15,left:80),child:Image.asset('assets/0-2.png',fit:BoxFit.contain));break;
      case 3:
        _tmp = Container(margin:const EdgeInsets.only(top:15,left:80),child:Image.asset('assets/0-3.png'));break;
      case 4:
        _tmp = Container(margin:const EdgeInsets.only(top:115,left:80),child:Image.asset('assets/0-4.png'));break;
      case 5:
        _tmp = Container(margin:const EdgeInsets.only(top:85,left:110),child:Image.asset('assets/0-5.png'));break;
      case 6:
        _tmp = Container(margin:const EdgeInsets.only(top:115,left:80),child:Image.asset('assets/0-6.png'));break;
    }
    List<Widget> stack = [];
    stack.add(Container(margin:const EdgeInsets.only(top:10)));
    stack.add(table());
    stack.add(_tmp);
    for(int i = 1; i<targetNumList.length; i++){
      stack.add(getLine(i));
    }
    return Stack(
      children:stack
    );
  }
  /// 文章
  Widget content(){
    return ListView.builder(
      itemCount:spinNumList.length,
      itemBuilder:(BuildContext context,int index){
        return Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(' ( '+(index+1).toString()+' ) ',style:const TextStyle(fontSize:20)),
            Text(targetNumList[index].toString()+' に'+getSpinNameList()[index],style:const TextStyle(fontSize:20)),
          ],
        );
      }
    );
  }
  List<String> getSpinNameList(){
    List<String> spinNameList = [];
    for(int spinNum in spinNumList){
      switch(spinNum){
        case 1: spinNameList.add('下回転');break;
        case 2: spinNameList.add('上回転');break;
        case 3: spinNameList.add('右横回転');break;
        case 4: spinNameList.add('左横回転');break;
      }
    }
    return spinNameList;
  }
  /// データ登録
  void regist() async{
    Tactics tac = Tactics(recId: 0, course:jsonEncode(targetNumList),title: _title.text,spin:jsonEncode(spinNumList));
    await Tactics.insertData(tac);
  }
  /// データ更新
  void update() async{
    Tactics tac = Tactics(recId:0,title:_title.text,course:jsonEncode(targetNumList),spin:jsonEncode(spinNumList));
    Tactics.update(widget.recId,tac);
  }
  /// データ取得
  void getData() async{
    List<Tactics> tac = await Tactics.getData(widget.recId);
    setState((){
      targetNumList = tac.isNotEmpty ? convertJson(jsonDecode(tac[0].course)) : [];
      spinNumList = tac.isNotEmpty ? convertJson(jsonDecode(tac[0].spin)) : [];
      _title.text = tac.isNotEmpty ? tac[0].title : '';
      _newRecId = tac.isNotEmpty ? tac[0].recId : 0;
    });
  }
  List<int> convertJson(dynamic json){
    List<int> result = [];
    for(int num in json){
      result.add(num);
    }
    return result;
  }
  Widget getLine(index){
    if(targetNumList.isEmpty){return const Text('');}
    int startNum = targetNumList.length>1 ? targetNumList[index-1] : -1;
    int endNum = targetNumList.length>1 ? targetNumList[index] : -1;
    int _angle = 0;
    double _top = 0;
    double _bottom = 0;
    double _horizon = 0;
    double _left = 0;
    double _height = 0;
    String _img = 'assets/line.png';
    switch(startNum){
      case 1:
        switch(endNum){
          case 7:_angle=180;_height=230;_bottom=50;_horizon=100;break;
          case 8:_angle=155;_height=250;_bottom=60;_horizon=120;break;
          case 9:_angle=140;_height=290;_bottom=80;_horizon=160;break;
          case 10:_angle=180;_height=330;_bottom=50;_horizon=80;break;
          case 11:_angle=165;_height=350;_bottom=50;_horizon=120;break;
          case 12:_angle=155;_height=400;_bottom=50;_horizon=150;break;
        }
        break;
      case 2:
        switch(endNum){
          case 7:_angle=200;_height=250;_bottom=5;_horizon=115;break;
          case 8:_angle=180;_height=230;_bottom=45;_horizon=177;break;
          case 9:_angle=155;_height=250;_bottom=85;_horizon=200;break;
          case 10:_angle=195;_height=350;_bottom=15;_horizon=125;break;
          case 11:_angle=180;_height=330;_bottom=45;_horizon=175;break;
          case 12:_angle=167;_height=350;_bottom=55;_horizon=185;break;
        }
        break;
      case 3:
        switch(endNum){
          case 7:_angle=215;_height=300;_bottom=0;_left=150;_top=550;break;
          case 8:_angle=200;_height=260;_bottom=0;_left=0;_top=1150;break;
          case 9:_angle=180;_height=230;_bottom=50;_horizon=250;break;
          case 10:_angle=205;_height=350;_bottom=0;_left=50;_top=800;break;
          case 11:_angle=197;_height=350;_bottom=0;_left=0;_top=1350;break;
          case 12:_angle=180;_height=330;_bottom=38;_horizon=250;break;
        }
        break;
      case 4:
        switch(endNum){
          case 7:_angle=180;_height=120;_bottom=150;_horizon=100;break;
          case 8:_angle=140;_height=150;_bottom=180;_horizon=80;break;
          case 9:_angle=120;_height=220;_bottom=200;_horizon=120;break;
          case 10:_angle=180;_height=250;_bottom=150;_horizon=80;break;
          case 11:_angle=160;_height=250;_bottom=150;_horizon=100;break;
          case 12:_angle=140;_height=300;_bottom=170;_horizon=120;break;
        }
        break;
      case 5:
        switch(endNum){
          case 7:_angle=220;_height=135;_bottom=80;_horizon=180;break;
          case 8:_angle=180;_height=120;_bottom=155;_horizon=185;break;
          case 9:_angle=140;_height=165;_bottom=200;_horizon=170;break;
          case 10:_angle=200;_height=260;_bottom=130;_horizon=150;break;
          case 11:_angle=180;_height=250;_bottom=150;_horizon=155;break;
          case 12:_angle=160;_height=250;_bottom=180;_horizon=175;break;
        }
        break;
      case 6:
        switch(endNum){
          case 7:_angle=235;_height=190;_bottom=10;_horizon=230;break;
          case 8:_angle=220;_height=135;_bottom=75;_horizon=255;break;
          case 9:_angle=180;_height=125;_bottom=150;_horizon=240;break;
          case 10:_angle=220;_height=280;_bottom=60;_horizon=220;break;
          case 11:_angle=200;_height=250;_bottom=110;_horizon=225;break;
          case 12:_angle=180;_height=230;_bottom=150;_horizon=250;break;
        }
        break;
      case 7:
        _img = 'assets/line2.png';
        switch(endNum){
          case 1:_angle=180;_height=230;_bottom=50;_horizon=100;break;
          case 2:_angle=200;_height=250;_bottom=5;_horizon=115;break;
          case 3:_angle=215;_height=300;_bottom=0;_left=150;_top=550;break;
          case 4:_angle=180;_height=120;_bottom=150;_horizon=100;break;
          case 5:_angle=220;_height=135;_bottom=80;_horizon=180;break;
          case 6:_angle=235;_height=190;_bottom=10;_horizon=230;break;
        }
        break;
      case 8:
        _img = 'assets/line2.png';
        switch(endNum){
          case 1:_angle=155;_height=250;_bottom=60;_horizon=120;break;
          case 2:_angle=180;_height=230;_bottom=45;_horizon=177;break;
          case 3:_angle=200;_height=260;_bottom=0;_left=0;_top=1150;break;
          case 4:_angle=140;_height=150;_bottom=180;_horizon=80;break;
          case 5:_angle=180;_height=120;_bottom=155;_horizon=185;break;
          case 6:_angle=220;_height=135;_bottom=75;_horizon=255;break;
        }
        break;
      case 9:
        _img = 'assets/line2.png';
        switch(endNum){
          case 1:_angle=140;_height=290;_bottom=80;_horizon=160;break;
          case 2:_angle=155;_height=250;_bottom=85;_horizon=200;break;
          case 3:_angle=180;_height=230;_bottom=50;_horizon=250;break;
          case 4:_angle=120;_height=220;_bottom=200;_horizon=120;break;
          case 5:_angle=140;_height=165;_bottom=200;_horizon=170;break;
          case 6:_angle=180;_height=125;_bottom=150;_horizon=240;break;
        }
        break;
      case 10:
        _img = 'assets/line2.png';
        switch(endNum){
          case 1:_angle=180;_height=330;_bottom=50;_horizon=80;break;
          case 2:_angle=195;_height=350;_bottom=15;_horizon=125;break;
          case 3:_angle=205;_height=350;_bottom=0;_left=50;_top=800;break;
          case 4:_angle=180;_height=250;_bottom=150;_horizon=80;break;
          case 5:_angle=200;_height=260;_bottom=130;_horizon=150;break;
          case 6:_angle=220;_height=280;_bottom=60;_horizon=220;break;
        }
        break;
      case 11:
        _img = 'assets/line2.png';
        switch(endNum){
          case 1:_angle=165;_height=350;_bottom=50;_horizon=120;break;
          case 2:_angle=180;_height=330;_bottom=45;_horizon=175;break;
          case 3:_angle=197;_height=350;_bottom=0;_left=0;_top=1350;break;
          case 4:_angle=160;_height=250;_bottom=150;_horizon=100;break;
          case 5:_angle=180;_height=250;_bottom=150;_horizon=155;break;
          case 6:_angle=200;_height=250;_bottom=110;_horizon=225;break;
        }
        break;
      case 12:
        _img = 'assets/line2.png';
        switch(endNum){
          case 1:_angle=155;_height=400;_bottom=50;_horizon=150;break;
          case 2:_angle=167;_height=350;_bottom=55;_horizon=185;break;
          case 3:_angle=180;_height=330;_bottom=38;_horizon=250;break;
          case 4:_angle=140;_height=300;_bottom=170;_horizon=120;break;
          case 5:_angle=160;_height=250;_bottom=180;_horizon=175;break;
          case 6:_angle=180;_height=230;_bottom=150;_horizon=250;break;
        }
        break;
    }
    return Transform.rotate(angle:_angle*pi/180,child:
      Container(height:_height,margin:EdgeInsets.only(top:_top,bottom:_bottom,right:_horizon,left:_left),child:Image.asset(_img))
    );
  }
}