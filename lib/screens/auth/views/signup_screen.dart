import 'package:flutter/material.dart';
import 'package:shop/constants.dart';
import 'package:shop/route/route_constants.dart';
import 'package:shop/api.dart';
import 'components/sign_up_form.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  final ApiService apiService = ApiService();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _fullNameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  bool _isLoading = false;
  Future<void> _signUp() async {
    setState(() {
      _isLoading = true;
    });

    if (_formKey.currentState?.validate() ?? false) {
      String email = _emailController.text;
      String password = _passwordController.text;
      String fullName = _fullNameController.text;
      String phone = _phoneController.text;

      Map<String, String> req = {
        "email": email,
        "password": password,
        "fullName": fullName,
        "phoneNumber": phone,
      };

      Map<String, dynamic> res =
          await apiService.postRequest('/user/register', body: req);

      if (res["success"]) {
        Navigator.pushNamedAndRemoveUntil(
          context,
          logInScreenRoute,
          (route) => false, // Xóa tất cả các màn hình trước đó
        );
      } else {
        Utils.showMsg(context, res["msg"]);
      }
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            if (_isLoading)
              const Expanded(child: Center(child: CircularProgressIndicator())),
            Image.asset(
              "assets/images/login_dark.png",
              height: MediaQuery.of(context).size.height * 0.35,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            Padding(
              padding: const EdgeInsets.all(defaultPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Đăng ký tài khoản",
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: defaultPadding / 2),
                  const Text(
                    "Vui lòng nhập đầy đủ thông tin để đăng ký",
                  ),
                  const SizedBox(height: defaultPadding),
                  SignUpForm(
                    formKey: _formKey,
                    emailController: _emailController,
                    passwordController: _passwordController,
                    fullNameController: _fullNameController,
                    phoneController: _phoneController,
                  ),
                  const SizedBox(height: defaultPadding * 2),
                  ElevatedButton(
                    onPressed: _signUp,
                    child: const Text("Đăng ký"),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Đã có tài khoản?"),
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamedAndRemoveUntil(
                              context, logInScreenRoute, (route) => false);
                        },
                        child: const Text("Đăng nhập"),
                      )
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
