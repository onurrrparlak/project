import 'package:video_player/video_player.dart';

class VideoPlayerService {
  late VideoPlayerController _controller;
  bool _isPlaying = true;

  Future<VideoPlayerController> init(String url) async {
    _controller = VideoPlayerController.networkUrl(Uri.parse(url));
    await _controller.initialize();
    _controller.setLooping(true);
    return _controller;
  }

  Future<void> play() async {
    if (!_isPlaying) {
      await _controller.play();
      _isPlaying = true;
    }
  }

  Future<void> pause() async {
    if (_isPlaying) {
      await _controller.pause();
      _isPlaying = false;
    }
  }

  Future<void> seekBackward() async {
    final Duration? currentPosition = await _controller.position;
    final Duration tenSecondsBack = currentPosition! - const Duration(seconds: 10);
    await _controller.seekTo(tenSecondsBack);
  }

  Future<void> seekForward() async {
    final Duration? currentPosition = await _controller.position;
    final Duration tenSecondsForward = currentPosition! + const Duration(seconds: 10);
    await _controller.seekTo(tenSecondsForward);
  }

  void dispose() {
    _controller.dispose();
  }
}
