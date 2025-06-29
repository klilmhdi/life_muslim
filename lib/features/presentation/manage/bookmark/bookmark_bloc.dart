import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

import '../../../../core/shared_preferenced/shared_preferenced.dart';
import '../../../data/models/quran/ayah_model.dart';
import '../../../data/models/quran/surah_model.dart';

part 'bookmark_event.dart';

part 'bookmark_state.dart';

class BookmarkBloc extends Bloc<BookmarkEvent, BookmarkState> {
  BookmarkBloc() : super(BookmarkInitial()) {
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

  /// for ayahs
  Future<void> _onSaveBookmark(SaveBookmark event, Emitter<BookmarkState> emit) async {
    try {
      await SharedPrefController.saveBookmark(
        quranModel: event.quranModel,
        surahName: event.surahName,
        ayahs: event.ayahs,
        selectedAyah: event.selectedAyah,
      );
      emit(BookmarkSaved());
    } catch (e) {
      emit(BookmarkError("Failed to save bookmark"));
    }
  }

  Future<void> _onRemoveBookmark(RemoveBookmark event, Emitter<BookmarkState> emit) async {
    try {
      await SharedPrefController.removeBookmark(event.surahName, event.ayahNumber);
      emit(BookmarkRemoved());
    } catch (e) {
      emit(BookmarkError("Failed to remove bookmark"));
    }
  }

  Future<void> _onGetBookmarks(GetBookmarks event, Emitter<BookmarkState> emit) async {
    try {
      final bookmarks = await SharedPrefController.getBookmarks();
      emit(BookmarksLoaded(bookmarks));
    } catch (e) {
      emit(BookmarkError("Failed to get bookmarks"));
    }
  }

  Future<void> _onCheckBookmark(CheckBookmark event, Emitter<BookmarkState> emit) async {
    try {
      final isBookmarked =
          await SharedPrefController.isBookmarked(event.surahName, event.ayahNumber);
      emit(BookmarkChecked(isBookmarked));
    } catch (e) {
      emit(BookmarkError("Failed to check bookmark"));
    }
  }

  /// for pages
  Future<void> _onSavePageBookmark(SavePageBookmark event, Emitter<BookmarkState> emit) async {
    try {
      await SharedPrefController.saveBookmarkedPage(event.juzNumber, event.pageNumber);
      debugPrint('تم حفظ الجزء ${event.juzNumber} - الصفحة ${event.pageNumber}');
      emit(PageBookmarkSaved());
    } catch (e) {
      debugPrint('خطأ في الحفظ: $e');
      emit(BookmarkError("Failed to save page bookmark"));
    }
  }

  Future<void> _onRemovePageBookmark(RemovePageBookmark event, Emitter<BookmarkState> emit) async {
    try {
      await SharedPrefController.removeBookmarkedPage(event.juzNumber);
      emit(PageBookmarkRemoved());
    } catch (e) {
      emit(BookmarkError("Failed to remove page bookmark"));
    }
  }

  Future<void> _onGetPageBookmark(GetPageBookmark event, Emitter<BookmarkState> emit) async {
    try {
      final pageNumber = await SharedPrefController.getBookmarkedPage(event.juzNumber);
      emit(PageBookmarkLoaded(pageNumber));
    } catch (e) {
      emit(BookmarkError("Failed to get page bookmark"));
    }
  }
}
