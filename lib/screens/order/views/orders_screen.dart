import 'package:flutter/material.dart';
import 'package:shop/constants.dart';
import 'package:shop/api.dart';
import 'package:shop/entry_point.dart';

import 'components/wallet_history_card.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  bool _isLoading = true;
  dynamic data;
  ApiService apiService = ApiService();

  @override
  void initState() {
    super.initState();
    _fetchOrders();
  }

  Future<void> _fetchOrders() async {
    try {
      setState(() {
        _isLoading = true;
      });

      String email = await Utils.getValueByKey("email") ?? "";
      Map<String, dynamic> res = await apiService.getRequest('/order/$email');

      if (res["success"]) {
        setState(() {
          data = res["data"];
        });
      } else {
        Utils.showMsg(context, res["msg"]);
      }

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const EntryPoint(
                              currentIndex: 0,
                            )),
                  )
                }),
        title: const Text("Danh sách đơn hàng"),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : CustomScrollView(
                  slivers: [
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) => Padding(
                          padding: const EdgeInsets.only(top: defaultPadding),
                          child: WalletHistoryCard(
                            order: data[index],
                            onOrderUpdated: _fetchOrders,
                          ),
                        ),
                        childCount: data.length,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
