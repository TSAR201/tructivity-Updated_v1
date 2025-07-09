import 'package:tructivity/db/database-helper.dart';
import 'package:tructivity/dialogs/category-add-dialog.dart';
import 'package:tructivity/models/category-model.dart';
import 'package:tructivity/dialogs/confirmation-dialog.dart';
import 'package:flutter/material.dart';
import 'package:tructivity/widgets/loading-widget.dart';

class CategoryPage extends StatefulWidget {
  final String dataTable, categoryTable;
  CategoryPage({required this.categoryTable, required this.dataTable});
  @override
  _CategoryPageState createState() =>
      _CategoryPageState(categoryTable, dataTable);
}

class _CategoryPageState extends State<CategoryPage> {
  _CategoryPageState(this._categoryTable, this._dataTable);
  final _db = DatabaseHelper.instance;
  final String _categoryTable, _dataTable;
  List<CategoryModel> categoryData = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_outlined),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text(
          'Manage Categories',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w500,
          ),
        ),
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: addTaskCategory, icon: Icon(Icons.add_outlined)),
        ],
      ),
      body: FutureBuilder(
        future: _db.getCategoryData(_categoryTable),
        builder: (BuildContext context,
            AsyncSnapshot<List<CategoryModel>> snapshot) {
          if (!snapshot.hasData) {
            return LoadingWidget();
          } else {
            categoryData = snapshot.data!;
            return ListView.builder(
                itemCount: categoryData.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                        border:
                            Border(bottom: BorderSide(color: Colors.black12))),
                    child: ListTile(
                      title: Text(categoryData[index].category),
                      trailing: IconButton(
                        icon: Icon(Icons.delete_outline_outlined),
                        onPressed: () => onPressDelete(index),
                      ),
                    ),
                  );
                });
          }
        },
      ),
    );
  }

  void addTaskCategory() async {
    await showDialog(
      context: context,
      builder: (_) => CategoryAddDialog(table: _categoryTable),
    ).whenComplete(() {
      setState(() {});
    });
  }

  void onPressDelete(int index) async {
    await showDialog(
            context: context,
            builder: (_) => ConfirmationDialog(
                text:
                    'Deleting this category would also delete all of its tasks'))
        .then((confirmed) async {
      if (confirmed != null) {
        if (confirmed) {
          deleteData(index);
        }
      }
    });
  }

  void deleteData(int index) async {
    await _db.remove(table: _categoryTable, id: categoryData[index].id!);

    await _db.removeDataByCategory(
        category: categoryData[index].category, table: _dataTable);
    setState(() {});
  }
}
