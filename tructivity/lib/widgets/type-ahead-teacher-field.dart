import 'package:tructivity/db/database-helper.dart';
import 'package:tructivity/models/teacher-model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class TypeAheadTeacherField extends StatefulWidget {
  final labelText;
  final fieldIcon;
  final capitalizaton;
  final Function(String) onChanged;
  final String initialText;
  final bool validate;

  TypeAheadTeacherField({
    required this.labelText,
    required this.fieldIcon,
    required this.onChanged,
    required this.capitalizaton,
    required this.initialText,
    required this.validate,
    Key? key,
  }) : super(key: key);

  @override
  State<TypeAheadTeacherField> createState() => TypeAheadTeacherFieldState();
}

class TypeAheadTeacherFieldState extends State<TypeAheadTeacherField> {
  final TextEditingController controller = TextEditingController();
  final _db = DatabaseHelper.instance;
  List<String> _options = [];
  List<TeacherModel> _teachers = [];
  @override
  void initState() {
    super.initState();
    controller.text = widget.initialText;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border(bottom: BorderSide(width: 1, color: Colors.black12))),
      child: Container(
        width: 800,
        child: FutureBuilder(
            future: _db.getTeacherData(),
            builder: (BuildContext context,
                AsyncSnapshot<List<TeacherModel>> snapshot) {
              if (!snapshot.hasData) {
                return Text('...');
              } else {
                _teachers = snapshot.data!;
                _options = getOptions();
                return TypeAheadFormField(
                  validator: !widget.validate
                      ? null
                      : (val) {
                          if (val == '') {
                            return 'Required Field';
                          }
                          return null;
                        },
                  suggestionsCallback: (pattern) => _options.where((element) =>
                      element.toLowerCase().contains(pattern.toLowerCase())),
                  itemBuilder: (BuildContext cont, String item) => ListTile(
                    title: Text(item),
                  ),
                  onSuggestionSelected: (String item) {
                    this.controller.text = item;
                    widget.onChanged(item);
                  },
                  hideOnEmpty: true,
                  hideSuggestionsOnKeyboardHide: true,
                  hideOnLoading: true,
                  getImmediateSuggestions: true,
                  textFieldConfiguration: TextFieldConfiguration(
                    textCapitalization: widget.capitalizaton,
                    onChanged: (String item) {
                      widget.onChanged(item);
                    },
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      labelText: widget.labelText,
                      prefixIcon: Icon(widget.fieldIcon),
                    ),
                    controller: this.controller,
                  ),
                );
              }
            }),
      ),
    );
  }

  List<String> getOptions() {
    List<String> l = [];
    for (TeacherModel item in _teachers) {
      l.add(item.name);
    }
    return l;
  }
}
