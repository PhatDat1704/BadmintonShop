import 'package:flutter/material.dart';
import 'components/offer_carousel_and_categories.dart';
import 'package:shop/components/product/product_grid.dart';
import '../../../constants.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: OffersCarouselAndCategories()),
            SliverPadding(
              padding: EdgeInsets.symmetric(
                horizontal: defaultPadding,
                vertical: defaultPadding,
              ),
              sliver: ProductGrid(
                categoriesId: '66a5585883af2636a0d31b14',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
