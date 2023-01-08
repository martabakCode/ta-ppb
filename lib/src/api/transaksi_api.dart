import 'package:ta_ppb_flutter/src/model/barang.dart';
import 'package:http/http.dart' show Client;
import 'package:ta_ppb_flutter/src/model/transaksi.dart';
import 'package:ta_ppb_flutter/src/model/transaksi.dart';
import 'package:ta_ppb_flutter/src/network/api.dart';

class TransaksiApi {


  Future<List<Transaksi>> createTransaksi(Transaksi data) async {
    var response = await Network().postData(data,'/transaksi');
    if (response.statusCode == 200) {
      return transaksiFromJson(response.body);
    } else {
      return null;
    }
  }

}
