import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ta_ppb_flutter/src/api/barang_api.dart';
import 'package:ta_ppb_flutter/src/api/profile_api.dart';
import 'package:ta_ppb_flutter/src/firebase/barang_fire.dart';
import 'package:ta_ppb_flutter/src/model/barang.dart';
import 'package:ta_ppb_flutter/src/ui/home/home_barang.dart';

final GlobalKey<ScaffoldState> _scaffoldState = GlobalKey<ScaffoldState>();

class FormAddBarang extends StatefulWidget {
  Barang barang;

  FormAddBarang({this.barang});

  @override
  _FormAddProfileState createState() => _FormAddProfileState();
}

class _FormAddProfileState extends State<FormAddBarang> {
  bool _isLoading = false;
  BarangApi _apiService = BarangApi();
  BarangFire _firebaseService = BarangFire();
  bool _isFieldNamaValid,_isFieldSatuanValid,_isFieldHargaValid,_isFieldJumlahValid,_isFieldTerjualValid;
  TextEditingController _controllerNama = TextEditingController();
  TextEditingController _controllerSatuan = TextEditingController();
  TextEditingController _controllerHarga = TextEditingController();
  TextEditingController _controllerJumlah = TextEditingController();
  TextEditingController _controllerTerjual = TextEditingController();

  @override
  void initState() {
    if (widget.barang != null) {
      _isFieldNamaValid = true;
      _controllerNama.text = widget.barang.nama;
      _isFieldSatuanValid = true;
      _controllerSatuan.text = widget.barang.satuan;
      _isFieldHargaValid = true;
      _controllerHarga.text = widget.barang.harga.toString();
      _isFieldJumlahValid = true;
      _controllerJumlah.text = widget.barang.jumlah.toString();
      _isFieldTerjualValid = true;
      _controllerTerjual.text = widget.barang.terjual.toString();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldState,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          widget.barang == null ? "Form Add" : "Change Data",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Stack(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                _buildTextFieldNama(),
                _buildTextFieldSatuan(),
                _buildTextFieldHarga(),
                _buildTextFieldJumlah(),
                _buildTextFieldTerjual(),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.orange,
                      fixedSize: Size.fromWidth(100),
                      padding: EdgeInsets.all(10),
                      shape: new RoundedRectangleBorder(
                          borderRadius:
                          new BorderRadius.circular(20.0)),
                    ),
                    child: Text(
                      widget.barang == null
                          ? "Submit".toUpperCase()
                          : "Update Data".toUpperCase(),
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    onPressed: () async {
                      if (_isFieldNamaValid == null ||
                          _isFieldSatuanValid == null ||
                          _isFieldHargaValid == null ||
                          _isFieldJumlahValid == null ||
                          _isFieldTerjualValid == null ||
                          !_isFieldNamaValid ||
                          !_isFieldSatuanValid ||
                          !_isFieldHargaValid ||
                          !_isFieldJumlahValid ||
                          !_isFieldTerjualValid) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Please fill all field"),
                          ),
                        );
                        return;
                      }
                      setState(() => _isLoading = true);
                      String name = _controllerNama.text.toString();
                      String satuan = _controllerSatuan.text.toString();
                      int harga = int.parse(_controllerHarga.text.toString());
                      int jumlah = int.parse(_controllerJumlah.text.toString());
                      int terjual = int.parse(_controllerTerjual.text.toString());
                      Barang barang =
                          Barang(nama: name, satuan: satuan, harga: harga, jumlah: jumlah, terjual: terjual);
                      if (widget.barang == null) {
                        _apiService.createBarang(barang).then((isSuccess) async {
                          setState(() => _isLoading = false);
                          if (!isSuccess.toString().isEmpty) {
                            await _firebaseService.addBarang(
                              id: isSuccess[0].id.toString(),
                              nama: barang.nama,
                              satuan: barang.satuan,
                              harga: barang.harga,
                              jumlah: barang.jumlah,
                              terjual: barang.terjual,
                            );
                            Navigator.pushReplacement(
                              context,
                              new MaterialPageRoute(
                                  builder: (context) => HomeBarang()
                              ),
                            ).then((_) => setState(() {}));
                          } else {
                            print(isSuccess);
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text("Submit data failed"),
                            ));
                          }
                        });
                      } else {
                        barang.id = widget.barang.id;

                        _apiService.updateBarang(barang).then((isSuccess) async {
                          setState(() => _isLoading = false);
                          if (!isSuccess.toString().isEmpty) {
                            await _firebaseService.updateBarang(
                                nama: barang.nama,
                                satuan: barang.satuan,
                                harga: barang.harga,
                                jumlah: barang.jumlah,
                                terjual: barang.terjual,
                                id: barang.id.toString()
                            );
                            Navigator.pushReplacement(
                              context,
                              new MaterialPageRoute(
                                  builder: (context) => HomeBarang()
                              ),
                            ).then((_) => setState(() {}));
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text("Update data failed"),
                            ));
                          }
                        });
                      }
                    },
                  ),
                )
              ],
            ),
          ),
          _isLoading
              ? Stack(
                  children: <Widget>[
                    Opacity(
                      opacity: 0.3,
                      child: ModalBarrier(
                        dismissible: false,
                        color: Colors.grey,
                      ),
                    ),
                    Center(
                      child: CircularProgressIndicator(),
                    ),
                  ],
                )
              : Container(),
        ],
      ),
    );
  }

  Widget _buildTextFieldNama() {
    return TextField(
      controller: _controllerNama,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        labelText: "Nama Barang",
        errorText: _isFieldNamaValid == null || _isFieldNamaValid
            ? null
            : "Nama Barang is required",
      ),
      onChanged: (value) {
        bool isFieldValid = value.trim().isNotEmpty;
        if (isFieldValid != _isFieldNamaValid) {
          setState(() => _isFieldNamaValid = isFieldValid);
        }
      },
    );
  }

  Widget _buildTextFieldSatuan() {
    return TextField(
      controller: _controllerSatuan,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        labelText: "Satuan",
        errorText: _isFieldSatuanValid == null || _isFieldSatuanValid
            ? null
            : "Satuan is required",
      ),
      onChanged: (value) {
        bool isFieldValid = value.trim().isNotEmpty;
        if (isFieldValid != _isFieldSatuanValid) {
          setState(() => _isFieldSatuanValid = isFieldValid);
        }
      },
    );
  }

  Widget _buildTextFieldHarga() {
    return TextField(
      controller: _controllerHarga,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: "Harga",
        errorText: _isFieldHargaValid == null || _isFieldHargaValid
            ? null
            : "Harga is required",
      ),
      onChanged: (value) {
        bool isFieldValid = value.trim().isNotEmpty;
        if (isFieldValid != _isFieldHargaValid) {
          setState(() => _isFieldHargaValid = isFieldValid);
        }
      },
    );
  }

  Widget _buildTextFieldJumlah() {
    return TextField(
      controller: _controllerJumlah,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: "Jumlah",
        errorText: _isFieldJumlahValid == null || _isFieldJumlahValid
            ? null
            : "Jumlah is required",
      ),
      onChanged: (value) {
        bool isFieldValid = value.trim().isNotEmpty;
        if (isFieldValid != _isFieldJumlahValid) {
          setState(() => _isFieldJumlahValid = isFieldValid);
        }
      },
    );
  }

  Widget _buildTextFieldTerjual() {
    return TextField(
      controller: _controllerTerjual,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: "Terjual",
        errorText: _isFieldTerjualValid == null || _isFieldTerjualValid
            ? null
            : "Terjual is required",
      ),
      onChanged: (value) {
        bool isFieldValid = value.trim().isNotEmpty;
        if (isFieldValid != _isFieldTerjualValid) {
          setState(() => _isFieldTerjualValid = isFieldValid);
        }
      },
    );
  }
}
