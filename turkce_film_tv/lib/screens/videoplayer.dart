import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:subtitle_wrapper_package/subtitle_wrapper_package.dart';
import 'package:video_player/video_player.dart';
import 'package:wakelock/wakelock.dart';
import 'package:volume_controller/volume_controller.dart';

class EnterButtonIntent extends Intent {}

class LeftButtonIntent extends Intent {}

class RightButtonIntent extends Intent {}

class VideoPlayerScreen extends StatefulWidget {
  final String videoUrl;
  final String? subtitle;

  const VideoPlayerScreen({
    super.key,
    required this.videoUrl,
    this.subtitle,
  });

  @override
  VideoPlayerScreenState createState() => VideoPlayerScreenState();
}

class VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;
  int _currentIndex = 0;
  SubtitleController? subtitleController;
  Timer? _hideTimer;
  bool _isVisible = true;
  Widget? _positionIcon;
  bool _isForward = true;
  double _currentVolume = 0.5;
  bool _volumeDrag = false;
  late double _initialVolume;
  FocusNode? _controllerFocus;
  final List<double> fontSizes = [];

  _setFirstFocus(BuildContext context) {
    if (_controllerFocus == null) {
      _controllerFocus = FocusNode();
      FocusScope.of(context).requestFocus(_controllerFocus);
    }
  }

  @override
  void initState() {
    super.initState();
    Wakelock.enable();
    VolumeController().showSystemUI = false;
    VolumeController().listener((volume) {
      setState(() => _currentVolume = volume);
    });

    VolumeController().getVolume().then((volume) => _currentVolume = volume);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);

    if (widget.subtitle != null && widget.subtitle!.isNotEmpty) {
      subtitleController = SubtitleController(
          subtitleUrl: widget.subtitle,
          subtitleType: SubtitleType.srt,
          subtitleDecoder: SubtitleDecoder.utf8);
    }

      _controller = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl));


    _initializeVideoPlayerFuture = _controller.initialize();
    _hideTimer = Timer(const Duration(seconds: 8), () {
      setState(() {
        _isVisible = false;
      });
    });
    _controller.play();
    setState(() {});

    _controller.addListener(() {
      if (_controller.value.hasError) {
        final error = _controller.value.errorDescription;
        if (error!.contains('Network connection lost')) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Bağlantınız koptu'),
          ));
        }
      }
    });
  }

  void _onDragStart(DragStartDetails details) {
    _initialVolume = _currentVolume;
    setState(() {
      _volumeDrag = true;
    });
  }

  void _onDragUpdate(DragUpdateDetails details) {
    final globalPosition = details.globalPosition.dy;
    final screenHeight = MediaQuery.of(context).size.height;
    final positionRatio = 1 - (globalPosition / screenHeight);
    final increment = positionRatio * 2 - 1;

    setState(() {
      _currentVolume = (_initialVolume + increment).clamp(0.0, 1.0);
      _controller.setVolume(_currentVolume);
      VolumeController().setVolume(_currentVolume);
      _volumeDrag = true;
    });
  }

  void _onDragEnd(DragEndDetails details) {
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _volumeDrag = false;
      });
    });
  }

  Stream<int> _tickStream() {
    return Stream.periodic(const Duration(seconds: 1), (i) => i);
  }

  void _rewind() {
    _controller
        .seekTo(_controller.value.position - const Duration(seconds: 10));
    setState(() {
      _positionIcon =
          const Icon(Icons.replay_10, size: 48, color: Colors.white);
      _isForward = false;
    });
    _hidePositionIcon();
  }

  void _forward() {
    _controller
        .seekTo(_controller.value.position + const Duration(seconds: 10));
    setState(() {
      _positionIcon =
          const Icon(Icons.forward_10, size: 48, color: Colors.white);
      _isForward = true;
    });
    _hidePositionIcon();
  }

  void _hidePositionIcon() {
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _positionIcon = null;
      });
    });
  }

  // Dispose of the timer when the screen is disposed
  @override
  void dispose() {
    _controller.dispose();
    _hideTimer?.cancel();
    _controllerFocus?.dispose();
    Wakelock.disable();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_controllerFocus == null) {
      _setFirstFocus(context);
    }
    final screenWidth = MediaQuery.of(context).size.width;
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      fontSizes.clear();
      fontSizes.add(constraints.maxWidth * 0.028);
      fontSizes.add(constraints.maxWidth * 0.032);
      fontSizes.add(constraints.maxWidth * 0.037);
      fontSizes.add(constraints.maxWidth * 0.041);
      fontSizes.add(constraints.maxWidth * 0.018);
      fontSizes.add(constraints.maxWidth * 0.023);
      fontSizes.add(constraints.maxWidth * 0.026);
      return Theme(
        data: ThemeData(
          fontFamily: 'Arial',
          textTheme: const TextTheme(
            bodyLarge: TextStyle(color: Colors.red),
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.black,
          body: Shortcuts(
            shortcuts: <LogicalKeySet, Intent>{
              LogicalKeySet(LogicalKeyboardKey.select): EnterButtonIntent(),
              LogicalKeySet(LogicalKeyboardKey.arrowLeft): LeftButtonIntent(),
              LogicalKeySet(LogicalKeyboardKey.arrowRight): RightButtonIntent(),
            },
            child: FutureBuilder(
              future: _initializeVideoPlayerFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return Actions(
                    actions: <Type, Action<Intent>>{
                      RightButtonIntent: CallbackAction<RightButtonIntent>(
                        onInvoke: (intent) async {
                          _forward();
                          return null;
                        },
                      ),
                      LeftButtonIntent: CallbackAction<LeftButtonIntent>(
                        onInvoke: (intent) async {
                          _rewind();
                          return null;
                        },
                      ),
                      EnterButtonIntent: CallbackAction<EnterButtonIntent>(
                        onInvoke: (intent) async {
                          if (_controller.value.isPlaying) {
                            await _controller.pause();
                          } else {
                            await _controller.play();
                          }
                          return null;
                        },
                      ),
                    },
                    child: Center(
                      child: Focus(
                        focusNode: _controllerFocus,
                        child: GestureDetector(
                          onVerticalDragStart: _onDragStart,
                          onVerticalDragUpdate: _onDragUpdate,
                          onVerticalDragEnd: _onDragEnd,
                          onDoubleTapDown: (details) {
                            final position = details.localPosition.dx;
                            if (position < screenWidth / 2) {
                              _rewind();
                            } else {
                              _forward();
                            }
                          },
                          onTap: () {
                            setState(() {
                              _isVisible = !_isVisible;
                            });
                            // Cancel and restart the timer when the user interact with screen
                            _hideTimer?.cancel();
                            _hideTimer = Timer(const Duration(seconds: 8), () {
                              setState(() {
                                _isVisible = false;
                              });
                            });
                          },
                          child: AspectRatio(
                            aspectRatio: _controller.value.aspectRatio,
                            child: Stack(
                              children: [
                                widget.subtitle != null &&
                                        widget.subtitle!.isNotEmpty
                                    ? SubtitleWrapper(
                                        subtitleStyle: SubtitleStyle(
                                          hasBorder: true,
                                          borderStyle:
                                              const SubtitleBorderStyle(
                                                  color: Colors.black),
                                          fontSize: fontSizes[_currentIndex],
                                          textColor: Colors.white,
                                        ),
                                        videoPlayerController: _controller,
                                        subtitleController: subtitleController!,
                                        videoChild: VideoPlayer(_controller),
                                      )
                                    : VideoPlayer(_controller),
                                AnimatedOpacity(
                                  opacity: _isVisible ? 1.0 : 0.0,
                                  duration: const Duration(milliseconds: 500),
                                  child: Align(
                                    alignment: Alignment.bottomCenter,
                                    child: AnimatedContainer(
                                      duration:
                                          const Duration(milliseconds: 500),
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          begin: Alignment.bottomCenter,
                                          end: Alignment.topCenter,
                                          stops: const [
                                            0.0,
                                            0.05,
                                            0.1,
                                            0.15,
                                            0.2,
                                            1.0
                                          ],
                                          tileMode: TileMode.clamp,
                                          colors: [
                                            Colors.black.withValues(alpha: 0.6),
                                            Colors.black.withValues(alpha: 0.5),
                                            Colors.black.withValues(alpha: 0.3),
                                            Colors.black.withValues(alpha: 0.2),
                                            Colors.black.withValues(alpha: 0.1),
                                            Colors.transparent,
                                          ],
                                          // Note: adjust the stops and colors array to create your desired gradient
                                        ),
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Visibility(
                                            visible: _isVisible,
                                            child: SliderTheme(
                                              data: const SliderThemeData(
                                                thumbColor: Colors
                                                    .transparent, // Make the thumb (blue dot) invisible
                                                thumbShape: RoundSliderThumbShape(
                                                    enabledThumbRadius:
                                                        0.0), // Change thumb shape to a line
                                                activeTrackColor: Colors
                                                    .white, // Change track (line) color to gray
                                                inactiveTrackColor: Colors
                                                    .grey, // Change inactive track (line) color to gray
                                              ),
                                              child: Slider(
                                                value: _controller
                                                    .value.position.inSeconds
                                                    .toDouble(),
                                                min: 0.0,
                                                max: _controller
                                                    .value.duration.inSeconds
                                                    .toDouble(),
                                                onChanged: (double value) {
                                                  setState(() {
                                                    Duration duration =
                                                        Duration(
                                                            seconds:
                                                                value.toInt());
                                                    _controller
                                                        .seekTo(duration);
                                                  });
                                                },
                                              ),
                                            ),
                                          ),
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(
                                                child: Padding(
                                                  padding: EdgeInsets.only(
                                                      left:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.025),
                                                  child: Align(
                                                    alignment:
                                                        Alignment.topLeft,
                                                    child: StreamBuilder(
                                                      stream: _tickStream(),
                                                      builder:
                                                          (context, snapshot) {
                                                        return Text(
                                                          Duration(
                                                                  seconds: (_controller
                                                                          .value
                                                                          .position
                                                                          .inSeconds)
                                                                      .toInt())
                                                              .toString()
                                                              .split('.')[0],
                                                          style:
                                                              const TextStyle(
                                                            color: Colors.grey,
                                                          ),
                                                        );
                                                      },
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                child: Align(
                                                  alignment:
                                                      Alignment.topCenter,
                                                  child: Visibility(
                                                    visible: _isVisible,
                                                    child: IconButton(
                                                      icon: Icon(
                                                        size: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.040,
                                                        _controller.value.isPlaying
                                                            ? Icons
                                                                .pause_circle_outline_outlined
                                                            : Icons
                                                                .play_circle_fill_outlined,
                                                        color: Colors.white,
                                                      ),
                                                      onPressed: () async {
                                                        if (_controller
                                                            .value.isPlaying) {
                                                          await _controller
                                                              .pause();
                                                        } else {
                                                          // If the video is paused, play it.
                                                          await _controller
                                                              .play();
                                                        }
                                                        setState(() {});
                                                      },
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                child: Padding(
                                                  padding: EdgeInsets.only(
                                                      right:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.025),
                                                  child: Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.end,
                                                    children: [
                                                      Visibility(
                                                        visible:
                                                            widget.subtitle !=
                                                                    null &&
                                                                widget.subtitle!
                                                                    .isNotEmpty,
                                                        child: IconButton(
                                                          onPressed: () {
                                                            setState(() {
                                                              _currentIndex =
                                                                  (_currentIndex +
                                                                          1) %
                                                                      fontSizes
                                                                          .length;
                                                            });
                                                          },
                                                          icon: const Icon(
                                                            Icons.text_increase,
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                      ),
                                                      StreamBuilder(
                                                        stream: _tickStream(),
                                                        builder: (context,
                                                            snapshot) {
                                                          return Text(
                                                            '-${Duration(seconds: (_controller.value.duration.inSeconds - _controller.value.position.inSeconds).toInt()).toString().split('.')[0]}',
                                                            style:
                                                                const TextStyle(
                                                              color:
                                                                  Colors.grey,
                                                            ),
                                                          );
                                                        },
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.center,
                                  child: _volumeDrag
                                      ? Container(
                                          color: Colors.black.withValues(alpha: 0.5), // Set the black color with 50% opacity
                                          child: Text(
                                            '%${(_currentVolume * 100).toStringAsFixed(0)}',
                                            style: const TextStyle(
                                              fontSize: 20,
                                              color: Colors.white,
                                            ),
                                          ),
                                        )
                                      : const SizedBox(),
                                ),
                                Align(
                                  alignment: _isForward
                                      ? Alignment.centerRight
                                      : Alignment.centerLeft,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20),
                                    child: _positionIcon,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                } else {
                  return Center(
                    child: CircularProgressIndicator(
                      backgroundColor: Colors.grey[200],
                      valueColor:
                          const AlwaysStoppedAnimation<Color>(Colors.grey),
                      strokeWidth: 5,
                    ),
                  );
                }
              },
            ),
          ),
        ),
      );
    });
  }
}
