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
                return TypeAheadField<String>(
                  suggestionsCallback: (pattern) => _options
                      .where((element) =>
                          element.toLowerCase().contains(pattern.toLowerCase()))
                      .toList(),
                  itemBuilder: (BuildContext context, String item) => ListTile(
                    title: Text(item),
                  ),
                  onSelected: (String item) {
                    this.controller.text = item;
                    widget.onChanged(item);
                  },
                  hideOnEmpty: true,
                  hideWithKeyboard: true,
                  debounceDuration: Duration.zero, // For immediate suggestions
                  builder: (context, controller, focusNode) {
                    return TextField(
                      controller: controller,
                      focusNode: focusNode,
                      textCapitalization: widget.capitalizaton,
                      onChanged: widget.onChanged,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        labelText: widget.labelText,
                        prefixIcon: Icon(widget.fieldIcon),
                        errorText: widget.validate && controller.text.isEmpty
                            ? 'Required Field'
                            : null,
                      ),
                    );
                  },
                );
              }
            }),
      ),
    );
  }

  List<String> getOptions() {
    return _teachers.map((item) => item.name).toList();
  }
}
