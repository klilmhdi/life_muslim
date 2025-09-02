part of 'bookmark_bloc.dart';

sealed class BookmarkState extends Equatable {
  final List<Map<String, dynamic>> bookmarks;
  final Map<String, int> pageBookmarks;

  const BookmarkState({
    this.bookmarks = const [],
    this.pageBookmarks = const {},
  });

  Map<String, dynamic> toMap() {
    return {
      'bookmarks': bookmarks,
      'pageBookmarks': pageBookmarks,
    };
  }

  factory BookmarkState.fromMap(Map<String, dynamic> map) {
    return BookmarkInitial(
      bookmarks: List<Map<String, dynamic>>.from(map['bookmarks'] ?? []),
      pageBookmarks: Map<String, int>.from(map['pageBookmarks'] ?? {}),
    );
  }

  @override
  List<Object> get props => [bookmarks, pageBookmarks];
}

final class BookmarkInitial extends BookmarkState {
  const BookmarkInitial({super.bookmarks, super.pageBookmarks});
}

/// حالة اللودينج
class BookmarkLoading extends BookmarkState {
  const BookmarkLoading({super.bookmarks, super.pageBookmarks});
}

/// for ayahs
class BookmarkSaved extends BookmarkState {
  const BookmarkSaved({super.bookmarks, super.pageBookmarks});
}

class BookmarkRemoved extends BookmarkState {
  const BookmarkRemoved({super.bookmarks, super.pageBookmarks});
}

class BookmarksLoaded extends BookmarkState {
  const BookmarksLoaded({super.bookmarks, super.pageBookmarks});
}

class BookmarkChecked extends BookmarkState {
  final bool isBookmarked;

  const BookmarkChecked(this.isBookmarked, {super.bookmarks, super.pageBookmarks});

  @override
  List<Object> get props => [isBookmarked, ...super.props];
}

class BookmarkError extends BookmarkState {
  final String error;

  const BookmarkError(this.error, {super.bookmarks, super.pageBookmarks});

  @override
  List<Object> get props => [error, ...super.props];
}

/// for pages
class PageBookmarkSaved extends BookmarkState {
  const PageBookmarkSaved({super.bookmarks, super.pageBookmarks});
}

class PageBookmarkRemoved extends BookmarkState {
  const PageBookmarkRemoved({super.bookmarks, super.pageBookmarks});
}

class PageBookmarkLoaded extends BookmarkState {
  final int? pageNumber;

  const PageBookmarkLoaded(this.pageNumber, {super.bookmarks, super.pageBookmarks});

  @override
  List<Object> get props => [pageNumber ?? 0, ...super.props];
}
