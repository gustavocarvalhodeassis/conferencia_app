import 'package:conferencia/model/company_model.dart';
import 'package:flutter/material.dart';

class CompanyPage extends StatefulWidget {
  const CompanyPage({super.key, this.company});
  final Company? company;

  @override
  State<CompanyPage> createState() => _CompanyPageState();
}

class _CompanyPageState extends State<CompanyPage> {
  TextEditingController nameController = TextEditingController();

  TextEditingController contNameController = TextEditingController();

  TextEditingController contEmailController = TextEditingController();

  FocusNode nameFocus = FocusNode();

  CompanyModel model = CompanyModel();

  String? errorMessage;

  @override
  void initState() {
    super.initState();
    if (widget.company != null) {
      nameController.text = widget.company!.name!;
      contEmailController.text = widget.company!.contEmail!;
      contNameController.text = widget.company!.contName!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.company?.name ?? 'Adicionar empresa'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(18, 15, 18, 0),
        child: Column(
          children: [
            TextFormField(
              controller: nameController,
              focusNode: nameFocus,
              onChanged: (value) {
                widget.company?.name = value;
                if (nameController.text.length <= 1) {
                  setState(() {
                    errorMessage = 'Insira o nome da empresa';
                  });
                } else {
                  if (widget.company != null) {
                    model.updateCompany(widget.company!);
                  }
                  setState(() {
                    errorMessage = null;
                  });
                }
              },
              decoration: InputDecoration(
                labelText: 'Nome da contabilidade',
                errorText: errorMessage,
              ),
            ),
            TextFormField(
              controller: contNameController,
              onChanged: (value) {
                if (widget.company != null) {
                  widget.company?.contName = value;
                  model.updateCompany(widget.company!);
                } else {
                  widget.company?.name = value;
                }
              },
              decoration: const InputDecoration(
                labelText: 'Email da contabilidade',
              ),
            ),
            TextFormField(
              controller: contEmailController,
              onChanged: (value) {
                if (widget.company != null) {
                  widget.company?.contEmail = value;
                  model.updateCompany(widget.company!);
                } else {
                  widget.company?.name = value;
                }
              },
              decoration: const InputDecoration(
                labelText: 'Nome da empresa',
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: widget.company == null
          ? FloatingActionButton(
              onPressed: () {
                if (nameController.text.isEmpty && widget.company == null) {
                  setState(() {
                    errorMessage = 'Insira o nome da empresa';
                  });
                  nameFocus.requestFocus();
                } else {
                  Company newCompany = Company();
                  newCompany.name = nameController.text;
                  newCompany.contName = contNameController.text;
                  newCompany.contEmail = contEmailController.text;
                  model.saveCompany(newCompany);

                  Navigator.pop(context);
                }
              },
              child: const Icon(Icons.check),
            )
          : Container(),
    );
  }
}
