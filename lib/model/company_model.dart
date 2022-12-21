// ignore_for_file: depend_on_referenced_packages

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;

const String companyTable = 'companyTable';
const String idColumn = 'idColumn';
const String nameColumn = 'nameColumn';
const String contEmailColumn = 'contEmailColumn';
const String contNameColumn = 'contNameColumn';
const String isCheckedColumn = 'isCheckedColumn';

class CompanyModel {
  static final CompanyModel _instance = CompanyModel.internal();

  factory CompanyModel() => _instance;

  CompanyModel.internal();

  Database? _db;

  Future<Database> get db async {
    if (_db != null) {
      return _db!;
    } else {
      _db = await initDb();
      return _db!;
    }
  }

  Future<Database> initDb() async {
    final dbPath = await getDatabasesPath();
    final path = p.join(dbPath, "companylist.db");

    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute(
          "CREATE TABLE $companyTable($idColumn INTEGER PRIMARY KEY, $nameColumn TEXT, $contEmailColumn TEXT, $contNameColumn TEXT, $isCheckedColumn BOOLEAN NOT NULL)",
        );
      },
    );
  }

  Future<Company> saveCompany(Company company) async {
    Database dbCompany = await db;
    company.id = await dbCompany.insert(
      companyTable,
      company.toMap(),
    );
    return company;
  }

  Future<Company?> getCompany(int id) async {
    Database dbCompany = await db;
    List<Map> maps = await dbCompany.query(
      companyTable,
      columns: [
        idColumn,
        nameColumn,
        contEmailColumn,
        contNameColumn,
      ],
      where: "$id = ?",
      whereArgs: [
        id,
      ],
    );
    if (maps.isNotEmpty) {
      return Company.fromMap(maps.first);
    } else {
      return null;
    }
  }

  deleteCompany(int id) async {
    Database dbCompany = await db;
    return await dbCompany.delete(
      companyTable,
      where: "$idColumn = ?",
      whereArgs: [id],
    );
  }

  Future<int> updateCompany(Company company) async {
    Database dbCompany = await db;
    return await dbCompany.update(
      companyTable,
      company.toMap(),
      where: "$idColumn = ?",
      whereArgs: [company.id],
    );
  }

  Future<List<Company>> getAllCompanys() async {
    Database dbCompany = await db;
    List listMap = await dbCompany.rawQuery("SELECT * FROM $companyTable");
    List<Company> listCompany = [];
    for (Map m in listMap) {
      listCompany.add(
        Company.fromMap(m),
      );
    }
    return listCompany;
  }

  Future<int?> getNumber() async {
    Database dbCompany = await db;
    return Sqflite.firstIntValue(
      await dbCompany.rawQuery("SELECT COUNT(*) FROM $companyTable"),
    );
  }

  Future close() async {
    Database dbCompany = await db;
    await dbCompany.close();
  }
}

class Company {
  int? id;
  String? name;
  String? contEmail;
  String? contName;
  bool isCheck = false;

  Company();

  Company.fromMap(Map map) {
    id = map[idColumn];
    name = map[nameColumn];
    contEmail = map[contEmailColumn];
    contName = map[contNameColumn];
    isCheck = map[isCheckedColumn];
  }

  toMap() {
    Map<String, dynamic> map = {
      nameColumn: name,
      contEmailColumn: contEmail,
      contNameColumn: contName,
      isCheckedColumn: isCheck,
    };
    if (id != null) {
      map[idColumn] = id;
    }
    return map;
  }

  @override
  String toString() {
    return "Empresa(id: $id, name: $name, email do contador: $contEmail, nome do contador: $contName, conferid? $isCheck)";
  }
}
