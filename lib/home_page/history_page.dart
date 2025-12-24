import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:modernlogintute/data_manager/database_helper.dart';
import 'package:modernlogintute/settings/theme_provider.dart';
import 'package:modernlogintute/settings/font_provider.dart';

class HistoryPage extends StatefulWidget {
  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  List<Map<String, dynamic>> history = [];

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    final dbHelper = DatabaseHelper();
    final data = await dbHelper.getSearchHistory();

    print("Loaded History: $data"); // Debugging: Print history

    setState(() {
      history = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final themeColor = isDarkMode ? Colors.purpleAccent : Colors.blue; // Dynamic Theme Color
    final textColor = isDarkMode ? Colors.white : Colors.black; // Text Color
    final fontSize = Provider.of<FontProvider>(context).fontSize; // Get font size

    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) => Scaffold(
        appBar: AppBar(
          title: const Text("Search History"),
          backgroundColor: themeColor, // AppBar follows theme
        ),
        body: history.isEmpty
            ? Center(
                child: Text(
                  "No history found.",
                  style: TextStyle(
                    fontSize: fontSize,
                    fontWeight: FontWeight.bold,
                    color: themeColor, // Matches theme
                  ),
                ),
              )
            : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: history.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: Icon(Icons.history, color: themeColor), // Icon follows theme
                    title: Text(
                      history[index]['word'],
                      style: TextStyle(
                        fontSize: fontSize,
                        fontWeight: FontWeight.bold,
                        color: textColor, // Black in light mode, White in dark mode
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
