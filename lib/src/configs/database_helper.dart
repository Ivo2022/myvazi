// //import 'package:myvazi/src/models/products_model.dart';
// import 'package:sqflite/sqflite.dart';
// import 'package:path/path.dart';

// /*
// getDatabasePath(): gets the default database location.
// openDatabase(): accepts a mandatory String as an argument that is the path of the database.
// We use the method join() which is inside the package path to join the given path into a single path, so for example we would get databasepath/database.db.
// onCreate() callback: It will be called when the database is created for the first time, and it will execute the above SQL query to create the table notes. This is where the creation of tables and the initial population of the tables should happen.
// */
// class SqliteService {
//   Future<Database> initializeDB() async {
//     String path = await getDatabasesPath();

//     return openDatabase(
//       join(path, 'database.db'),
//       onCreate: (database, version) async {
//         await database.execute(
//           "CREATE TABLE Notes(id INTEGER PRIMARY KEY AUTOINCREMENT, description TEXT NOT NULL)",
//         );
//       },
//       version: 1,
//       //onUpgrade: (database, oldVersion, newVersion){()=>}
//     );
//   }

// /*
// createItem() will take a product, and then insert the product into the table Products.
// insert() method: It accepts 2 arguments String table, Map<String, Object?> values, and that’s why we create a toMap() method in the model class.
// */
//   Future<int> createItem(Products product) async {
//     int result = 0;
//     final Database db = await initializeDB();
//     final id = await db.insert('Products', product.toMap(),
//         conflictAlgorithm: ConflictAlgorithm.replace);

//     // Make sure to return an int value
//     return id;
//   }

// /*
// We use the query() the method that accepts a string augment Notes which is the table name to retrieve all columns from the table Notes.
// The queryResult returns a List, so we use the map() method to transform the List<Map<String, Object?>> into a List<Note>.
// */
//   Future<List<Products>> getItems() async {
//     final db = await initializeDB();
//     final List<Map<String, Object?>> queryResult =
//         await db.query('Products', orderBy: 'id');
//     return queryResult.map((e) => Products.fromMap(e)).toList();
//   }

// /*
// The delete() method: we pass the table name and specify the columns that we want to delete the row in the table.
// */
//   Future<void> deleteItem(String id) async {
//     final db = await initializeDB();
//     try {
//       await db.delete("Products", where: "id = ?", whereArgs: [id]);
//     } catch (err) {
//       print("Something went wrong when deleting an item: $err");
//     }
//   }
// }
