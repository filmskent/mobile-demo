import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/item.dart';

class TodoListService extends ChangeNotifier {
  final List<Item> _items = [];

  void add(Item item) {
    _items.add(item);
    notifyListeners();
  }

  void removeAll() {
    _items.clear();
    notifyListeners();
  }

  void removeAt(int index) {
    _items.removeAt(index);
    notifyListeners();
  }

  void toggleMark(index) {
    _items[index].isMarked = !_items[index].isMarked;
    notifyListeners();
  }

  get getList => _items;
}
