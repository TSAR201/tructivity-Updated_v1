import 'package:flutter/material.dart';
import 'package:tructivity/constants.dart';
import 'package:tructivity/functions.dart';

class GradingSystemDialog extends StatefulWidget {
  @override
  _GradingSystemDialogState createState() => _GradingSystemDialogState();
}

class _GradingSystemDialogState extends State<GradingSystemDialog> {
  int? groupValue;
  @override
  void initState() {
    super.initState();
    getData();
  }

  Future<void> getData() async {
    groupValue = await getGradingPreference();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.symmetric(vertical: 25, horizontal: 15),
      title: Text('Grade System'),
      content: groupValue == null
          ? Container(height: 200)
          : Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                getRadioTile(value: 1, label: gradingSystems[1]!),
                getRadioTile(value: 2, label: gradingSystems[2]!),
                getRadioTile(value: 3, label: gradingSystems[3]!),
                getRadioTile(value: 4, label: gradingSystems[4]!),
                getRadioTile(value: 5, label: gradingSystems[5]!),
                getRadioTile(value: 6, label: gradingSystems[6]!),
              ],
            ),
      actions: [
        TextButton(
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.transparent)),
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text(
            'Cancel',
            style: TextStyle(color: Colors.teal),
          ),
        ),
        TextButton(
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.teal)),
          onPressed: () async {
            await setGradingPreference(groupValue!);
            Navigator.pop(context);
          },
          child: Text(
            'Save',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }

  Row getRadioTile({required int value, required String label}) {
    return Row(
      children: [
        Radio(
          activeColor: Colors.teal,
          value: value,
          groupValue: groupValue,
          onChanged: (int? val) {
            setState(() {
              groupValue = val;
            });
          },
        ),
        Text(
          label,
          style: TextStyle(overflow: TextOverflow.ellipsis),
        )
      ],
    );
  }
}
