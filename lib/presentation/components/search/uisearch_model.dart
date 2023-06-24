import 'package:flutter/material.dart';

class UiSearchModel {
  final List<ImageCard> chooseCards;

  UiSearchModel(this.chooseCards) ;
}

class ImageCard {
  final String title;
  final String backgroundImage;
  final Color backgroundColor;
  final VoidCallback? callback;

  ImageCard({required this.title,this.callback,  required this.backgroundImage, required this.backgroundColor});

}