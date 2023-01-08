
import 'package:cloud_firestore/cloud_firestore.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final CollectionReference _mainCollection = _firestore.collection('ta_ppb');

class TransaksiFire {

  Future<void> addTransaksi({
    String id,
    int barang_id,
    String nama,
    int total
  }) async {
    DocumentReference documentReferencer =
    _mainCollection.doc("transaksi").collection('items').doc(id);

    Map<String, dynamic> data = <String, dynamic>{
      "barang_id": barang_id,
      "nama": nama,
      "total": total,
    };

    await documentReferencer
        .set(data)
        .whenComplete(() => print("Barang item added to the database"))
        .catchError((e) => print(e));
  }

}
