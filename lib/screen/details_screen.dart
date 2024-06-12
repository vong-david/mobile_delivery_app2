import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:test_flutter_week8/Model/prodcut.dart';
import '../Controller/counter.dart';
import 'package:test_flutter_week8/screen/checkout.dart';

class DetailScreen extends StatefulWidget {
  final int id;
  final double rating;
  final int starCount;

  const DetailScreen({
    required this.id,
    required this.rating,
    this.starCount = 5,
  });

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  late CounterController _counterController;
  Product? _product;
  bool _isLoading = true;
  bool _hasError = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _counterController = CounterController();
    _fetchProduct();
  }

  Future<void> _fetchProduct() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final response = await http.get(Uri.parse('https://dummyjson.com/products/${widget.id}'));
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);
        setState(() {
          _product = Product.fromJson(jsonData);
        });
      } else {
        setState(() {
          _errorMessage = 'Failed to load product: ${response.reasonPhrase}';
          _hasError = true;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load product: $e';
        _hasError = true;
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text("Detail", style: TextStyle(fontSize: 18)),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 15),
            child: Icon(Icons.favorite, color: Colors.red),
          )
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _hasError
          ? Center(child: Text(_errorMessage!))
          : _product != null
          ? Padding(
        padding: const EdgeInsets.all(10),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (_product!.thumbnail.isNotEmpty)
                Image.network(
                  _product!.thumbnail,
                  height: 400,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _product!.title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '\$${_product!.price}',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
              StarRating(rating: widget.rating, starCount: widget.starCount),
              const SizedBox(height: 10),
              Text(_product!.description),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 130,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 25,
                          offset: Offset(1, 1), // changes position of shadow
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Material(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.grey,
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  _counterController.decrement();
                                });
                              },
                              child: Container(
                                width: 35,
                                height: 35,
                                child: Center(
                                  child: Icon(
                                    Icons.remove,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 8), // Add some spacing between buttons and count
                        Text(
                          '${_counterController.count}',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(width: 8), // Add some spacing between count and buttons
                        Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Material(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.pinkAccent,
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  _counterController.increment();
                                });
                              },
                              child: Container(
                                width: 35,
                                height: 35,
                                child: Center(
                                  child: Icon(
                                    Icons.add,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (_counterController.count > 0) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Checkout(
                              title: _product!.title,
                              price: _product!.price,
                              thumbnail: _product!.thumbnail,
                              count: _counterController.count,
                            ),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Please add items to the cart before proceeding to checkout.'),
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.pinkAccent,
                      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      'Add To Cart',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      )
          : const Center(child: Text('Product not found')),
    );
  }
}

class StarRating extends StatelessWidget {
  final double rating;
  final int starCount;

  StarRating({required this.rating, this.starCount = 5});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(starCount, (index) {
        if (index < rating.floor()) {
          return Icon(Icons.star, color: Colors.amber);
        } else if (index < rating) {
          return Icon(Icons.star_half, color: Colors.amber);
        } else {
          return Icon(Icons.star_border, color: Colors.amber);
        }
      }),
    );
  }
}
