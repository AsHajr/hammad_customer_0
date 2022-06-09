import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:hammad_customer_0/translations/locale_keys.g.dart';

class ChangeLanguageDialog extends StatefulWidget {
  final bool isEnChecked;
  final bool isArChecked;
  const ChangeLanguageDialog({Key key,this.isEnChecked,this.isArChecked}) : super(key: key);

  @override
  _ChangeLanguageDialogState createState() => _ChangeLanguageDialogState();
}

class _ChangeLanguageDialogState extends State<ChangeLanguageDialog> {
  bool isEnChecked;
  bool isArChecked;
  @override
  void initState() {
    super.initState();
    isEnChecked= widget.isEnChecked;
    isArChecked= widget.isArChecked;
  }
  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      title: Text(LocaleKeys.change_language.tr()),
      children: [
        CheckboxListTile(
          title: Text('English'),
          value: isEnChecked,
          onChanged: (bool value) async{
            setState(() {
              isEnChecked = value;
              isArChecked = false;
            });
            await context.setLocale(Locale('en'));
            Navigator.pop(context);
          },
        ),
        CheckboxListTile(
          title: Text('العربية'),
          value: isArChecked,
          onChanged: (bool value) async{
            setState(() {
              isArChecked = value;
              isEnChecked = false;
            });
            await context.setLocale(Locale('ar'));
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
