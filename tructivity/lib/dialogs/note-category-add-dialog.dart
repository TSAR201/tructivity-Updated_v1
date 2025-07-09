import 'package:tructivity/db/database-helper.dart';
import 'package:tructivity/models/note-category-model.dart';
import 'package:tructivity/widgets/buttons.dart';
import 'package:tructivity/widgets/custom-textfield.dart';
import 'package:tructivity/widgets/error-dialog.dart';
import 'package:flutter/material.dart';

class NoteCategoryAddDialog extends StatelessWidget {
  final String table = 'noteCategory';
  final DatabaseHelper _db = DatabaseHelper.instance;
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    String categoryInput = '';
    String descriptionInput = '';
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
              labelText: 'Category Name',
              fieldIcon: Icons.category_outlined,
              onChangedCallback: (val) {
                categoryInput = val;
              },
              capitalizaton: TextCapitalization.words,
            ),
            CustomTextField(
              initialText: '',
              validate: false,
              labelText: 'Description',
              fieldIcon: Icons.description_outlined,
              onChangedCallback: (val) {
                descriptionInput = val;
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
              if (!categoryExists) {
                await _db.add(
                    table: table,
                    model: NoteCategoryModel(
                      category: categoryInput,
                      description: descriptionInput,
                    ));
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
