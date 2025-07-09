import 'package:tructivity/models/absence-model.dart';
import 'package:tructivity/widgets/filler-widget.dart';
import 'package:flutter/material.dart';

class AbsenceDetail extends StatelessWidget {
  final List<AbsenceModel> absenceData;
  final String category;
  const AbsenceDetail({required this.absenceData, required this.category});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_outlined),
          onPressed: () => Navigator.of(context).pop(),
        ),
        centerTitle: true,
        title: Text(
          category,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: absenceData.isEmpty
          ? FillerWidget(icon: Icons.person_add_disabled_outlined)
          : Container(
              width: double.infinity,
              child: SingleChildScrollView(
                child: DataTable(
                  horizontalMargin: 20,
                  headingTextStyle: TextStyle(
                    color: Theme.of(context).textTheme.bodyText1!.color!,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                  columns: generateColumns(),
                  rows: generateRows(),
                ),
              ),
            ),
    );
  }

  List<DataRow> generateRows() {
    List<DataRow> rows = [];
    Map<String, int> data = getMapData();
    for (MapEntry<String, int> item in data.entries) {
      DataRow row = DataRow(cells: [
        DataCell(Text(item.key)),
        DataCell(Text(item.value.toString())),
      ]);
      rows.add(row);
    }
    return rows;
  }

  List<DataColumn> generateColumns() {
    return [
      DataColumn(
        label: Text(
          'Subject',
        ),
      ),
      DataColumn(
        label: Text(
          'Absences',
        ),
      )
    ];
  }

  Map<String, int> getMapData() {
    Map<String, int> data = {};
    for (AbsenceModel item in absenceData) {
      String subject = item.subject;
      if (data[subject] == null) {
        data[subject] = 1;
      } else {
        data[subject] = data[subject]! + 1;
      }
    }
    return data;
  }
}
