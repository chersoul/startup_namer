import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';

class WordList{
  late WordPair word;
  var color;
  var liked;

  WordList(WordPair word, color, liked){
    this.word = word;
    this.color = (color ?? Colors.transparent);
    this.liked = (liked ?? 0);
  }

}