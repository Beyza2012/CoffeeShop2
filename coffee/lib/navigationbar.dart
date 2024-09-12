import 'package:coffee_shop/basket.dart';
import 'package:coffee_shop/campaign.dart';
import 'package:coffee_shop/details.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'buymenu.dart';
import 'main.dart';

class BarMenu extends StatefulWidget {
  const BarMenu({super.key});

  @override
  State<BarMenu> createState() => _BarMenuState();
}

class _BarMenuState extends State<BarMenu> {
  var sayfaListesi=[BuyMenu(),basket(),Campaign()];
  int secilensayfaindeks=0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: sayfaListesi[secilensayfaindeks],
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home),
              label: "▬"),
          BottomNavigationBarItem(icon: Icon(Icons.help),
              label: "▬"),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_basket),
              label: "▬"),
          BottomNavigationBarItem(icon: Icon(Icons.supervised_user_circle_outlined),
              label: "▬"),
        ],
        backgroundColor: Colors.white,
        selectedItemColor: Color.fromRGBO(198, 124, 78, 1),
        unselectedItemColor: Colors.grey,
        currentIndex: secilensayfaindeks,
        onTap: (indeks){
          setState(() {
            secilensayfaindeks = indeks;
          });
        },

      ),
    );
  }
}
