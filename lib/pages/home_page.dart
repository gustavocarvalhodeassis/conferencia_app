import 'package:conferencia/model/company_model.dart';
import 'package:conferencia/pages/company_page.dart';
import 'package:conferencia/widgets/checking_list_tile.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  CompanyModel model = CompanyModel();

  List<Company> companyList = [];

  @override
  void initState() {
    super.initState();
    model.deleteCompany(5);
    _getAllCompanys();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Conferencia'),
      ),
      body: companyList.isEmpty
          ? const Center(
              child: Text('tem nada'),
            )
          : ListView.builder(
              itemCount: companyList.length,
              itemBuilder: (context, index) {
                return CheckingListTile(
                  companyName: companyList[index].name!,
                  contName: companyList[index].contName,
                  contEmail: companyList[index].contEmail,
                  checked: companyList[index].isCheck,
                  onTap: () {
                    _showCompanyPage(company: companyList[index]);
                  },
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showCompanyPage();
        },
        child: const Icon(
          Icons.add,
        ),
      ),
    );
  }

  void _showCompanyPage({Company? company}) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => CompanyPage(
          company: company,
        ),
      ),
    );
    _getAllCompanys();
  }

  void _getAllCompanys() {
    model.getAllCompanys().then((value) {
      setState(() {
        companyList = value;
      });
    });
  }
}
