
import 'package:coffee_shop/baskets.dart';
import 'package:coffee_shop/coffees.dart';
import 'package:coffee_shop/order.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'coffeesdao.dart';

class basket extends StatefulWidget {
  @override
  State<basket> createState() => _basketState();
}

class _basketState extends State<basket> {
  late double totalPriceFin = 0.0;
  Map<int, int> quantities = {};
  Future<double?> calculateTotalPrice() async {
    var sepetListesi = await Coffeesdao().coffeeInBasket();
    double toplam = 0.0;

    for (Baskets sepet in sepetListesi) {
      double? fiyat = double.tryParse(sepet.coffee.price);
      int miktar = quantities[sepet.coffee.coffee_id] ?? 0;
      toplam += (fiyat ?? 0.0) * miktar;
    }

    return toplam;
  }



  Future<void> basketDelete(int basket_id) async{
    await Coffeesdao().coffeeInBasketDelete(basket_id);
  }
  void initState() {
    super.initState();
    siparisListeGetir();
    basketGet();
  }

  Future<void> userekle() async{
    await Coffeesdao().userInsert("Hülya", "woman.png", "Yozgat");
  }

  Future<List<Baskets>> siparisListeGetir() async{
    var liste = await Coffeesdao().coffeeInBasket();
    return liste;
    }
   Future<void> basketEkle(int coffee, int user, int quantity) async{
    await Coffeesdao().basketInsert(coffee, user, quantity);
   }
   Future<void> basketGuncelle(int coffee_id, int coffee_quantity) async{
    await Coffeesdao().basketGuncelle(coffee_id, coffee_quantity);
   }
  Future<void> basketGet() async {
    var basketList = await Coffeesdao().coffeeInBasket();
    for (Baskets k in basketList) {
      print("********************");
      print(" basket_id:${k.basket_id}");
      print(" coffee_id:${k.coffee.coffee_id}");
      print(" coffeeName:${k.coffee.coffeeName}");
      print(" user_id:${k.user.users_id}");
      print(" quan:${k.quantity}");
    }
  }


  void arttir(int productId) {
    setState(() {
      quantities[productId] = (quantities[productId] ?? 0) + 1;
    });
  }


  void azalt(int productId) {
    setState(() {
      if (quantities[productId] != null && quantities[productId]! > 1) {
        quantities[productId] = quantities[productId]! - 1;
      }
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding:  EdgeInsets.only(top: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                GestureDetector(
                    onTap:(){
                      Navigator.pop(context);
                    },
                    child: Icon(Icons.chevron_left)
                ),
                Text("Basket",style: TextStyle(fontSize: 25,color: Colors.black),
                ),
                Icon(Icons.check_box_outline_blank,color: Colors.white,),
              ],
            ),
          ),
         SizedBox(
           width: 500,
           height: 400,
           child: FutureBuilder<List<Baskets>>(
               future: siparisListeGetir(),
               builder: (context,snapshot){
                    if(snapshot.hasData){
                    var siparisList = snapshot.data;
                    calculateTotalPrice().then((value) {
                      setState(() {
                        totalPriceFin = value ?? 0.0;
                      });
                    });
                    return ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    itemCount: siparisList?.length,
                    itemBuilder: (context,index){
                    var siparis = siparisList?[index];
                    quantities[siparis!.coffee.coffee_id] ??= 1;
                    double totalPrice =
                        (double.tryParse(siparis.coffee.price) ?? 0.0) *
                            quantities[siparis.coffee.coffee_id]!;
                    return Card(
                       child: Padding(
                         padding: const EdgeInsets.all(8.0),
                         child: Container(
                         decoration: BoxDecoration(
                          color: Colors.white38,
                                    ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                            Column(
                              children: [
                                Container(
                                 width: 150,
                                 height: 100,
                                 decoration: BoxDecoration(
                                 borderRadius: BorderRadius.circular(20),
                                 image: DecorationImage(
                                 image: AssetImage("resimler/${siparis?.coffee.imageName}"), fit:BoxFit.fill,
                                              ),
                                                  ),

                                                ),
                              ],
                            ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("${siparis?.coffee.coffeeName}",style: TextStyle(fontSize: 20,color: Colors.black,),),
                                    Text("${totalPrice}"),
                                  ],

                                ),
                                Row(
                                  children: [
                                    GestureDetector(
                                      onTap: (){
                                        setState(() {
                                          azalt(siparis.coffee.coffee_id);
                                        });
                                      },
                                      child: SizedBox(
                                        width: 30,
                                        height: 30,
                                        child: Container(
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Text('-'),
                                            ],
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            border: Border.all(
                                              color: Colors.grey,
                                            ),
                                            borderRadius: BorderRadius.circular(80),
                                          ),
                                        ),
                                      ),
                                    ),


                                    Text(
                                      "${quantities[siparis.coffee.coffee_id]}",
                                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                    ),
                                    GestureDetector(
                                      onTap: (){
                                        setState(() {
                                          arttir(siparis.coffee.coffee_id);
                                        });

                                      },
                                      child: SizedBox(
                                        width: 30,
                                        height: 30,
                                        child: Container(
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Text('+'),
                                            ],
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            border: Border.all(
                                              color: Colors.grey,
                                            ),
                                            borderRadius: BorderRadius.circular(80),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    Row(
                                      children: [
                                        GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                basketDelete(siparis.basket_id);
                                              });

                                            },

                                            child: Icon(Icons.delete,color: Color.fromRGBO(198, 124, 78, 1),)
                                        ),
                                      ],
                                    )
                                  ],
                                ),



                                      ], ),
                                  ),
                       ),
                     ) ;
                                       });

                   }
                       else{
                             return Center(
                               child: Text("veri yok"),
                             );
               }

                   }

           ),
         )


        ],),
      bottomNavigationBar: BottomAppBar(
        color: Color.fromRGBO(255, 245, 238, 1),
        child: Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Price",style: TextStyle(color: Colors.grey),),
                Text(
                  "${totalPriceFin}",
                  style: TextStyle(fontSize: 20),
                ),


                  ],
                ),
              ),
              SizedBox(
                width: 200,
                child: ElevatedButton(
                  onPressed:() async{
                    Navigator.push(context, MaterialPageRoute(builder: (context) => Order(coffeeQuantities: quantities,)));
                  },
                  style: ButtonStyle(
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)
                        ),
                      ),
                      backgroundColor: MaterialStateProperty.all<Color>(Color.fromRGBO(198, 124, 78, 1))
                  ),
                  child: Text("Confirm the basket.",style: TextStyle(color: Colors.white),),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
