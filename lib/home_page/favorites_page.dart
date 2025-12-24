import 'package:flutter/material.dart';
import 'package:modernlogintute/data_manager/database_helper.dart';
import 'package:provider/provider.dart';
import 'package:modernlogintute/settings/font_provider.dart';
import 'package:modernlogintute/settings/theme_provider.dart';
import 'package:modernlogintute/settings/app_localization.dart';

class FavoritesPage extends StatefulWidget {
  @override
  _FavoritesPageState createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  List<String> _favoriteWords = [];

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  // Load favorite words from database
  Future<void> _loadFavorites() async {
    List<String> favorites = await _dbHelper.getFavoriteWords();
    setState(() {
      _favoriteWords = favorites;
    });
  }

  // Remove a word from favorites
  void _removeFavorite(String word) async {
    await _dbHelper.removeFromFavorites(word);
    _loadFavorites(); // Refresh list
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final fontProvider = Provider.of<FontProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;
    final themeColor = isDarkMode ? Colors.purpleAccent : Colors.blue;
    final backgroundColor = isDarkMode ? Colors.black : Colors.white;
    final textColor = isDarkMode ? Colors.white : Colors.black;

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalization.getTranslation(context, "favorites")),
        backgroundColor: themeColor,
      ),
      backgroundColor: backgroundColor,
      body: _favoriteWords.isEmpty
          ? Center(
              child: Text(
                AppLocalization.getTranslation(context, "no_favorites"),
                style: TextStyle(fontSize: fontProvider.fontSize, fontWeight: FontWeight.w500, color: textColor),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: _favoriteWords.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  decoration: BoxDecoration(
                    color: isDarkMode ? Colors.grey[900] : Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: themeColor, width: 1),
                  ),
                  child: ListTile(
                    title: Text(
                      _favoriteWords[index],
                      style: TextStyle(fontSize: fontProvider.fontSize, fontWeight: FontWeight.bold, color: textColor),
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _removeFavorite(_favoriteWords[index]),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
