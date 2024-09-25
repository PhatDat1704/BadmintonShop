import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shop/api.dart';
import 'package:shop/components/product/secondary_product_card.dart';
import '../../../../../constants.dart';

class WalletHistoryCard extends StatelessWidget {
  const WalletHistoryCard({
    super.key,
    required this.order,
    required this.onOrderUpdated,
  });

  final dynamic order;
  final Function onOrderUpdated;

  Future<void> _updateOrderStatus(BuildContext context, String status) async {
    try {
      ApiService apiService = ApiService();
      dynamic res = await apiService.postRequest(
        '/order/status/${order["_id"]}',
        body: {"status": status},
      );

      print(res.toString());
      if (res["success"]) {
        Utils.showMsg(
            context,
            status == "cancel"
                ? "Đơn hàng đã được hủy"
                : "Đơn hàng đã cập nhật thành công");
        onOrderUpdated();
      } else {
        Utils.showMsg(context, res["msg"]);
      }
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius:
            const BorderRadius.all(Radius.circular(defaultBorderRadious)),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: Column(
        children: [
          ListTile(
            minLeadingWidth: 24,
            leading: SvgPicture.asset(
              "assets/icons/Product.svg",
              color: Theme.of(context).iconTheme.color,
              height: 24,
              width: 24,
            ),
            title: const Text('Tổng tiền'),
            trailing: Text(
              Utils.formatCurrency(order["total"]),
              style: Theme.of(context)
                  .textTheme
                  .titleSmall!
                  .copyWith(color: successColor),
            ),
          ),
          const Divider(height: 1),
          const SizedBox(height: defaultPadding),
          ...order["orderDetails"].map((product) {
            return Padding(
              padding: const EdgeInsets.only(
                bottom: defaultPadding,
                left: defaultPadding,
                right: defaultPadding,
              ),
              child: Row(
                children: [
                  Expanded(
                      child: SecondaryProductCard2(
                    image: product["image"][0],
                    brandName: '',
                    title: product["productName"],
                    price: product['price'],
                    priceAfetDiscount: product['price'],
                    quantity: product["amount"],
                    style: ElevatedButton.styleFrom(
                      maximumSize: const Size(double.infinity, 90),
                      padding: EdgeInsets.zero,
                    ),
                  )),
                ],
              ),
            );
          }).toList(),
          const SizedBox(height: defaultPadding),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
            child: ElevatedButton(
              onPressed: order["status"] == "waiting"
                  ? () => _updateOrderStatus(context, "cancel")
                  : null,
              child: Text(
                order["status"] == "waiting"
                    ? 'Hủy đơn hàng'
                    : order["status"] == "success"
                        ? 'Đơn hàng đã thành công'
                        : 'Đơn hàng đã hủy',
              ),
            ),
          ),
          const SizedBox(height: defaultPadding),
        ],
      ),
    );
  }
}
