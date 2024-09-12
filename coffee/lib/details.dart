
import 'package:coffee_shop/basket.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:coffee_shop/buymenu.dart';
import 'package:readmore/readmore.dart';

import 'coffeesdao.dart';
import 'order.dart';


class Details extends StatefulWidget {

  int coffee_id;
  String coffeeName;
  String imageName;
  String point;
  String price;
  String withMilk;

  Details({required this.coffee_id,required this.coffeeName, required this.imageName, required this.point, required this.price, required this.withMilk});

  @override
  State<Details> createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  Future<void> basketekle() async{
    await Coffeesdao().basketInsert(widget.coffee_id, 1,1);
  }
  int selectedSizeIndex=0;
  var sizeofcoffee = ["S","M","L"];

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
                          Navigator.push(context,MaterialPageRoute(builder: (context)=>BuyMenu()));
                        },
                        child: Icon(Icons.chevron_left)
                    ),
                    Text("Detail",style: TextStyle(fontSize: 25,color: Colors.black),
                    ),
                    Image.asset("resimler/heart.png"),
                  ],
                ),
              ),
              Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 20,left: 25),
                    child: Container(
                      width: 360,
                      height: 250,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        image: DecorationImage(
                          image: AssetImage("resimler/${widget.imageName}"), fit:BoxFit.fill,
                        ),
                      ),
                    ),
                  )
                ],
              ),
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0,left: 20),
                      child: Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("${widget.coffeeName}",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                              Text("${widget.withMilk}",style: TextStyle(color: Colors.grey,fontSize: 15),),

                            ],
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 17),
                          child: Container(
                            child: Row(
                              children: [
                                Icon(Icons.star,color: Color.fromRGBO(251, 190, 33, 1),size: 25,),
                                Text("${widget.point}",style: TextStyle(fontSize: 20),
                                ),
                              ],
                            ),
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.only(right: 20),
                          child: Container(
                            child: Row(
                              children: [
                                SizedBox(
                                    width: 44,
                                    height: 44,
                                    child: Image.asset("resimler/iconcoffee1.png")
                                ),
                                SizedBox(
                                    width: 44,
                                    height: 44,
                                    child: Image.asset("resimler/iconcoffee2.png")
                                ),
                              ],
                            ),
                          ),
                        )

                      ],
                    ),
                  ],
                ),
              ),

              Padding(
                padding: EdgeInsets.only(top: 20,left: 20),
                child: Container(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Column(
                            children: [
                              Positioned(
                                left:  30,
                                top:  465,
                                child:
                                Align(
                                  child:
                                  SizedBox(
                                    width:  355,
                                    height:  1,
                                    child:
                                    Container(
                                      decoration:  BoxDecoration (
                                        color:  Color(0xffeaeaea),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8,bottom: 8),
                        child: Row(
                          children: [
                            Text("Description",style: TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          SizedBox(
                            height: 70,
                            width: 370,
                            child: ReadMoreText(
                              "A delightful fusion of robust espresso, velvety steamed milk, and airy foam, crafting a perfect harmony of intense coffee notes and creamy indulgence. Enjoy the rich sophistication.",
                              trimLines: 2,
                              colorClickableText: Colors.pink,
                              trimMode: TrimMode.Line,
                              trimCollapsedText: 'Read more',
                              trimExpandedText: 'Show less',
                              lessStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold,color: Color.fromRGBO(198, 124, 78, 1)),
                              moreStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold,color: Color.fromRGBO(198, 124, 78, 1)),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20,left: 20,bottom: 20),
                child: Row(
                  children: [
                    Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Size",style: TextStyle(fontSize: 16)),
                          SizedBox(
                            width: 360,
                            height: 50,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: sizeofcoffee.length,
                              itemBuilder: (context,indeks){
                                return GestureDetector(
                                  onTap: (){
                                    setState(() {
                                      selectedSizeIndex = indeks;
                                    });
                                  },
                                  child: SizedBox(
                                    width: 120,
                                    child: Card(
                                      child: Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(color: selectedSizeIndex ==indeks

                                         ? Color.fromRGBO(198, 124, 78, 1)
                                         : Color.fromRGBO(222, 222, 222, 1)
                                        ),
                                        borderRadius: BorderRadius.circular(10),
                                        color: selectedSizeIndex == indeks
                                          ?  Color.fromRGBO(255, 245, 238, 1)
                                            : Colors.white,
                                      ),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text(sizeofcoffee[indeks],style: TextStyle(
                                              color: selectedSizeIndex == indeks
                                                  ? Color.fromRGBO(198, 124, 78, 1)
                                                  : Colors.black,
                                            ),),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                            },),
                          )
                        ],
                      ),
                    )

                  ],
                ),
              ),
            ],
          ),

        ],
      ),
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
                    Text(r"$" "${widget.price}",style: TextStyle(color: Color.fromRGBO(198, 124, 78, 1),fontSize: 20),)

                  ],
                ),
              ),
              SizedBox(
                width: 200,
                child: ElevatedButton(
                  onPressed: () {
                    basketekle();
                    Navigator.push(context, MaterialPageRoute(builder: (context) => basket()));
                  },
                  style: ButtonStyle(
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)
                        ),
                      ),
                      backgroundColor: MaterialStateProperty.all<Color>(Color.fromRGBO(198, 124, 78, 1))
                  ),
                  child: Text("add to Basket",style: TextStyle(color: Colors.white),),
                ),
              ),
            ],
          ),
        ),
      ),


    );
  }
}