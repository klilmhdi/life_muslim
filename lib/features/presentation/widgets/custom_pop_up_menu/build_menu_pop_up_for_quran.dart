import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class QuranJuzMenuOptionsWidget extends StatelessWidget {
  final VoidCallback saveCurrentPage;
  final VoidCallback removeCurrentPageBookmark;
  final bool isCurrentPageBookmarked;

  const QuranJuzMenuOptionsWidget({
    super.key,
    required this.saveCurrentPage,
    required this.removeCurrentPageBookmark,
    required this.isCurrentPageBookmarked,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<int>(
      icon: const Icon(Icons.more_vert),
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 1,
          onTap: isCurrentPageBookmarked ? removeCurrentPageBookmark : saveCurrentPage,
          child: Row(
            children: [
              Icon(isCurrentPageBookmarked ? Icons.bookmark_remove : Icons.bookmark_add),
              const SizedBox(width: 8),
              Text(
                isCurrentPageBookmarked
                    ? 'إزالة العلامة المرجعية للصفحة الحالية'
                    : 'حفظ الصفحة الحالية',
                style: TextStyle(fontSize: 14.sp),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class QuranAyahsMenuOptionsWidget extends StatelessWidget {
  final VoidCallback saveCurrentPage;
  final VoidCallback removeCurrentPageBookmark;
  final bool isBookView;

  const QuranAyahsMenuOptionsWidget({
    super.key,
    required this.saveCurrentPage,
    required this.removeCurrentPageBookmark,
    required this.isBookView,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<int>(
      icon: const Icon(Icons.more_vert),
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 1,
          onTap: isBookView ? removeCurrentPageBookmark : saveCurrentPage,
          child: Row(
            children: [
              Icon(isBookView ? Icons.menu_book_rounded : Icons.table_rows_rounded),
              const SizedBox(width: 8),
              Text(
                isBookView ? 'تبديل عرض الآيات كص' : 'حفظ الصفحة الحالية',
                style: TextStyle(fontSize: 14.sp),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
