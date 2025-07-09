// import 'package:tructivity/db/database-helper.dart';
// import 'package:tructivity/models/category-model.dart';
// import 'package:flutter/material.dart';

// class CategoryPicker extends StatefulWidget {
//   final Function(String) onCategoryChanged;
//   final String initialCategory, table;
//   CategoryPicker({
//     required this.onCategoryChanged,
//     required this.initialCategory,
//     required this.table,
//   });

//   @override
//   _CategoryPickerState createState() =>
//       _CategoryPickerState(initialCategory, table);
// }

// class _CategoryPickerState extends State<CategoryPicker> {
//   _CategoryPickerState(this.selectedCategory, this._table);
//   String selectedCategory;
//   String _table;
//   final _db = DatabaseHelper.instance;
//   List<String> categories = [];
//   @override
//   void initState() {
//     super.initState();
//     getCategoryData();
//   }

//   void getCategoryData() async {
//     List<CategoryModel> categoryData = await _db.getCategoryData(_table);
//     categories = [];
//     for (CategoryModel item in categoryData) {
//       categories.add(item.category);
//     }
//     setState(() {});
//   }

//   @override
//   Widget build(BuildContext context) {
//     return categories.length == 0
//         ? Container()
//         : Container(
//             decoration: BoxDecoration(
//                 border: Border(
//                     bottom: BorderSide(width: 1, color: Colors.black12))),
//             padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
//             height: 60,
//             width: 600,
//             child: ListView.builder(
//               scrollDirection: Axis.horizontal,
//               itemCount: categories.length,
//               itemBuilder: (context, index) {
//                 return GestureDetector(
//                   child: Container(
//                     margin: EdgeInsets.only(right: 10),
//                     padding: EdgeInsets.symmetric(horizontal: 15),
//                     decoration: BoxDecoration(
//                       color: categories[index] == selectedCategory
//                           ? Theme.of(context).cardColor
//                           : Colors.transparent,
//                       borderRadius: BorderRadius.circular(15),
//                       border: Border.all(
//                         color: Colors.black,
//                       ),
//                     ),
//                     child: Center(child: Text(categories[index])),
//                   ),
//                   onTap: () {
//                     if (selectedCategory == categories[index]) {
//                       selectedCategory = '';
//                     } else {
//                       selectedCategory = categories[index];
//                     }
//                     widget.onCategoryChanged(selectedCategory);
//                     setState(() {});
//                   },
//                   //on long press remove selected category
//                   onLongPress: () {
//                     widget.onCategoryChanged('');
//                     setState(() {
//                       selectedCategory = '';
//                     });
//                   },
//                 );
//               },
//             ),
//           );
//   }
// }

import 'package:tructivity/db/database-helper.dart';
import 'package:tructivity/models/category-model.dart';
import 'package:tructivity/widgets/dropdown-list.dart';
import 'package:flutter/material.dart';

class CategoryPicker extends StatefulWidget {
  final Function(String) onCategoryChanged;
  final String initialCategory, table;
  CategoryPicker({
    required this.onCategoryChanged,
    required this.initialCategory,
    required this.table,
  });

  @override
  _CategoryPickerState createState() =>
      _CategoryPickerState(initialCategory, table);
}

class _CategoryPickerState extends State<CategoryPicker> {
  _CategoryPickerState(this.initialCategory, this._table);
  final String _table;
  String initialCategory;
  final _db = DatabaseHelper.instance;
  List<String> categories = [];
  @override
  void initState() {
    super.initState();
    getCategoryData();
  }

  void getCategoryData() async {
    List<CategoryModel> categoryData = await _db.getCategoryData(_table);
    categories = ['All'];
    if (initialCategory == '') {
      initialCategory = 'All';
    }
    for (CategoryModel item in categoryData) {
      categories.add(item.category);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return categories.length == 0
        ? Container()
        : DropdownList(
            label: 'Category',
            onChanged: (String val) {
              widget.onCategoryChanged(val);
            },
            options: categories,
            icon: Icons.category_outlined,
            initialSelection: initialCategory,
          );
  }
}
