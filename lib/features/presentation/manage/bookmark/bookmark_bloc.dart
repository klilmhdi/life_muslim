import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

import '../../../data/models/quran/ayah_model.dart';
import '../../../data/models/quran/surah_model.dart';

part 'bookmark_event.dart';
part 'bookmark_state.dart';

class BookmarkBloc extends HydratedBloc<BookmarkEvent, BookmarkState> {
  BookmarkBloc() : super(const BookmarkInitial()) {
    /// for ayahs
    on<SaveBookmark>(_onSaveBookmark);
    on<RemoveBookmark>(_onRemoveBookmark);
    on<GetBookmarks>(_onGetBookmarks);
    on<CheckBookmark>(_onCheckBookmark);

    /// for pages
    on<SavePageBookmark>(_onSavePageBookmark);
    on<RemovePageBookmark>(_onRemovePageBookmark);
    on<GetPageBookmark>(_onGetPageBookmark);
  }

  @override
  BookmarkState? fromJson(Map<String, dynamic> json) {
    try {
      return BookmarkState.fromMap(json);
    } catch (_) {
      return null;
    }
  }

  @override
  Map<String, dynamic>? toJson(BookmarkState state) {
    try {
      return state.toMap();
    } catch (_) {
      return null;
    }
  }

  /// for ayahs
  void _onSaveBookmark(SaveBookmark event, Emitter<BookmarkState> emit) {
    try {
      final Map<String, dynamic> bookmarkData = {
        "quranModel": event.quranModel.toJson(),
        "surahName": event.surahName,
        "ayahs": event.ayahs.map((ayah) => ayah.toJson()).toList(),
        "selectedAyah": event.selectedAyah.toJson(),
        "ayahNumber": event.selectedAyah.numberInSurah,
        "page": event.selectedAyah.page,
        "juz": event.selectedAyah.juz,
        "hizbQuarter": event.selectedAyah.hizbQuarter,
      };

      // Check if bookmark already exists
      final exists = state.bookmarks.any((bookmark) =>
          bookmark["surahName"] == event.surahName && bookmark["ayahNumber"] == event.selectedAyah.numberInSurah);

      if (!exists) {
        final newBookmarks = List<Map<String, dynamic>>.from(state.bookmarks);
        newBookmarks.add(bookmarkData);

        emit(BookmarkSaved(bookmarks: newBookmarks, pageBookmarks: state.pageBookmarks));
      }
    } catch (e) {
      emit(BookmarkError("Failed to save bookmark", bookmarks: state.bookmarks, pageBookmarks: state.pageBookmarks));
    }
  }

  void _onRemoveBookmark(RemoveBookmark event, Emitter<BookmarkState> emit) {
    try {
      final newBookmarks = state.bookmarks
          .where(
              (bookmark) => !(bookmark["surahName"] == event.surahName && bookmark["ayahNumber"] == event.ayahNumber))
          .toList();

      emit(BookmarkRemoved(bookmarks: newBookmarks, pageBookmarks: state.pageBookmarks));
    } catch (e) {
      emit(BookmarkError("Failed to remove bookmark", bookmarks: state.bookmarks, pageBookmarks: state.pageBookmarks));
    }
  }

  void _onGetBookmarks(GetBookmarks event, Emitter<BookmarkState> emit) {
    try {
      emit(BookmarksLoaded(bookmarks: state.bookmarks, pageBookmarks: state.pageBookmarks));
    } catch (e) {
      emit(BookmarkError("Failed to get bookmarks", bookmarks: state.bookmarks, pageBookmarks: state.pageBookmarks));
    }
  }

  void _onCheckBookmark(CheckBookmark event, Emitter<BookmarkState> emit) async {
    try {
      emit(BookmarkLoading(bookmarks: state.bookmarks, pageBookmarks: state.pageBookmarks));

      await Future.delayed(const Duration(seconds: 2));

      final isBookmarked = state.bookmarks
          .any((bookmark) => bookmark["surahName"] == event.surahName && bookmark["ayahNumber"] == event.ayahNumber);

      emit(BookmarksLoaded(bookmarks: state.bookmarks, pageBookmarks: state.pageBookmarks));

      debugPrint("Checked → $isBookmarked");
    } catch (e) {
      emit(BookmarkError("Failed to check bookmark", bookmarks: state.bookmarks, pageBookmarks: state.pageBookmarks));
    }
  }

  /// for pages
  void _onSavePageBookmark(SavePageBookmark event, Emitter<BookmarkState> emit) {
    try {
      final newPageBookmarks = Map<String, int>.from(state.pageBookmarks);
      newPageBookmarks[event.juzNumber.toString()] = event.pageNumber;

      debugPrint('تم حفظ الجزء ${event.juzNumber} - الصفحة ${event.pageNumber}');
      emit(PageBookmarkSaved(bookmarks: state.bookmarks, pageBookmarks: newPageBookmarks));
    } catch (e) {
      debugPrint('خطأ في الحفظ: $e');
      emit(BookmarkError("Failed to save page bookmark",
          bookmarks: state.bookmarks, pageBookmarks: state.pageBookmarks));
    }
  }

  void _onRemovePageBookmark(RemovePageBookmark event, Emitter<BookmarkState> emit) {
    try {
      final newPageBookmarks = Map<String, int>.from(state.pageBookmarks);
      newPageBookmarks.remove(event.juzNumber.toString());

      emit(PageBookmarkRemoved(bookmarks: state.bookmarks, pageBookmarks: newPageBookmarks));
    } catch (e) {
      emit(BookmarkError("Failed to remove page bookmark",
          bookmarks: state.bookmarks, pageBookmarks: state.pageBookmarks));
    }
  }

  void _onGetPageBookmark(GetPageBookmark event, Emitter<BookmarkState> emit) {
    try {
      final pageNumber = state.pageBookmarks[event.juzNumber.toString()];
      emit(PageBookmarkLoaded(pageNumber, bookmarks: state.bookmarks, pageBookmarks: state.pageBookmarks));
    } catch (e) {
      emit(
          BookmarkError("Failed to get page bookmark", bookmarks: state.bookmarks, pageBookmarks: state.pageBookmarks));
    }
  }
}
