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

  SaveBookmark({required this.quranModel, required this.surahName, required this.ayahs, required this.selectedAyah});

  @override
  List<Object> get props => [quranModel, surahName, ayahs, selectedAyah];

  Map<String, dynamic> toMap() {
    return {
      'quranModel': quranModel.toJson(),
      'surahName': surahName,
      'ayahs': ayahs.map((ayah) => ayah.toJson()).toList(),
      'selectedAyah': selectedAyah.toJson(),
    };
  }

  factory SaveBookmark.fromMap(Map<String, dynamic> map) {
    return SaveBookmark(
      quranModel: SurahModel.fromJson(map['quranModel']),
      surahName: map['surahName'],
      ayahs: (map['ayahs'] as List).map((e) => AyahsModel.fromJson(e)).toList(),
      selectedAyah: AyahsModel.fromJson(map['selectedAyah']),
    );
  }
}

class RemoveBookmark extends BookmarkEvent {
  final String surahName;
  final int ayahNumber;

  RemoveBookmark({required this.surahName, required this.ayahNumber});

  @override
  List<Object> get props => [surahName, ayahNumber];

  Map<String, dynamic> toMap() {
    return {
      'surahName': surahName,
      'ayahNumber': ayahNumber,
    };
  }

  factory RemoveBookmark.fromMap(Map<String, dynamic> map) {
    return RemoveBookmark(
      surahName: map['surahName'],
      ayahNumber: map['ayahNumber'],
    );
  }
}

class GetBookmarks extends BookmarkEvent {}

class CheckBookmark extends BookmarkEvent {
  final String surahName;
  final int ayahNumber;

  CheckBookmark({required this.surahName, required this.ayahNumber});

  @override
  List<Object> get props => [surahName, ayahNumber];

  Map<String, dynamic> toMap() {
    return {
      'surahName': surahName,
      'ayahNumber': ayahNumber,
    };
  }

  factory CheckBookmark.fromMap(Map<String, dynamic> map) {
    return CheckBookmark(
      surahName: map['surahName'],
      ayahNumber: map['ayahNumber'],
    );
  }
}

/// for pages
class SavePageBookmark extends BookmarkEvent {
  final int juzNumber;
  final int pageNumber;

  SavePageBookmark({required this.juzNumber, required this.pageNumber});

  @override
  List<Object> get props => [juzNumber, pageNumber];

  Map<String, dynamic> toMap() {
    return {
      'juzNumber': juzNumber,
      'pageNumber': pageNumber,
    };
  }

  factory SavePageBookmark.fromMap(Map<String, dynamic> map) {
    return SavePageBookmark(
      juzNumber: map['juzNumber'],
      pageNumber: map['pageNumber'],
    );
  }
}

class RemovePageBookmark extends BookmarkEvent {
  final int juzNumber;

  RemovePageBookmark({required this.juzNumber});

  @override
  List<Object> get props => [juzNumber];

  Map<String, dynamic> toMap() {
    return {
      'juzNumber': juzNumber,
    };
  }

  factory RemovePageBookmark.fromMap(Map<String, dynamic> map) {
    return RemovePageBookmark(
      juzNumber: map['juzNumber'],
    );
  }
}

class GetPageBookmark extends BookmarkEvent {
  final int juzNumber;

  GetPageBookmark({required this.juzNumber});

  @override
  List<Object> get props => [juzNumber];

  Map<String, dynamic> toMap() {
    return {
      'juzNumber': juzNumber,
    };
  }

  factory GetPageBookmark.fromMap(Map<String, dynamic> map) {
    return GetPageBookmark(
      juzNumber: map['juzNumber'],
    );
  }
}
