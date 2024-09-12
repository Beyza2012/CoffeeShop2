import 'package:coffee_shop/address.dart';
import 'package:coffee_shop/details.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:readmore/readmore.dart';
import 'baskets.dart';
import 'campaign.dart';
import 'campaigns.dart';
import 'coffees.dart';
import 'coffeesdao.dart';

class Order extends StatefulWidget {
  final Map<int, int> coffeeQuantities;
  Order({required this.coffeeQuantities});

  @override
  State<Order> createState() => _OrderState();
}

class _OrderState extends State<Order> {
  late double totalPriceFin = 0.0;
  int selectedCampaign = 0;
  double saleValue = 0.0;
  double delivery = 1.0;
  Future<List<Campaigns>> campList() async {
    var coffeeList = await Coffeesdao().campaignListdao();
    for(Campaigns k in coffeeList){
      // print("********************");
      // print(" id:${k.coffee_id}");
      //print(" ad:${k.coffeeName}");
      // print("price:${k.price}");
      // print("point:${k.point}");
      // print("milk:${k.withMilk}");
      // print("image:${k.imageName}");

    }
    return coffeeList;
  }
  double calculateSale(double value) {
    double s = (totalPriceFin * value) / 100;
    return s;
  }

  Future<double?> calculateTotalPrice() async {
    var sepetListesi = await Coffeesdao().coffeeInBasket();
    double toplam = 0.0;

    for (Baskets sepet in sepetListesi) {
      double? fiyat = double.tryParse(sepet.coffee.price);
      int miktar = widget.coffeeQuantities[sepet.coffee.coffee_id] ?? 0;
      toplam += (fiyat ?? 0.0) * miktar;
    }

    return toplam;
  }

  Future<List<Baskets>> siparis() async{
    var liste = await Coffeesdao().coffeeInBasket();
    return liste;
  }

  var typeOrder=["Deliver","Pick Up"];
  var orderStatus=["Let me know when you arrive for preparation.","Order is being prepared"];
  var selectedOrderStatus = 0;
  var selectedTypeOrder = 0;
  var addressList = <Address>[];
  var address1 = Address(streetName: "Jl. Kpg Sutoyo", detailAddress: "Kpg. Sutoyo No. 620, Bilzen, Tanjungbalai.");
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Column(
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
                    Text("Order",style: TextStyle(fontSize: 25,color: Colors.black),
                    ),
                    Icon(Icons.check_box_outline_blank,color: Colors.white,),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 370,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(242, 242, 242, 1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: 50,
                        child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: typeOrder.length,
                            itemBuilder: (context,indeks){
                               return Padding(
                                 padding: const EdgeInsets.only(left: 12),
                                 child: Row(
                                   //mainAxisAlignment: MainAxisAlignment.center,
                                   children: [
                                   GestureDetector(
                                     onTap: (){
                                       setState(() {
                                         selectedTypeOrder = indeks;
                                       });
                                     },
                                     child: Container(
                                     width: 167,
                                     height: 35,
                                     decoration: BoxDecoration(
                                       color: selectedTypeOrder==indeks
                                           ? Color.fromRGBO(198, 124, 78, 1)
                                           : Color.fromRGBO(242, 242, 242, 1),
                                       borderRadius: BorderRadius.circular(10),
                                     ),
                                     child: Row(
                                       mainAxisAlignment: MainAxisAlignment.center,
                                       children: [
                                         Text(typeOrder[indeks],style: TextStyle(color:
                                           selectedTypeOrder==indeks
                                               ? Colors.white
                                               : Colors.black,
                                           fontWeight: selectedTypeOrder==indeks
                                           ? FontWeight.bold
                                           : FontWeight.normal,
                                         ),),
                                       ],
                                     ),
                                     ),
                                   ),

                                   ],
                                 ),
                               );
                        }
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              selectedTypeOrder == 0 // "Deliver" seçeneği
                  ?
              Column(
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 20,left: 25),
                        child: Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(bottom: 15),
                                child: Text("Delivery Address",style: TextStyle(fontWeight: FontWeight.bold),),
                              ),
                              //Spacer(),
                              Padding(
                                padding: EdgeInsets.only(bottom: 15),
                                child: Text("${address1.streetName}",style: TextStyle(fontWeight: FontWeight.bold)),
                              ),
                              Text("${address1.detailAddress}",style: TextStyle(color: Colors.grey)),
                              Padding(
                                padding: EdgeInsets.only(top: 15),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 120,
                                      height: 27,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Icon(Icons.edit_calendar_outlined,size: 20,),
                                          Text("Edit Address"),
                                        ],
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        border: Border.all(
                                          color: Colors.grey,
                                        ),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(left: 15),
                                      child: Container(
                                        width: 100,
                                        height: 27,
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Icon(Icons.note_add_outlined,size: 20,),
                                            Text("Add Note"),
                                          ],
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          border: Border.all(
                                            color: Colors.grey,
                                          ),
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),





                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: FutureBuilder<List<Baskets>>(
                      future: siparis(),
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
                                widget.coffeeQuantities[siparis!.coffee.coffee_id] ??= 1;
                                double totalPrice =
                                    (double.tryParse(siparis.coffee.price) ?? 0.0) *
                                        widget.coffeeQuantities[siparis.coffee.coffee_id]!;
                                return SizedBox(
                                  height: 100,
                                  child: Card(
                                    child: Row(
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(left: 25),
                                          child: Container(
                                            color: Color.fromRGBO(242, 242, 242, 1),
                                            child: Row(
                                              children: [
                                                SizedBox(
                                                    width: 70,
                                                    height: 70,
                                                    child: Image.asset("resimler/${siparis.coffee.imageName}")),

                                                Padding(
                                                  padding: const EdgeInsets.only(left: 8.0,right: 120),
                                                  child: SizedBox(
                                                    width: 100,
                                                    height: 42,
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Text("${siparis.coffee.coffeeName}",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15)),
                                                        Text("${siparis.coffee.withMilk}")
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 60,
                                                  height: 42,
                                                  child: Column(
                                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                    children: [
                                                      Text(widget.coffeeQuantities[siparis.coffee.coffee_id].toString(),style: TextStyle(color: Color.fromRGBO(198, 124, 78, 1)),),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              });
                        }else{
                          return Column(
                            children: [
                              Text("veri yokk")
                            ],
                          );
                        }

                      },
                    ),
                  ),



                  Padding(
                    padding: EdgeInsets.only(top: 15, left: 25),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: (){
                            showDialog(context: context, builder: (BuildContext context){
                              return AlertDialog(
                                title: Text("Campaign"),
                                content: Column(
                                  children: [ SizedBox(
                                    width: 600,
                                    height: 500,
                                    child: FutureBuilder<List<Campaigns>>(
                                      future: campList(),
                                      builder: (context,snapshot) {
                                        if(snapshot.hasData){
                                          var campList = snapshot.data;
                                          return ListView.builder(
                                            itemCount: campList!.length,
                                            itemBuilder: (context, index) {
                                              var camp = campList?[index];
                                              return Card(
                                                child: SizedBox(
                                                  height: 160,
                                                  width: 400,
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      color: Colors.white38,
                                                    ),
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                      children: [
                                                        Container(
                                                          width: 100,
                                                          height: 100,
                                                          decoration: BoxDecoration(
                                                            borderRadius: BorderRadius.circular(20),
                                                            image: DecorationImage(
                                                              image: AssetImage("resimler/${camp?.campaignsImageName}"),
                                                              fit: BoxFit.fill,
                                                            ),
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding: const EdgeInsets.only(top:20, bottom:10),
                                                          child: Column(
                                                            children: [
                                                              Row(
                                                                children: [
                                                                  SizedBox(
                                                                      height: 60,
                                                                      width: 150,
                                                                      child: Text("${camp?.campaignsexplanation}")
                                                                  ),
                                                                ],
                                                              ),
                                                              SizedBox(
                                                                height: 60,
                                                                width: 150,
                                                                child: Row(
                                                                  children: [
                                                                    TextButton(onPressed: (){
                                                                      if (selectedCampaign==0){
                                                                        setState(() {
                                                                          selectedCampaign = camp!.campaigns_id;
                                                                          saleValue = camp!.campaignsValue;
                                                                        });

                                                                      }
                                                                      else if(selectedCampaign == camp!.campaigns_id){
                                                                        ScaffoldMessenger.of(context).showSnackBar(
                                                                          SnackBar(
                                                                            content: Text("Zaten uygulandı."),
                                                                            action: SnackBarAction(
                                                                              label: "Remove",
                                                                              onPressed: () {
                                                                                setState(() {
                                                                                  selectedCampaign = 0;
                                                                                });

                                                                              },

                                                                            ),
                                                                          ),
                                                                        );
                                                                      }
                                                                      else {
                                                                        ScaffoldMessenger.of(context).showSnackBar(
                                                                          SnackBar(
                                                                            content: Text("En fazla bir indirim uygulanır"),
                                                                          ),
                                                                        );
                                                                      }

                                                                      Navigator.pop(context);
                                                                      print("sale fiyat:${calculateSale(saleValue)}");
                                                                    }, child: Text("Apply",style: TextStyle(color: Color.fromRGBO(198, 124, 78, 1)),)),

                                                                  ],
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              );

                                            },
                                          );
                                        }else{
                                          return Column(
                                            children: [
                                              Text("Campaings"),
                                            ],
                                          );
                                        }
                                      },
                                    ),
                                  ),

                                  ],
                                ),
                              );
                            });
                            //Navigator.push(context, MaterialPageRoute(builder: (context) => Campaign()));
                          },
                          child: Container(
                            width: 320,
                            height: 56,
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: SizedBox(
                                      width: 30,
                                      height: 30,
                                      child: Image.asset("resimler/saleicon.png")
                                  ),
                                ),
                                Text("1 Apply discount",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
                                Padding(
                                  padding: EdgeInsets.only(left: 130),
                                  child: Icon(Icons.chevron_right),
                                ),
                              ],
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                color: Colors.grey,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        GestureDetector(
                            onTap: (){
                              if(selectedCampaign !=0){
                                setState(() {
                                  selectedCampaign = 0;
                                  totalPriceFin = ((totalPriceFin * saleValue) / 100)*100/saleValue;
                                });

                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text("İndirim kaldırıldı."),
                                  ),
                                );
                              }
                              else if(selectedCampaign==0){
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text("Uygulanan indirim yok"),
                                  ),
                                );
                              }

                            },
                            child: Padding(
                              padding: const EdgeInsets.only(left: 8),
                              child: Container(
                                  width: 50,
                                  height: 56,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(
                                      color: Colors.grey,
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Icon(Icons.delete,color: Color.fromRGBO(198, 124, 78, 1))),
                            )) ,

                      ],
                    ),
                  ),


                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 20,left: 30),
                        child: Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(bottom: 15),
                                child: Text("Payment Summary",style: TextStyle(fontWeight: FontWeight.bold),),
                              ),
                              Row(
                                children: [
                                  Text("Price"),
                                  Padding(
                                    padding: EdgeInsets.only(left: 281),
                                    child: Text(r"$" "${totalPriceFin}"),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 10),
                                child: Row(
                                  children: [
                                    Text("Delivery Fee"),
                                    Padding(
                                      padding: EdgeInsets.only(left: 210,right: 5),
                                      child: Text(r"$" "2.0",style: TextStyle(
                                        decoration: TextDecoration.lineThrough, // Opsiyonel: Üstü çizgi rengi
                                        decorationThickness: 1, // Opsiyonel: Üstü çizgi kalınlığı
                                      ),),
                                    ),
                                    Text(r"$" "1.0"),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 10,bottom: 30),
                                child: Row(
                                  children: [
                                    Text("Total Payment"),
                                    Padding(
                                      padding: EdgeInsets.only(left: 220),
                                      child: Text(
                                          selectedCampaign == 0
                                              ? "${totalPriceFin + delivery}"
                                              : r"$" "${calculateSale(saleValue) + delivery}"
                                      ),

                                    ),
                                  ],
                                ),
                              ),

                            ],
                          ),
                        ),
                      )
                    ],
                  ),





                ],
              )
              : Column(
                children: [
                  Row(
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: FutureBuilder<List<Baskets>>(
                          future: siparis(),
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
                                    widget.coffeeQuantities[siparis!.coffee.coffee_id] ??= 1;
                                    double totalPrice =
                                        (double.tryParse(siparis.coffee.price) ?? 0.0) *
                                            widget.coffeeQuantities[siparis.coffee.coffee_id]!;
                                    return SizedBox(
                                      height: 100,
                                      child: Card(
                                        child: Row(
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.only(left: 25),
                                              child: Container(
                                                color: Color.fromRGBO(242, 242, 242, 1),
                                                child: Row(
                                                  children: [
                                                    SizedBox(
                                                        width: 70,
                                                        height: 70,
                                                        child: Image.asset("resimler/${siparis.coffee.imageName}")),

                                                    Padding(
                                                      padding: const EdgeInsets.only(left: 8.0,right: 120),
                                                      child: SizedBox(
                                                        width: 100,
                                                        height: 42,
                                                        child: Column(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            Text("${siparis.coffee.coffeeName}",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15)),
                                                            Text("${siparis.coffee.withMilk}")
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 60,
                                                      height: 42,
                                                      child: Column(
                                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                        children: [
                                                          Text(widget.coffeeQuantities[siparis.coffee.coffee_id].toString(),style: TextStyle(color: Color.fromRGBO(198, 124, 78, 1)),),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    );
                                  });
                            }else{
                              return Column(
                                children: [
                                  Text("veri yokk")
                                ],
                              );
                            }

                          },
                        ),
                      ),
                    ],

                      ),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 20,left: 30),
                        child: Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(bottom: 15),
                                child: Text("Payment Summary",style: TextStyle(fontWeight: FontWeight.bold),),
                              ),
                              Row(
                                children: [
                                  Text("Price"),
                                  Padding(
                                    padding: EdgeInsets.only(left: 281),
                                    child: Text(r"$" "${totalPriceFin}"),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 10),
                                child: Row(
                                  children: [
                                    Text("Delivery Fee"),
                                    Padding(
                                      padding: EdgeInsets.only(left: 210,right: 5),
                                      child: Text(r"$" "2.0",style: TextStyle(
                                        decoration: TextDecoration.lineThrough, // Opsiyonel: Üstü çizgi rengi
                                        decorationThickness: 1, // Opsiyonel: Üstü çizgi kalınlığı
                                      ),),
                                    ),
                                    Text(r"$" "1.0"),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 10,bottom: 30),
                                child: Row(
                                  children: [
                                    Text("Total Payment"),
                                    Padding(
                                      padding: EdgeInsets.only(left: 220),
                                      child: Text(
                                          selectedCampaign == 0
                                              ? "${totalPriceFin + delivery}"
                                              : r"$" "${calculateSale(saleValue) + delivery}"
                                      ),

                                    ),
                                  ],
                                ),
                              ),

                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(selectedOrderStatus == 0 ? orderStatus[0]:orderStatus[1],style: TextStyle(color: Color.fromRGBO(198, 124, 78, 1)),)
                    ],
                  )

                ],
              )


            ],
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        color: Color.fromRGBO(255, 245, 238, 1),
        child: Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 300,
                height: 200,
                child: ElevatedButton(
                  onPressed: () {
                    if(selectedTypeOrder == 1){
                      selectedOrderStatus= 1;
                    }
                    //Navigator.push(context, MaterialPageRoute(builder: (context) => Order(coffeeName: "${widget.coffeeName}", imageName: "${widget.imageName}", point: "${widget.point}", price: "${widget.price}", withMilk: "${widget.withMilk}")));
                  },
                  style: ButtonStyle(
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)
                        ),
                      ),
                      backgroundColor: MaterialStateProperty.all<Color>(Color.fromRGBO(198, 124, 78, 1))
                  ),
                  child: Text(selectedTypeOrder == 0 ? "Order" : "Prepare My Order",style: TextStyle(color: Colors.white),),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
