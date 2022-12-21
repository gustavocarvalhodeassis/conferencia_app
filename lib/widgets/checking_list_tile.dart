// ignore_for_file: must_be_immutable
import 'package:conferencia/model/company_model.dart';
import 'package:flutter/material.dart';

class CheckingListTile extends StatefulWidget {
  CheckingListTile({
    super.key,
    required this.companyName,
    this.contName,
    this.contEmail,
    this.onTap,
    this.checked,
  });

  String companyName;
  String? contName;
  String? contEmail;
  Function()? onTap;
  bool? checked;

  @override
  State<CheckingListTile> createState() => _CheckingListTileState();
}

class _CheckingListTileState extends State<CheckingListTile> {
  CompanyModel model = CompanyModel();

  subtitleRender() {
    if (widget.contName!.isEmpty && widget.contEmail!.isEmpty) {
      return null;
    } else {
      return Text('${widget.contName} - ${widget.contEmail}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: widget.onTap,
      title: Text(widget.companyName),
      subtitle: subtitleRender(),
      trailing: Checkbox(
        splashRadius: 30,
        onChanged: (value) {
          setState(() {
            widget.checked = value!;
          });
          Company newCheckCompany = Company();
          newCheckCompany.isCheck = widget.checked!;
          model.updateCompany(newCheckCompany);
        },
        value: widget.checked,
      ),
    );
  }
}
