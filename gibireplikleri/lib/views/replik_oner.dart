import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ReplikOner extends StatefulWidget {
  const ReplikOner({super.key});

  @override
  ReplikOnerState createState() => ReplikOnerState();
}

class ReplikOnerState extends State<ReplikOner> {
  final TextEditingController _replikController = TextEditingController();
  final TextEditingController _neredeGeciyorController =
      TextEditingController();

  void _submitForm() async {
    final String subject = _replikController.text;
    final String body =
        'Replik: ${_replikController.text}\nNerede geçiyor: ${_neredeGeciyorController.text}';
    const String recipient = 'gibireplikleriapp@gmail.com';
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: recipient,
      query: 'subject=$subject&body=$body',
    );

    if (await canLaunchUrl(emailLaunchUri)) {
      await launchUrl(emailLaunchUri);
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Başarılı!'),
            content: const Text(
                'Maili göndermek için e-posta adresinize yönlendiriliyorsunuz.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    } else {
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Hata'),
            content: const Text('Mail adresi açılamadı.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Tamam'),
              ),
            ],
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Replik Öner'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Replik'),
            const SizedBox(height: 8.0),
            TextFormField(
              decoration: const InputDecoration(hintText: 'Repliği giriniz.'),
              controller: _replikController,
            ),
            const SizedBox(height: 16.0),
            const Text('Nerede geçiyor?'),
            const SizedBox(height: 8.0),
            TextFormField(
              decoration: const InputDecoration(
                  hintText: 'Hangi sahnede geçtiğini tarif ediniz.'),
              controller: _neredeGeciyorController,
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _submitForm,
              child: const Text('Gönder'),
            ),
          ],
        ),
      ),
    );
  }
}
