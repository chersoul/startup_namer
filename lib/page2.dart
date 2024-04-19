import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';
import 'package:get/get.dart';

import 'package:startup_namer/controller/like_controller.dart';
import 'package:startup_namer/data/word_list.dart';

class Page2 extends StatefulWidget {

  @override
  Page1State createState() => Page1State();
}

class Page1State extends State<Page2> {
  final LikeController _likeController = Get.put(LikeController());

  final _biggerFont = const TextStyle(fontSize: 20.0);

  @override
  Widget build(BuildContext context) {
    if (_likeController.dislikeCount() == 0) {
      return Scaffold(
        body: _buildNoRow(),
      );
    } else {
      return Scaffold(
        body: _buildLikedRow(),
      );
    }
  }

  Widget _buildLikedRow() {
    final Iterable<ListTile> tiles = _likeController.suggestions.where((p0) => p0.liked == -1).map((WordList wl) {
      return ListTile(
          title: Text(wl.word.asPascalCase, style: _biggerFont),
          trailing: const Icon(
            Icons.replay,
            color: Colors.grey,
          ),
          onTap: () async {
            await _showNotlikedDialog(wl.word);
            setState(() {});
          });
    });
    final List<Widget> divided =
        ListTile.divideTiles(context: context, tiles: tiles).toList();

    return Scaffold(
        appBar: AppBar(title: const Text("Disliked")),
        body: ListView(
          children: divided,
        ));
  }

  Future<dynamic> _showNotlikedDialog(WordPair pair) {
    return Get.dialog(
      AlertDialog(
        title: const Text('Re-include'),
        content: Text('Back to suggestion list "${pair.asPascalCase}"'),
        actions: [
          TextButton(
              child: const Text("Cancel"),
              onPressed: () {
                return Navigator.of(context).pop(false);
              }),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple),
            onPressed: () => {
              Navigator.pop(context, 'OK'),
              _likeController.backToSosoWord(pair),
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Back to suggestion "${pair.asPascalCase}"'),
                  duration: const Duration(milliseconds: 2500),
                  action: SnackBarAction(
                    label: 'Undo',
                    textColor: Colors.lightBlueAccent,
                    onPressed: () {
                      //_likeController.liked.add(pair);
                      _likeController.disLikeWord(pair);
                      setState(() {});
                    },
                  ),
                ),
              )
            },
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  Widget _buildNoRow() {
    return Scaffold(
      appBar: AppBar(title: const Text("Disliked")),
      body: const Text(
        ' No word',
        style: TextStyle(fontSize: 20.0, color: Colors.grey),
      ),
    );
  }
}
