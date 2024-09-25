import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:shop/api.dart';
import 'package:shop/components/product/secondary_product_card.dart';
import 'package:shop/constants.dart';
import 'package:shop/screens/profile/views/edit_profile_screen.dart';

class WalletHistoryCard extends StatelessWidget {
  const WalletHistoryCard({
    super.key,
    required this.amount,
    required this.products,
    required this.onProductDeleted,
  });

  final dynamic amount;
  final dynamic products;
  final Function onProductDeleted;

  Future<void> _checkUserProfileAndProcessOrder(BuildContext context) async {
    try {
      ApiService apiService = ApiService();

      // Get user profile
      final profileRes = await apiService.getRequest('/user/profile');

      if (profileRes["success"]) {
        final user = profileRes['data']["user"];

        // Check if phone number and address are provided
        final phoneNumber = user["information"]["phoneNumber"];
        final address = user["information"]["address"]?.isNotEmpty ?? false;

        if (phoneNumber == null || !address) {
          // Show dialog to notify user
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('Cập nhật thông tin'),
                content: const Text(
                    'Bạn cần cập nhật số điện thoại và địa chỉ trước khi đặt hàng. Bạn có muốn cập nhật thông tin ngay không?'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Hủy'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const UpdateProfileScreen(),
                        ),
                      );
                    },
                    child: const Text('Đồng ý'),
                  ),
                ],
              );
            },
          );
          return;
        }

        // Process order if profile is complete
        _processPayment(context);
      } else {
        Utils.showMsg(context, profileRes["msg"]);
      }
    } catch (e) {
      print(e.toString());
      Utils.showMsg(context, "Đã xảy ra lỗi");
    }
  }

  Future<void> _processPayment(BuildContext context) async {
    try {
      ApiService apiService = ApiService();

      dynamic body = {
        "username": await Utils.getValueByKey("email"),
        "amount": amount,
        "total": amount,
        "discount": 0,
        "subTotal": amount,
        "note": "",
        "address": await Utils.getValueByKey("address"),
        "status": "waiting",
        "orderDetails": products.map((product) {
          return {
            "amount": product["quantity"],
            "total": product["product"]["price"] * product["quantity"],
            "discount": 0,
            "shippingFee": 0,
            "subTotal": product["product"]["price"] * product["quantity"],
            "productName": product["product"]["name"],
            "price": product["product"]["price"],
            "image": product["product"]["image"]
          };
        }).toList()
      };
      dynamic res = await apiService.postRequest('/order', body: body);
      if (res["success"]) {
        String us = await Utils.getValueByKey("email") ?? "";
        Utils.showMsg(context, "Đặt hàng thành công");
        dynamic res2 = await apiService.getRequest('/cart/clear/$us');
        if (res2["success"]) {
          onProductDeleted();
        }
      } else {
        Utils.showMsg(context, res["msg"]);
      }
    } catch (e) {
      print(e.toString());
      Utils.showMsg(context, "Đã xảy ra lỗi");
    }
  }

  Future<void> _deleteProduct(
      BuildContext context, dynamic cartDetailId) async {
    try {
      ApiService apiService = ApiService();
      dynamic res = await apiService.getRequest('/cart/remove/$cartDetailId');
      if (res["success"]) {
        Utils.showMsg(context, "Đã xóa sản phẩm khỏi giỏ hàng");
        onProductDeleted();
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
              Utils.formatCurrency(amount),
              style: Theme.of(context)
                  .textTheme
                  .titleSmall!
                  .copyWith(color: successColor),
            ),
          ),
          const Divider(height: 1),
          const SizedBox(height: defaultPadding),
          ...products.map((product) {
            return Padding(
              padding: const EdgeInsets.only(
                  bottom: defaultPadding,
                  left: defaultPadding,
                  right: defaultPadding),
              child: Row(
                children: [
                  Expanded(
                    child: SecondaryProductCard(
                      image: product["product"]["image"][0],
                      brandName: product["product"]["size"],
                      title: product["product"]["name"],
                      price: product["product"]["price"],
                      priceAfetDiscount: product["product"]["price"],
                      quantity: product["quantity"],
                      style: ElevatedButton.styleFrom(
                        maximumSize: const Size(double.infinity, 90),
                        padding: EdgeInsets.zero,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      _deleteProduct(context, product["_id"]);
                    },
                  ),
                ],
              ),
            );
          }).toList(),
          const SizedBox(height: defaultPadding),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
            child: ElevatedButton(
              onPressed: () {
                _checkUserProfileAndProcessOrder(context);
              },
              child: const Text('Đặt hàng'),
            ),
          ),
          const SizedBox(height: defaultPadding),
        ],
      ),
    );
  }

  // String formatCurrency(double amount) {
  //   final formatter = NumberFormat.currency(locale: 'vi_VN', symbol: '₫');
  //   return formatter.format(amount);
  // }
}
