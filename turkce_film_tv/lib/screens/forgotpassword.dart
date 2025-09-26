import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../services/focusnodeservice.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ForgotPasswordScreenState createState() => ForgotPasswordScreenState();
}

class ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  bool _isLoading = false;
   late FocusServiceProvider _provider;
  @override
  void initState() {
   
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
     _provider.changeFocus(
          context, FocusServiceProvider.forgotPasswordMailNode);
    });
  }

  final TextStyle whiteTextStyle = const TextStyle(
    color: Colors.white,
  );

  final whiteInputBorder = OutlineInputBorder(
    borderSide: const BorderSide(color: Colors.white),
    borderRadius: BorderRadius.circular(38.0),
  );

  Future<void> _resetPassword() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: _emailController.text,
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Password reset email sent')),
        );
        Navigator.of(context).pop();
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error.toString())),
        );
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/background.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  focusNode: FocusServiceProvider.forgotPasswordMailNode,
                  onEditingComplete: () async {
                    await _resetPassword();
                  },
                  controller: _emailController,
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
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'E-mail adresinizi giriniz';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                Focus(
                  focusNode: FocusServiceProvider.forgotPasswordSubmitNode,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _resetPassword,
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
                    child: _isLoading
                        ? const CircularProgressIndicator()
                        : const Text('Şifre sıfırlama mailini gönder'),
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
