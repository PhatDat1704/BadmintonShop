import 'package:flutter/material.dart';
import 'package:shop/api.dart';
import 'package:shop/constants.dart';

class UpdateProfileScreen extends StatefulWidget {
  const UpdateProfileScreen({super.key});

  @override
  _UpdateProfileScreenState createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  final _fullNameController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _birthdayController = TextEditingController();
  final _addressController = TextEditingController();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isLoading = false;
  String _selectedGender = 'Nam'; // Default gender

  @override
  void initState() {
    super.initState();
    _fetchUserProfile();
  }

  Future<void> _fetchUserProfile() async {
    setState(() {
      _isLoading = true;
    });

    try {
      ApiService apiService = ApiService();
      final res = await apiService.getRequest('/user/profile');

      if (res["success"]) {
        final user = res['data']["user"];
        _fullNameController.text = user["information"]["fullName"] ?? '';
        _phoneNumberController.text = user["information"]["phoneNumber"] ?? '';
        _birthdayController.text = user["information"]["birthday"] != null
            ? '${user["information"]["birthday"].split('T')[0]}'
            : '';
        _selectedGender = user["information"]["gender"] ?? 'Nam';
        _addressController.text =
            user["information"]["address"]?.isNotEmpty ?? false
                ? user["information"]["address"][0]["fullAddress"] ?? ''
                : '';
      } else {
        Utils.showMsg(context, res["msg"]);
      }
    } catch (e) {
      print(e.toString());
      Utils.showMsg(context, "Đã xảy ra lỗi");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _updateProfile() async {
    if (_newPasswordController.text != _confirmPasswordController.text) {
      Utils.showMsg(context, "Mật khẩu xác nhận không khớp");
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      ApiService apiService = ApiService();
      final res = await apiService.postRequest('/user/profile', body: {
        'fullName': _fullNameController.text,
        'phoneNumber': _phoneNumberController.text,
        'birthday': _birthdayController.text,
        'gender': _selectedGender,
        'avtUrl': '', // Update if needed
        'address': [
          {
            'fullAddress': _addressController.text,
            'nameAddress': 'Primary Address', // Adjust if needed
            'phoneNumber': _phoneNumberController.text,
          }
        ],
        'currentPassword': _currentPasswordController.text,
        'newPassword': _newPasswordController.text,
      });

      if (res["success"]) {
        await Utils.setValueByKey("address", _addressController.text);
        Utils.showMsg(context, "Cập nhật thông tin thành công");
      } else {
        Utils.showMsg(context, res["msg"]);
      }
    } catch (e) {
      print(e.toString());
      Utils.showMsg(context, "Đã xảy ra lỗi");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (selectedDate != null) {
      setState(() {
        _birthdayController.text = '${selectedDate.toLocal()}'.split(' ')[0];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cập nhật thông tin"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(defaultPadding),
        child: ListView(
          children: [
            TextField(
              controller: _fullNameController,
              decoration: const InputDecoration(labelText: 'Họ và tên'),
            ),
            const SizedBox(height: defaultPadding / 2),
            TextField(
              controller: _phoneNumberController,
              decoration: const InputDecoration(labelText: 'Số điện thoại'),
            ),
            const SizedBox(height: defaultPadding / 2),
            GestureDetector(
              onTap: () => _selectDate(context),
              child: AbsorbPointer(
                child: TextField(
                  controller: _birthdayController,
                  decoration: const InputDecoration(labelText: 'Ngày sinh'),
                ),
              ),
            ),
            const SizedBox(height: defaultPadding / 2),
            DropdownButtonFormField<String>(
              value: _selectedGender,
              decoration: const InputDecoration(labelText: 'Giới tính'),
              items: ['Nam', 'Nữ', 'Khác'].map((gender) {
                return DropdownMenuItem(
                  value: gender,
                  child: Text(gender),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedGender = value ?? 'Nam'; // Default to 'Nam'
                });
              },
            ),
            const SizedBox(height: defaultPadding / 2),
            TextField(
              controller: _addressController,
              decoration: const InputDecoration(labelText: 'Địa chỉ'),
            ),
            const SizedBox(height: defaultPadding / 2),
            TextField(
              controller: _currentPasswordController,
              decoration: const InputDecoration(labelText: 'Mật khẩu hiện tại'),
              obscureText: true,
            ),
            const SizedBox(height: defaultPadding / 2),
            TextField(
              controller: _newPasswordController,
              decoration: const InputDecoration(labelText: 'Mật khẩu mới'),
              obscureText: true,
            ),
            const SizedBox(height: defaultPadding / 2),
            TextField(
              controller: _confirmPasswordController,
              decoration:
                  const InputDecoration(labelText: 'Xác nhận mật khẩu mới'),
              obscureText: true,
            ),
            const SizedBox(height: defaultPadding),
            _isLoading
                ? const Center(child: CircularProgressIndicator())
                : ElevatedButton(
                    onPressed: _updateProfile,
                    child: const Text('Cập nhật'),
                  ),
          ],
        ),
      ),
    );
  }
}
