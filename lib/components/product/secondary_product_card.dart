import 'package:flutter/material.dart';

import '../../constants.dart';
import '../network_image_with_loader.dart';

class SecondaryProductCard extends StatelessWidget {
  const SecondaryProductCard({
    super.key,
    required this.image,
    required this.brandName,
    required this.title,
    required this.price,
    this.priceAfetDiscount,
    this.dicountpercent,
    this.quantity,
    this.press,
    this.style,
  });
  final dynamic image, brandName, title;
  final dynamic price;
  final dynamic priceAfetDiscount;
  final dynamic dicountpercent;
  final dynamic quantity;
  final VoidCallback? press;

  final ButtonStyle? style;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: () {},
      style: style ??
          OutlinedButton.styleFrom(
              minimumSize: const Size(256, 114),
              maximumSize: const Size(256, 114),
              padding: const EdgeInsets.all(8)),
      child: Row(
        children: [
          AspectRatio(
            aspectRatio: 1.15,
            child: Stack(
              children: [
                NetworkImageWithLoader(image, radius: defaultBorderRadious),
                if (dicountpercent != null)
                  Positioned(
                    right: defaultPadding / 2,
                    top: defaultPadding / 2,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: defaultPadding / 2),
                      height: 16,
                      decoration: const BoxDecoration(
                        color: errorColor,
                        borderRadius: BorderRadius.all(
                            Radius.circular(defaultBorderRadious)),
                      ),
                      child: Text(
                        "$dicountpercent% off",
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  )
              ],
            ),
          ),
          const SizedBox(width: defaultPadding / 4),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(defaultPadding / 2),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context)
                        .textTheme
                        .titleSmall!
                        .copyWith(fontSize: 12),
                  ),
                  const SizedBox(height: defaultPadding / 2),
                  Text(
                    "Size: ${brandName.toUpperCase()} -  SL: $quantity",
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(fontSize: 10),
                  ),
                  const Spacer(),
                  priceAfetDiscount != null
                      ? Row(
                          children: [
                            Text(
                              "$priceAfetDiscount",
                              style: const TextStyle(
                                color: Color(0xFF31B0D8),
                                fontWeight: FontWeight.w500,
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(width: defaultPadding / 4),
                            Text(
                              "$price",
                              style: TextStyle(
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .color,
                                fontSize: 10,
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                          ],
                        )
                      : Text(
                          "$price",
                          style: const TextStyle(
                            color: Color(0xFF31B0D8),
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                          ),
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

class SecondaryProductCard2 extends StatelessWidget {
  const SecondaryProductCard2({
    super.key,
    required this.image,
    required this.brandName,
    required this.title,
    required this.price,
    this.priceAfetDiscount,
    this.dicountpercent,
    this.quantity,
    this.press,
    this.style,
  });
  final dynamic image, brandName, title;
  final dynamic price;
  final dynamic priceAfetDiscount;
  final dynamic dicountpercent;
  final dynamic quantity;
  final VoidCallback? press;

  final ButtonStyle? style;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: () {},
      style: style ??
          OutlinedButton.styleFrom(
              minimumSize: const Size(256, 114),
              maximumSize: const Size(256, 114),
              padding: const EdgeInsets.all(8)),
      child: Row(
        children: [
          AspectRatio(
            aspectRatio: 1.15,
            child: Stack(
              children: [
                NetworkImageWithLoader(image, radius: defaultBorderRadious),
                if (dicountpercent != null)
                  Positioned(
                    right: defaultPadding / 2,
                    top: defaultPadding / 2,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: defaultPadding / 2),
                      height: 16,
                      decoration: const BoxDecoration(
                        color: errorColor,
                        borderRadius: BorderRadius.all(
                            Radius.circular(defaultBorderRadious)),
                      ),
                    ),
                  )
              ],
            ),
          ),
          const SizedBox(width: defaultPadding / 4),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(defaultPadding / 2),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context)
                        .textTheme
                        .titleSmall!
                        .copyWith(fontSize: 12),
                  ),
                  const SizedBox(height: defaultPadding / 2),
                  Text(
                    "SL: $quantity",
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(fontSize: 10),
                  ),
                  const Spacer(),
                  priceAfetDiscount != null
                      ? Row(
                          children: [
                            Text(
                              "$priceAfetDiscount",
                              style: const TextStyle(
                                color: Color(0xFF31B0D8),
                                fontWeight: FontWeight.w500,
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(width: defaultPadding / 4),
                          ],
                        )
                      : Text(
                          "$price",
                          style: const TextStyle(
                            color: Color(0xFF31B0D8),
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                          ),
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
