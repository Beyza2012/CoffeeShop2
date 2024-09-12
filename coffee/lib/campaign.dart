import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:readmore/readmore.dart';

import 'campaigns.dart';
import 'coffeesdao.dart';

class Campaign extends StatefulWidget {
  const Campaign({super.key});

  @override
  State<Campaign> createState() => _CampaignState();
}

class _CampaignState extends State<Campaign> {
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
                Text("Campaign",style: TextStyle(fontSize: 25,color: Colors.black),
                ),
                Icon(Icons.check_box_outline_blank,color: Colors.white,),
              ],
            ),
          ),
          SizedBox(
            width: 500,
            child: FutureBuilder<List<Campaigns>>(
              future: campList(),
              builder: (context,snapshot) {
                if(snapshot.hasData){
                  var campList = snapshot.data;
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: campList!.length,
                    itemBuilder: (context,index) {
                      var camp = campList?[index];
                      return Card(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white38,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Container(
                                width: 100,
                                height:100,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  image: DecorationImage(
                                    image: AssetImage("resimler/${camp?.campaignsImageName}"), fit:BoxFit.fill,
                                  ),
                                ),

                              ),
                              Column(
                                children: [
                                  Row(
                                    children: [
                                      SizedBox(
                                        height: 100,
                                        width: 120,
                                        child: ReadMoreText(
                                          "${camp?.campaignsexplanation}",
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
                              Column(
                                children: [
                                  SizedBox(
                                    width: 100,
                                    child: ElevatedButton(
                                      onPressed: () {
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
                                      child: Text("apply",style: TextStyle(color: Colors.white),),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      );
                    } ,
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
  }
}
