import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:english_words/english_words.dart';
import 'package:startup_namer/controller/like_controller.dart';
import 'package:startup_namer/data/word_list.dart';

class RandomWords extends StatefulWidget {
  @override
  RandomWordsState createState() => RandomWordsState();
}

class RandomWordsState extends State<RandomWords> {
  final LikeController _likeController = Get.put(LikeController());
  final _biggerFont = const TextStyle(fontSize: 20.0);
  var divide_skip_flag; //구분선 스킵 flag


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Startup Name Generator'),
        leading: IconButton(  //왼쪽
            icon: const Icon(Icons.thumb_down_off_alt), 
            onPressed: _pushDisliked
        ),
        actions: <Widget>[   //오른쪽
          // ignore: unnecessary_new
          new IconButton(
            icon: const Icon(Icons.thumb_up_alt),
            onPressed: _pushLiked,
          )
        ],
      ),
      body: _buildSuggestions(),
    );
  }

  Widget _buildSuggestions() {
    divide_skip_flag = false;
    return ListView.builder(              
        padding: const EdgeInsets.all(16.0),
        itemBuilder:  (context, i) {
          if (i.isOdd) {
            if (divide_skip_flag == true){ //구분선 스킵
              divide_skip_flag = false; //다음 라인은 구분선 그려질 수 있도록 false
              return const SizedBox.shrink(); //
            }
            else {
              return const Divider();
            }
          }
          final index = i ~/ 2;          
          
          if (index >= _likeController.suggestions.length) {
            for (int j = 0; j < 10; j++) {
              //10단어 추가?
              WordList newWord = WordList(WordPair.random(), null, null);
              _likeController.suggestions.add(newWord);
            }
          }             
          if(_likeController.suggestions[index].liked == -1){ //liked가 -1인 경우 
            divide_skip_flag = true; //다음 구분선 그려지지 않게 
            return const SizedBox.shrink(); //빈 위젯
          }            
          return Dismissible(
              key: Key(_likeController.suggestions[index].word.toString()),
              background: Container(
                color: Colors.red,
                padding: const EdgeInsets.only(left: 20.0),
                child: const Icon(Icons.thumb_down, color: Colors.white),
              ),
              direction: DismissDirection.endToStart, //왼쪽 스와이프 시에만 삭제되도록
              //저장된 단어 삭제 시 alert
              confirmDismiss: (direction) {
                if (_likeController.suggestions[index].liked == 1) {
                  return Get.dialog(
                    AlertDialog(
                      title: Text(
                          '"${_likeController.suggestions[index].word.asPascalCase}" is Liked word'),
                      content: const Text('Are you sure to delete ?'),
                      actions: [
                        TextButton(
                            child: const Text("Cancel"),
                            onPressed: () {
                              return Navigator.of(context).pop(false);
                            }),
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red),
                            onPressed: () {
                              setState(() {
                                _likeController.dislike(index);
                              });
                              return Navigator.of(context).pop(false);
                            },
                            child: const Text("Delete")),
                      ],
                    ),
                  );
                }
                setState(() {
                  _likeController.dislike(index);
                });
                divide_skip_flag = false;
                 ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(
                          'Delete "${_likeController.suggestions[index].word.asPascalCase}"')));
                return Future<bool>.value(false);
              },
              onDismissed: (direction) {        
                //삭제 아니고 liked = -1처리하여 안보이게 함        
              },
              child: _buildRow(index)
            );
        });
  }

  Widget _buildRow(int index) {
    final int alreadyLiked = _likeController.suggestions[index].liked;
    return ListTile(
      title: Text(
        _likeController.suggestions[index].word.asPascalCase,
        style: _biggerFont,
      ),
      trailing: Icon(alreadyLiked == 1 ? Icons.favorite : Icons.favorite_border,
          color: alreadyLiked == 1
              ? _likeController.suggestions[index].color
              : null),
      onTap: () {
        setState(() {
          if (alreadyLiked == 1) {
            _likeController.backToSoso(index);
          } else {
            _likeController.like(index);
          }
        });
      },
    );
  }

  _pushLiked() async {
    int length = _likeController.likeCount();
    ScaffoldMessenger.of(context).showSnackBar((SnackBar(
      content: Text(
        'Liked Count : $length',
        style: const TextStyle(fontSize: 18.0),
        textAlign: TextAlign.center,
      ),
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.black.withOpacity(0.7),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).size.height - 80, right: 10, left: 10),
      duration: const Duration(milliseconds: 1500),
    )));

    await Get.toNamed('/page1');

    setState(() {}); //화면 새로고침 용
  }

   _pushDisliked() async {
    int length = _likeController.dislikeCount();
    ScaffoldMessenger.of(context).showSnackBar((SnackBar(
      content: Text(
        'Disliked Count : $length',
        style: const TextStyle(fontSize: 18.0),
        textAlign: TextAlign.center,
      ),
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.black.withOpacity(0.7),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).size.height - 80, right: 10, left: 10),
      duration: const Duration(milliseconds: 1500),
    )));

    await Get.toNamed('/page2');

    setState(() {}); //화면 새로고침 용
  }


}