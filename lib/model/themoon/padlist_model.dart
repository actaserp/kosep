import 'dart:ffi';

class padlist_model{

  late var phm_pcod;
  late var phm_pnam;
  late var phm_size;
  late var phm_unit;
  late var code88;
  late var ischdate;
  late var cltnm;
  late var wmqty;
  late var cltcd;
  late var wqcqty;
  late var baldate;
  late var balnum;
  late var balseq;
  late var store;
  late var comcd;
  int Count;

  padlist_model({
    required this.phm_pnam,
    required this.phm_size,
             this.ischdate,
             this.cltcd,
             this.cltnm,
             this.wmqty,
             this.phm_pcod,
             this.phm_unit,
             this.wqcqty,
             this.baldate,
             this.balnum,
             this.balseq,
             this.store,
             this.comcd,
             this.code88,
             this.Count = 0,
});

  bool startsWith(String prefix){
    return phm_pcod.toString().startsWith(prefix);
  }

  @override
  String toString() {
    return '$phm_pcod $phm_pnam $phm_size $phm_unit $ischdate $cltnm $cltcd $wmqty $wqcqty $baldate $balnum $balseq $store $comcd $code88 $Count';
  }



}

List<padlist_model> padlists =[];