import 'package:flutter/material.dart';
import 'package:shop/components/skleton/product/products_skelton.dart';
import 'package:shop/components/product/product_card.dart';
import 'package:shop/route/route_constants.dart';
import '../../../constants.dart';
import 'package:shop/api.dart';

class ProductGrid extends StatefulWidget {
  final String categoriesId;

  const ProductGrid({
    super.key,
    required this.categoriesId,
  });

  @override
  _ProductGridState createState() => _ProductGridState();
}

class _ProductGridState extends State<ProductGrid> {
  late List<dynamic> _products;
  bool _isLoading = true;
  bool _hasError = false;
  String _errorMessage = '';
  final ApiService apiService = ApiService();

  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }

  Future<void> _fetchProducts() async {
    try {
      Map<String, dynamic> res = await apiService
          .getRequest('/product?categoryId=${widget.categoriesId}');
      setState(() {
        _products = res["data"]["data"] as List<dynamic>;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _hasError = true;
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SliverFillRemaining(
      child: _isLoading
          ? const ProductsSkelton() // Thay thế với SliverFillRemaining nếu ProductsSkelton không phải Sliver
          : _hasError
              ? Center(child: Text('Lỗi: $_errorMessage'))
              : _products.isEmpty
                  ? const Center(child: Text('Không có sản phẩm nào.'))
                  : CustomScrollView(
                      slivers: [
                        SliverPadding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: defaultPadding,
                              vertical: defaultPadding),
                          sliver: SliverGrid(
                            gridDelegate:
                                const SliverGridDelegateWithMaxCrossAxisExtent(
                              maxCrossAxisExtent: 200.0,
                              mainAxisSpacing: defaultPadding,
                              crossAxisSpacing: defaultPadding,
                              childAspectRatio: 0.66,
                            ),
                            delegate: SliverChildBuilderDelegate(
                              (BuildContext context, int index) {
                                final product = _products[index];
                                return ProductCard(
                                  image: product['image'][0],
                                  brandName: product['branchName'],
                                  title: product['name'],
                                  price: product['price'],
                                  priceAfetDiscount: Utils.calcPrice(
                                              product['price'],
                                              product['salePercent'])[
                                          "discountedPrice"] ??
                                      0,
                                  dicountpercent: product['salePercent'],
                                  press: () async {
                                    await Utils.setValueByKey(
                                        "productId", product['_id']);
                                    Navigator.pushNamed(
                                        context, productDetailsScreenRoute);
                                  },
                                );
                              },
                              childCount: _products.length,
                            ),
                          ),
                        ),
                      ],
                    ),
    );
  }
}
