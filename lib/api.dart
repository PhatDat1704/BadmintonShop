import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class ApiService {
  final Dio _dio = Dio();

  ApiService() {
    _dio.options.baseUrl = "https://badminton-shop-be.vercel.app/api";
  }

  // Hàm để lấy token từ SharedPreferences
  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token'); // Lấy token từ SharedPreferences
  }

  // Thêm token vào header nếu có
  Future<void> _addTokenToHeader() async {
    final token = await _getToken();
    if (token != null) {
      _dio.options.headers['Authorization'] = 'Bearer $token';
    }
  }

  Future<dynamic> getRequest(String url) async {
    try {
      await _addTokenToHeader(); // Thêm token vào header trước khi gửi yêu cầu
      Response response = await _dio.get(url);
      return response.data as Map<String, dynamic>?;
    } catch (e) {
      return null;
    }
  }

  Future<dynamic> postRequest(String url, {Map<String, dynamic>? body}) async {
    try {
      await _addTokenToHeader(); // Thêm token vào header trước khi gửi yêu cầu
      Response response = await _dio.post(
        url,
        data: body,
      );
      return response.data as Map<String, dynamic>?;
    } catch (e) {
      return null;
    }
  }
}

class Utils {
  static String formatCurrency(dynamic amount) {
    final NumberFormat formatter = NumberFormat('#,###,###', 'vi_VN');
    return '${formatter.format(amount)} ₫';
  }

  static Future<void> setValueByKey(String key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
  }

  /// Lấy giá trị theo khóa.
  static Future<String?> getValueByKey(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

  static Future<void> clearValueByKey(String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(key);
  }

  static Map<String, double> calcPrice(int price, int discountPercentage) {
    if (price < 0 || discountPercentage < 0 || discountPercentage > 100) {
      throw ArgumentError('Giá và tỷ lệ giảm giá không hợp lệ.');
    }

    double discountAmount = (price * discountPercentage) / 100;

    double discountedPrice = price - discountAmount;

    return {
      'discountedPrice': discountedPrice,
      'discountAmount': discountAmount,
    };
  }

  static void showMsg(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Thông báo'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Đóng hộp thoại
              },
              child: const Text('Đóng'),
            ),
          ],
        );
      },
    );
  }
}
