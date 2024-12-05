import 'package:elderly_care/pages/register/register_page.dart';
import 'package:elderly_care/pages/forgotpassword/forgot_password_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../authentication/validaton/validator.dart';
import '../../controller/login_controller.dart';
import 'components/my_button.dart';
import 'components/my_textfield.dart';
import 'components/square_tiles.dart';

class LoginPage extends StatefulWidget {
  LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // loading state
  bool isLoading = false;

  // text editing controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LoginController());
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 100),
                const Icon(Icons.elderly, color: Colors.blue, size: 100),
                const SizedBox(height: 60),
                Text("Welcome to Revolutionizing Elder Care",
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineLarge),
                const SizedBox(height: 40),

                //email textfield
                MyTextfield(
                  controller: emailController,
                  hintText: 'Email',
                  labelText: "Email",
                  obscureText: false,
                  isPasswordField: false,
                  prefixIcon: Icons.email_outlined,
                  validator: (value) => EmailValidator.validate(value ?? ""),
                ),
                const SizedBox(height: 20),

                //password textfield
                MyTextfield(
                  controller: passwordController,
                  hintText: 'Password',
                  labelText: "Password",
                  obscureText: true,
                  isPasswordField: true,
                  prefixIcon: Icons.lock_outline,
                  validator: (value) => PasswordValidator.validate(value ?? ""),
                ),
                const SizedBox(height: 20),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      ForgotPasswordPage.ForgotPasswordModalShow(context);
                    },
                    child: Text(
                      "Forgot Password?",
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Obx(() {
                  if (controller.isLoading.value) {
                    return Center(child: CircularProgressIndicator());
                  } else {
                    return MyButton(
                      text: "Sign In",
                      onTap: () {
                        // Calling signIn method from the controller
                        LoginController.instance.signUserIn(
                          emailController.text,
                          passwordController.text,
                          context,
                        );
                      },
                    );
                  }
                }),
                const SizedBox(height: 40),
                Row(
                  children: [
                    Expanded(
                      child: Divider(
                        thickness: 0.5,
                        color: Colors.grey[400],
                      ),
                    ),
                    const Text("Or continue with"),
                    Expanded(
                      child: Divider(
                        thickness: 0.5,
                        color: Colors.grey[400],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Obx(() => SquareTile(
                          imagePath: 'lib/images/google.png',
                          onTap: () {
                            LoginController.instance.googleSignIn();
                          },
                          isLoading: controller.isGoogleLoading.value,
                        )),
                    const SizedBox(width: 20),
                    Obx(() => SquareTile(
                          imagePath: 'lib/images/facebook.jpg',
                          onTap: () {
                            // LoginController.instance.facebookSignIn();
                          },
                          isLoading: controller.isFacebookLoading.value,
                        )),
                  ],
                ),

                const SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account?",
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                    const SizedBox(width: 5),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => RegisterPage()));
                      },
                      child: const Text(
                        "Register now",
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ForgotPasswordOptions extends StatelessWidget {
  const ForgotPasswordOptions({
    required this.btnIcon,
    required this.title,
    required this.subTitle,
    required this.onTap,
    super.key,
  });

  final IconData btnIcon;
  final String title, subTitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            color: Colors.grey.shade200),
        child: Row(
          children: [
            Icon(
              btnIcon,
              size: 60,
            ),
            const SizedBox(
              width: 20.0,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                Text(
                  subTitle,
                  style: Theme.of(context).textTheme.bodyMedium,
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
