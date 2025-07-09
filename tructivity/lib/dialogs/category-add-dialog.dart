import 'package:tructivity/db/database-helper.dart';
import 'package:tructivity/models/category-model.dart';
import 'package:tructivity/widgets/buttons.dart';
import 'package:tructivity/widgets/custom-textfield.dart';
import 'package:tructivity/widgets/error-dialog.dart';
import 'package:flutter/material.dart';

class CategoryAddDialog extends StatelessWidget {
  CategoryAddDialog({required this.table, this.label});
  final String? label;
  final String table;
  final DatabaseHelper _db = DatabaseHelper.instance;
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    String categoryInput = '';
    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomTextField(
              initialText: '',
              validate: true,
              labelText: label != null ? label : 'Category Name',
              fieldIcon: Icons.category_outlined,
              onChangedCallback: (val) {
                categoryInput = val;
              },
              capitalizaton: TextCapitalization.words,
            ),
          ],
        ),
      ),
      actions: [
        DeleteButton(
          onTapDelete: () {
            Navigator.pop(context);
          },
        ),
        SaveButton(
          onTapSave: () async {
            if (_formKey.currentState!.validate()) {
              bool categoryExists =
                  await _db.categoryExists(table, categoryInput);
              if (categoryInput == 'All') {
                categoryExists = true;
              }
              if (!categoryExists) {
                await _db.add(
                    table: table,
                    model: CategoryModel(category: categoryInput));
                Navigator.pop(context);
              } else {
                await showDialog(
                    context: context,
                    builder: (context) =>
                        ErrorDialog(error: 'Category Already Exists'));
              }
            }
          },
        ),
      ],
    );
  }
}
