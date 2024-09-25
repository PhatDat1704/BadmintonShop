import 'package:flutter/material.dart';
import 'package:shop/api.dart';
import 'package:shop/entry_point.dart';
import '../../../../constants.dart';

class Categories extends StatelessWidget {
  final List<dynamic> categories;

  const Categories({
    super.key,
    required this.categories,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          ...List.generate(
            categories.length, // Sử dụng danh sách được truyền vào
            (index) => Padding(
              padding: EdgeInsets.only(
                left: index == 0 ? defaultPadding : defaultPadding / 2,
                right: index == categories.length - 1 ? defaultPadding : 0,
              ),
              child: CategoryBtn(
                category: categories[index]
                    ['title'], // Truy cập tên từ danh sách dynamic
                isActive: index == 0,
                press: () async {
                  await Utils.setValueByKey(
                      "categoriesId", categories[index]["_id"]);
                  await Utils.setValueByKey(
                      "categories_title", categories[index]["title"]);

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const EntryPoint(
                              currentIndex: 1,
                            )),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CategoryBtn extends StatelessWidget {
  const CategoryBtn({
    super.key,
    required this.category,
    required this.isActive,
    required this.press,
  });

  final String category;

  final bool isActive;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: press,
      borderRadius: const BorderRadius.all(Radius.circular(30)),
      child: Container(
        height: 36,
        padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
        decoration: BoxDecoration(
          color: isActive ? primaryColor : Colors.transparent,
          border: Border.all(
              color: isActive
                  ? Colors.transparent
                  : Theme.of(context).dividerColor),
          borderRadius: const BorderRadius.all(Radius.circular(30)),
        ),
        child: Row(
          children: [
            Text(
              category,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: isActive
                    ? Colors.white
                    : Theme.of(context).textTheme.bodyLarge!.color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
