import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';
import 'package:get/get.dart';

import 'package:startup_namer/controller/like_controller.dart';
import 'package:startup_namer/data/word_list.dart';

class Page1 extends StatefulWidget {
  //final Set<WordPair> liked ;

  //const Page1(this.liked);

  @override
  Page1State createState() => Page1State();
}

class Page1State extends State<Page1> {
  final LikeController _likeController = Get.put(LikeController());

  final _biggerFont = const TextStyle(fontSize: 20.0);

  @override
  Widget build(BuildContext context) {
    //if (_likeController.liked.isEmpty){
    if (_likeController.likeCount() == 0) {
      return Scaffold(
        // appBar: AppBar (title : Text ('liked suggestions')),
        body: _buildNoRow(),
      );
    } else {
      return Scaffold(
        // appBar: AppBar (title : Text ('liked suggestions')),
        body: _buildLikedRow(),
      );
    }
  }

  Widget _buildLikedRow() {
    // final Iterable<ListTile> tiles = _likeController.liked.map((WordPair pair) {
    final Iterable<ListTile> tiles = _likeController.suggestions.where((p0) => p0.liked == 1).map((WordList wl) {
      return ListTile(
          title: Text(wl.word.asPascalCase, style: _biggerFont),
          trailing: Icon(
            Icons.favorite,
            color: wl.color,
          ),
          onTap: () async {
            await _showNotlikedDialog(wl.word);
            setState(() {});
          });
    });
    final List<Widget> divided =
        ListTile.divideTiles(context: context, tiles: tiles).toList();

    return Scaffold(
        appBar: AppBar(title: const Text("Liked")),
        body: ListView(
          children: divided,
        ));
  }

  Future<dynamic> _showNotlikedDialog(WordPair pair) {
    return Get.dialog(
      AlertDialog(
        title: const Text('Unlike'),
        content: Text('Unlike word "${pair.asPascalCase}"'),
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
                  content: Text('Unlike "${pair.asPascalCase}"'),
                  duration: const Duration(milliseconds: 2500),
                  action: SnackBarAction(
                    label: 'Undo',
                    textColor: Colors.lightBlueAccent,
                    onPressed: () {
                      //_likeController.liked.add(pair);
                      _likeController.likeWord(pair);
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
      appBar: AppBar(title: const Text("Liked")),
      body: const Text(
        ' No word',
        style: TextStyle(fontSize: 20.0, color: Colors.grey),
      ),
    );
  }
}
