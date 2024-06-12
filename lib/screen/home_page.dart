import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:test_flutter_week8/Model/prodcut.dart';
import 'package:test_flutter_week8/screen/details_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late List<Product> _products = [];
  bool _isLoading = true;
  bool _hasError = false;
  String? _errorMessage;
  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }

  Future<void> _fetchProducts() async {
    try {
      final response = await http.get(Uri.parse('https://dummyjson.com/products?limit=10'));
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);
        final List<dynamic> productsJson = jsonData['products'];
        setState(() {
          _products = productsJson.map((data) => Product.fromJson(data)).toList();
        });
      } else {
        setState(() {
          _errorMessage = 'Failed to load products: ${response.reasonPhrase}';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load products: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const Drawer(),
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.location_on_outlined),
              Text("Kampong Cham", style: TextStyle(fontSize: 18)),
            ],
          ),
        ),
        actions: [
          const Padding(
            padding: EdgeInsets.all(15.0),
            child: Icon(Icons.shopping_basket_outlined),
          ),
        ],
      ),
      body: SafeArea(
        child: Container(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(25.0),
            child: Column(
              children: [
                // Hello David
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Hello David!",
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 5),
                        Text(
                          "11-11-2022",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFC0CB),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.all(12),
                        child: Icon(Icons.notifications_active_outlined),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                // Search area
                Container(
                  padding: const EdgeInsets.all(5.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: "Search",
                            prefixIcon: const Icon(Icons.search, color: Colors.grey),
                            border: InputBorder.none,
                            fillColor: Colors.white,
                            filled: true,
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.grey, width: 1.0),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.blue, width: 2.0),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                // Product
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Menu", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                    Text("View All", style: TextStyle(fontSize: 15)),
                  ],
                ),
                // First list of products
                SizedBox(
                  height: 150, // Set a fixed height for the first list
                  child: _products.isNotEmpty
                      ? ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _products.length,
                    itemBuilder: (context, index) {
                      return ProductList(product: _products[index]);
                    },
                  )
                      : const Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
                const SizedBox(height: 10), // Add some spacing between the two lists
                // Second list of products
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Popular", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                    Text("View All", style: TextStyle(fontSize: 15)),
                  ],
                ),
                const SizedBox(height: 15,),
                Expanded(
                  child: _products.isNotEmpty
                      ? ListView.builder(
                    itemCount: _products.length,
                    itemBuilder: (context, index) {
                      return ProductCard(product: _products[index]);
                    },
                  )
                      : const Center(
                    child: null,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

}

// class ProductCard extends StatelessWidget {
//   final Product product;
//   const ProductCard({required this.product});
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.all(10),
//       child: Padding(
//         padding: const EdgeInsets.all(10),
//         child: Column(
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Row(
//                   children: [
//                     if (product.thumbnail.isNotEmpty)
//                       CircleAvatar(
//                         radius: 30.0,
//                         backgroundImage: NetworkImage(product.thumbnail),
//                         backgroundColor: Colors.transparent,
//                       ),
//                     const SizedBox(width: 10), // Add spacing between image and text
//                     Text('Price: \$${product.price}'),
//                   ],
//                 ),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     CircleAvatar(
//                       radius: 15,
//                       child: IconButton(
//                         icon: const Icon(Icons.remove, size: 15),
//                         onPressed: () {
//                           Provider.of<CounterController>(context, listen: false).decrement();
//                         },
//                       ),
//                     ),
//                     const SizedBox(width: 8), // Add spacing between elements
//                     Consumer<CounterController>(
//                       builder: (context, counterController, child) {
//                         return Text(
//                           '${counterController.count}',
//                           style: const TextStyle(fontSize: 15),
//                         );
//                       },
//                     ),
//                     const SizedBox(width: 8), // Add spacing between elements
//                     CircleAvatar(
//                       radius: 15,
//                       child: IconButton(
//                         icon: const Icon(Icons.add, size: 15),
//                         onPressed: () {
//                           Provider.of<CounterController>(context, listen: false).increment();
//                         },
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }

class ProductCard extends StatelessWidget {
  final Product product;
  const ProductCard({required this.product});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
      child: SizedBox(
        width: 200,
        child: GestureDetector(
          onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailScreen(id: product.id, rating: product.rating),
                ),
              );
          },
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            color: Colors.white,
            elevation: 5,
            shadowColor: Colors.grey.withOpacity(0.5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                product.thumbnail.isNotEmpty
                    ? Center(
                      child: ClipRRect(
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(15.0)),
                        child: Image.network(
                        product.thumbnail,
                        height: 120,
                        width: 120,
                        fit: BoxFit.fill,
                      ),
                      ),
                    )
                    : Container(),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.title,
                        style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold, color: Colors.black87),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          Text(
                            '\$${product.price}',
                            style: const TextStyle(
                              fontSize: 14.0,
                              color: Colors.grey,
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                          const SizedBox(width: 5),
                          Text(
                            '\$${product.discountPercentage}',
                            style: const TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.pinkAccent,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ProductList extends StatelessWidget {
  final Product product;
  const ProductList({required this.product});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 20,top: 10),
          child: Container(
              padding: const EdgeInsets.all(10.0),
            decoration:  BoxDecoration(
              gradient: const RadialGradient(
                center: Alignment.center,
                radius: 1.5,
                colors: [
                  Color(0xFFFBE0E6),
                  Colors.pinkAccent,
                  // Color(0xFFFFC0CB),
                ],
                stops: [0.0, 0.5],
              ),
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: product.thumbnail.isNotEmpty
                ? CircleAvatar(
              radius: 30.0,
              backgroundImage: NetworkImage(product.thumbnail),
              backgroundColor: Colors.transparent,
            )
                : Container()
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 10, top: 10),
          child: Text(
            '${product.title.length > 10 ? '${product.title.substring(0, 10)}...' : product.title}',
            overflow: TextOverflow.ellipsis, // Show '...' if text overflows
          ),
        ),
      ],
    );
  }
}
