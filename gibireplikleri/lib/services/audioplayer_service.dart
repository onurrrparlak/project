import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/widgets.dart';

import '../core/replikler.dart';

class AudioService extends ChangeNotifier {
  final AudioPlayer _player = AudioPlayer();
  Map<String, Duration> audioDurations = {};
  bool _isPlaying = false;
  var r = Replikler.replikler;

  bool get isPlaying => _isPlaying;

  AudioService() {
    // Fetch the duration of all the sounds and store them in _audioDurations
    for (var i = 0; i < r.length; i++) {
      final audioPath = 'sounds/$i.mp3';
      getAudioDuration(audioPath).then((duration) {
        audioDurations[audioPath] = duration;
        notifyListeners();
      });
    }
  }

  Future<Duration> getAudioDuration(String audioPath) async {
    if (audioDurations.containsKey(audioPath)) {
      return audioDurations[audioPath]!;
    }

    final player = AudioPlayer();
    await player.setSourceAsset(audioPath);
    final duration = await player.getDuration();
    await player.dispose();
    final durationInSeconds = duration != null
        ? Duration(milliseconds: duration.inMilliseconds)
        : Duration.zero;

    audioDurations[audioPath] = durationInSeconds;
    return durationInSeconds;
  }


  playSound(int id) async {
    var path = ('sounds/$id.mp3');
    _isPlaying = true;
    await _player.play(AssetSource(path.toString()));
    _player.onPlayerStateChanged.listen((state) {
      if (state == PlayerState.completed) {
        _isPlaying = false;
        notifyListeners();
      }
    });
    notifyListeners();
  }

  stopSound() async {
    await _player.stop();
    _isPlaying = false;
    notifyListeners();
  }

  @override
  void dispose() {
    super.dispose();
    _player.dispose();
  }
}
