import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shop/api.dart';
import 'package:shop/components/cart_button.dart';
import 'package:shop/components/custom_modal_bottom_sheet.dart';
import 'package:shop/components/network_image_with_loader.dart';
import 'package:shop/screens/product/views/added_to_cart_message_screen.dart';
import 'package:shop/screens/product/views/components/selected_size.dart';

import '../../../constants.dart';
import 'components/product_quantity.dart';
import 'components/unit_price.dart';

class ProductBuyNowScreen extends StatefulWidget {
  const ProductBuyNowScreen({super.key, required this.product});

  final dynamic product;

  @override
  _ProductBuyNowScreenState createState() => _ProductBuyNowScreenState();
}

class _ProductBuyNowScreenState extends State<ProductBuyNowScreen> {
  int _numOfItems = 1;
  int _selectedSizeIndex = 0;
  bool _isLoading = false;
  ApiService apiService = ApiService();

  void _incrementQuantity() {
    setState(() {
      _numOfItems++;
    });
  }

  void _decrementQuantity() {
    if (_numOfItems > 1) {
      setState(() {
        _numOfItems--;
      });
    }
  }

  void _selectSize(int index) {
    setState(() {
      _selectedSizeIndex = index;
    });
  }

  void _addToCart() async {
    setState(() {
      _isLoading = true;
    });

    Map<String, dynamic> req = {
      "username": await Utils.getValueByKey("email") ?? "",
      "quantity": _numOfItems,
      "product": {
        "productId": widget.product["_id"],
        "name": widget.product["name"],
        "price": (Utils.calcPrice(widget.product["price"],
                widget.product["salePercent"])['discountedPrice'] ??
            0),
        "image": widget.product["image"],
        "size": widget.product["size"][_selectedSizeIndex],
      },
    };

    Map<String, dynamic> res =
        await apiService.postRequest('/cart/add', body: req);

    if (res["success"]) {
      customModalBottomSheet(
        context,
        isDismissible: false,
        child: const AddedToCartMessageScreen(),
      );
    } else {
      Utils.showMsg(context, res["msg"]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CartButton(
        price: (Utils.calcPrice(widget.product["price"],
                    widget.product["salePercent"])['discountedPrice'] ??
                0.00) *
            _numOfItems,
        title: "Thêm vào giỏ hàng",
        subTitle: "Tổng cộng",
        press: _addToCart,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: defaultPadding / 2, vertical: defaultPadding),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const BackButton(),
                Expanded(
                  child: Text(
                    widget.product["name"],
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: SvgPicture.asset(
                    "assets/icons/Bookmark.svg",
                    color: Theme.of(context).textTheme.bodyLarge!.color,
                  ),
                ),
              ],
            ),
          ),
          if (_isLoading)
            const Expanded(child: Center(child: CircularProgressIndicator()))
          else
            Expanded(
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: defaultPadding),
                      child: AspectRatio(
                        aspectRatio: 1.05,
                        child:
                            NetworkImageWithLoader(widget.product["image"][0]),
                      ),
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.all(defaultPadding),
                    sliver: SliverToBoxAdapter(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: UnitPrice(
                              price: widget.product["price"],
                              priceAfterDiscount: Utils.calcPrice(
                                      widget.product["price"],
                                      widget.product["salePercent"])[
                                  'discountedPrice'],
                            ),
                          ),
                          ProductQuantity(
                            numOfItem: _numOfItems,
                            onIncrement: _incrementQuantity,
                            onDecrement: _decrementQuantity,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SliverToBoxAdapter(child: Divider()),
                  // SliverToBoxAdapter(
                  //   child: SelectedColors(
                  //     colors: widget.product["color"],
                  //     selectedColorIndex: 0,
                  //     press: (value) {},
                  //   ),
                  // ),
                  SliverToBoxAdapter(
                    child: SelectedSize(
                      sizes: widget.product["size"],
                      selectedIndex: _selectedSizeIndex,
                      press: _selectSize,
                    ),
                  ),
                  const SliverToBoxAdapter(
                      child: SizedBox(height: defaultPadding))
                ],
              ),
            )
        ],
      ),
    );
  }
}
