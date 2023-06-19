import 'dart:convert';

import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:http/http.dart' as http;

import '../../config/constant.dart';


class Ca636List_model{
  late var custcd;
  late var spjangcd;
  late var movdate;
  late var strmovdate;
  late var movnum;
  late var movseq;
  late var cltcd;
  late var cltnm;
  late var pcode;
  late var pname;
  late var width;
  late var thick;
  late var color;
  late var grade;
  late var qty;
  late var lotno;
  late var psize;
  late var uamt;
  late var samt;




  Ca636List_model({  this.custcd, this.spjangcd, this.movdate, this.strmovdate, this.movnum, this.movseq,
     this.pcode,required this.pname,  this.width,   this.thick,  this.color,  this.grade,  this.lotno});






}


List<Ca636List_model> ca636Data =[];
