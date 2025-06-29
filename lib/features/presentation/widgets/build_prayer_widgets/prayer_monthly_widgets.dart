import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../../core/utils/consts/app_consts.dart';
import '../../../data/models/adhan/azan_by_month_model.dart';

class PrayerDataSource extends DataGridSource {
  PrayerDataSource({List<PrayerDay>? prayerData}) {
    _prayerData = prayerData ?? [];
    _buildDataGridRows();
  }

  List<PrayerDay> _prayerData = [];
  List<DataGridRow> _dataGridRows = [];

  void updateData(List<PrayerDay> prayerData) {
    _prayerData = prayerData;
    _buildDataGridRows();
    notifyListeners();
  }

  void _buildDataGridRows() {
    _dataGridRows = _prayerData.map<DataGridRow>((e) {
      return DataGridRow(cells: [
        DataGridCell<String>(columnName: 'day', value: e.day),
        DataGridCell<String>(columnName: 'date', value: e.date),
        DataGridCell<String>(columnName: 'fajr', value: e.fajr),
        DataGridCell<String>(columnName: 'dhuhr', value: e.dhuhr),
        DataGridCell<String>(columnName: 'asr', value: e.asr),
        DataGridCell<String>(columnName: 'maghrib', value: e.maghrib),
        DataGridCell<String>(columnName: 'isha', value: e.isha),
      ]);
    }).toList();
  }

  bool _isToday(String dateStr) {
    final cleaned =
        dateStr.replaceAll('\u200f', '').replaceAll('\u202a', '').replaceAll('\u202c', '').replaceAll('\n', '').trim();

    debugPrint("🔍 Original: '$dateStr' | Cleaned: '$cleaned'");

    for (final format in ['dd-MM-yyyy', 'MM-dd-yyyy', 'yyyy-MM-dd']) {
      try {
        final date = DateFormat(format, 'en').parseStrict(cleaned);
        final now = DateTime.now();
        return date.day == now.day && date.month == now.month && date.year == now.year;
      } catch (e) {
        debugPrint("❌ Failed with $format: $e");
      }
    }
    return false;
  }

  @override
  List<DataGridRow> get rows => _dataGridRows;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    final int rowIndex = _dataGridRows.indexOf(row);
    final PrayerDay prayerDay = _prayerData[rowIndex];

    return DataGridRowAdapter(
      cells: row.getCells().map<Widget>((e) {
        return Container(
          alignment: Alignment.center,
          color: _isToday(prayerDay.date) ? Colors.red.withValues(alpha: 0.6) : Colors.transparent,
          padding: EdgeInsets.all(4.sp),
          child: Text(
            e.value.toString(),
            style: const TextStyle(
              fontFamily: AppConsts.tajawal,
              fontWeight: FontWeight.bold,
            ),
          ),
        );
      }).toList(growable: false),
    );
  }

  int get rowCount => _prayerData.length;
}

Widget buildTable({required DataGridController controller, required PrayerDataSource source}) => SfDataGridTheme(
      data: SfDataGridThemeData(
        headerColor: AppConsts.skyBlueDarkColor.withValues(alpha: 0.5),
        frozenPaneLineColor: Colors.transparent,
      ),
      child: SfDataGrid(
        controller: controller,
        source: source,
        columns: [
          GridColumn(
            columnName: 'day',
            label: Container(
              padding: const EdgeInsets.all(8.0),
              alignment: Alignment.center,
              child: const Text(
                'اليوم',
                style:
                    TextStyle(fontFamily: AppConsts.tajawal, color: CupertinoColors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          GridColumn(
            columnName: 'date',
            label: Container(
              padding: const EdgeInsets.all(8.0),
              alignment: Alignment.center,
              child: const Text(
                'التاريخ',
                style:
                    TextStyle(fontFamily: AppConsts.tajawal, color: CupertinoColors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          GridColumn(
            columnName: 'fajr',
            label: Container(
              padding: const EdgeInsets.all(8.0),
              alignment: Alignment.center,
              child: const Text(
                'الفجر',
                style:
                    TextStyle(fontFamily: AppConsts.tajawal, color: CupertinoColors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          GridColumn(
            columnName: 'dhuhr',
            label: Container(
              padding: const EdgeInsets.all(8.0),
              alignment: Alignment.center,
              child: const Text(
                'الظهر',
                style:
                    TextStyle(fontFamily: AppConsts.tajawal, color: CupertinoColors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          GridColumn(
            columnName: 'asr',
            label: Container(
              padding: const EdgeInsets.all(8.0),
              alignment: Alignment.center,
              child: const Text(
                'العصر',
                style:
                    TextStyle(fontFamily: AppConsts.tajawal, color: CupertinoColors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          GridColumn(
            columnName: 'maghrib',
            label: Container(
              padding: const EdgeInsets.all(8.0),
              alignment: Alignment.center,
              child: const Text(
                'المغرب',
                style:
                    TextStyle(fontFamily: AppConsts.tajawal, color: CupertinoColors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          GridColumn(
            columnName: 'isha',
            label: Container(
              padding: const EdgeInsets.all(8.0),
              alignment: Alignment.center,
              child: const Text(
                'العشاء',
                style:
                    TextStyle(fontFamily: AppConsts.tajawal, color: CupertinoColors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
        frozenColumnsCount: 2,
        selectionMode: SelectionMode.multiple,
        columnWidthMode: ColumnWidthMode.fitByCellValue,
      ),
    );

Widget buildPaging({required PrayerDataSource source}) => Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: SfDataPagerTheme(
        data: SfDataPagerThemeData(
          backgroundColor: AppConsts.skyBlueDarkColor.withValues(alpha: 0.5),
          selectedItemColor: AppConsts.basicAppColor.withValues(alpha: 0.7),
          itemTextStyle: const TextStyle(fontWeight: FontWeight.bold),
          selectedItemTextStyle: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        child: SfDataPager(
          delegate: source,
          direction: Axis.horizontal,
          availableRowsPerPage: const [10],
          pageCount: 3,
        ),
      ),
    );
