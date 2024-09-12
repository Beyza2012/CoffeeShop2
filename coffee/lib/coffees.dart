import 'dart:ffi';
class Coffees{
   int coffee_id;
   String coffeeName;
   String imageName;
   String point;
   String price;
   String withMilk;
  Coffees({
    required this.coffee_id,required this.coffeeName, required this.imageName, required this.point, required this.price, required this.withMilk
  });
}