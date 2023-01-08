import 'dart:convert';

class Transaksi {
  int id;
  int barang_id;
  String nama;
  int total;

  Transaksi({this.id = 0, this.barang_id, this.nama, this.total});

  factory Transaksi.fromJson(Map<String, dynamic> map) {
    return Transaksi(
        barang_id: map["id"], nama: map["nama"], total: map["total"]);
  }

  Map<String, dynamic> toJson() {
    return {"id": id, "barang_id": barang_id, "nama": nama, "total": total};
  }

  @override
  String toString() {
    return 'Transaksi{id: $id, barang_id: $barang_id, nama: $nama, total: $total}';
  }

}

List<Transaksi> transaksiFromJson(String jsonData) {
  final data = json.decode(jsonData);
  return List<Transaksi>.from(data.map((item) => Transaksi.fromJson(item)));
}

String transaksiToJson(Transaksi data) {
  final jsonData = data.toJson();
  return json.encode(jsonData);
}
