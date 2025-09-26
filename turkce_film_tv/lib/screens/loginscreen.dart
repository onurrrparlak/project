import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:turkce_film_tv/screens/forgotpassword.dart';
import 'package:turkce_film_tv/screens/register.dart';
import '../services/focusnodeservice.dart';
import '../services/user_service.dart';
import 'homepage.dart';

// ignore_for_file: use_build_context_synchronously

class LeftButtonIntent extends Intent {}

class RightButtonIntent extends Intent {}

class UpButtonIntent extends Intent {}

class DownButtonIntent extends Intent {}

class EnterButtonIntent extends Intent {}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final UserService _userService = UserService();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  FocusServiceProvider? _provider;

  final PageController _pageController = PageController(initialPage: 0);

  final TextStyle whiteTextStyle = const TextStyle(
    color: Colors.white,
  );

  final whiteInputBorder = OutlineInputBorder(
    borderSide: const BorderSide(color: Colors.white),
    borderRadius: BorderRadius.circular(38.0),
  );

  @override
  void initState() {
    
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _provider?.changeFocus(
          context, FocusServiceProvider.loginButtonNode);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => FocusServiceProvider(),
      child:  Consumer<FocusServiceProvider>(
         builder: (context, focusServiceProvider, _) {
        return Shortcuts(
          shortcuts: FocusServiceProvider.shortcuts,
          child: Scaffold(
            body: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/background.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.3,
                          width: MediaQuery.of(context).size.width * 0.2,
                          child: Image.asset('assets/images/logo.png'),
                        ),
                        Text(
                          'Türkçe film izlemek artık daha kolay',
                          style: TextStyle(
                            fontSize: MediaQuery.of(context).size.width * 0.0220,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Actions(
                                actions: <Type, Action<Intent>>{
                                  RightButtonIntent:
                                      CallbackAction<RightButtonIntent>(
                                    onInvoke: (intent) async {
                                      _provider?.changeFocus(
          context, FocusServiceProvider.registerButtonNode);
        
                                      _pageController.animateToPage(
                                        1,
                                        duration: const Duration(milliseconds: 300),
                                        curve: Curves.easeInOut,
                                      );
                                      return null;
                                    },
                                  ),
                                  DownButtonIntent:
                                      CallbackAction<DownButtonIntent>(
                                    onInvoke: (intent) async {
                                     _provider?.changeFocus(
          context, FocusServiceProvider.loginEpostaNode);
                                      return null;
                                    },
                                  ),
                                },
                                child: Focus(
                                  focusNode: FocusServiceProvider.loginButtonNode,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      border:
                                          (FocusServiceProvider.loginButtonNode.hasFocus)
                                              ? Border(
                                                  bottom: BorderSide(
                                                    color: Colors.white,
                                                    width: MediaQuery.of(context)
                                                            .size
                                                            .width *
                                                        0.0020,
                                                  ),
                                                )
                                              : null,
                                    ),
                                    child: TextButton(
                                      onPressed: () async {
                                        _provider?.changeFocus(
          context, FocusServiceProvider.loginButtonNode);
                                        _pageController.animateToPage(
                                          0,
                                          duration: const Duration(milliseconds: 300),
                                          curve: Curves.easeInOut,
                                        );
                                      },
                                      child: const Text(
                                        'Giriş',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8.0),
                              Actions(
                                actions: <Type, Action<Intent>>{
                                  DownButtonIntent:
                                      CallbackAction<DownButtonIntent>(
                                    onInvoke: (intent) async {
                                      _provider?.changeFocus(
          context, FocusServiceProvider.registerKullaniciAdiNode);
                                      return null;
                                    },
                                  ),
                                  LeftButtonIntent:
                                      CallbackAction<LeftButtonIntent>(
                                    onInvoke: (intent) async {
                                      _provider?.changeFocus(
          context, FocusServiceProvider.loginButtonNode);
                                      return null;
                                    },
                                  ),
                                },
                                child: Focus(
                                  focusNode: FocusServiceProvider.registerButtonNode,
                                  child: Container(
                                    decoration: BoxDecoration(
                                        border: (FocusServiceProvider
                                                .registerButtonNode.hasFocus)
                                            ? Border(
                                                bottom: BorderSide(
                                                  color: Colors.white,
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.0020,
                                                ),
                                              )
                                            : null),
                                    child: TextButton(
                                      onPressed: () async {
                                        _provider?.changeFocus(
          context, FocusServiceProvider.registerButtonNode);
                                        _pageController.animateToPage(
                                          1,
                                          duration: const Duration(milliseconds: 300),
                                          curve: Curves.easeInOut,
                                        );
                                      },
                                      child: const Text(
                                        'Kayıt',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Expanded(
                            child: PageView(
                              controller: _pageController,
                              onPageChanged: (index) {
                                setState(() {
                                });
                              },
                              children: [
                                // Giriş page
                                SingleChildScrollView(
                                  child: Column(
                                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                                  children: [
                                  const SizedBox(height: 16.0),
                                  TextField(
                                    controller: _emailController,
                                    focusNode: FocusServiceProvider.loginEpostaNode,
                                    onEditingComplete: () {
                                      _provider?.changeFocus(
          context, FocusServiceProvider.loginSifreNode);
                                    },
                                    decoration: InputDecoration(
                                      labelText: 'E-Posta',
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
                                  const SizedBox(height: 16.0),
                                  Actions(
                                    actions: <Type, Action<Intent>>{
                                      UpButtonIntent:
                                          CallbackAction<UpButtonIntent>(
                                        onInvoke: (intent) async {
                                          _provider?.changeFocus(
          context, FocusServiceProvider.loginEpostaNode);
                                          return null;
                                        },
                                      ),
                                      DownButtonIntent:
                                          CallbackAction<DownButtonIntent>(
                                        onInvoke: (intent) async {
                                          
                                          _provider?.changeFocus(
                                              context,
                                              FocusServiceProvider
                                                  .loginLoginButtonNode);
                                          return null;
                                        },
                                      ),
                                    },
                                    child: TextField(
                                      focusNode: FocusServiceProvider.loginSifreNode,
                                      controller: _passwordController,
                                      textInputAction: TextInputAction.next,
                                      onEditingComplete: () {
                                          _userService.loginUser(
                                            _emailController.text,
                                            _passwordController.text,
                                          ).then((_) {
                                            if (mounted) {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      const HomePage(),
                                                ),
                                              );
                                            }
                                          }).catchError((e) {
                                            if (mounted) {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                SnackBar(
                                                    content: Text(e.toString())),
                                              );
                                            }
                                          });
                                        },
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
                                    ),
                                  ),
                                  const SizedBox(height: 16.0),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Actions(
                                        actions: <Type, Action<Intent>>{
                                          RightButtonIntent:
                                              CallbackAction<RightButtonIntent>(
                                            onInvoke: (intent) async {
                                              _provider?.changeFocus(
                                                  context,
                                                  FocusServiceProvider
                                                      .loginForgotPasswordButtonNode);
                                              return null;
                                            },
                                          ),
                                          UpButtonIntent:
                                              CallbackAction<UpButtonIntent>(
                                            onInvoke: (intent) async {
                                              _provider?.changeFocus(context,
                                                  FocusServiceProvider.loginSifreNode);
                                              return null;
                                            },
                                          ),
                                          EnterButtonIntent:
                                              CallbackAction<EnterButtonIntent>(
                                            onInvoke: (intent) {
                                              _userService.loginUser(
                                                _emailController.text,
                                                _passwordController.text,
                                              ).then((_) {
                                                if (mounted) {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          const HomePage(),
                                                    ),
                                                  );
                                                }
                                              }).catchError((e) {
                                                if (mounted) {
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                    SnackBar(
                                                        content:
                                                            Text(e.toString())),
                                                  );
                                                }
                                              });
                                              return null;
                                            },
                                          ),
                                        },
                                        child: Focus(
                                          focusNode:
                                              FocusServiceProvider.loginLoginButtonNode,
                                          child: ElevatedButton(
                                            onPressed: () {
                                              _userService.loginUser(
                                                _emailController.text,
                                                _passwordController.text,
                                              ).then((_) {
                                                if (mounted) {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          const HomePage(),
                                                    ),
                                                  );
                                                }
                                              }).catchError((e) {
                                                if (mounted) {
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                    SnackBar(
                                                        content:
                                                            Text(e.toString())),
                                                  );
                                                }
                                              });
                                            },
                                            style: ButtonStyle(
                                              shape: WidgetStateProperty.all<
                                                  RoundedRectangleBorder>(
                                                RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0), // Adjust the radius as needed
                                                ),
                                              ),
                                              padding: WidgetStateProperty
                                                  .all<EdgeInsetsGeometry>(
                                                const EdgeInsets.symmetric(
                                                    vertical: 12.0,
                                                    horizontal:
                                                        24.0), // Adjust the padding as needed
                                              ),
                                              backgroundColor:
                                                  WidgetStateProperty.all<
                                                      Color>(Colors.green),
                                              foregroundColor:
                                                  WidgetStateProperty.all<
                                                      Color>(Colors.white),
                                              overlayColor:
                                                  WidgetStateProperty
                                                      .all<Color>(Colors.green
                                                          .withValues(alpha: 0.8)),
                                              elevation: WidgetStateProperty.all<
                                                      double>(
                                                  0.0), // Remove the button shadow
                                            ),
                                            child: const Text(
                                              'Giriş yap',
                                              style: TextStyle(
                                                fontSize: 18.0,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Actions(
                                        actions: <Type, Action<Intent>>{
                                          LeftButtonIntent:
                                              CallbackAction<LeftButtonIntent>(
                                            onInvoke: (intent) async {
                                              _provider?.changeFocus(
                                                  context,
                                                  FocusServiceProvider
                                                      .loginLoginButtonNode);
                                              return null;
                                            },
                                          ),
                                          EnterButtonIntent:
                                              CallbackAction<EnterButtonIntent>(
                                            onInvoke: (intent) async {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      const ForgotPasswordScreen(),
                                                ),
                                              );
                                              return null;
                                            },
                                          ),
                                        },
                                        child: Focus(
                                          focusNode: FocusServiceProvider
                                              .loginForgotPasswordButtonNode,
                                          child: TextButton(
                                            onPressed: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      const ForgotPasswordScreen(),
                                                ),
                                              );
                                            },
                                            child: const Text(
                                              'Şifreni mi unuttun?',
                                              style:
                                                  TextStyle(color: Colors.grey),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                                                  ],
                                                                ),
                                ),
                                // Kayıt page
                                const RegisterPage(),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
         
        );
         },
      ),
    );
  }
}
