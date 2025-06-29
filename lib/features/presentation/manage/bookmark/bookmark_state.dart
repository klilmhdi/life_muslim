part of 'bookmark_bloc.dart';

sealed class BookmarkState extends Equatable {
  @override
  List<Object> get props => [];
}

final class BookmarkInitial extends BookmarkState {}

/// for ayahs
class BookmarkSaved extends BookmarkState {}

class BookmarkRemoved extends BookmarkState {}

class BookmarksLoaded extends BookmarkState {
  final List<Map<String, dynamic>> bookmarks;

  BookmarksLoaded(this.bookmarks);

  @override
  List<Object> get props => [bookmarks];
}

class BookmarkChecked extends BookmarkState {
  final bool isBookmarked;

  BookmarkChecked(this.isBookmarked);

  @override
  List<Object> get props => [isBookmarked];
}

class BookmarkError extends BookmarkState {
  final String error;

  BookmarkError(this.error);

  @override
  List<Object> get props => [error];
}

/// for pages
class PageBookmarkSaved extends BookmarkState {}

class PageBookmarkRemoved extends BookmarkState {}

class PageBookmarkLoaded extends BookmarkState {
  final int? pageNumber;

  PageBookmarkLoaded(this.pageNumber);

  @override
  List<Object> get props => [pageNumber!];
}
