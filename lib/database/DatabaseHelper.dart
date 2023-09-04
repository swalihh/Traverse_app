import 'dart:io';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {
  static const dbName = "MyDatabase";
  static const dbversion = 1;
  static const dbTable = 'myTable';
  static const ColumnUserId = 'id';
  static const ColumnName = 'name';
  static const ColumnPassword = "password";
  static const ColumnMail = "Mail";
  static const Columnislogin = "islogin";
  static const Columnimage = "image";

  //TRIPS
  static const ColumnCoverphoto = "_image";
  static const ColumnTripId = "userid";
  static const addtable = "addtrip";
  static const Columnstarting = "starting";
  static const ColumnEnding = "Ending";
  static const Columnstartdate = "startdate";
  static const Columnenddate = "enddate";
  static const ColumnBudget = "Budget";
  static const Columntriptype = "triptype"; 
  static const ColumnNote = "Note";

  //companion

  static const CompanionTable = 'companion';
  static const CompanionId = 'companionId';
  static const CompanionTripId = 'TripId';
  static const CompanionName = 'CompanionName';
  static const CompanionNum = 'CompanionNum';

  //album
  static const ColumnAlbum = 'Album_Table';
  static const Album = 'imagepath';
  static const AlbumId = 'AlbumTripId';
  static const AlbumTableId = 'AlbumTableId';

  //expenses

  static const ExpenceTable = 'expenses';
  static const ExpensesTableId = 'ExpensesId';
  static const ColumnTravel = 'travel';
  static const ColumnFood = 'food';
  static const ColumnHotel = 'hotel';
  static const ColumnOthers = 'others';
  static const ColumnExpence = 'Expence';
  static const ColumnExpenseTripId = 'TripId';

  static final DatabaseHelper instance = DatabaseHelper();

  static Database? _database;

  Future<Database?> get database async {
    _database ??= await initDB();
    return _database;
  }

  initDB() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, dbName);
    return await openDatabase(path, version: dbversion, onCreate: Oncreate);
  }

  Future Oncreate(Database db, int version) async {
    await db.execute('''
CREATE TABLE $dbTable(
$ColumnUserId INTEGER PRIMARY KEY, 
$ColumnName TEXT NOT NULL,
$ColumnPassword TEXT NOT NULL,
$ColumnMail  TEXT NOT NULL,
$Columnimage TEXT NOT NULL,
$Columnislogin INTEGER DEFAULT 0
)
''');
    await db.execute('''
CREATE TABLE $addtable(
$ColumnTripId  INTEGER PRIMARY KEY,
$ColumnUserId INTEGER,
$ColumnCoverphoto TEXT, 
$Columnstarting TEXT,
$ColumnEnding TEXT,
$Columnstartdate TEXT,
$Columnenddate TEXT,
$ColumnBudget TEXT,
$ColumnNote TEXT,
$Columntriptype TEXT,
FOREIGN KEY ($ColumnUserId) REFERENCES $dbTable($ColumnUserId) ON DELETE CASCADE


)
''');

    await db.execute('''
CREATE TABLE $CompanionTable(
  $CompanionId INTEGER PRIMARY KEY,
  $CompanionName TEXT,
  $CompanionNum TEXT,
  $CompanionTripId INTEGER,
 
FOREIGN KEY ($CompanionTripId) REFERENCES $addtable($ColumnTripId)

)

''');

    await db.execute('''
CREATE TABLE $ColumnAlbum(
  $AlbumTableId INTEGER PRIMARY KEY,
  $Album TEXT,
  $AlbumId INTEGER,
  FOREIGN KEY ($AlbumId) REFERENCES $addtable($ColumnTripId)

)
''');

    await db.execute(''' 
   CREATE TABLE $ExpenceTable(
    $ExpensesTableId INTEGER PRIMARY KEY,
    $ColumnFood TEXT,
    $ColumnTravel TEXT,
    $ColumnHotel TEXT,
    $ColumnOthers TEXT,
    $ColumnExpence TEXT,
    $ColumnExpenseTripId TEXT,

    FOREIGN KEY ($ColumnExpenseTripId) REFERENCES $addtable($ColumnTripId)

   )
   
   ''');
  }

  //companion insert table---------------------

  insertCompanion(Map<String, dynamic> row) async {
    Database? db = await instance.database;
    return await db!.insert(CompanionTable, row);
  }
  //companion delete-------------------

  deleteComapanion(int CompanionID) async {
    Database? db = await instance.database;
    db!.delete(CompanionTable,
        where: '$CompanionId=?', whereArgs: [CompanionID]);
  }

  // get companion------------------

  Future<List<Map<String, dynamic>>> Getcompanion(int tripId) async {
    Database? db = await instance.database;
    return await db!.query(CompanionTable,
        where: "$CompanionTripId=?", whereArgs: [tripId]);
  }

//insert
  insertRecords(Map<String, dynamic> row) async {
    Database? db = await instance.database;
    return await db!.insert(dbTable, row);
  }

//to get iMage details
  Future<List<String>> getAlbumImages(int tripId) async {
    final db = await instance.database;
    final result = await db!.query(
      ColumnAlbum,
      columns: [Album],
      where: '$AlbumId = ?',
      whereArgs: [tripId],
    );

    return result.map((row) => row[Album] as String).toList();
  }

  // to insert the photos  from gallary
  Future<void> insertPhotoToAlbum(int tripId, String photoPath) async {
    final db = await instance.database;
    await db!.insert(ColumnAlbum, {
      AlbumTableId: null,
      AlbumId: tripId,
      Album: photoPath,
    });
  }

// to delete photos
  Future<void> deletePhotoFromAlbum(int tripId, String imagePath) async {
    final db = await instance.database;
    await db!.delete(
      DatabaseHelper.ColumnAlbum,
      where: '$AlbumId = ? AND $Album = ?',
      whereArgs: [tripId, imagePath],
    );
  }

///////------------NAME ALREADY TAKEN OR NOT-----------------
  Future<bool> isUsernameTaken(String username) async {
    final db = await DatabaseHelper.instance.database;
    final result = await db?.rawQuery(
      "SELECT * FROM ${DatabaseHelper.dbTable} WHERE ${DatabaseHelper.ColumnName} = ?",
      [username],
    );
    return result!.isNotEmpty;
  }

  //insert
  // tripRecords(Map<String, dynamic> row) async {
  //   Database? db = await instance.database;
  //   return await db!.insert(addtable, row);
  // }
  tripInsertRecords(
      Map<String, dynamic> row, List<Map<String, dynamic>> companions) async {
    Database? db = await instance.database;
    int tripId = await db!.insert(addtable, row);
    if (companions.isNotEmpty) {
      for (var row in companions) {
        row['TripId'] = tripId;

        await db.insert(CompanionTable, row);
      }
    }
    await db.query(CompanionTable, where: 'TripId = ?', whereArgs: [tripId]);
    initExp(tripId);
  }
  // if(companions.isNotEmpty){
  //   companions.map((map) {
  //     map[CompanionTripId]:tripId;
  //   });
  // }
  //}

  // initial exp

  initExp(int tripId) async {
    Map<String, dynamic> initialExpenses = {
      ColumnTravel: 0,
      ColumnFood: 0,
      ColumnHotel: 0,
      ColumnOthers: 0,
      ColumnExpence: 0,
      ColumnExpenseTripId: tripId,
    };

    Database? db = await instance.database;
    db!.insert(ExpenceTable, initialExpenses);
  }

//read
  Future<List<Map<String, dynamic>>> queryDatabase() async {
    Database? db = await instance.database;
    return db!.query(dbTable);
  }

  //update
  Future<int> updateRecords(Map<String, dynamic> row) async {
    Database? db = await instance.database;
    int id = row[ColumnUserId];
    return await db!
        .update(dbTable, row, where: '$ColumnUserId=?', whereArgs: [id]);
  }

  //delete

  Future<int> deleteRecords(int id) async {
    Database? db = await instance.database;
    return await db!.delete(dbTable, where: '$ColumnUserId=?', whereArgs: [id]);
  }

  //read
  Future<List<Map<String, dynamic>>> queryDatabase2() async {
    Database? db = await instance.database;
    return db!.query(addtable);
  }

//---------------------check user
  Future<Map<String, dynamic>?> getloggeduser() async {
    Database? db = await instance.database;
    final map =
        await db!.query(dbTable, where: '$Columnislogin=?', whereArgs: [1]);
    if (map.isEmpty) {
      return null;
    }
    return map.first;
  }
  //-------logout User-----

  logoutuser() async {
    Database? db = await instance.database;
    await db!.update(dbTable, {Columnislogin: 0}, where: '$Columnislogin=1');
  }

  //--------get all trip details 
  Future<List<Map<String, dynamic>>> AlltripDetails(
    int userid,
  ) async {
    Database? db = await instance.database;

    return await db!.query(addtable,
        where: '$ColumnUserId=?',
        whereArgs: [userid],
        orderBy: '$Columnstartdate ASC');
  }

  //--------get Upcoming details
  Future<List<Map<String, dynamic>>> readUpcomingTrips(
    int userid,
  ) async {
    Database? db = await instance.database;
    final currentdate = DateTime.now();
    final formatedDate = DateFormat('yyyy-MM-dd').format(currentdate);

    return await db!.query(addtable,
        where: '$ColumnUserId=? AND $Columnstartdate > ?',
        whereArgs: [userid, formatedDate],
        orderBy: '$Columnstartdate ASC');
  }

  //--------get Upcoming details
  Future<List<Map<String, dynamic>>> readOngoingTrips(
    int userid,
  ) async {
    Database? db = await instance.database;
    final currentdate = DateTime.now();
    final formatedDate = DateFormat('yyyy-MM-dd').format(currentdate);

    return await db!.query(addtable,
        where:
            '$ColumnUserId=? AND ($Columnstartdate <= ? AND $Columnenddate >= ? )',
        whereArgs: [
          userid,
          formatedDate,
          formatedDate,
         
        ],
        orderBy: '$Columnstartdate ASC');
    
  }


//-------------------compleated trips----------------
Future<List<Map<String, dynamic>>> readCompletedTrip(int userId) async {
  Database? db = await instance.database;
  final currentDate = DateTime.now();
  final formattedDate = DateFormat('yyyy-MM-dd').format(currentDate);

  final completed= await db!.query(addtable,
      where: '$ColumnUserId = ? AND $Columnenddate <= ?',
      whereArgs: [userId, formattedDate],
      orderBy: '$Columnstartdate ASC');

      print('completed $completed');
      return completed;
}

  getOngoingtripId(
    int userid,
  ) async {
    Database? db = await instance.database;
    final currentdate = DateTime.now();
    final formatedDate = DateFormat('yyyy-MM-dd').format(currentdate);

    final ongoingtrip = await db!.query(addtable,
        where:
            '$ColumnUserId=? AND ($Columnstartdate <= ? AND $Columnenddate >= ? ) OR ($Columnstartdate = ?)',
        whereArgs: [
          userid,
          formatedDate,
          formatedDate,
          formatedDate,
        ],
        orderBy: '$Columnstartdate ASC');
    return ongoingtrip[0] ;
  }

  //function for note------------------------------------
  UpdateTripdata(String Note, int TripId) async {
    Database? db = await instance.database;
    return await db!.update(addtable, {"Note": Note},
        where: '$ColumnTripId=?', whereArgs: [TripId]);
  }

  //update in ongoing
  Future<void> updateTrip(
      int tripId, String newName, String newEndDate, String newBudget) async {
    Database? db = await instance.database;
    await db!.update(
        addtable,
        {
          DatabaseHelper.ColumnEnding: newName,
          DatabaseHelper.Columnenddate: newEndDate,
          DatabaseHelper.ColumnBudget: newBudget,
        },
        where: '${DatabaseHelper.ColumnTripId} = ?',
        whereArgs: [tripId]);
  }
  //update profile

  Future<void> updateProfile(
    int userid,
    String Nawname,
    String newmail,
  ) async {
    Database? db = await instance.database;
    await db!.update(
        dbTable,
        {
          //  DatabaseHelper.Columnimage: newProfile,
          DatabaseHelper.ColumnName: Nawname,
          DatabaseHelper.ColumnMail: newmail
        },
        where: '${DatabaseHelper.ColumnUserId} =?',
        whereArgs: [userid]);
  }

//----------------------------------------------------------------------expence------------------------------------------------------------------
// Expence functions
// Get the corresponding category column name
  String getCategoryColumn(String category) {
    switch (category) {
      case 'food':
        return ColumnFood;
      case 'travel':
        return ColumnTravel;
      case 'hotel':
        return ColumnHotel;
      case 'others':
        return ColumnOthers;
      default:
        return '';
    }
  }

  //---------------------------
  getExpences(int tripId) async {
    final db = await instance.database;
    final existingData = await db!.query(ExpenceTable,
        where: '$ColumnExpenseTripId = ?', whereArgs: [tripId]);
    return existingData;
  }

  addtoExpense(int tripId, String selectedCategory, double amount) async {
    final db = await instance.database;
    String categoryColumn = getCategoryColumn(selectedCategory);

    // Check if expense data already exists for this trip
    final existingData = await db!.query(ExpenceTable,
        where: '$ColumnExpenseTripId = ?', whereArgs: [tripId]);

    if (existingData.isNotEmpty) {
      // Update the existing data
      double currentAmount =
          double.parse(existingData.first[categoryColumn] as String);
      await db.update(
        ExpenceTable,
        {categoryColumn: currentAmount + amount},
        where: '$ColumnExpenseTripId = ?',
        whereArgs: [tripId],
      
      );
    } else {
      // Insert new row with expense data
      Map<String, dynamic> initialExpenses = {
        ColumnTravel: 0,
        ColumnFood: 0,
        ColumnHotel: 0,
        ColumnOthers: 0,
        ColumnExpence: amount.toString(),
        ColumnExpenseTripId: tripId,
        
      };
      initialExpenses[categoryColumn] = amount.toString();
      await db.insert(ExpenceTable, initialExpenses);
    }

    // Update total trip expense
    await updateTripExpence(amount, tripId);
  }

// Update the tripexpence column in the ExpenceTable
  Future<void> updateTripExpence(double amount, int tripId) async {
    final db = await database;
    if (db != null) {
      final currentExpence = await db.rawQuery(
        'SELECT $ColumnExpence FROM $ExpenceTable WHERE $ColumnExpenseTripId = ?',
        [tripId],
      );

      if (currentExpence.isNotEmpty) {
        final currentAmount =
            double.parse(currentExpence.first[ColumnExpence] as String);
        final newAmount = currentAmount + amount;
        await db.rawUpdate(
          'UPDATE $ExpenceTable SET $ColumnExpence = ? WHERE $ColumnExpenseTripId = ?',
          [newAmount.toString(), tripId], // Convert newAmount to String
        );
      }
    }
  }

// Update the selected category column in the ExpenceTable
  Future<void> updateCategoryExpence(
      String categoryColumn, double amount, int tripId) async {
    final db = await database;
    await db!.rawUpdate(
      'UPDATE $ExpenceTable SET $categoryColumn = $categoryColumn + ? WHERE $ColumnExpenseTripId = ?',
      [amount.toString(), tripId], // Convert amount to String
    );
  }
//----------------------------------------------------------------------expence------------------------------------------------------------------
 //-----get all Expences
 Future<List<Map<String, dynamic>>> getExpenseInfo(int tripId) async {
    final db = await database;
    List<Map<String, dynamic>> getExpences = await db!.query(
      ExpenceTable,
      where: '$ColumnTripId = ?',
      whereArgs: [tripId],
    );
    return getExpences;
  }
  // delete full trip
  Future<int> deleteTrip(int tripId) async {
    final db = await instance.database;
    return await db!.delete(DatabaseHelper.addtable,
        where: '${DatabaseHelper.ColumnTripId} = ?', whereArgs: [tripId]);
  }

  // to get images
  Future<List<String>> getTripImagePaths(int tripId) async {
  final db = await instance.database;
  final result = await db!.query(
    ColumnAlbum,
    columns: [Album],
    where: '$AlbumId = ?',
    whereArgs: [tripId],
  );

  return result.map((row) => row[Album] as String).toList();
}


  Future<Map<String, dynamic>> logincheck(
      String username, String password) async {
    Database? db = await instance.database;
    List<Map<String, dynamic>> value = await db!.query(dbTable,
        where: '$ColumnName=? AND $ColumnPassword=?',
        whereArgs: [username, password],
        limit: 1);
    if (value.isNotEmpty) {
      final user = value.first;
      await db.update(dbTable, {'islogin': 1},
          where: 'id=?', whereArgs: [user['id']]);
      final Map<String, dynamic>? usr = await getloggeduser();
      return usr!;
    } else {
      return {};
    }
  }
}
