import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

//Class Model
class ContactData {
  int? id;
  String? name;
  String? contact;
  DateTime? date;

  ContactData({this.id, this.name, this.contact, this.date});
  // constructor with id
  ContactData.withId({this.id, this.name, this.contact, this.date});

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{};

    if (id != null) {
      map['id'] = id;
    }

    map["name"] = name;
    map["contact"] = contact;

    map["date"] = date!.toIso8601String();
    return map;
  }

  factory ContactData.fromMap(Map<String, dynamic> map) {
    return ContactData.withId(
      id: map['id'],
      name: map['name'],
      contact: map['contact'],
      date: DateTime.parse(map["date"]),
    );
  }
}

//database helper
class DatabaseHelperTwo {
  static final DatabaseHelperTwo instance = DatabaseHelperTwo._instance();

  //instance of a fdb
  static Database? _db;

  DatabaseHelperTwo._instance();

  String myContactTable = 'my_contact_table';

  String colId = 'id';
  String colName = 'name';
  String colContact = 'contact';
  String colDate = 'date';

  //if db is null then create it
  Future<Database?> get db async {
    _db ??= await initDB();
    return _db;
  }

  //initialize the database
  Future<Database> initDB() async {
    Directory dir = await getApplicationDocumentsDirectory();
    String path = '${dir.path}my_contact_data.db';
    final contactDataDB = await openDatabase(
      path,
      version: 1,
      onCreate: _createDb,
    );
    return contactDataDB;
  }

  //'Create a database'
  void _createDb(Database db, int version) async {
    await db.execute('CREATE TABLE $myContactTable('
        '$colId INTEGER PRIMARY KEY , '
        '$colName TEXT,'
        '$colContact TEXT,'
        '$colDate TEXT)');
  }

  //getMapList
  Future<List<Map<String, dynamic>>> getContactDataMapList() async {
    Database? db = await this.db;
    final List<Map<String, dynamic>> result =
        // await db!.query(scannerTable, orderBy: '${colDate} DESC Limit');
        await db!
            .rawQuery("SELECT * FROM $myContactTable ORDER BY $colId DESC ");
    return result;
  }

  //get the list of data
  Future<List<ContactData>> getContactList() async {
    final List<Map<String, dynamic>> contactMapList =
        await getContactDataMapList();

    final List<ContactData> contactList = [];

    for (var element in contactMapList) {
      contactList.add(ContactData.fromMap(element));
    }

    // scannedList.sort((scanA, scanB) => scanA.date!.compareTo(scanB.date!));

    return contactList;
  }

  //insert scanned data
  Future<int> insertContactData(ContactData contactData) async {
    Database? db = await this.db;
    final int result = await db!.insert(
      myContactTable,
      contactData.toMap(),
    );
    return result;
  }

  //update scanned data
  Future<int> updatingContactData(ContactData contactData) async {
    Database? db = await this.db;
    final int result = await db!.update(
      myContactTable,
      contactData.toMap(),
      where: '$colId =?',
      whereArgs: [contactData.id],
    );
    return result;
  }

  //delete scanned data
  Future<void> deletingContactData(int id) async {
    Database? db = await this.db;
    // final int result =
    await db!.delete(
      myContactTable,
      where: '$colId = ?',
      whereArgs: [id],
    );
    // return result;
  }

  Future<void> deletingAllContactData() async {
    Database? db = await this.db;
    // final int result =
    await db!.rawDelete("DELETE FROM my_contact_table");
    // return result;
  }
}

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._instance();

  //instance of a fdb
  static Database? _db;

  DatabaseHelper._instance();

  String contactTable = 'contact_table';
  String myContactTable = 'my_contact_table';

  String colId = 'id';
  String colName = 'name';
  String colContact = 'contact';
  String colDate = 'date';

  //if db is null then create it
  Future<Database?> get db async {
    _db ??= await initDB();
    return _db;
  }

  //initialize the database
  Future<Database> initDB() async {
    Directory dir = await getApplicationDocumentsDirectory();
    String path = '${dir.path}contact_data.db';
    final contactDataDB = await openDatabase(
      path,
      version: 1,
      onCreate: _createDb,
    );
    return contactDataDB;
  }

  //'Create a database'
  void _createDb(Database db, int version) async {
    await db.execute('CREATE TABLE $contactTable('
        '$colId INTEGER PRIMARY KEY , '
        '$colName TEXT,'
        '$colContact TEXT,'
        '$colDate TEXT)');
  }

  //getMapList
  Future<List<Map<String, dynamic>>> getContactDataMapList() async {
    Database? db = await this.db;
    final List<Map<String, dynamic>> result =
        // await db!.query(scannerTable, orderBy: '${colDate} DESC Limit');
        await db!.rawQuery("SELECT * FROM $contactTable ORDER BY $colId DESC ");
    return result;
  }

  //get the list of data
  Future<List<ContactData>> getContactList() async {
    final List<Map<String, dynamic>> contactMapList =
        await getContactDataMapList();

    final List<ContactData> contactList = [];

    for (var element in contactMapList) {
      contactList.add(ContactData.fromMap(element));
    }

    // scannedList.sort((scanA, scanB) => scanA.date!.compareTo(scanB.date!));

    return contactList;
  }

  //insert scanned data
  Future<int> insertContactData(ContactData contactData) async {
    Database? db = await this.db;
    final int result = await db!.insert(
      contactTable,
      contactData.toMap(),
    );
    return result;
  }

  //update scanned data
  Future<int> updatingContactData(ContactData contactData) async {
    Database? db = await this.db;
    final int result = await db!.update(
      contactTable,
      contactData.toMap(),
      where: '$colId =?',
      whereArgs: [contactData.id],
    );
    return result;
  }

  //delete scanned data
  Future<void> deletingContactData(int id) async {
    Database? db = await this.db;
    // final int result =
    await db!.delete(
      contactTable,
      where: '$colId = ?',
      whereArgs: [id],
    );
    // return result;
  }

  Future<void> deletingAllContactData() async {
    Database? db = await this.db;
    // final int result =
    await db!.rawDelete("DELETE FROM contact_table");
    // return result;
  }
}
