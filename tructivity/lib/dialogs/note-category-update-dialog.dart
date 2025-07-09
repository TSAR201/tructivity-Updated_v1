import 'package:tructivity/constants.dart';
import 'package:tructivity/db/database-helper.dart';
import 'package:tructivity/dialogs/confirmation-dialog.dart';
import 'package:tructivity/models/note-category-model.dart';
import 'package:tructivity/widgets/buttons.dart';
import 'package:tructivity/widgets/custom-textfield.dart';
import 'package:flutter/material.dart';

class NoteCategoryUpdateDialog extends StatelessWidget {
  NoteCategoryUpdateDialog(
      {required this.categoryTable,
      required this.dataTable,
      required this.categoryData});
  final String categoryTable;
  final String dataTable;
  final NoteCategoryModel categoryData;
  final DatabaseHelper _db = DatabaseHelper.instance;
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomTextField(
              initialText: categoryData.category,
              validate: true,
              labelText: 'Category Name',
              fieldIcon: Icons.category_outlined,
              onChangedCallback: (val) {
                categoryData.category = val;
              },
              capitalizaton: TextCapitalization.words,
            ),
            CustomTextField(
              initialText: categoryData.description,
              validate: true,
              labelText: 'Description',
              fieldIcon: Icons.description_outlined,
              onChangedCallback: (val) {
                categoryData.description = val;
              },
              capitalizaton: TextCapitalization.words,
            ),
          ],
        ),
      ),
      actions: [
        DeleteButton(
          onTapDelete: () async {
            await showDialog(
              context: context,
              builder: (_) =>
                  ConfirmationDialog(text: confirmationText + ' category?'),
            ).then((confirmed) async {
              if (confirmed != null) {
                if (confirmed) {
                  await _db.removeDataByCategory(
                      table: dataTable, category: categoryData.category);
                  await _db.remove(table: categoryTable, id: categoryData.id!);
                  Navigator.pop(context);
                }
              }
            });
          },
        ),
        SaveButton(
          onTapSave: () async {
            if (_formKey.currentState!.validate()) {
              await _db.update(table: categoryTable, model: categoryData);
              Navigator.pop(context);
            }
          },
        ),
      ],
    );
  }
}
