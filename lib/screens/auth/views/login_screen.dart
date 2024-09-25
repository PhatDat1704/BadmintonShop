import 'package:flutter/material.dart';
import 'package:shop/constants.dart';

import 'package:shop/route/route_constants.dart';
import 'components/login_form.dart';
import 'package:shop/api.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final ApiService apiService = ApiService();

  @override
  void initState() {
    super.initState();
    _checkForToken();
  }

  Future<void> _checkForToken() async {
    final token = await Utils.getValueByKey('token');
    if (token != null) {
      Navigator.pushReplacementNamed(context, entryPointScreenRoute);
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.asset(
              "assets/images/login_dark.png",
              fit: BoxFit.cover,
            ),
            Padding(
              padding: const EdgeInsets.all(defaultPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (_isLoading)
                    const Expanded(
                        child: Center(child: CircularProgressIndicator())),
                  Align(
                    child: Text(
                      "Đăng nhập",
                      style: Theme.of(context).textTheme.headlineSmall,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: defaultPadding / 2),
                  const SizedBox(height: defaultPadding),
                  LogInForm(
                    formKey: _formKey,
                    emailController: _emailController,
                    passwordController: _passwordController,
                  ),
                  Align(
                    child: TextButton(
                      child: const Text("Quên mật khẩu"),
                      onPressed: () {
                        Utils.showMsg(context, "Tính năng đang phát triển");
                      },
                    ),
                  ),
                  const SizedBox(height: defaultPadding),
                  ElevatedButton(
                    onPressed: () async {
                      setState(() {
                        _isLoading = true;
                      });
                      if (_formKey.currentState!.validate()) {
                        String email = _emailController.text;
                        String password = _passwordController.text;

                        Map<String, String> req = {
                          "email": email,
                          "password": password
                        };

                        Map<String, dynamic> res = await apiService
                            .postRequest('/user/login', body: req);

                        if (res["success"]) {
                          await Utils.setValueByKey("fullName",
                              res["data"]["user"]["information"]["fullName"]);
                          await Utils.setValueByKey(
                              "email", res["data"]["user"]["email"]);
                          await Utils.setValueByKey(
                              "token", res["data"]["token"]);

                          Navigator.pushNamed(context, entryPointScreenRoute);
                        } else {
                          Utils.showMsg(context, res["msg"]);
                        }

                        setState(() {
                          _isLoading = false;
                        });
                        //
                      }
                    },
                    child: const Text("Đăng nhập"),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Chưa có tài khoản?"),
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, signUpScreenRoute);
                        },
                        child: const Text("Đăng ký"),
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
