import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:modernlogintute/data_manager/database_helper.dart';
import 'package:modernlogintute/settings/theme_provider.dart';
import 'package:modernlogintute/settings/font_provider.dart';
import 'package:modernlogintute/settings/app_localization.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _controller = TextEditingController();
  List<Map<String, dynamic>> searchResults = [];
  List<String> suggestions = [];
  bool hasResults = false;
  final DatabaseHelper _dbHelper = DatabaseHelper();
  Map<String, bool> _favoriteStatus = {}; // Store favorite states for words

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
        title: Text(AppLocalization.getTranslation(context, "search"), style: TextStyle(fontSize: fontProvider.fontSize + 2)),
        backgroundColor: themeColor,
      ),
      backgroundColor: backgroundColor,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Search Bar
              Container(
                decoration: BoxDecoration(
                  color: isDarkMode ? Colors.grey[900] : Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: themeColor, width: 2),
                ),
                child: TextField(
                  controller: _controller,
                  style: TextStyle(fontSize: fontProvider.fontSize, color: textColor),
                  decoration: InputDecoration(
                    labelText: AppLocalization.getTranslation(context, "enter_word"),
                    labelStyle: TextStyle(color: themeColor),
                    border: InputBorder.none,
                    prefixIcon: Icon(Icons.search, color: themeColor),
                    suffixIcon: _controller.text.isNotEmpty
                        ? IconButton(
                            icon: Icon(Icons.clear, color: themeColor),
                            onPressed: () {
                              setState(() {
                                _controller.clear();
                                searchResults.clear();
                                suggestions.clear();
                                hasResults = false;
                              });
                            },
                          )
                        : null,
                    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  ),
                  onChanged: _getSuggestions,
                  onSubmitted: _searchWord,
                ),
              ),

              const SizedBox(height: 15),

              // Display Suggestions
              if (suggestions.isNotEmpty)
                Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  constraints: const BoxConstraints(maxHeight: 200),
                  decoration: BoxDecoration(
                    color: backgroundColor,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: themeColor, width: 1),
                  ),
                  child: ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: suggestions.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(
                          suggestions[index],
                          style: TextStyle(fontSize: fontProvider.fontSize, color: textColor),
                        ),
                        onTap: () {
                          _controller.text = suggestions[index];
                          _searchWord(suggestions[index]);
                        },
                      );
                    },
                  ),
                ),

              const SizedBox(height: 15),

              // Display Search Results
              if (hasResults && searchResults.isNotEmpty)
                Expanded(
                  child: ListView.builder(
                    itemCount: searchResults.length,
                    itemBuilder: (context, index) {
                      final result = searchResults[index];
                      return _buildResultBox(
                        result['vietnamese'] ?? "",
                        result['nom_character'] ?? "",
                        result['linked_nom'] ?? "",
                        result['definition'] ?? "No definition available.",
                        fontProvider.fontSize,
                        themeColor,
                        textColor,
                        backgroundColor,
                      );
                    },
                  ),
                ),

              // No Results Message
              if (!hasResults && _controller.text.isNotEmpty)
                Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: Text(
                    AppLocalization.getTranslation(context, "no_results"),
                    style: TextStyle(fontSize: fontProvider.fontSize, fontWeight: FontWeight.w500, color: themeColor),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  // Fetch Suggestions
  void _getSuggestions(String query) async {
    if (query.isEmpty) {
      setState(() {
        suggestions = [];
        hasResults = false;
      });
      return;
    }

    List<String> matches = await _dbHelper.getSuggestions(query);
    setState(() {
      suggestions = matches;
      hasResults = false;
    });
  }

  // Search Word
  void _searchWord(String word) async {
    final results = await _dbHelper.searchWord(word.trim());
    await _dbHelper.saveSearchHistory(word.trim());

    Map<String, bool> favStatus = {};
    for (var result in results) {
      String vietnameseWord = result['vietnamese'];
      favStatus[vietnameseWord] = await _dbHelper.isFavorite(vietnameseWord);
    }

    setState(() {
      _controller.text = word.trim();
      searchResults = results;
      hasResults = results.isNotEmpty;
      suggestions = [];
      _favoriteStatus = favStatus;
    });
  }

  // Toggle Favorite
  void _toggleFavorite(String word) async {
    bool isFav = _favoriteStatus[word] ?? false;

    if (isFav) {
      await _dbHelper.removeFromFavorites(word);
    } else {
      await _dbHelper.addToFavorites(word);
    }

    setState(() {
      _favoriteStatus[word] = !isFav;
    });
  }

  // Build Search Result Box
  Widget _buildResultBox(String vietnamese, String nomChar, String linkedNom, String definition, double fontSize, Color themeColor, Color textColor, Color backgroundColor) {
    bool isFav = _favoriteStatus[vietnamese] ?? false;

    return Container(
      width: MediaQuery.of(context).size.width * 0.95,
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: themeColor, width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                vietnamese,
                style: TextStyle(fontSize: fontSize + 2, fontWeight: FontWeight.bold, color: textColor),
              ),
              IconButton(
                icon: Icon(isFav ? Icons.star : Icons.star_border, color: isFav ? Colors.yellow : themeColor),
                onPressed: () => _toggleFavorite(vietnamese),
              ),
            ],
          ),
          _buildText("Nom Character", nomChar, fontSize, themeColor, textColor),
          _buildText("Linked Nom", linkedNom, fontSize, themeColor, textColor),
          _buildText("Definition", definition, fontSize, themeColor, textColor),
        ],
      ),
    );
  }

  // Build Text Widgets with Different Title Color
  Widget _buildText(String title, String content, double fontSize, Color titleColor, Color textColor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(fontSize: fontSize + 2, fontWeight: FontWeight.bold, color: titleColor)),
          Text(content.isNotEmpty ? content : "N/A", style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.w500, color: textColor)),
        ],
      ),
    );
  }
}
