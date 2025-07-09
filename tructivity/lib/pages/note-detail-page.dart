import 'dart:io' as io;
import 'dart:convert';
import 'dart:math';
import 'package:tructivity/constants.dart';
import 'package:tructivity/db/database-helper.dart';
import 'package:tructivity/models/note-model.dart';
import 'package:tructivity/pages/handwriting-page.dart';
import 'package:tructivity/widgets/color-pick-field.dart';
import 'package:tructivity/dialogs/confirmation-dialog.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:open_file/open_file.dart';
// import 'package:google_ml_kit/google_ml_kit.dart';

class NoteDetailPage extends StatefulWidget {
  final NoteModel noteData;

  NoteDetailPage({required this.noteData});

  @override
  _NoteDetailPageState createState() => _NoteDetailPageState(this.noteData);
}

class _NoteDetailPageState extends State<NoteDetailPage> {
  final String table = 'note';
  late final quill.QuillController _controller;
  final _db = DatabaseHelper.instance;
  TextEditingController _titleController = TextEditingController();
  NoteModel noteData;
  int cursorPosition = 0;

  _NoteDetailPageState(this.noteData);

  @override
  void initState() {
    super.initState();
    setInitialEditorText();
    listenToEditorChanges();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _titleController.text = noteData.title;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_outlined),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        actions: [
          // IconButton(
          //   onPressed: () async {
          //     await showAttachmentOptions();
          //   },
          //   padding: EdgeInsets.only(right: 10),
          //   icon: Icon(
          //     Icons.attach_file_outlined,
          //   ),
          // ),
          IconButton(
            padding: EdgeInsets.only(right: 10),
            onPressed: showColorPicker,
            icon: Icon(
              Icons.color_lens_outlined,
              color: noteData.color,
            ),
          ),

          IconButton(
            onPressed: deleteNote,
            icon: Icon(
              Icons.delete_outlined,
            ),
          ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            SizedBox(height: 10),
            TextFormField(
              cursorColor: Colors.teal,
              textCapitalization: TextCapitalization.sentences,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
              decoration: InputDecoration.collapsed(
                hintText: 'Title',
                hintStyle: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
              controller: _titleController,
              onChanged: (String val) async {
                noteData.title = val;
                await autoSave();
              },
            ),
            SizedBox(height: 30),
            Expanded(
              flex: 15,
              child: quill.QuillEditor(
                controller: _controller,
                scrollController: ScrollController(),
                scrollable: true,
                focusNode: FocusNode(),
                autoFocus: true,
                readOnly: false,
                paintCursorAboveText: true,
                expands: false,
                padding: EdgeInsets.zero,
                ///ff_log embedBuilder commented, removed in updated package
                // embedBuilder:
                //     (BuildContext context, quill.Embed node, bool readOnly) {
                //   String type = node.value.type;
                //   String url = node.value.data;
                //   if (type == 'image') {
                //     return imageBuilder(url);
                //   } else {
                //     List<String> data = url.split('/');
                //     String fileName = data.last;
                //     return fileBuilder(fileName, url);
                //   }
                // },
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 5),
              child: quill.QuillToolbar.basic(
                multiRowsDisplay: false,
                locale: Locale('en'),
                ///ff_log showImageButton showVideoButton, removed in updated package
                // showImageButton: false,
                // showVideoButton: false,
                showLink: false,
                controller: _controller,
                toolbarIconSize: 25,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void changeColor(Color newColor) {
    setState(() {
      noteData.color = newColor;
    });
  }

  void showColorPicker() async {
    await showDialog(
      context: context,
      builder: (_) => ColorPickerDialog(initialColor: noteData.color),
    ).then((newColor) async {
      if (newColor != null) {
        changeColor(newColor);
        await autoSave();
      }
    });
  }

  void deleteNote() async {
    if (noteData.id != null) {
      await showDialog(
        context: context,
        builder: (_) => ConfirmationDialog(text: confirmationText + ' note?'),
      ).then((delete) async {
        if (delete != null) {
          if (delete) {
            await _db.remove(table: table, id: noteData.id!);
            Navigator.pop(context);
          }
        }
      });
    } else {
      Navigator.pop(context);
    }
  }

  Future<void> autoSave() async {
    noteData.pickedDateTime = DateTime.now();
    if (noteData.id == null) {
      noteData.id = await _db.add(table: table, model: noteData);
    } else {
      await _db.update(table: table, model: noteData);
    }
  }

  Future<void> pickFile(List<String>? allowedExtensions, String type) async {
    FileType fileType = FileType.any;
    if (type == 'image') {
      fileType = FileType.custom;
    }
    final FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: fileType,
      allowedExtensions: allowedExtensions,
    );
    if (result != null) {
      List paths = result.paths;
      var url = paths[0];
      if (allowedExtensions != null) {
        //for images
        String extension = url.split('.').last;
        if (allowedExtensions.contains(extension)) {
          await insertMedia(url, type);
        }
      } else {
        //for files
        await insertMedia(url, type);
      }
      Navigator.pop(context);
      setState(() {});
    }
  }

  Future<void> insertMedia(String url, String type) async {
    int baseOffset = _controller.selection.baseOffset;
    _controller.document.insert(baseOffset, '\n\n');
    await Future.delayed(Duration(milliseconds: 400));
    _controller.document.insert(baseOffset + 2, quill.Embeddable(type, url));
    await Future.delayed(Duration(milliseconds: 400));
    _controller.document.insert(baseOffset + 3, '\n\n');
  }

  void setInitialEditorText() {
    quill.Document doc =
        quill.Document.fromJson(jsonDecode(noteData.description));

    cursorPosition = doc.toPlainText().length - 1;
    _controller = quill.QuillController(
      document: doc,
      selection: TextSelection.collapsed(offset: cursorPosition),
    );
  }

  void listenToEditorChanges() async {
    _controller.changes.listen((event) async {
      String data =
          jsonEncode(_controller.document.toDelta().toJson()).toString();
      noteData.description = data;
      await autoSave();
    });
  }

  Future<void> openEmbeddedFile(String url) async {
    var result = await OpenFile.open(url);
    if (result.type != ResultType.done) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          duration: Duration(seconds: 2),
          content: Text(
              'File could not be opened because the app cache was cleared')));
    }
  }

  Future<void> showAttachmentOptions() async {
    await showModalBottomSheet(
        context: context,
        builder: (cont) {
          return Container(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 15, bottom: 15, left: 15),
                  child: Text(
                    'Attach',
                    style: TextStyle(fontWeight: FontWeight.w400),
                  ),
                ),
                ListTile(
                    leading: Icon(Icons.image_outlined),
                    title: Text('Photo'),
                    onTap: () async {
                      await pickFile(allowedImageExtensions, 'image');
                    }),
                ListTile(
                  leading: Icon(Icons.description_outlined),
                  title: Text('File'),
                  onTap: () async {
                    await pickFile(null, 'video');
                  },
                )
              ],
            ),
          );
        });
  }

  GestureDetector imageBuilder(String url) {
    return GestureDetector(
      child: Image.file(io.File(url), key: ValueKey(new Random().nextInt(1000)),
          errorBuilder: (context, object, stackTrace) {
        return Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(7),
              border: Border.all(color: Theme.of(context).cardColor)),
          child: ListTile(
            leading: Icon(Icons.error_outline_rounded),
            title: Text(
              'Image could not be loaded because the app cache was cleared',
            ),
          ),
        );
      }),
      onTap: () async {
        bool imgExists = await io.File(url).exists();
        if (imgExists) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => HandwritingPage(url: url)));
        }
      },
    );
  }

  GestureDetector fileBuilder(String fileName, String url) {
    return GestureDetector(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(7),
          color: Theme.of(context).cardColor,
        ),
        child: ListTile(
          contentPadding: EdgeInsets.all(10),
          leading: Icon(Icons.description_outlined),
          title: Text(
            '$fileName',
          ),
        ),
      ),
      onTap: () async {
        await openEmbeddedFile(url);
      },
    );
  }
}
