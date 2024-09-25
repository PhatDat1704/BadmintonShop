import 'package:flutter/material.dart';
import 'package:shop/api.dart';
import 'package:shop/components/skleton/others/categories_skelton.dart';
import '../../../../constants.dart';
import 'categories.dart';
import 'offers_carousel.dart';

class OffersCarouselAndCategories extends StatefulWidget {
  const OffersCarouselAndCategories({super.key});

  @override
  _OffersCarouselAndCategoriesState createState() =>
      _OffersCarouselAndCategoriesState();
}

class _OffersCarouselAndCategoriesState
    extends State<OffersCarouselAndCategories> {
  late List<dynamic> _categories;
  bool _isLoading = true;
  final ApiService apiService = ApiService();
  @override
  void initState() {
    super.initState();
    _fetchCategories();
  }

  Future<void> _fetchCategories() async {
    Map<String, dynamic> res = await apiService.getRequest('/categories');
    setState(() {
      _categories = res["data"]["data"] as List<dynamic>;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const OffersCarousel(),
        const SizedBox(height: defaultPadding / 2),
        const SizedBox(height: defaultPadding / 2),
        Padding(
          padding: const EdgeInsets.all(defaultPadding),
          child: Text(
            "Danh mục sản phẩm",
            style: Theme.of(context).textTheme.titleSmall,
          ),
        ),
        _isLoading
            ? const CategoriesSkelton()
            : Categories(categories: _categories),
      ],
    );
  }
}
