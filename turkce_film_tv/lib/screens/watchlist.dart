import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:turkce_film_tv/screens/videoplayer.dart';
import 'package:turkce_film_tv/services/focusnodeservice.dart';

// ignore_for_file: unused_local_variable

class LeftButtonIntent extends Intent {}

class RightButtonIntent extends Intent {}

class UpButtonIntent extends Intent {}

class DownButtonIntent extends Intent {}

class EnterButtonIntent extends Intent {}

enum DPadDirection {
  up,
  down,
  left,
  right,
}

class UserWatchlistPage extends StatefulWidget {
  const UserWatchlistPage({super.key});

  @override
  UserWatchlistPageState createState() => UserWatchlistPageState();
}

class UserWatchlistPageState extends State<UserWatchlistPage> {
  late final User _currentUser;
  late final CollectionReference _watchlistRef;
  FocusServiceProvider? _provider;

  @override
  void initState() {
    super.initState();
    _currentUser = FirebaseAuth.instance.currentUser!;
    _watchlistRef = FirebaseFirestore.instance
        .collection('users')
        .doc(_currentUser.uid)
        .collection('watchlist');
  }

  @override
  Widget build(BuildContext context) {
    _provider = Provider.of<FocusServiceProvider>(context, listen: false);
    return ChangeNotifierProvider<FocusServiceProvider>.value(
      value: _provider!,
      child: Consumer<FocusServiceProvider>(
        builder: (context, focusServiceProvider, _) {
          return Scaffold(
            backgroundColor: Colors.transparent,
            body: Padding(
              padding: EdgeInsets.fromLTRB(
                MediaQuery.of(context).size.width * 0.06,
                MediaQuery.of(context).size.width * 0.02,
                MediaQuery.of(context).size.width * 0.06,
                MediaQuery.of(context).size.width * 0.02,
              ),
              child: Shortcuts(
                shortcuts: <LogicalKeySet, Intent>{
                  LogicalKeySet(LogicalKeyboardKey.arrowLeft):
                      LeftButtonIntent(),
                  LogicalKeySet(LogicalKeyboardKey.arrowRight):
                      RightButtonIntent(),
                  LogicalKeySet(LogicalKeyboardKey.arrowUp): UpButtonIntent(),
                  LogicalKeySet(LogicalKeyboardKey.arrowDown):
                      DownButtonIntent(),
                  LogicalKeySet(LogicalKeyboardKey.select): EnterButtonIntent(),
                },
                child: StreamBuilder<QuerySnapshot>(
                  stream: _watchlistRef
                      .orderBy('timestamp', descending: true)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    final movies = snapshot.data!.docs;

                    final watchedMovies = movies
                        .where((doc) =>
                            (doc.data() as Map<String, dynamic>)['isWatched'])
                        .toList();

                    final notWatchedMovies = movies
                        .where((doc) =>
                            !(doc.data() as Map<String, dynamic>)['isWatched'])
                        .toList();

                    return movies.isEmpty
                        ? const Text('Listenize henüz film eklememişsiniz')
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                    'İzleyeceklerim (${notWatchedMovies.length})',
                                    style: TextStyle(
                                        fontSize:
                                            MediaQuery.of(context).size.width *
                                                0.02,
                                        fontWeight: FontWeight.w400)),
                              ),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.25,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  shrinkWrap: true,
                                  itemCount: notWatchedMovies.length,
                                  itemBuilder: (context, index) {
                                    final movieId =
                                        (notWatchedMovies[index].data()
                                            as Map<String, dynamic>)['movieId'];
                                    List focusNodes = List.generate(
                                        notWatchedMovies.length, (int index) => FocusNode());

                                    return Row(
                                      children: [
                                        Column(
                                          children: [
                                            Actions(
                                              actions: <Type, Action<Intent>>{
                                                RightButtonIntent:
                                                    CallbackAction<
                                                        RightButtonIntent>(
                                                  onInvoke: (intent) async {
                                                    return null;
                                                  },
                                                ),
                                                DownButtonIntent:
                                                    CallbackAction<
                                                        DownButtonIntent>(
                                                  onInvoke: (intent) async {
                                                    _provider?.changeFocus(
                                                        context,
                                                        FocusServiceProvider
                                                            .homepagePlayNode);

                                                    return null;
                                                  },
                                                ),
                                                EnterButtonIntent:
                                                    CallbackAction<
                                                        EnterButtonIntent>(
                                                  onInvoke: (intent) async {
                                                    try {
                                                      await FirebaseFirestore
                                                          .instance
                                                          .collection('users')
                                                          .doc(_currentUser.uid)
                                                          .collection(
                                                              'watchlist')
                                                          .where('movieId',
                                                              isEqualTo:
                                                                  movieId)
                                                          .get()
                                                          .then(
                                                              (snapshot) async {
                                                        if (snapshot
                                                            .docs.isNotEmpty) {
                                                          final movieRef =
                                                              snapshot
                                                                  .docs
                                                                  .first
                                                                  .reference;
                                                          await movieRef
                                                              .delete();
                                                        }
                                                      });
                                                    } catch (e) {
                                                      // Error deleting movie from watchlist: $e
                                                    }
                                                    return null;
                                                  },
                                                ),
                                              },
                                              child: Focus(
                                                focusNode:  focusNodes[index],
                                                child: Container(
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.118,
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.118,
                                                  decoration: BoxDecoration(
                                                      borderRadius: BorderRadius
                                                          .circular(MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .height *
                                                              0.09), // Adjust the border radius to make it round
                                                      border: (FocusServiceProvider
                                                              .listemWillWatchDeleteNode
                                                              .hasFocus)
                                                          ? Border.all(
                                                              color: Colors
                                                                  .white, // Change the border color
                                                              width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .height *
                                                                  0.005, // Change the border width as needed
                                                            )
                                                          : null),
                                                  child: Center(
                                                    child: IconButton(
                                                      icon: const Icon(
                                                        Icons.delete,
                                                        color: Colors.white,
                                                      ),
                                                      onPressed: () async {
                                                        try {
                                                          await FirebaseFirestore
                                                              .instance
                                                              .collection(
                                                                  'users')
                                                              .doc(_currentUser
                                                                  .uid)
                                                              .collection(
                                                                  'watchlist')
                                                              .where('movieId',
                                                                  isEqualTo:
                                                                      movieId)
                                                              .get()
                                                              .then(
                                                                  (snapshot) async {
                                                            if (snapshot.docs
                                                                .isNotEmpty) {
                                                              final movieRef =
                                                                  snapshot
                                                                      .docs
                                                                      .first
                                                                      .reference;
                                                              await movieRef
                                                                  .delete();
                                                            }
                                                          });
                                                        } catch (e) {
                                                          // Error deleting movie from watchlist: $e
                                                        }
                                                      },
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Focus(
                                              focusNode: FocusServiceProvider
                                                  .listenWillWatchMakeWatchedNode,
                                              child: IconButton(
                                                icon: const Icon(
                                                  Icons.check,
                                                  color: Colors.white,
                                                ),
                                                onPressed: () async {
                                                  try {
                                                    await FirebaseFirestore
                                                        .instance
                                                        .collection('users')
                                                        .doc(_currentUser.uid)
                                                        .collection('watchlist')
                                                        .where('movieId',
                                                            isEqualTo: movieId)
                                                        .get()
                                                        .then((snapshot) async {
                                                      if (snapshot
                                                          .docs.isNotEmpty) {
                                                        final movieRef =
                                                            snapshot.docs.first
                                                                .reference;
                                                        final isWatched =
                                                            snapshot.docs.first
                                                                    .data()[
                                                                'isWatched'];
                                                        await movieRef.update({
                                                          'isWatched':
                                                              !isWatched
                                                        });
                                                      } else {
                                                        await FirebaseFirestore
                                                            .instance
                                                            .collection('users')
                                                            .doc(_currentUser
                                                                .uid)
                                                            .collection(
                                                                'watchlist')
                                                            .add({
                                                          'movieId': movieId,
                                                          'isWatched': false,
                                                        });
                                                      }
                                                    });
                                                  } catch (e) {
                                                    // Error updating movie watched status: $e
                                                  }
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                        FutureBuilder<
                                            QuerySnapshot<
                                                Map<String, dynamic>>>(
                                          future: FirebaseFirestore.instance
                                              .collection('movies')
                                              .where('movieId',
                                                  isEqualTo: movieId)
                                              .limit(1)
                                              .get(),
                                          builder: (context, snapshot) {
                                            if (!snapshot.hasData) {
                                              return const Center(
                                                  child:
                                                      CircularProgressIndicator());
                                            }

                                            var movieData = snapshot
                                                .data!.docs.first
                                                .data();
                                            final movieUrl = movieData['url']; 

                                            final movieImage =
                                                movieData['posterImageUrl'];

                                            return Focus(
                                              focusNode: FocusServiceProvider
                                                  .listemWillWatchNode,
                                              child: GestureDetector(
                                                onTap: () async {
                                                  await Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          VideoPlayerScreen(
                                                        videoUrl: movieUrl,
                                                      ),
                                                    ),
                                                  );
                                                },
                                                child: AspectRatio(
                                                  aspectRatio: 5 / 3,
                                                  child: Container(
                                                    padding: EdgeInsets.all(
                                                      MediaQuery.of(context)
                                                              .size
                                                              .width *
                                                          0.0045,
                                                    ),
                                                    child: Image.network(
                                                      movieImage,
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              ),
                              Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                    'İzlediklerim (${watchedMovies.length})',
                                    style: TextStyle(
                                        fontSize:
                                            MediaQuery.of(context).size.width *
                                                0.02,
                                        fontWeight: FontWeight.w400)),
                              ),
                              Focus(
                                focusNode:
                                    FocusServiceProvider.listemWatchedNode,
                                child: SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.30,
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    shrinkWrap: true,
                                    itemCount: watchedMovies.length,
                                    itemBuilder: (context, index) {
                                      final movieId = (watchedMovies[index]
                                              .data()
                                          as Map<String, dynamic>)['movieId'];

                                      return Row(
                                        children: [
                                          Column(
                                            children: [
                                              Focus(
                                                focusNode: FocusServiceProvider
                                                    .listemWatchedDeleteNode,
                                                child: IconButton(
                                                  icon: const Icon(
                                                    Icons.delete,
                                                    color: Colors.white,
                                                  ),
                                                  onPressed: () async {
                                                    try {
                                                      await FirebaseFirestore
                                                          .instance
                                                          .collection('users')
                                                          .doc(_currentUser.uid)
                                                          .collection(
                                                              'watchlist')
                                                          .where('movieId',
                                                              isEqualTo:
                                                                  movieId)
                                                          .get()
                                                          .then(
                                                              (snapshot) async {
                                                        if (snapshot
                                                            .docs.isNotEmpty) {
                                                          final movieRef =
                                                              snapshot
                                                                  .docs
                                                                  .first
                                                                  .reference;
                                                          await movieRef
                                                              .delete();
                                                        }
                                                      });
                                                    } catch (e) {
                                                      // Error deleting movie from watchlist: $e
                                                    }
                                                  },
                                                ),
                                              ),
                                              Focus(
                                                focusNode: FocusServiceProvider
                                                    .listemWatchedRemoveNode,
                                                child: IconButton(
                                                  icon: const Icon(
                                                    Icons.close,
                                                    color: Colors.white,
                                                  ),
                                                  onPressed: () async {
                                                    try {
                                                      await FirebaseFirestore
                                                          .instance
                                                          .collection('users')
                                                          .doc(_currentUser.uid)
                                                          .collection(
                                                              'watchlist')
                                                          .where('movieId',
                                                              isEqualTo:
                                                                  movieId)
                                                          .get()
                                                          .then(
                                                              (snapshot) async {
                                                        if (snapshot
                                                            .docs.isNotEmpty) {
                                                          final movieRef =
                                                              snapshot
                                                                  .docs
                                                                  .first
                                                                  .reference;
                                                          final isWatched =
                                                              snapshot.docs.first
                                                                      .data()[
                                                                  'isWatched'];
                                                          await movieRef
                                                              .update({
                                                            'isWatched':
                                                                !isWatched
                                                          });
                                                        } else {
                                                          await FirebaseFirestore
                                                              .instance
                                                              .collection(
                                                                  'users')
                                                              .doc(_currentUser
                                                                  .uid)
                                                              .collection(
                                                                  'watchlist')
                                                              .add({
                                                            'movieId': movieId,
                                                            'isWatched': false,
                                                          });
                                                        }
                                                      });
                                                    } catch (e) {
                                                      // Error updating movie watched status: $e
                                                    }
                                                  },
                                                ),
                                              ),
                                            ],
                                          ),
                                          FutureBuilder<
                                              QuerySnapshot<
                                                  Map<String, dynamic>>>(
                                            future: FirebaseFirestore.instance
                                                .collection('movies')
                                                .where('movieId',
                                                    isEqualTo: movieId)
                                                .limit(1)
                                                .get(),
                                            builder: (context, snapshot) {
                                              if (!snapshot.hasData) {
                                                return const Center(
                                                    child:
                                                        CircularProgressIndicator());
                                              }
                                              var movieData = snapshot
                                                  .data!.docs.first
                                                  .data();
                                              final movieUrl = movieData['url'];

                                              final movieImage =
                                                  movieData['posterImageUrl'];

                                              return GestureDetector(
                                                onTap: () async {},
                                                child: AspectRatio(
                                                  aspectRatio: 5 / 3,
                                                  child: Container(
                                                    padding: EdgeInsets.all(
                                                      MediaQuery.of(context)
                                                              .size
                                                              .width *
                                                          0.0045,
                                                    ),
                                                    child: Image.network(
                                                      movieImage,
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ],
                          );
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
