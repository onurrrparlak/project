import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

class ShareAppWidget extends StatelessWidget {
  final String playStoreLink =
      'https://play.google.com/store/apps/details?id=com.wivizo.gibireplikleri';

  const ShareAppWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final params = ShareParams(
      text: 'Gibi Replikleri uygulamasını hemen indir! : $playStoreLink',
    );

    return ListTile(
      leading: const Icon(Icons.share),
      title: const Text('Uygulamayı paylaş'),
      onTap: () async {
        final result = await SharePlus.instance.share(params);
        SharePlus.instance.share(params);

       
      },
    );
  }
}
