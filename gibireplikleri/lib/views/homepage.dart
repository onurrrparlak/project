import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gibireplikleri/core/replikler.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

import '../provider/settings_provider.dart';
import '../services/admob_service.dart';
import '../services/audioplayer_service.dart';
import '../services/random_snackbar_text.dart';
import '../services/replik_filter_service.dart';
import '../widgets/floating_action_button.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> with WidgetsBindingObserver {
  bool _isKeyboardVisible = false;
  bool? w;
  final AdMobService _adMobService = AdMobService();

  var r = Replikler.replikler;

  TextEditingController editingController = TextEditingController();

  String getRandomReplik() {
    final random = Random();
    final randomIndex = random.nextInt(_filteredReplikler.length);
    return _filteredReplikler[randomIndex]['replik']!;
  }

  String getStoredReplik() {
    final box = Hive.box('replikBox');

    String? storedReplik = box.get('replik');
    if (storedReplik == null) {
      storedReplik = getRandomReplik();
      box.put('replik', storedReplik);
    }
    return storedReplik;
  }

  void updateReplikIfNeeded() {
    final box = Hive.box('replikBox');
    final storedTimestamp = box.get('timestamp');
    final now = DateTime.now().millisecondsSinceEpoch;
    const oneDayInMillis = 86400000;
    if (storedTimestamp == null || now - storedTimestamp > oneDayInMillis) {
      final newReplik = getRandomReplik();
      box.put('replik', newReplik);
      box.put('timestamp', now);
    }
  }

  @override
  void initState() {
    super.initState();
    _adMobService.initialize();
    WidgetsBinding.instance.addObserver(this);
    final kufurBox = Hive.box('settings');
    w = kufurBox.get('kufur') ?? false;

    _filteredReplikler = FilterService.filterByKufur(w!, r);

    _adMobService.createBannerAd();
    _adMobService.createRewardedAd();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _adMobService.dispose();
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    setState(() {
      _isKeyboardVisible = bottomInset > 0;
    });
  }

  int? _selectedSoyleyen = -1;

  List _filteredReplikler =
      FilterService.filterBySoyleyen(null, Replikler.replikler);

  void _onSoyleyenToggle(int index) {
    setState(() {
      if (_selectedSoyleyen == index) {
        _selectedSoyleyen = -1;
        _filteredReplikler = FilterService.filterBySoyleyen(
            null, Replikler.replikler,
            excludeKufur: w!);
      } else {
        _selectedSoyleyen = index;

        _filteredReplikler = FilterService.filterBySoyleyen(
            _selectedSoyleyen, r,
            excludeKufur: w!);
      }
    });
  }

  void _runFilter(String enteredKeyword) {
    setState(() {
      _filteredReplikler = FilterService.filterBySearch(
          enteredKeyword, Replikler.replikler, w ?? false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final audioService = Provider.of<AudioService>(context);
    double unitHeightValue = MediaQuery.of(context).size.height * 0.01;
    updateReplikIfNeeded();
    final replik = getStoredReplik();

    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: const MyFloatingActionButton(),
      body: Consumer<SettingsProvider>(builder: (context, provider, _) {
        return SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Expanded(
             
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Visibility(
                      visible: !_isKeyboardVisible,
                      child: Expanded(
                        flex: 1,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(15, 15, 0, 0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Günün repliği:',
                                style: TextStyle(
                                    fontSize: 2.6 * unitHeightValue,
                                    color: const Color(0xFF8c8d96)),
                              ),
                             
                              Expanded(
                                child: Text(
                                  replik,
                                  style: TextStyle(
                                    fontSize: 2.5 * unitHeightValue,
                                    fontWeight: FontWeight.w700,
                                  ),
                                  maxLines: 4, // Limits the number of lines
                                  overflow: TextOverflow
                                      .ellipsis, // Adds "..." if text is too long
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
             
              Expanded(
                flex: 0,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      ToggleButtons(
                        borderColor: Colors.transparent,
                        selectedBorderColor: Colors.transparent,
                        color: const Color(0XFFecebd4),
                        onPressed: _onSoyleyenToggle,
                        isSelected: [
                          _selectedSoyleyen == 0,
                          _selectedSoyleyen == 1,
                          _selectedSoyleyen == 2,
                        ],
                        children: const [
                          Padding(
                            padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                            child: Column(
                              children: [
                                CircleAvatar(
                                  radius: 30,
                                  backgroundImage:
                                      AssetImage('assets/images/yilmaz.jpg'),
                                ),
                                Text('Yılmaz'),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                            child: Column(
                              children: [
                                CircleAvatar(
                                  radius: 30,
                                  backgroundImage:
                                      AssetImage('assets/images/ilkkan.jpg'),
                                ),
                                Text('İlkkan'),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                            child: Column(
                              children: [
                                CircleAvatar(
                                  radius: 30,
                                  backgroundImage:
                                      AssetImage('assets/images/ersoy.jpg'),
                                ),
                                Text('Ersoy'),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 0,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(5, 0, 0, 5),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          onChanged: (value) => _runFilter(value),
                          controller: editingController,
                          style: const TextStyle(fontSize: 10),
                          decoration: const InputDecoration(
                              hintText: 'Replik giriniz',
                              hintStyle: TextStyle(fontSize: 15),
                              prefixIcon: Icon(Icons.search),
                              prefixIconColor: Colors.white),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      CircleAvatar(
                        radius: 30,
                        backgroundColor: const Color(0xFF1d1c21),
                        child: GestureDetector(
                          onLongPress: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                backgroundColor: Colors
                                    .red, // Set the background color to red
                                content: Text(
                                  'Rastgele replik, tüm replik listesinden birini oynatır. Replik, küfür içerebilir.',
                                  style: TextStyle(
                                    color: Colors
                                        .white, // Set the text color to white
                                  ),
                                ),
                              ),
                            );
                          },
                          onTap: () async {
                            var max = r.length;
                            int randomNumber = Random().nextInt(max);
                            stopRandomSnackbar(context);
                            showRandomSnackbar(context, randomNumber);
                            await audioService.stopSound();
                            await audioService.playSound(randomNumber);
                          },
                          child: IconButton(
                            onPressed: () async {
                              var max = r.length;
                              int randomNumber = Random().nextInt(max);
                              stopRandomSnackbar(context);
                              showRandomSnackbar(context, randomNumber);
                              await audioService.stopSound();
                              await audioService.playSound(randomNumber);
                            },
                            icon: const Icon(
                              color: Color(0XFFecebd4),
                              Icons.casino,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(5, 10, 5, 0),
                  child: Container(
                      padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                      decoration: const BoxDecoration(
                          color: Color(0xFF1d1c21),
                          borderRadius: BorderRadius.all(
                            Radius.circular(30),
                          )),
                      child: ValueListenableBuilder(
                          valueListenable: Hive.box('favoriler').listenable(),
                          builder: (context, box, child) {
                            if (_filteredReplikler.isEmpty) {
                              return const Center(
                                child: Text(
                                  'Aradığınız replik bulunamadı.',
                                  style: TextStyle(fontSize: 18),
                                ),
                              );
                            } else {
                              return ListView.builder(
                                  itemCount: _filteredReplikler.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    final reversedList =
                                        _filteredReplikler.reversed.toList();
                                    final word = reversedList[index];
                                    var deger = reversedList[index]['id'];
                                    final isFavorite = box.get(deger) != null;
                                    return ListTile(
                                      onTap: () async {
                                        await audioService.stopSound();
                                        await audioService.playSound(
                                            reversedList[index]['id']);
                                      },
                                      subtitle: Text(
                                        audioService.audioDurations.containsKey(
                                                'sounds/${reversedList[index]['id']}.mp3')
                                            ? '${audioService.audioDurations['sounds/${reversedList[index]['id']}.mp3']!.inSeconds} saniye'
                                            : 'Yükleniyor',
                                        style: const TextStyle(fontSize: 14),
                                      ),
                                      leading: CircleAvatar(
                                        radius: 20,
                                        backgroundImage: AssetImage(
                                            'assets/images/${reversedList[index]['soyleyen'] == 0 ? 'yilmaz.jpg' : reversedList[index]['soyleyen'] == 1 ? 'ilkkan.jpg' : 'ersoy.jpg'}'),
                                      ),
                                      title: Text(reversedList[index]['replik'],
                                          style: TextStyle(
                                              color: (reversedList[index]
                                                          ['kufur'] ==
                                                      true)
                                                  ? Colors.red.shade400
                                                  : Colors.white,
                                              fontSize: 14)),
                                      trailing: Wrap(
                                        spacing: -10,
                                        children: [
                                          Material(
                                            color: Colors.transparent,
                                            clipBehavior: Clip.hardEdge,
                                            shape: const CircleBorder(),
                                            child: IconButton(
                                              icon: Icon(
                                                  color: Colors.white,
                                                  isFavorite
                                                      ? Icons.favorite
                                                      : Icons.favorite_border),
                                              onPressed: () async {
                                                ScaffoldMessenger.of(context)
                                                    .clearSnackBars();
                                                if (isFavorite) {
                                                  await box.delete(deger);
                                                } else {
                                                  await box.put(deger, word);
                                                }
                                              },
                                            ),
                                          ),
                                          Material(
                                            color: Colors.transparent,
                                            clipBehavior: Clip.hardEdge,
                                            shape: const CircleBorder(),
                                            child: IconButton(
                                              icon: const Icon(
                                                Icons.share,
                                              ),
                                              onPressed: () async {
                                                _adMobService
                                                        .adDismissedCallback =
                                                    () async {
                                                  final selectedReplik =
                                                      reversedList[index];
                                                  final indexInOriginalList =
                                                      Replikler.replikler
                                                          .indexWhere(
                                                    (replik) =>
                                                        replik['id'] ==
                                                        selectedReplik['id'],
                                                  );
                                                  final data =
                                                      await rootBundle.load(
                                                          'assets/sounds/$indexInOriginalList.mp3');
                                                  final buffer = data.buffer;
                                                  await Share.shareXFiles([
                                                    XFile.fromData(
                                                      buffer.asUint8List(
                                                          data.offsetInBytes,
                                                          data.lengthInBytes),
                                                      mimeType: 'audio/x-aiff',
                                                    ),
                                                  ]);
                                                };
                                                _adMobService
                                                        .rewardedAdNotReadyCallback =
                                                    (String message) {
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                    SnackBar(
                                                      content: Text(message),
                                                    ),
                                                  );
                                                };
                                                _adMobService.showRewardedAd();
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  });
                            }
                          })),
                ),
              ),
              Expanded(
                flex: 0,
                child: SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.01,
                      ),
                      _adMobService.showBannerAd(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
