import 'dart:convert';

import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:http/http.dart' as http;

import '../../config/constant.dart';


class Da035List_model{
  late var custcd;
  late var spjangcd;
  late var fdeldate;
  late var fdeldatetext;
  late var fdelnum;
  late var fdelseq;
  late var cltcd;
  late var cltnm;
  late var pcode;
  late var pname;
  late var width;
  late var thick;
  late var color;
  late var deldate;
  late var delnum;
  late var delseq;
  late var grade;
  late var qty;
  late var lotno;
  late var psize;
  late var uamt;
  late var samt;




  Da035List_model({ required this.custcd,required this.spjangcd, this.fdeldate, this.fdeldatetext, this.fdelnum, this.fdelseq,
    required this.cltcd, required this.cltnm,
    required this.pcode,required this.pname,  this.width,   this.thick,  this.color,  this.deldate,required this.delnum,required this.delseq,
      this.grade,   this.qty, this.lotno, this.psize, this.uamt, this.samt});






}


List<Da035List_model> da035Data =[];
