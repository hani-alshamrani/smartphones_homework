import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'واجب التصميم - هاني',
      home: Scaffold(
        appBar: AppBar(
          title: const Text("واجب التصميم - هاني"),
          backgroundColor: Colors.blueGrey,
        ),
        body: const ProductList(),
      ),
    );
  }
}

class ProductList extends StatelessWidget {
  const ProductList({super.key});
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: const [
        ProductBox(
          name: "لابتوب ديل - Dell Inspiron",
          description: "معالج i7 ورام 16 جيجا هاردسك 512 SSD شاشة عالية الوضوح",
          price: 3500,
          image: "https://images.unsplash.com/photo-1588872657578-7efd1f1555ed?w=500",
          brands: ["Dell", "Inspiron", "Gaming"],
        ),
        ProductBox(
          name: "لابتوب اتش بي - HP Pavilion",
          description: "شاشة لمس وتصميم نحيف خفيف الوزن مناسب للسفر والعمل المكتبي",
          price: 4200,
          image: "https://images.unsplash.com/photo-1589561084283-930aa7b1ce50?w=500",
          brands: ["HP", "Pavilion", "Office"],
        ),
        ProductBox(
          name: "آيفون 15 برو - iPhone 15 Pro",
          description: "ذاكرة 256 جيجا، لون تيتانيوم طبيعي، كاميرا احترافية",
          price: 5100,
          // رابط جديد لصورة الآيفون
          image: "https://images.unsplash.com/photo-1664478546384-d2b0abb68432?w=500",
          brands: ["Apple", "Pro", "15 Series"],
        ),
        ProductBox(
          name: "ساعة آبل - Apple Watch",
          description: "الإصدار التاسع، مقاومة للماء، تتبع الأنشطة الرياضية والنبض",
          price: 1850,
          image: "https://images.unsplash.com/photo-1546868871-7041f2a55e12?w=500",
          brands: ["Apple", "Ultra", "Sport"],
        ),
      ],
    );
  }
}

class ProductBox extends StatefulWidget {
  final String name, description, image;
  final int price;
  final List<String> brands;
  const ProductBox({super.key, required this.name, required this.description, required this.price, required this.image, required this.brands});
  @override
  _ProductBoxState createState() => _ProductBoxState();
}

class _ProductBoxState extends State<ProductBox> {
  late String _selectedBrand;
  @override
  void initState() {
    super.initState();
    _selectedBrand = widget.brands[0];
  }
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: const EdgeInsets.all(10),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.horizontal(left: Radius.circular(4)),
            child: Image.network(
              widget.image, 
              width: 120, 
              height: 120, 
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => const SizedBox(
                width: 120, 
                height: 120, 
                child: Icon(Icons.broken_image, size: 50, color: Colors.grey)
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                  const SizedBox(height: 5),
                  Text(widget.description, style: const TextStyle(fontSize: 11, color: Colors.black54), maxLines: 2, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 5),
                  Text("السعر: ${widget.price} ريال", style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                  DropdownButton<String>(
                    isExpanded: true,
                    value: _selectedBrand,
                    items: widget.brands.map((String value) => DropdownMenuItem(value: value, child: Text(value, style: const TextStyle(fontSize: 12)))).toList(),
                    onChanged: (v) => setState(() => _selectedBrand = v!),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
