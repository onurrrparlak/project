import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class CustomAlertDialog extends StatefulWidget {
  final String email = 'gibireplikleriapp@gmail.com';

  const CustomAlertDialog({super.key});

  @override
  State<CustomAlertDialog> createState() => _CustomAlertDialogState();
}

class _CustomAlertDialogState extends State<CustomAlertDialog> {
  void _launchEmailApp() async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: widget.email,
    );
    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    } else {
      // Display an error message if the email app isn't available
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Email uygulaması bulunamadı')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Bize ulaşın'),
      content: RichText(
        text: TextSpan(
          text: 'Bizlere ',
          children: [
            TextSpan(
              text: widget.email,
              style: const TextStyle(
                color: Colors.blue,
                decoration: TextDecoration.underline,
              ),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  _launchEmailApp();
                },
            ),
            const TextSpan(
              text: ' adresinden ulaşabilirsiniz.',
            ),
          ],
        ),
      ),
      actions: <Widget>[
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Tamam'),
        ),
      ],
    );
  }
}
