import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:modernlogintute/data_manager/database_helper.dart';
import 'package:modernlogintute/settings/theme_provider.dart';
import 'package:modernlogintute/settings/font_provider.dart';

class AddWordPage extends StatefulWidget {
  const AddWordPage({super.key});

  @override
  _AddWordPageState createState() => _AddWordPageState();
}

class _AddWordPageState extends State<AddWordPage> {
  final TextEditingController _vietnameseController = TextEditingController();
  final TextEditingController _nomCharacterController = TextEditingController();
  final TextEditingController _linkedNomController = TextEditingController();
  final TextEditingController _definitionController = TextEditingController();
  final DatabaseHelper dbHelper = DatabaseHelper();

  void _saveWord() async {
    String vietnamese = _vietnameseController.text.trim();
    String nomCharacter = _nomCharacterController.text.trim();
    String linkedNom = _linkedNomController.text.trim();
    String definition = _definitionController.text.trim();

    if (vietnamese.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Vietnamese word cannot be empty")),
      );
      return;
    }

    try {
      await dbHelper.addNewWord(vietnamese, nomCharacter, linkedNom, definition);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Word added successfully!")),
      );
      _vietnameseController.clear();
      _nomCharacterController.clear();
      _linkedNomController.clear();
      _definitionController.clear();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error adding word: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final themeColor = isDarkMode ? Colors.purpleAccent : Colors.blue;
    final fontSize = Provider.of<FontProvider>(context).fontSize;

    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) => Scaffold(
        appBar: AppBar(
          title: Text("Add New Word", style: TextStyle(fontSize: fontSize + 2)),
          backgroundColor: themeColor,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: _vietnameseController,
                style: TextStyle(fontSize: fontSize),
                decoration: InputDecoration(
                  labelText: "Vietnamese Word *",
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: _nomCharacterController,
                style: TextStyle(fontSize: fontSize),
                decoration: InputDecoration(
                  labelText: "Nom Character (Optional)",
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: _linkedNomController,
                style: TextStyle(fontSize: fontSize),
                decoration: InputDecoration(
                  labelText: "Linked Nom (Optional)",
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: _definitionController,
                style: TextStyle(fontSize: fontSize),
                decoration: InputDecoration(
                  labelText: "Definition (Optional)",
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveWord,
                style: ElevatedButton.styleFrom(
                  backgroundColor: themeColor,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  textStyle: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold),
                ),
                child: Text("Save Word"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
