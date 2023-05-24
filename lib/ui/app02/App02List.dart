
import 'dart:convert';
import 'dart:ffi';

import 'package:actkosep/model/themoon/ca609list_model.dart';
import 'package:actkosep/model/themoon/padlist_model.dart';
import 'package:actkosep/ui/home/tab_home.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:get/get.dart';
import 'package:get_ip_address/get_ip_address.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

import '../../config/constant.dart';
import '../../config/global_style.dart';
import '../../model/themoon/ca609list_model.dart';
import '../../model/themoon/ca609list_modell.dart';

class App02List extends StatefulWidget {
  final padlist_model padlistmodel;
  const App02List({Key? key, required this.padlistmodel}) : super(key: key);

  @override
  _App02ListState createState() => _App02ListState();
}

class _App02ListState extends State<App02List>   {


  List<String> resultset = [];
  List<String> resultset2 = [];
  List<String> resultset3 = [];
  List<String> resultset4 = [];
  List<String> resultset5 = [];
  List<String> resultset6 = [];
  List<String> resultset7 = [];
  List<String> resultset8 = [];
  List<String> resultset9 = [];
  List<String> resultset10 = [];
  List<String> resultset11 = [];
  List<String> resultset12 = [];
  List<String> resultset13 = [];
  List<String> resultset14 = [];
  List<String> resultset15 = [];
  List<String> resultset16 = [];
  List<String> resultset17 = [];
  List<String> resultset18 = [];


  TextEditingController _etDate = TextEditingController();
  TimeOfDay selectedTime = TimeOfDay(hour: 00, minute: 00);
  DateTime _selectedDate = DateTime.now(), initialDate = DateTime.now();

  List<ca609list_modell> ca609Datas = ca609datal;
  List<TextEditingController> textControllers = List.generate(ca609datal.length, (index) => TextEditingController());












  String _dbnm = '';
  String _userid = '';
  String _username = '';

  String _perid = '';
  String _custcd = '';
  String _spjangcd = '';
  String checkvalue = 'true';


  @override
  void initState() {
    // TODO: implement initState
    sessionData();
    _initalizeState();
    _etDate.text = getToday();
    super.initState();





  }

  Future<void> _initalizeState() async {


    await ca609list_getdata();

  }


  String getToday(){
    var now = new DateTime.now();
    var formatter = new DateFormat('yyyyMMdd');
    String formattedDate = formatter.format(now);
    return formattedDate;
  }
  Future<void> sessionData() async{
    _dbnm     = (await SessionManager().get("dbnm")).toString();
    _userid   = (await SessionManager().get("userid")).toString();
    _username = (await SessionManager().get("username")).toString();
    _perid    = (await SessionManager().get("perid")).toString().replaceAll("p", "");
    _custcd    = (await SessionManager().get("custcd")).toString();
    _spjangcd    = (await SessionManager().get("spjangcd")).toString();
    print(_perid);
  }



  @override
  void dispose() {
    _etDate.dispose();
    ca609datal.clear();
    super.dispose();
  }

  Future ca609list_getdata() async {
    String _dbnm = await  SessionManager().get("dbnm");

    var uritxt = CLOUD_URL + "/ca609/list02";
    var encoded = Uri.encodeFull(uritxt);

    Uri uri = Uri.parse(encoded);
    final response = await http.post(
      uri,
      headers: <String, String> {
        'Content-Type': 'application/x-www-form-urlencoded',
        'Accept' : 'application/json'
      },
      body: <String, String> {
        'dbnm': _dbnm,
        'custcd': _custcd,
        'spjangcd': _spjangcd,
        'pcode' : widget.padlistmodel.phm_pcod
      },
    );
    if(response.statusCode == 200){
      List<dynamic> alllist = [];
      alllist =  jsonDecode(utf8.decode(response.bodyBytes))  ;
      ca609datal.clear();

      for (int i = 0; i < alllist.length; i++) {
        ca609list_modell emObject= ca609list_modell(
          ischdate:alllist[i]['ischdate'],
          qcqty:alllist[i]['qcqty'],
          cltcd:alllist[i]['cltcd'],
          cltnm:alllist[i]['cltnm'],
          pcode:alllist[i]['pcode'],
          pname:alllist[i]['pname'],
          psize:alllist[i]['psize'],
          punit:alllist[i]['punit'],
          baldate:alllist[i]['baldate'],
          balnum:alllist[i]['balnum'],
          balseq:alllist[i]['balseq'],
          store:alllist[i]['store'],
          comcd:alllist[i]['comcd'],
          wmqty:alllist[i]['wmqty'],
          qcflag: alllist[i]['qcflag'],
          ibgflag: alllist[i]['ibgflag'],
          divicd: alllist[i]['divicd'],
          qty:    alllist[i]['qty'],
          qcdv:   alllist[i]['qcdv'],
          isChecked: true,
          textEditingController: TextEditingController(text: alllist[i]["wmqty"]),
        );


        resultset.add(alllist[i]["qcflag"]);
        resultset2.add(alllist[i]["ibgflag"]);
        resultset3.add(alllist[i]["baldate"]);
        resultset4.add(alllist[i]["balnum"]);
        resultset6.add(alllist[i]["cltcd"]);
        resultset7.add(alllist[i]["divicd"]);
        resultset8.add(alllist[i]["store"]);
        resultset9.add(alllist[i]["ischdate"]);
        resultset10.add(alllist[i]["comcd"]);
        resultset11.add(alllist[i]["pcode"]);
        resultset12.add(alllist[i]["pname"]);
        resultset13.add(alllist[i]["psize"]);
        resultset14.add(alllist[i]["punit"]);
        resultset15.add(alllist[i]["qty"]);
        resultset16.add(alllist[i]["qcdv"]);
        resultset17.add(alllist[i]["balseq"]);
        resultset18.add(alllist[i]["wmqty"]);



        setState(() {
          ca609Datas.add(emObject);
        });

      }
      print("서버통신 성공");
      return ca609Datas;
    }else{
      //만약 응답이 ok가 아니면 에러를 던집니다.
      throw Exception('불러오는데 실패했습니다');
    }
  }

  @override
  Future<bool> save_CA() async {
    _dbnm = await  SessionManager().get("dbnm");
    var uritxt = CLOUD_URL + '/ca609/Update_TB_CA';
    var encoded = Uri.encodeFull(uritxt);
    Uri uri = Uri.parse(encoded);
    print("----------------------------");

    final response = await http.post(
        uri,
        headers: <String, String> {
          'Content-Type': 'application/json',
          'Accept' : 'application/json'
        },
        body: json.encode({
          'dbnm': _dbnm,
          'ls_qcflag' : resultset,
          'ls_ibgflag' : resultset2,
          'as_baldate' : resultset3,
          'as_balnum'  : resultset4,
          'as_cltcd'   : resultset6,
          'gs_perid'   : _perid,
          'gs_today'   : _etDate.text.toString(),
          'as_divicd'  : resultset7,
          'as_store'   : resultset8,
          'as_ischdate': resultset9,
          'as_comcd'   : resultset10,
          'as_pcode'   : resultset11,
          'as_pname'   : resultset12,
          'as_psize'   : resultset13,
          'as_punit'   : resultset14,
          'ae_qty'     : resultset5,
          'as_qcdv'    : resultset16,
          'as_balseq'  : resultset17,
          'ae_wqcqty'  : resultset18

        }));
    if(response.statusCode == 200){
      print("저장됨");
      return true;
    }else{
      throw Exception('고장부위를 불러오는데 실패했습니다.');

    }

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: GlobalStyle.appBarIconThemeColor,
        ),
        elevation: GlobalStyle.appBarElevation,
        title: Text('수입검사작업',
          style: GlobalStyle.appBarTitle,
        ),
        backgroundColor: GlobalStyle.appBarBackgroundColor,
        systemOverlayStyle: GlobalStyle.appBarSystemOverlayStyle,
      ),

      body:
      WillPopScope(
        onWillPop: (){
          Navigator.pop(context);
          return Future.value(true);
        },
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _etDate,
                    readOnly: true,
                    onTap: () {
                      _selectDateWithMinMaxDate(context);
                      print(_etDate.text);
                    },
                    maxLines: 1,
                    cursorColor: Colors.grey[600],
                    style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                    decoration: InputDecoration(
                      isDense: true,
                      contentPadding:  EdgeInsets.all(10),
                      suffixIcon: Icon(Icons.date_range, color: Colors.indigo),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey[600]!),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey[600]!),
                      ),
                      labelText: '수입검사일',
                      labelStyle: TextStyle(color: BLACK_GREY),
                    ),
                  ),
                ),
              ],
            ),

            Expanded(child: ListView.builder(itemCount: ca609datal.length,
              padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
              physics: AlwaysScrollableScrollPhysics(),
              itemBuilder: (BuildContext context, int index){
                return _buildListCard(ca609datal[index]);
              },
            )),
            SizedBox(
              height: 20,
            ),
            Container(
              width: double.infinity,
              child: TextButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.resolveWith<Color>(
                          (Set<MaterialState> states) => SOFT_BLUE,
                    ),
                    overlayColor: MaterialStateProperty.all(Colors.transparent),
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(3.0),
                      ),
                    ),
                  ),
                  onPressed: () async
                  {

                    print(resultset);
                    print(resultset2);
                    print(resultset3);
                    print(resultset4);
                    print(resultset5);


                    showDialog(context: context, builder: (context){
                      return AlertDialog(
                        content: Text('입고등록 하시겠습니까?'),
                        actions: <Widget>[
                          TextButton(onPressed: (){

                            for(var item in ca609datal){
                              if(item.isChecked){
                                for(int i=0; i<ca609datal.length; i++){
                                  String? value = ca609datal[i].textEditingController?.text;
                                  resultset5.add(value ?? '0');

                                }
                              }
                            }

                            save_CA();
                            Navigator.pop(context);
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => TabHomePage()));
                          }, child: Text('OK'))
                        ],
                      );
                    });
                    //save_fplandata();

                  }, child: Padding(padding: const EdgeInsets.symmetric(vertical: 5.0),
                child: Text('입고등록',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white
                  ),
                  textAlign: TextAlign.center,
                ),)),
            )
          ],
        ),
      ),
    );

  }



  Widget _buildListCard(ca609list_modell ca609Data){

    //TextEditingController cnt = TextEditingController(text: padlistmodel.Count.toString());

    return Card(
      margin: EdgeInsets.only(top: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
      ),
      elevation: 2,
      color: Colors.white,
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: (){

        },
        child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: (){

          },
          child: Container(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('입고예정일: ' + ca609Data.ischdate.toString()   , style: GlobalStyle.couponName),
                Text('거래처: ' + ca609Data.cltnm.toString()   , style: GlobalStyle.couponName),
                Text('품목명: ' + ca609Data.pname.toString()   , style: GlobalStyle.couponName),
                Text('규격: ' + ca609Data.psize.toString()   , style: GlobalStyle.couponName),
                Text('미입고수량: ' + ca609Data.wmqty.toString()   , style: GlobalStyle.couponName),
                SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text("실입고수량 : ", style: TextStyle(
                            fontSize: 14, color: SOFT_BLUE, fontWeight: FontWeight.bold
                        )),
                        Container(
                          width: 120,
                          height: 30,
                          child: TextField(
                            maxLength: 9,
                            controller: ca609Data.textEditingController,
                            cursorColor: Colors.grey[600],
                            style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              counterText: '',
                            ),
                          ),
                        )
                      ],
                    ),
                    Checkbox(
                        value: ca609Data.isChecked,
                        onChanged: (bool? value){
                          setState(() {
                            ca609Data.isChecked = value ?? true;

                            if(ca609Data.isChecked)
                            {
                              resultset.add(ca609Data.qcflag);
                              resultset2.add(ca609Data.ibgflag);
                              resultset3.add(ca609Data.baldate);
                              resultset4.add(ca609Data.balnum);
                              resultset6.add(ca609Data.cltcd);
                              resultset7.add(ca609Data.divicd);
                              resultset8.add(ca609Data.store);
                              resultset9.add(ca609Data.ischdate);
                              resultset10.add(ca609Data.comcd);
                              resultset11.add(ca609Data.pcode);
                              resultset12.add(ca609Data.pname);
                              resultset13.add(ca609Data.psize);
                              resultset14.add(ca609Data.punit);
                              //resultset5.add(ca609Data.qty);
                              resultset16.add(ca609Data.qcdv);
                              resultset17.add(ca609Data.balseq);
                              resultset18.add(ca609Data.wmqty);


                            }else{
                              resultset.remove(ca609Data.qcflag);
                              resultset2.remove(ca609Data.ibgflag);
                              resultset3.remove(ca609Data.baldate);
                              resultset4.remove(ca609Data.balnum);
                              resultset6.remove(ca609Data.cltcd);
                              resultset7.remove(ca609Data.divicd);
                              resultset8.remove(ca609Data.store);
                              resultset9.remove(ca609Data.ischdate);
                              resultset10.remove(ca609Data.comcd);
                              resultset11.remove(ca609Data.pcode);
                              resultset12.remove(ca609Data.pname);
                              resultset13.remove(ca609Data.psize);
                              resultset14.remove(ca609Data.punit);
                              //resultset5.remove(ca609Data.qty);
                              resultset16.remove(ca609Data.qcdv);
                              resultset17.remove(ca609Data.balseq);
                              resultset18.remove(ca609Data.wmqty);


                            }
                            checkvalue = ca609Data.isChecked ? 'Y' : '';

                          });
                        })
                    /* GestureDetector(
                        onTap: (){
                          print(ca609Data);
                          // Navigator.push(context, MaterialPageRoute(builder: (context) => AppPage11Detail(da035Data: da035Data)));
                        },
                        child: Text( ca609Data.cltnm, style: TextStyle(
                            fontSize: 14, color: SOFT_BLUE, fontWeight: FontWeight.bold
                        )),
                      ),*/
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }


  void showAlertDialog_Clear(BuildContext context) async {
    String result = await showDialog(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('ACTAS 출고등록'),
          content: Text("스캔한 LotNo를 리셋하시겠습니까?"),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () async{
                setState(() {

                });
                Navigator.pop(context, "닫기");
              },
            ),
            TextButton(
              child: Text('취소'),
              onPressed: () {
                Navigator.pop(context, "닫기");
              },
            ),
          ],
        );
      },
    );
  }


  void showAlertDialog(BuildContext context, String as_msg) async {
    String result = await showDialog(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('ACTAS 입고등록'),
          content: Text(as_msg),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.pop(context, "확인");
              },
            ),
          ],
        );
      },
    );
  }


  Future<Null> _selectDateWithMinMaxDate(BuildContext context) async {
    var firstDate = DateTime(initialDate.year, initialDate.month - 3, initialDate.day);
    var lastDate = DateTime(initialDate.year, initialDate.month, initialDate.day + 7);
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: firstDate,
      lastDate: lastDate,
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: Colors.indigo,
            colorScheme: ColorScheme.light(primary: Colors.indigo, secondary: Colors.indigo),
            buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;

        _etDate = TextEditingController(
            text: _selectedDate.toLocal().toString().split('-')[0]+_selectedDate.toLocal().toString().split('-')[1]+_selectedDate.toLocal().toString().split('-')[2].substring(0,2));
      });
    }
  }




}



