import 'package:flutter/material.dart';

import 'coffees.dart';
import 'details.dart';
class CustomSearchDelegate extends SearchDelegate{
  final List<Coffees> allCoffee;

  CustomSearchDelegate({required this.allCoffee});




  @override
  List<Widget>? buildActions(BuildContext context) {
   return [
     IconButton(onPressed: (){
       query.isEmpty ? null : query = '';

     }, icon: const Icon(Icons.clear)),
   ];

  }

  @override
  Widget? buildLeading(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        child: GestureDetector(
            onTap: (){
              close(context, null);
            },
            child: const Icon(Icons.arrow_back_ios,color: Colors.black,size: 15)),
      ),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    List<Coffees> filteredCoffee = allCoffee
        .where((element) => element.coffeeName.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return filteredCoffee.isNotEmpty
        ? GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // Bir satırdaki öğe sayısı
          childAspectRatio: MediaQuery.of(context).size.width / (MediaQuery.of(context).size.height / 1.2),
          crossAxisSpacing: 8.0, // Yatayda öğeler arası boşluk
          mainAxisSpacing: 8.0, // Dikeyde öğeler arası boşluk
        ),
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: filteredCoffee?.length,
        itemBuilder: (context, index) {
          var coffee = filteredCoffee![index];
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

                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        })
        : Container(
      child: Center(child: Text("Arama bulunamadı")),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    var typesofcoffee = ["Cappucino", "Latte", "Machiato", "Espresso", "Americano"];
    List<String> filteredCoffee = typesofcoffee
        .where((element) => element.toLowerCase().contains(query.toLowerCase()))
        .toList();
    return filteredCoffee.isNotEmpty
        ? ListView.builder(
        itemCount: filteredCoffee.length,
        itemBuilder: (context,index){
          var coffee = filteredCoffee[index];
          return Dismissible(
            key: Key(coffee),
            child: ListTile(
              title: Text("${coffee}"),
              onTap: () {
              },
            ),
          );
    }) : Container();
  }

  
}