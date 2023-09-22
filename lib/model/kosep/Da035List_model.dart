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
  late var remark;
  late var deldefault;




  Da035List_model({   this.custcd,  this.spjangcd, this.fdeldate, this.fdeldatetext, this.fdelnum, this.fdelseq,
      this.cltcd,   this.cltnm,
      this.pcode,  this.pname,  this.width,   this.thick,  this.color,  this.deldate,  this.delnum,  this.delseq,
      this.grade,   this.qty, this.lotno, this.psize, this.uamt, this.samt, this.remark, this.deldefault});






}


List<Da035List_model> da035Data =[];
