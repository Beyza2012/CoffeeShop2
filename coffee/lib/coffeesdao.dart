import 'package:coffee_shop/VeritabaniYardimcisi.dart';
import 'package:coffee_shop/campaign.dart';
import 'package:coffee_shop/campaigns.dart';
import 'package:coffee_shop/coffees.dart';
import 'package:coffee_shop/users.dart';

import 'baskets.dart';

class Coffeesdao{
  Future<List<Coffees>> coffeeListdao() async {
    var db = await VeritabaniYardimcisi.veritabaniErisim();
    List<Map<String, dynamic>> maps = await db.rawQuery(
        "SELECT * FROM coffees");
    return List.generate(maps.length, (i) {
      var satir = maps[i];
      return Coffees(coffee_id: satir["coffee_id"],coffeeName: satir["coffeeName"], imageName: satir["imageName"], point: satir["point"], price: satir["price"], withMilk: satir["withMilk"]);
    });
  }
  Future<List<Campaigns>> campaignListdao() async {
    var db = await VeritabaniYardimcisi.veritabaniErisim();
    List<Map<String, dynamic>> maps = await db.rawQuery(
        "SELECT * FROM campaigns");
    return List.generate(maps.length, (i) {
      var satir = maps[i];
      return Campaigns(campaigns_id: satir["campaigns_id"], campaignsName: satir["campaignsName"], campaignsImageName: satir["campaignsImageName"], campaignsValue: satir["campaignsValue"], campaignsexplanation: satir["campaignsexplanation"]);
    });
  }

  Future<users> usersOne(int users_id) async {
    var db = await VeritabaniYardimcisi.veritabaniErisim();

    List<Map<String, dynamic>> maps = await db.rawQuery(
        "SELECT * FROM users WHERE users_id = $users_id");

    var satir= maps[0];
    return users(users_id: satir["users_id"], usersName: satir["usersName"], imageName: satir["imageName"], location: satir["location"]);


  }
  Future<List<Baskets>> coffeeInBasket() async {
    var db = await VeritabaniYardimcisi.veritabaniErisim();
    List<Map<String, dynamic>> maps = await db.rawQuery(
        "SELECT * FROM coffees,baskets,users WHERE baskets.coffee_id = coffees.coffee_id and baskets.users_id = users.users_id");
    return List.generate(maps.length, (i) {
      var satir = maps[i];
      var c=Coffees(coffee_id: satir["coffee_id"],coffeeName: satir["coffeeName"], imageName: satir["imageName"], point: satir["point"], price: satir["price"], withMilk: satir["withMilk"]);
      var u= users(users_id: satir["users_id"], usersName: satir["usersName"], imageName: satir["usersimageName"], location: satir["location"]);
      var quantity = 1;
      return Baskets(basket_id: satir["baskets_id"], coffee: c, user: u,quantity: quantity);
    });

  }
  Future<void> basketGuncelle(int coffee_id, int coffee_quantity) async {
    try {
      var db = await VeritabaniYardimcisi.veritabaniErisim();
      var bilgiler = Map<String, dynamic>();
      bilgiler["coffee_quantity"] = coffee_quantity;
      await db.update("baskets", bilgiler, where: "coffee_id = ?", whereArgs: [coffee_id]);
    } catch (error) {
      print("Hata oluştu: $error");
      // Hatanın nedenini daha ayrıntılı incelemek için error'ı yazdırabilirsiniz
    }
  }

  Future<void> basketInsert(int coffee,int user,int quantity) async {
    var db = await VeritabaniYardimcisi.veritabaniErisim();
    var bilgiler = Map<String, dynamic>();
    bilgiler["coffee_id"] = coffee;
    bilgiler["users_id"] = user;
    bilgiler["coffee_quantity"] = quantity;
    await db.insert("baskets", bilgiler);

  }
  Future<void> userInsert(String name,String imageName,String location) async {
    var db = await VeritabaniYardimcisi.veritabaniErisim();
    var bilgiler = Map<String, dynamic>();
    bilgiler["usersName"] = name;
    bilgiler["usersimageName"] = imageName;
    bilgiler["location"] = location;
    await db.insert("users", bilgiler);

  }
  Future<void> coffeeInBasketDelete(int basket_id) async {
    var db = await VeritabaniYardimcisi.veritabaniErisim();
    await db.delete("baskets",where: "baskets_id =?",whereArgs: [basket_id]);
  }
}