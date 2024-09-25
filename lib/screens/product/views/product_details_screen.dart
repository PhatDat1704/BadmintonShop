import 'package:flutter/material.dart';

import 'package:shop/api.dart';

import 'package:shop/components/cart_button.dart';
import 'package:shop/components/custom_modal_bottom_sheet.dart';

import 'package:shop/constants.dart';

import 'components/product_images.dart';
import 'components/product_info.dart';

import 'product_buy_now_screen.dart';

class ProductDetailsScreen extends StatefulWidget {
  const ProductDetailsScreen({Key? key}) : super(key: key);

  @override
  _ProductDetailsScreenState createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  late dynamic _product;
  bool _isLoading = true;

  final ApiService apiService = ApiService();

  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }

  Future<void> _fetchProducts() async {
    try {
      String productId = await Utils.getValueByKey("productId") ?? "";
      Map<String, dynamic> res =
          await apiService.getRequest('/product?productId=$productId');
      setState(() {
        _product = res["data"]["data"];
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: _isLoading
          ? const SizedBox.shrink()
          : CartButton(
              price: Utils.calcPrice(_product["price"],
                      _product["salePercent"])['discountedPrice'] ??
                  0,
              press: () {
                customModalBottomSheet(
                  context,
                  height: MediaQuery.of(context).size.height * 0.92,
                  child: ProductBuyNowScreen(product: _product),
                );
              },
            ),
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : CustomScrollView(
                slivers: [
                  ProductImages(
                    images: [_product['image'][0], _product['image'][1]],
                  ),
                  ProductInfo(
                    brand: _product["branchName"],
                    title: _product["name"],
                    description: _product["description"],
                    rating: 5,
                    numOfReviews: 0,
                  ),
                  const SliverToBoxAdapter(
                    child: SizedBox(height: defaultPadding),
                  )
                ],
              ),
      ),
    );
  }
}
