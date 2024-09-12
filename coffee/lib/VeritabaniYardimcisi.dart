import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class VeritabaniYardimcisi{
  static final String veritabaniAdi="kahveverileriGuncell.sqlite";

  static Future<Database> veritabaniErisim() async{
    String veritabaniYolu= join(await getDatabasesPath(),veritabaniAdi);
    if (await databaseExists(veritabaniYolu)){ //veritabanı var mı yok mu
      print("veritanabı zaten var. Kopyalamaya gerek yok");  }
    else{
      ByteData data = await rootBundle.load("veritabani/$veritabaniAdi");
      List<int> bytes = data.buffer.asUint8List(data.offsetInBytes,data.lengthInBytes);
      await File(veritabaniYolu).writeAsBytes(bytes, flush: true);
      print("Veritabanı koplayandı.");

    }
    return openDatabase(veritabaniYolu);


  }
}