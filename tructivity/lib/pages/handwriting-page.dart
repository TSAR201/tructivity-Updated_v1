import 'dart:io';
import 'dart:typed_data';
import 'package:tructivity/widgets/color-pick-field.dart';
import 'package:draw_your_image/draw_your_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:math';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'dart:io' as io;

class HandwritingPage extends StatefulWidget {
  final String? url;
  HandwritingPage({this.url});
  @override
  State<HandwritingPage> createState() => _HandwritingPageState();
}

class _HandwritingPageState extends State<HandwritingPage> {
  Color _currentColor = Color(0xff26a69a);
  double _currentWidth = 4.0;
  final DrawController _controller = DrawController();
  ScreenshotController _screenshotController = ScreenshotController();
  bool _eraserEnabled = false;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Handwritten Note',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w500,
          ),
        ),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_outlined),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        actions: [
          IconButton(
              onPressed: () async {
                Uint8List? image = await _screenshotController.capture();
                if (image != null) {
                  await saveImage(image);
                }
              },
              icon: Icon(Icons.save_outlined))
        ],
      ),
      body: SizedBox(
        height: double.infinity,
        width: double.infinity,
        child: Column(
          children: [
            Expanded(
              child: Screenshot(
                controller: _screenshotController,
                child: Stack(
                  children: [
                    getBackground(),
                    Draw(
                      backgroundColor: Colors.transparent,
                      strokeColor: _currentColor,
                      strokeWidth: _currentWidth,
                      controller: _controller,
                      isErasing: _eraserEnabled,
                    ),
                  ],
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 5),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      IconButton(
                        onPressed: showColorPicker,
                        icon: Icon(
                          Icons.brush_outlined,
                          color: _currentColor,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            _eraserEnabled = !_eraserEnabled;
                          });
                        },
                        icon: Icon(
                          FontAwesomeIcons.eraser,
                          color: _eraserEnabled ? _currentColor : null,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          _controller.undo();
                        },
                        icon: Icon(
                          Icons.undo_outlined,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          _controller.redo();
                        },
                        icon: Icon(
                          Icons.redo_outlined,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          _controller.clear();
                        },
                        icon: Icon(
                          Icons.delete_outline_outlined,
                        ),
                      ),
                    ],
                  ),
                  Slider(
                    activeColor: _currentColor,
                    inactiveColor: _currentColor.withOpacity(0.2),
                    max: 40,
                    min: 1,
                    value: _currentWidth,
                    onChanged: (value) {
                      setState(() {
                        _currentWidth = value;
                      });
                    },
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void showColorPicker() async {
    await showDialog(
      context: context,
      builder: (_) => ColorPickerDialog(initialColor: _currentColor),
    ).then((newColor) async {
      if (newColor != null) {
        _currentColor = newColor;
      }
      if (_eraserEnabled) {
        _eraserEnabled = false;
      }
      setState(() {});
    });
  }

  Future<void> saveImage(Uint8List _imageData) async {
    if (widget.url == null) {
      final Directory _directory = await getTemporaryDirectory();
      final int fileName = Random().nextInt(999999999);
      String _imgPath = _directory.path + '/$fileName.png';
      final File imgFile = new File(_imgPath);
      await imgFile.writeAsBytes(_imageData);
      Navigator.pop(context, _imgPath);
    } else {
      final File imgFile = File(widget.url!);
      await imgFile.writeAsBytes(_imageData);
      imageCache!.clearLiveImages();
      imageCache!.clear();
      Navigator.pop(context);
    }
  }

  Widget getBackground() {
    if (widget.url != null) {
      return Container(
        child: Image.file(io.File(widget.url!)),
      );
    }
    return Container(
      color: Colors.grey[200],
    );
  }
}
