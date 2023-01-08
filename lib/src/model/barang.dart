import 'dart:convert';

class Barang {
  int id;
  String nama,satuan;
  int harga,jumlah,terjual;

  Barang({this.id = 0, this.nama, this.satuan, this.harga, this.jumlah, this.terjual});

  factory Barang.fromJson(Map<String, dynamic> map) {
    return Barang(
        id: map["id"], nama: map["nama"], satuan: map["satuan"], harga: map["harga"], jumlah: map["jumlah"], terjual: map["terjual"]);
  }

  Map<String, dynamic> toJson() {
    return {"id": id, "nama": nama, "satuan": satuan, "harga" :harga,"jumlah" :jumlah,"terjual" :terjual};
  }

  @override
  String toString() {
    return 'Barang{id: $id, nama: $nama, satuan: $satuan, harga: $harga, jumlah: $jumlah, terjual: $terjual,}';
  }

}

List<Barang> barangFromJson(String jsonData) {
  final data = json.decode(jsonData);
  return List<Barang>.from(data.map((item) => Barang.fromJson(item)));
}

String barangToJson(Barang data) {
  final jsonData = data.toJson();
  return json.encode(jsonData);
}
