import 'package:get/get.dart';
import 'package:startup_namer/data/word_list.dart';
import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'dart:math';


class LikeController extends GetxController {
  final suggestions = <WordList>[].obs;
  //final liked = Set<WordPair>().obs;

  
  void dislike(int index){ //해당 인덱스에 dislike
      suggestions[index].liked = -1;
      print ('dislike ${index} ${suggestions[index].word.asPascalCase}');
  }

    void disLikeWord(WordPair pair){
    for(int i=0; i< suggestions.length; i++){
      if(suggestions[i].word == pair){  //해당 단어면
        suggestions[i].liked = -1;
        print ('disLikeWord ${suggestions[i].word.asPascalCase}');
        break;
      }
    }      
  } 


  void like(int index){ //해당 인덱스에 like
    var color = Colors.primaries[Random().nextInt(Colors.primaries.length)];
      suggestions[index].liked = 1;
      suggestions[index].color = color;
      print ('like ${suggestions[index].word.asPascalCase}');
  }

  void likeWord(WordPair pair){
    var color = Colors.primaries[Random().nextInt(Colors.primaries.length)];
    for(int i=0; i< suggestions.length; i++){
      if(suggestions[i].word == pair){  //해당 단어면
        suggestions[i].liked = 1;
        suggestions[i].color = color;
        print ('likeWord ${suggestions[i].word.asPascalCase}');
        break;
      }
    }      
  } 

  void backToSoso(int index){ //해당 인덱스에
      suggestions[index].liked = 0;
      print ('backToSoso ${suggestions[index].word.asPascalCase}');
  }

  void backToSosoWord(WordPair pair){ 
    for(int i=0; i< suggestions.length; i++){
      if(suggestions[i].word == pair){  //해당 단어면
        suggestions[i].liked = 0;
        print ('backToSosoWord ${suggestions[i].word.asPascalCase}');
        break;
      }
    }      
  } 

  int likeCount(){
    return suggestions.where((p0) => p0.liked == 1).length;
  }

  int dislikeCount(){
    return suggestions.where((p0) => p0.liked == -1).length;
  }
  
}
