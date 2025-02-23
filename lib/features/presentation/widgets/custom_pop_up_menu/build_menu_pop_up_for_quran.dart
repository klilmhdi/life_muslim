import 'package:flutter/material.dart';
import 'package:quran_life_muslim/core/enums/saved_enum.dart';

class QuranMenuOptionsWidget extends StatefulWidget {
  const QuranMenuOptionsWidget({super.key});

  @override
  State<QuranMenuOptionsWidget> createState() => _QuranMenuOptionsWidgetState();
}

class _QuranMenuOptionsWidgetState extends State<QuranMenuOptionsWidget> {
  SavedEnum? selectedItem;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<SavedEnum>(
      initialValue: selectedItem,
      onSelected: (SavedEnum item) {
        setState(() {
          selectedItem = item;
        });
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<SavedEnum>>[
        const PopupMenuItem<SavedEnum>(
          value: SavedEnum.favourite,
          child: Row(
            children: [
              Icon(Icons.favorite),
              Text('Favourite'),
            ],
          ),
        ),
        const PopupMenuItem<SavedEnum>(
          value: SavedEnum.archive,
          child: Row(
            children: [
              Icon(Icons.archive),
              Text('Archive'),
            ],
          ),
        ),
        const PopupMenuItem<SavedEnum>(
          value: SavedEnum.archive,
          child: Row(
            children: [
              Icon(Icons.bookmark_add),
              Text('Bookmark'),
            ],
          ),
        ),
      ],
    );
  }
}
