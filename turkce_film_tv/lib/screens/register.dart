import 'package:flutter/material.dart';
import '../services/focusnodeservice.dart';
import '../services/user_service.dart';
import 'homepage.dart';

// ignore_for_file: use_build_context_synchronously

class LeftButtonIntent extends Intent {}

class RightButtonIntent extends Intent {}

class UpButtonIntent extends Intent {}

class DownButtonIntent extends Intent {}

class EnterButtonIntent extends Intent {}

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  RegisterPageState createState() => RegisterPageState();
}

class RegisterPageState extends State<RegisterPage> {
  final UserService _userService = UserService();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordAgainController =
      TextEditingController();

late FocusServiceProvider _provider;
  final whiteInputBorder = OutlineInputBorder(
    borderSide: const BorderSide(color: Colors.white),
    borderRadius: BorderRadius.circular(38.0),
  );

  @override
  void initState() {
   
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {

      _provider.changeFocus(
          context, FocusServiceProvider.homepageMenuAnasayfaNode);
    });
  }

  @override
  Widget build(BuildContext context) {
    final textScaler = MediaQuery.of(context).textScaler;
    const baseFontSize = 14.0;
    final scaledFontSize = textScaler.scale(baseFontSize);
    final TextStyle whiteTextStyle = TextStyle(
      color: Colors.white,
      fontSize: scaledFontSize,
    );

    return Shortcuts(
      shortcuts: FocusServiceProvider.shortcuts,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                TextField(
                  focusNode: FocusServiceProvider.registerKullaniciAdiNode,
                  controller: _usernameController,
                  onEditingComplete: () {
                    _provider.changeFocus(
                        context, FocusServiceProvider.registerEPostaNode);
                  },
                  decoration: InputDecoration(
                    labelText: 'Kullanıcı Adı',
                    labelStyle: whiteTextStyle,
                    prefixIcon: const Icon(
                      Icons.person_2_outlined,
                      color: Colors.white,
                    ),
                    enabledBorder: whiteInputBorder,
                    focusedBorder: whiteInputBorder,
                  ),
                  style: whiteTextStyle,
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.width * 0.01,
                ),
                TextField(
                  focusNode: FocusServiceProvider.registerEPostaNode,
                  onEditingComplete: () {
                    _provider.changeFocus(
                        context, FocusServiceProvider.registerPasswordNode);
                  },
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'E- Posta',
                    labelStyle: whiteTextStyle,
                    prefixIcon: const Icon(
                      Icons.mail,
                      color: Colors.white,
                    ),
                    enabledBorder: whiteInputBorder,
                    focusedBorder: whiteInputBorder,
                  ),
                  style: whiteTextStyle,
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.width * 0.01,
                ),
                TextField(
                  focusNode: FocusServiceProvider.registerPasswordNode,
                  onEditingComplete: () {
                    _provider.changeFocus(
                        context, FocusServiceProvider.registerPasswordAgainNode);
                  },
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: 'Şifre',
                    labelStyle: whiteTextStyle,
                    prefixIcon: const Icon(
                      Icons.lock,
                      color: Colors.white,
                    ),
                    enabledBorder: whiteInputBorder,
                    focusedBorder: whiteInputBorder,
                  ),
                  style: whiteTextStyle,
                  obscureText: false,
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.width * 0.01,
                ),
                TextField(
                  focusNode: FocusServiceProvider.registerPasswordAgainNode,
                  onEditingComplete: () {
                    if (_passwordController.text ==
                        _passwordAgainController.text) {
                      _userService.registerUser(
                        _emailController.text,
                        _passwordController.text,
                        _usernameController.text,
                      ).then((_) {
                        if (mounted) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const HomePage(),
                            ),
                          );
                        }
                      }).catchError((e) {
                        // Error: $e
                      });
                    } else {
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Girdiğiniz şifreler aynı değil')),
                        );
                      }
                    }
                  },
                  controller: _passwordAgainController,
                  decoration: InputDecoration(
                    labelText: 'Şifre tekrar',
                    labelStyle: whiteTextStyle,
                    prefixIcon: const Icon(
                      Icons.lock,
                      color: Colors.white,
                    ),
                    enabledBorder: whiteInputBorder,
                    focusedBorder: whiteInputBorder,
                  ),
                  style: whiteTextStyle,
                  obscureText: false,
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.width * 0.01,
                ),
                Focus(
                  focusNode: FocusServiceProvider.registerRegisterButtonNode,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_passwordController.text ==
                          _passwordAgainController.text) {
                        _userService.registerUser(
                          _emailController.text,
                          _passwordController.text,
                          _usernameController.text,
                        ).then((_) {
                          if (mounted) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const HomePage(),
                              ),
                            );
                          }
                        }).catchError((e) {
                          // Error: $e
                        });
                      } else {
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Girdiğiniz şifreler aynı değil')),
                          );
                        }
                      }
                    },
                    style: ButtonStyle(
                      shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              8.0), // Adjust the radius as needed
                        ),
                      ),
                      padding: WidgetStateProperty.all<EdgeInsetsGeometry>(
                        const EdgeInsets.symmetric(
                            vertical: 12.0,
                            horizontal: 24.0), // Adjust the padding as needed
                      ),
                      backgroundColor:
                          WidgetStateProperty.all<Color>(Colors.green),
                      foregroundColor:
                          WidgetStateProperty.all<Color>(Colors.white),
                      overlayColor: WidgetStateProperty.all<Color>(
                          Colors.green.withValues(alpha: 0.8)),
                      elevation: WidgetStateProperty.all<double>(
                          0.0), // Remove the button shadow
                    ),
                    child: const Text('Kayıt ol'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
