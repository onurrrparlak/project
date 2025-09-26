import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:turkce_film_tv/screens/loginscreen.dart';

import '../services/focusnodeservice.dart';
import '../services/user_service.dart';

// ignore_for_file: use_build_context_synchronously

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  ProfilePageState createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {
  final UserService _userService = UserService();
  late String _currentUserId;
  String? _password;
  String? _newPassword;
  String? _selectedAvatar;

  int selectedItemIndex = -1;

  final List<String> _avatars = [
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    '10',
    '11',
    '12',
    '13',
    '14',
    '15',
    '16',
    '17',
    '18',
    '19',
    '20',
    '21',
    '22',
    '23',
    '24',
    '25',
    '26',
    '27',
    '28',
    '29',
    '30',
    '31',
    '32',
  ];

  Future<Map<String, dynamic>?> getCurrentUser() async {
    final currentUser = _userService.auth.currentUser;
    if (currentUser != null) {
      final userData = await _userService.getUserData(currentUser.uid);
      final selectedAvatar = userData['avatar'] ?? _avatars[0];
      return {
        'username': userData['username'],
        'email': userData['email'],
        'avatar': selectedAvatar,
      };
    } else {
      return null;
    }
  }

  Future<void> updateAvatar(String? avatarNumber, String userId) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .update({'avatar': avatarNumber});
    } catch (e) {
      // Handle any errors that occur while updating the avatar
      // Error updating avatar: $e
    }
  }

  @override
  void initState() {
   
    super.initState();
    _currentUserId = _userService.getCurrentUserId() ?? '';
    getCurrentUser();
  }

  final _formKey = GlobalKey<FormState>();

  _changePassword(String currentPassword, String newPassword) async {
    final user = FirebaseAuth.instance.currentUser;
    final cred = EmailAuthProvider.credential(
        email: user!.email!, password: currentPassword);

    if (newPassword.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Yeni şifreniz 6 haneli veya daha fazla olmalıdır')),
      );
    }

    user.reauthenticateWithCredential(cred).then((value) {
      user.updatePassword(newPassword).then((_) async {
        await _userService.logoutUser();
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const LoginPage()),
          );
        }
      }).catchError((error) {});
    }).catchError((err) {
      if (err.code == 'wrong-password') {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content:
                    Text('Girdiğiniz şifre hesabınızın şifresiyle aynı değil')),
          );
        }
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: FutureBuilder(
          future: getCurrentUser(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else {
              final userData = snapshot.data!;
              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    key: _formKey,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Flexible(
                          flex: 1,
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    const Text('Kullanıcının adı:'),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.0120,
                                    ),
                                    Expanded(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          border:
                                              Border.all(color: Colors.white),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: Theme(
                                          data: ThemeData(
                                            primaryColor: Colors.white,
                                            textTheme: const TextTheme(
                                              titleMedium: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                          child: SizedBox(
                                            width: 200,
                                            child: Container(
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: Colors.white),
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              child: TextFormField(
                                                initialValue:
                                                    userData['username'],
                                                enabled: false,
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                ),
                                                decoration:
                                                    const InputDecoration(
                                                  border: OutlineInputBorder(),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16.0),
                                Row(
                                  children: [
                                    const Text('Güncel şifrenizi giriniz:'),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.0120,
                                    ),
                                    Expanded(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          border:
                                              Border.all(color: Colors.white),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: TextFormField(
                                          focusNode: FocusServiceProvider
                                              .avatarCurrentPasswordNode,
                                          style: const TextStyle(
                                            color: Colors.white,
                                          ),
                                          onChanged: (value) {
                                            _password = value;
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16.0),
                                Row(
                                  children: [
                                    const Text('Yeni şifrenizi giriniz:'),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.0120,
                                    ),
                                    Expanded(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          border:
                                              Border.all(color: Colors.white),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: TextFormField(
                                          focusNode: FocusServiceProvider
                                              .avatarNewPasswordNode,
                                          onChanged: (value) {
                                            _newPassword = value;
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Focus(
                                  focusNode:
                                      FocusServiceProvider.avatarUpdateSubmitNode,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      _password != null
                                          ? _changePassword(
                                              _password!, _newPassword!)
                                          : null;
                                    },
                                    style: ButtonStyle(
                                      shape: WidgetStateProperty.all<
                                          RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                        ),
                                      ),
                                      padding: WidgetStateProperty.all<
                                          EdgeInsetsGeometry>(
                                        const EdgeInsets.symmetric(
                                            vertical: 12.0, horizontal: 24.0),
                                      ),
                                      backgroundColor:
                                          WidgetStateProperty.all<Color>(
                                              Colors.green),
                                      foregroundColor:
                                          WidgetStateProperty.all<Color>(
                                              Colors.white),
                                      overlayColor:
                                          WidgetStateProperty.all<Color>(
                                        Colors.green.withValues(alpha: 0.8),
                                      ),
                                      elevation:
                                          WidgetStateProperty.all<double>(
                                              0.0),
                                    ),
                                    child: const Text('Güncelle'),
                                  ),
                                ),
                                Focus(
                                  focusNode:
                                      FocusServiceProvider.avatarUpdateSubmitNode,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      _userService.logoutUser().then((_) {
                                        if (mounted) {
                                          Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const LoginPage()),
                                          );
                                        }
                                      });
                                    },
                                    style: ButtonStyle(
                                      shape: WidgetStateProperty.all<
                                          RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                        ),
                                      ),
                                      padding: WidgetStateProperty.all<
                                          EdgeInsetsGeometry>(
                                        const EdgeInsets.symmetric(
                                            vertical: 12.0, horizontal: 24.0),
                                      ),
                                      backgroundColor:
                                          WidgetStateProperty.all<Color>(
                                              Colors.red),
                                      foregroundColor:
                                          WidgetStateProperty.all<Color>(
                                              Colors.white),
                                      overlayColor:
                                          WidgetStateProperty.all<Color>(
                                        Colors.red.withValues(alpha: 0.8),
                                      ),
                                      elevation:
                                          WidgetStateProperty.all<double>(
                                              0.0),
                                    ),
                                    child: const Text('Çıkış yap'),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Flexible(
                          flex: 1,
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    height: MediaQuery.of(context).size.width *
                                        0.38,
                                    width: MediaQuery.of(context).size.width *
                                        0.38,
                                    child: GridView.builder(
                                      itemCount: _avatars.length,
                                      gridDelegate:
                                          const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 6,
                                        childAspectRatio: 1.0,
                                        mainAxisSpacing: 10.0,
                                        crossAxisSpacing: 10.0,
                                      ),
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              setState(() {
                                                _selectedAvatar =
                                                    _avatars[index];
                                                updateAvatar(_selectedAvatar,
                                                    _currentUserId);
                                              });
                                            });
                                          },
                                          child: Focus(
                                            focusNode: FocusServiceProvider
                                                .avatarGridViewBuilderNode,
                                            onFocusChange: (bool hasFocus) {
                                              if (hasFocus &&
                                                  selectedItemIndex == -1) {
                                                // Set initial focus to the first item
                                                selectedItemIndex = 0;
                                              }
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                image: DecorationImage(
                                                  image: AssetImage(
                                                      'assets/images/avatars/${_avatars[index]}.jpg'),
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                              child: _selectedAvatar ==
                                                      _avatars[index]
                                                  ? const Icon(
                                                      Icons.check_circle,
                                                      color: Colors.white,
                                                      size: 50.0)
                                                  : Container(),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              );
            }
          }),
    );
  }
}
