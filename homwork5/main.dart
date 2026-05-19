import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future<List> getProducts() async {
    final response = await http.get(Uri.parse("http://192.168.1.3/product_api/get_products.php"));
    return json.decode(response.body);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Product Listing")),
      body: FutureBuilder<List>(
        future: getProducts(),
        builder: (context, snapshot) {
          if (snapshot.hasError) return Center(child: Text("Error: ${snapshot.error}"));

          return snapshot.hasData
              ? ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    List list = snapshot.data!;
                    return ProductBox(
                      name: list[index]['name'],
                      description: list[index]['description'],
                      price: int.parse(list[index]['price']),
                      image: list[index]['image'],
                      brands: list[index]['brands'].toString().split(','),
                    );
                  },
                )
              : const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}

class ProductBox extends StatefulWidget {
  final String name;
  final String description;
  final int price;
  final String image;
  final List<String> brands;

  const ProductBox({
    Key? key,
    required this.name,
    required this.description,
    required this.price,
    required this.image,
    required this.brands,
  }) : super(key: key);

  @override
  _ProductBoxState createState() => _ProductBoxState();
}

class _ProductBoxState extends State<ProductBox> {
  late String selectedBrand;

  @override
  void initState() {
    super.initState();
    selectedBrand = widget.brands[0];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(2),
      height: 150,
      child: Card(
        child: Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.network(
                widget.image,
                width: 100, height: 100, fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => const Icon(Icons.image, size: 50),
              ),
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(5),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(widget.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                    DropdownButton<String>(
                      value: selectedBrand,
                      isExpanded: true,
                      isDense: true,
                      items: widget.brands.map((String value) {
                        return DropdownMenuItem<String>(value: value, child: Text(value, style: const TextStyle(fontSize: 13)));
                      }).toList(),
                      onChanged: (String? n) => setState(() => selectedBrand = n!),
                    ),
                    Text(widget.description, style: const TextStyle(fontSize: 11), maxLines: 1),
                    Text("Price: \$${widget.price}", style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green)),],),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
