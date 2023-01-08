
import 'package:cloud_firestore/cloud_firestore.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final CollectionReference _mainCollection = _firestore.collection('ta_ppb');

class BarangFire {

  Future<void> addBarang({
    String id,
    String nama,
    String satuan,
    int harga,int jumlah,int terjual,
  }) async {
    DocumentReference documentReferencer =
    _mainCollection.doc("masterbarang").collection('items').doc(id);

    Map<String, dynamic> data = <String, dynamic>{
      "nama": nama,
      "satuan": satuan,
      "harga": harga,
      "jumlah": jumlah,
      "terjual": terjual,
    };

    await documentReferencer
        .set(data)
        .whenComplete(() => print("Barang item added to the database"))
        .catchError((e) => print(e));
  }

  Future<void> updateBarang({
    String nama,
    String satuan,
    int harga,int jumlah,int terjual,String id
  }) async {
    DocumentReference documentReferencer =
    _mainCollection.doc("masterbarang").collection('items').doc(id);

    Map<String, dynamic> data = <String, dynamic>{
      "nama": nama,
      "satuan": satuan,
      "harga": harga,
      "jumlah": jumlah,
      "terjual": terjual,
    };

    await documentReferencer
        .update(data)
        .whenComplete(() => print("Barang item updated in the database"))
        .catchError((e) => print(e));
  }

  Stream<QuerySnapshot> readBarangs() {
    CollectionReference notesItemCollection = _mainCollection.doc("masterbarang").collection('items');

    return notesItemCollection.snapshots();
  }

  Future<void> deleteBarang(String id) async {
    DocumentReference documentReferencer =
    _mainCollection.doc("masterbarang").collection('items').doc(id);

    await documentReferencer
        .delete()
        .whenComplete(() => print('Note item deleted from the database'))
        .catchError((e) => print(e));
  }
}
