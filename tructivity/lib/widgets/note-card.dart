import 'dart:convert';

import 'package:tructivity/models/note-model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import '../constants.dart';

class NoteCard extends StatelessWidget {
  final NoteModel note;
  NoteCard({
    required this.note,
  });
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        Container(
          margin: EdgeInsets.all(10),
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
              color: note.color,
              border: Border.all(width: 1, color: Colors.black12),
              borderRadius: BorderRadius.circular(25)),
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 5),
                      child: Text(
                        note.title,
                        maxLines: 1,
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          overflow: TextOverflow.ellipsis,
                          color: noteTextColor,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  // Text(
                  //   getPriorityText(priority: note.priority),
                  //   style: TextStyle(
                  //     color: noteTextColor,
                  //     fontWeight: FontWeight.w500,
                  //   ),
                  // ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    child: Text(
                      quill.Document.fromJson(jsonDecode(note.description))
                          .toPlainText(),
                      maxLines: 2,
                      style: TextStyle(
                          overflow: TextOverflow.ellipsis,
                          color: noteTextColor),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(20),
          child: Text(
            DateFormat("h:mma").format(note.pickedDateTime),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: noteTextColor,
            ),
          ),
        ),
      ],
    );
  }
}
