import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shop/constants.dart';
import 'package:shop/theme/input_decoration_theme.dart';
import 'package:shop/components/skleton/product/products_skelton.dart';
import 'package:shop/components/product/product_card.dart';
import 'package:shop/route/route_constants.dart';
import 'package:shop/api.dart';

class DiscoverScreen extends StatefulWidget {
  const DiscoverScreen({super.key});

  @override
  _DiscoverScreenState createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen> {
  List<dynamic> _products = [];
  String _title = "Tìm kiếm sản phẩm";
  bool _isLoading = true;
  final ApiService apiService = ApiService();
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }

  @override
  void dispose() {
    clear();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> clear() async {
    await Utils.clearValueByKey("categoriesId");
    await Utils.clearValueByKey("categories_title");
  }

  Future<void> _fetchProducts({String keyword = ""}) async {
    setState(() {
      _isLoading = true;
    });

    try {
      Map<String, dynamic> res;

      if (keyword.isNotEmpty) {
        res = await apiService.getRequest('/product?keyword=$keyword');
      } else {
        String categoriesId = await Utils.getValueByKey("categoriesId") ?? "";
        if (categoriesId.isNotEmpty) {
          String categoriesTitle =
              await Utils.getValueByKey("categories_title") ?? "";
          res =
              await apiService.getRequest('/product?categoryId=$categoriesId');
          setState(() {
            _title = categoriesTitle;
          });
        } else {
          res = {
            "data": {"data": []}
          };
          setState(() {
            _title = "Tìm kiếm sản phẩm";
          });
        }
      }

      setState(() {
        _products = res["data"]["data"] as List<dynamic>;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _onSearch() {
    final keyword = _searchController.text.trim();
    _fetchProducts(keyword: keyword);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(defaultPadding),
                child: TextFormField(
                  controller: _searchController,
                  textInputAction: TextInputAction.search,
                  decoration: InputDecoration(
                    hintText: "Tìm kiếm...",
                    filled: false,
                    border: secodaryOutlineInputBorder(context),
                    enabledBorder: secodaryOutlineInputBorder(context),
                    suffixIcon: IconButton(
                      onPressed: _onSearch,
                      icon: SvgPicture.asset(
                        "assets/icons/Search.svg",
                        height: 24,
                        color: Theme.of(context).iconTheme.color,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(defaultPadding),
                child: Text(
                  _title,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(
                horizontal: defaultPadding,
                vertical: defaultPadding,
              ),
              sliver: SliverFillRemaining(
                child: _isLoading
                    ? const ProductsSkelton()
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}
