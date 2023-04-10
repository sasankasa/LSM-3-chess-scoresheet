import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class Pieces {
  late final String position;
}

class ScoreSheetController extends GetxController {
  final category = ''.obs;
  var moves = <Pieces>[].obs;
  final length = 0.obs;

  void updateScore(item) {
    final piece = Pieces()..position = item;
    moves.add(piece);
    length.value += 1;
    if (kDebugMode) {
      print('Added $item to $category. Length of list - $length');
    }
  }

  void refreshList() {
    moves.clear();
    length.value = 0;
    if (kDebugMode) {
      print('$category was cleared. Length of list - $length');
    }
  }

  ScoreSheetController(String name) {
    category.value = name;
  }
}
