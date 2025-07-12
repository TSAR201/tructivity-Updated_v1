import 'package:tructivity/db/database-helper.dart';
import 'package:tructivity/models/course-model.dart';
import 'package:tructivity/models/subject-model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class TypeAheadSubjectField extends StatefulWidget {
  final labelText;
  final fieldIcon;
  final capitalizaton;
  final Function(String) onChanged;
  final Function(CourseModel) onSuggestionSelected;
  final String initialText;
  final String? category;
  final bool validate;

  TypeAheadSubjectField({
    required this.labelText,
    required this.fieldIcon,
    required this.onChanged,
    required this.onSuggestionSelected,
    required this.capitalizaton,
    required this.initialText,
    required this.validate,
    this.category,
  });

  @override
  State<TypeAheadSubjectField> createState() => _TypeAheadSubjectFieldState();
}

class _TypeAheadSubjectFieldState extends State<TypeAheadSubjectField> {
  final TextEditingController _controller = TextEditingController();
  final _db = DatabaseHelper.instance;
  List<String> _options = [];
  List<SubjectModel> _subjects = [];

  @override
  void initState() {
    super.initState();
    _controller.text = widget.initialText;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border(bottom: BorderSide(width: 1, color: Colors.black12))),
      child: Container(
        width: 800,
        child: FutureBuilder(
            future: widget.category == null
                ? _db.getSubjectData()
                : _db.getSubjectsByCategory(widget.category!),
            builder: (BuildContext context,
                AsyncSnapshot<List<SubjectModel>> snapshot) {
              if (!snapshot.hasData) {
                return Text('...');
              } else {
                _subjects = snapshot.data!;
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
                    this._controller.text = item;
                    int index = _options.indexOf(item);
                    CourseModel course = getModel(index);
                    widget.onSuggestionSelected(course);
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
    return _subjects.map((item) => item.subject).toList();
  }

  CourseModel getModel(int index) {
    SubjectModel subj = _subjects[index];
    return CourseModel(
        room: subj.room, subject: subj.subject, teacher: subj.teacher);
  }
}
