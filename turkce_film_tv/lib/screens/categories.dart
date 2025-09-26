import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:turkce_film_tv/screens/videoplayer.dart';

import '../services/focusnodeservice.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  CategoriesScreenState createState() => CategoriesScreenState();
}

class CategoriesScreenState extends State<CategoriesScreen> {
  List<DocumentSnapshot> _movies = [];
  late String _selectedCategory;

  @override
  void initState() {
    super.initState();
    _selectedCategory = 'Aile';
    _getMovies();
  }

  Future<void> _getMovies() async {
    Query query = FirebaseFirestore.instance.collection('movies');

    query = query.where('categories', arrayContains: _selectedCategory);

    var querySnapshot = await query.get();

    setState(() {
      _movies = querySnapshot.docs;
    });
  }

  void _onCategorySelected(String category) {
    setState(() {
      _selectedCategory = category;
    });

    _getMovies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(
                MediaQuery.of(context).size.width * 0.03,
                0,
                MediaQuery.of(context).size.width * 0.06,
                0,
              ),
              child: Wrap(
                spacing: MediaQuery.of(context).size.width * 0.0150,
                runSpacing: 0,
                alignment:
                    WrapAlignment.center, // set horizontal alignment to center
                runAlignment: WrapAlignment.center,
                children: [
                  categoryButton('Aile', _selectedCategory == 'Aile'),
                  categoryButton('Aksiyon', _selectedCategory == 'Aksiyon'),
                  categoryButton('Animasyon', _selectedCategory == 'Animasyon'),
                  categoryButton(
                      'Bilim Kurgu', _selectedCategory == 'Bilim Kurgu'),
                  categoryButton('Biyografi', _selectedCategory == 'Biyografi'),
                  categoryButton('Çocuk', _selectedCategory == 'Çocuk'),
                  categoryButton('Dram', _selectedCategory == 'Dram'),
                  categoryButton('Fantastik', _selectedCategory == 'Fantastik'),
                  categoryButton('Gerilim', _selectedCategory == 'Gerilim'),
                  categoryButton('Gizem', _selectedCategory == 'Gizem'),
                  categoryButton('Komedi', _selectedCategory == 'Komedi'),
                  categoryButton('Korku', _selectedCategory == 'Korku'),
                  categoryButton('Macera', _selectedCategory == 'Macera'),
                  categoryButton('Müzikal', _selectedCategory == 'Müzikal'),
                  categoryButton('Polisiye', _selectedCategory == 'Polisiye'),
                  categoryButton('Psikoloji', _selectedCategory == 'Psikoloji'),
                  categoryButton('Romantik', _selectedCategory == 'Romantik'),
                  categoryButton('Savaş', _selectedCategory == 'Savaş'),
                  categoryButton('Spor', _selectedCategory == 'Spor'),
                  categoryButton('Suç', _selectedCategory == 'Suç'),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(
                MediaQuery.of(context).size.width * 0.06,
                MediaQuery.of(context).size.width * 0.02,
                MediaQuery.of(context).size.width * 0.06,
                MediaQuery.of(context).size.width * 0.02,
              ),
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.6,
                child: GridView.builder(
                  itemCount: _movies.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    childAspectRatio: 5 / 3,
                  ),
                  itemBuilder: (context, index) {
                    final Map<String, dynamic> movieData = (_movies[index]
                            as DocumentSnapshot<Map<String, dynamic>>)
                        .data()!;
                    final String? subtitle = movieData.containsKey('subtitle')
                        ? movieData['subtitle'].toString()
                        : null;

                    return GestureDetector(
                      onTap: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => VideoPlayerScreen(
                              videoUrl: movieData['url'],
                              subtitle: subtitle,
                            ),
                          ),
                        );
                      },
                      child: AspectRatio(
                        aspectRatio: 5 / 3,
                        child: Container(
                          padding: EdgeInsets.all(
                            MediaQuery.of(context).size.width * 0.0045,
                          ),
                          child: Image.network(
                            _movies[index]['posterImageUrl'],
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget categoryButton(String categoryName, bool isSelected) {
    Color buttonColor = isSelected ? Colors.black : Colors.grey[900]!;
    return Focus(
      focusNode: FocusServiceProvider.categoryMenuNode,
      child: ElevatedButton(
        onPressed: () {
          _onCategorySelected(categoryName);
        },
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all<Color>(buttonColor),
          shape: WidgetStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
          side: WidgetStateProperty.all<BorderSide>(
            const BorderSide(color: Colors.white, width: 1.0),
          ),
          minimumSize: WidgetStateProperty.all<Size>(const Size(45, 25)),
        ),
        child: FittedBox(
          child: Text(
            categoryName,
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
