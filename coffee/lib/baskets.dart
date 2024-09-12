import 'package:coffee_shop/coffees.dart';
import 'package:coffee_shop/users.dart';

class Baskets{
  int basket_id;
  Coffees coffee;
  users user;
  int quantity;
  Baskets({required this.basket_id,required this.coffee,required this.user,required this.quantity});
}