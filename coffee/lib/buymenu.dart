import 'package:coffee_shop/baskets.dart';
import 'package:coffee_shop/coffees.dart';
import 'package:coffee_shop/coffeesdao.dart';
import 'package:coffee_shop/details.dart';
import 'package:coffee_shop/users.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'custom_search_delegate.dart';

class BuyMenu extends StatefulWidget {
  const BuyMenu({Key? key});

  @override
  State<BuyMenu> createState() => _BuyMenuState();
}

class _BuyMenuState extends State<BuyMenu> {

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

  Future<List<Coffees>> coffeeGet() async {
    var coffeeList = await Coffeesdao().coffeeListdao();
    for (Coffees k in coffeeList) {
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

  Future<users> usersGet() async {
    var user = await Coffeesdao().usersOne(1);
    return user;
  }

  var allItems = List.generate(50, (index) => "item $index");
  var item = [];
  var searHistory = [];
  final TextEditingController searchController = TextEditingController();
  var typesofcoffee = ["Cappucino", "Latte", "Machiato", "Espresso", "Americano"];
  int selectedTypeIndex = 0;
  List<Coffees>? coffeeList; // coffeeList'i buraya ekledik
  List<Coffees>? filteredCoffeeList; // filteredCoffeeList'i buraya ekledik


  @override
  void initState() {
    basketGet();
    coffeeGet().then((coffeeList) {
      setState(() {
        this.coffeeList = coffeeList;
        // filteredCoffeeList'i coffeeList ile doldur
        filterCoffeeList("");
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Column(
            children: [
              Row(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: 290,
                        color: Color.fromRGBO(19, 19, 19, 1),
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Positioned(
                              height: 500,
                              top: 10,
                              left: 0,
                              right: 0,
                              child: Container(
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(30.0),
                                      child: SizedBox(
                                          width: MediaQuery.of(context).size.width / 1.1,
                                          height: 50,
                                          child: FutureBuilder<users>(
                                              future: usersGet(),
                                              builder: (context, snapshot) {
                                                if (snapshot.connectionState == ConnectionState.waiting) {
                                                  // Eğer veri bekleniyorsa
                                                  return CircularProgressIndicator();
                                                } else if (snapshot.hasError) {
                                                  return Text('Error: ${snapshot.error}');
                                                } else {
                                                  // Veri geldiyse
                                                  var user = snapshot.data!;
                                                  return Row(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Text("Location", style: TextStyle(color: Colors.white, fontSize: 18)),
                                                          Row(
                                                            children: [
                                                              Text("${user.location}", style: TextStyle(color: Colors.white, fontSize: 5)),
                                                              Icon(Icons.arrow_drop_down_sharp, color: Colors.white, size: 5),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                      Spacer(),
                                                      SizedBox(
                                                        width: 50,
                                                        height: 50,
                                                        child: Image.asset("resimler/${user.imageName}"),
                                                      ),
                                                    ],
                                                  );
                                                }
                                              })),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(top: 5, left: 20),
                                      child: Row(
                                        children: [
                                          SizedBox(
                                              width: MediaQuery.of(context).size.width / 1.1,
                                              child: TextField(
                                                onTap: (){
                                                  _showSearchPage();
                                                },
                                                showCursor: false,
                                                controller: searchController,
                                                decoration: InputDecoration(
                                                  hintText: 'Ara..',
                                                  hintStyle: TextStyle(color: Colors.grey),
                                                  suffixIcon: Icon(Icons.search,color: Colors.white),
                                                  enabledBorder: UnderlineInputBorder(
                                                    borderSide: BorderSide(color: Colors.white), // Alt çizgi rengi
                                                  ),
                                                  focusedBorder: UnderlineInputBorder(
                                                    borderSide: BorderSide(color: Colors.white), // Tıklandığında alt çizgi rengi
                                                  ),
                                                ),
                                                onChanged: (value) {
                                                  filterCoffeeList(value);
                                                  _showSearchPage();

                                                },
                                              )),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(top: 30),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            width: 315,
                                            height: 140,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(20),
                                              image: DecorationImage(
                                                image: AssetImage("resimler/bigcappucino.png"),
                                                fit: BoxFit.fill,
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 80.0),
                child: Row(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: 50,
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: typesofcoffee.length,
                          itemBuilder: (context, indeks) {
                            return SizedBox(
                              width: 120,
                              child: Card(
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      selectedTypeIndex = indeks;
                                    });
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      color: selectedTypeIndex == indeks ? Color.fromRGBO(198, 124, 78, 1) : Colors.white,
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(11.0),
                                          child: Text(
                                            typesofcoffee[indeks],
                                            style: TextStyle(
                                              color: selectedTypeIndex == indeks ? Colors.white : Colors.black,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }),
                    )
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 20),
                child: Row(
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width/1,
                      child: FutureBuilder<List<Coffees>>(
                        future: coffeeGet(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            var coffeeList = snapshot.data;
                            var filteredCoffeeList = coffeeList
                                ?.where((coffee) => coffee.coffeeName == typesofcoffee[selectedTypeIndex])
                                .toList();
                            return GridView.builder(
                                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2, // Bir satırdaki öğe sayısı
                                  childAspectRatio: MediaQuery.of(context).size.width / (MediaQuery.of(context).size.height ),
                                  crossAxisSpacing: 8.0, // Yatayda öğeler arası boşluk
                                  mainAxisSpacing: 8.0, // Dikeyde öğeler arası boşluk
                                ),
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: filteredCoffeeList?.length,
                                itemBuilder: (context, index) {
                                  var coffee = filteredCoffeeList![index];
                                  return GestureDetector(
                                    onTap: () {
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => Details(coffee_id: coffee.coffee_id, coffeeName: "${coffee.coffeeName}", point: "${coffee.point}", price: "${coffee.price}", withMilk: "${coffee.withMilk}", imageName: "${coffee.imageName}")));
                                    },
                                    child: Card(
                                      color: Colors.white,
                                      elevation: 8.0,
                                      margin: EdgeInsets.all(8.0),
                                      child: Column(
                                        children: [
                                          Container(
                                            width: 209,
                                            height: 150,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(20),
                                              image: DecorationImage(
                                                image: AssetImage("resimler/${coffee?.imageName}"),
                                                fit: BoxFit.fill,
                                              ),
                                            ),
                                            child: Stack(
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets.all(5.0),
                                                  child: Row(
                                                    children: [
                                                      Icon(Icons.star, color: Color.fromRGBO(251, 190, 33, 1), size: 15),
                                                      Padding(
                                                        padding: const EdgeInsets.only(left: 1.0),
                                                        child: Text("${coffee.point}", style: TextStyle(color: Colors.white)),
                                                      ),
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                          ListTile(
                                            title: Text("${coffee.coffeeName}", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                                            subtitle: Text("${coffee.withMilk}", style: TextStyle(fontSize: 15, color: Colors.black45)),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(left: 18, right: 15),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(r"$" "${coffee.price}", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                                                Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(8),
                                                    color: Color.fromRGBO(198, 124, 78, 1),
                                                  ),
                                                  child: Padding(
                                                    padding: const EdgeInsets.all(8.0),
                                                    child: Icon(Icons.add, color: Colors.white, size: 13),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                });
                          } else {
                            return Center();
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showSearchPage() {
    showSearch(context: context, delegate: CustomSearchDelegate(allCoffee: filteredCoffeeList!));
  }

  void filterCoffeeList(String searchTerm) {
    // searchTerm boş ise, tüm kahveleri göster
    if (searchTerm.isEmpty) {
      setState(() {
        // Tüm kahve listesini göster
        filteredCoffeeList = coffeeList;
      });
    } else {
      setState(() {
        // searchTerm içeren kahveleri filtrele ve göster
        filteredCoffeeList = coffeeList
            ?.where((coffee) =>
            coffee.coffeeName.toLowerCase().contains(searchTerm.toLowerCase()))
            .toList();
      });
  }
}
}
