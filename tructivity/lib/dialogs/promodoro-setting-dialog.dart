import 'package:flutter/services.dart';
import 'package:tructivity/constants.dart';
import 'package:tructivity/functions.dart';
import 'package:tructivity/widgets/buttons.dart';
import 'package:tructivity/widgets/custom-textfield.dart';
import 'package:flutter/material.dart';
import 'package:tructivity/widgets/error-dialog.dart';

class PromodoroSettingDialog extends StatelessWidget {
  final int focusTime, breakTime;
  PromodoroSettingDialog({required this.focusTime, required this.breakTime});
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    String focusVal = focusTime.toString();
    String breakVal = breakTime.toString();
    return AlertDialog(
      scrollable: true,
      title: Text('Promodoro Setting'),
      contentPadding: EdgeInsets.zero,
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomTextField(
              validate: true,
              initialText: focusVal,
              labelText: "Work Duration",
              fieldIcon: Icons.timer_outlined,
              capitalizaton: TextCapitalization.none,
              type: TextInputType.number,
              formatter: FilteringTextInputFormatter.allow(intExpression),
              onChangedCallback: (val) {
                focusVal = val;
              },
            ),
            CustomTextField(
              validate: true,
              initialText: breakVal,
              labelText: "Break Duration",
              fieldIcon: Icons.snooze_outlined,
              type: TextInputType.number,
              capitalizaton: TextCapitalization.none,
              formatter: FilteringTextInputFormatter.allow(intExpression),
              onChangedCallback: (val) {
                breakVal = val;
              },
            ),
          ],
        ),
      ),
      actions: [
        CustomButton(
          buttonColor: Colors.transparent,
          textColor: Colors.teal,
          label: 'Cancel',
          onTapButton: () {
            Navigator.pop(context);
          },
        ),
        SaveButton(onTapSave: () async {
          if (_formKey.currentState!.validate()) {
            if (int.parse(focusVal) <= 120 && int.parse(breakVal) <= 30) {
              await setPromodoroPreference("$focusVal:$breakVal");
              Navigator.pop(context);
            } else {
              showDialog(
                  context: context,
                  builder: (c) {
                    return ErrorDialog(
                        error:
                            'Work duration should not be more than 120 minutes and the break duration should not be more than 30 minutes');
                  });
            }
          }
        }),
      ],
    );
  }
}
