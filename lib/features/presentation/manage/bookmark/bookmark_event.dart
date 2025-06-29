part of 'bookmark_bloc.dart';

abstract class BookmarkEvent extends Equatable {
  @override
  List<Object> get props => [];
}

/// for ayahs
class SaveBookmark extends BookmarkEvent {
  final SurahModel quranModel;
  final String surahName;
  final List<AyahsModel> ayahs;
  final AyahsModel selectedAyah;

  SaveBookmark({
    required this.quranModel,
    required this.surahName,
    required this.ayahs,
    required this.selectedAyah,
  });

  @override
  List<Object> get props => [quranModel, surahName, ayahs, selectedAyah];
}

class RemoveBookmark extends BookmarkEvent {
  final String surahName;
  final int ayahNumber;

  RemoveBookmark({
    required this.surahName,
    required this.ayahNumber,
  });

  @override
  List<Object> get props => [surahName, ayahNumber];
}

class GetBookmarks extends BookmarkEvent {}

class CheckBookmark extends BookmarkEvent {
  final String surahName;
  final int ayahNumber;

  CheckBookmark({
    required this.surahName,
    required this.ayahNumber,
  });

  @override
  List<Object> get props => [surahName, ayahNumber];
}

/// for pages
class SavePageBookmark extends BookmarkEvent {
  final int juzNumber;
  final int pageNumber;

  SavePageBookmark({required this.juzNumber, required this.pageNumber});
}

class RemovePageBookmark extends BookmarkEvent {
  final int juzNumber;

  RemovePageBookmark({required this.juzNumber});
}

class GetPageBookmark extends BookmarkEvent {
  final int juzNumber;

  GetPageBookmark({required this.juzNumber});
}
