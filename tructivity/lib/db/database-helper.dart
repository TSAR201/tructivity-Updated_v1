import 'package:tructivity/models/absence-model.dart';
import 'package:tructivity/models/category-model.dart';
import 'package:tructivity/models/event-model.dart';
import 'package:tructivity/models/grade-models/college-grade-model.dart';
import 'package:tructivity/models/grade-models/grade-data-model.dart';
import 'package:tructivity/models/grade-models/highschool-grade-model.dart';
import 'package:tructivity/models/grade-models/letter-grade-model.dart';
import 'package:tructivity/models/grade-models/percentage-grade-model.dart';
import 'package:tructivity/models/grade-models/point-grade-model.dart';
import 'package:tructivity/models/note-category-model.dart';
import 'package:tructivity/models/schedule-model.dart';
import 'package:tructivity/models/homework-model.dart';
import 'package:tructivity/models/note-model.dart';
import 'package:tructivity/models/subject-model.dart';
import 'package:tructivity/models/task-model.dart';
import 'package:tructivity/models/teacher-model.dart';
import 'package:tructivity/models/timetable-data-model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class DatabaseHelper {
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  static Database? _database;

  Future<Database> get database async => _database ??= await _initDatabase();
  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'myDatabase.db');
    return await openDatabase(path,
        version: 2, onCreate: _onCreate, onUpgrade: _onUpgrade);
  }

  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion == 1 && newVersion == 2) {
      await db.execute(
          '''ALTER TABLE subject ADD COLUMN category TEXT DEFAULT "Semester 1" NOT NULL;''');
      await db.execute(
          '''ALTER TABLE noteCategory ADD COLUMN description TEXT DEFAULT "description" NOT NULL;''');
    }
  }

  Future _onCreate(Database db, int version) async {
    await createTables(db);
    await insertInitialData(db);
  }

  Future<List<SubjectModel>> getSubjectData() async {
    Database db = await instance.database;
    var subjectTable = await db.query('subject', orderBy: 'id');
    List<SubjectModel> subjectList = subjectTable.isNotEmpty
        ? subjectTable.map((e) => SubjectModel.fromMap(e)).toList()
        : [];
    return subjectList;
  }

  Future<List<SubjectModel>> getSubjectsByCategory(String category) async {
    Database db = await instance.database;
    var subjectTable = await db.query('subject',
        orderBy: 'id', where: "category = ?", whereArgs: [category]);
    List<SubjectModel> subjectList = subjectTable.isNotEmpty
        ? subjectTable.map((e) => SubjectModel.fromMap(e)).toList()
        : [];
    return subjectList;
  }

  Future<List<HomeworkModel>> getHomeworkData(String category) async {
    Database db = await instance.database;
    List<HomeworkModel> homeworkList = [];
    if (category == 'All' || category == '') {
      var homeworkTable = await db.query('homework', orderBy: 'id');
      homeworkList = homeworkTable.isNotEmpty
          ? homeworkTable.map((e) => HomeworkModel.fromMap(e)).toList()
          : [];
    } else {
      var homeworkTable = await db.query('homework',
          orderBy: 'id', where: "category = ?", whereArgs: [category]);
      homeworkList = homeworkTable.isNotEmpty
          ? homeworkTable.map((e) => HomeworkModel.fromMap(e)).toList()
          : [];
    }

    return homeworkList;
  }

  Future<List<EventModel>> getEventData(String category) async {
    Database db = await instance.database;
    List<EventModel> eventList;
    if (category == 'All' || category == '') {
      var eventTable = await db.query('event', orderBy: 'id');
      eventList = eventTable.isNotEmpty
          ? eventTable.map((e) => EventModel.fromMap(e)).toList()
          : [];
    } else {
      var eventTable = await db.query('event',
          orderBy: 'id', where: "category = ?", whereArgs: [category]);
      eventList = eventTable.isNotEmpty
          ? eventTable.map((e) => EventModel.fromMap(e)).toList()
          : [];
    }
    return eventList;
  }

  Future<List<TaskModel>> getTaskData(String category) async {
    Database db = await instance.database;
    List<TaskModel> taskList = [];
    if (category == 'All' || category == '') {
      var taskTable = await db.query('task', orderBy: 'id');
      taskList = taskTable.isNotEmpty
          ? taskTable.map((e) => TaskModel.fromMap(e)).toList()
          : [];
    } else {
      var taskTable = await db.query('task',
          orderBy: 'id', where: "category = ?", whereArgs: [category]);

      taskList = taskTable.isNotEmpty
          ? taskTable.map((e) => TaskModel.fromMap(e)).toList()
          : [];
    }
    return taskList;
  }

  Future<List<CategoryModel>> getCategoryData(String table) async {
    Database db = await instance.database;
    var categoryTable = await db.query(table, orderBy: 'id');
    List<CategoryModel> categoryList = categoryTable.isNotEmpty
        ? categoryTable.map((e) => CategoryModel.fromMap(e)).toList()
        : [];
    return categoryList;
  }

  Future<Map<String, List>> getHomeworkPageData(String category) async {
    Map<String, List> data = {};
    List<HomeworkModel> homeworkData = await getHomeworkData(category);
    List<CategoryModel> categoryData =
        await getCategoryData('homeworkCategory');
    data = {'homeworkData': homeworkData, 'categoryData': categoryData};
    return data;
  }

  Future<Map<String, List>> getTaskPageData(String category) async {
    Map<String, List> data = {};
    List<TaskModel> taskData = await getTaskData(category);
    List<CategoryModel> categoryData = await getCategoryData('taskCategory');
    data = {'taskData': taskData, 'categoryData': categoryData};
    return data;
  }

  Future<Map<String, List>> getEventPageData(String category) async {
    Map<String, List> data = {};
    List<EventModel> eventData = await getEventData(category);
    List<CategoryModel> categoryData = await getCategoryData('eventCategory');
    data = {'eventData': eventData, 'categoryData': categoryData};
    return data;
  }

  Future<bool> categoryExists(String table, String category) async {
    Database db = await instance.database;
    var categoryTable = await db.query(table,
        orderBy: 'id', where: "category = ?", whereArgs: [category]);
    return categoryTable.isNotEmpty;
  }

  Future<List<TimetableDataModel>> getTimetableData() async {
    Database db = await instance.database;
    var timeTable = await db.query('timetable', orderBy: 'id');
    List<TimetableDataModel> timeTableData = timeTable.isNotEmpty
        ? timeTable.map((e) => TimetableDataModel.fromMap(e)).toList()
        : [];
    return timeTableData;
  }

  Future<List<ScheduleModel>> getScheduleData() async {
    Database db = await instance.database;
    var scheduleTable = await db.query('schedule', orderBy: 'id');
    List<ScheduleModel> examData = scheduleTable.isNotEmpty
        ? scheduleTable.map((e) => ScheduleModel.fromMap(e)).toList()
        : [];
    return examData;
  }

  Future<List<NoteModel>> getNoteData() async {
    Database db = await instance.database;
    var noteTable = await db.query('note', orderBy: 'id');
    List<NoteModel> noteData = noteTable.isNotEmpty
        ? noteTable.map((e) => NoteModel.fromMap(e)).toList()
        : [];
    return noteData;
  }

  Future<List<NoteModel>> getNotesByCategory(String category) async {
    Database db = await instance.database;
    var noteTable = await db.query('note',
        orderBy: 'id', where: "category = ?", whereArgs: [category]);
    List<NoteModel> noteData = noteTable.isNotEmpty
        ? noteTable.map((e) => NoteModel.fromMap(e)).toList()
        : [];
    return noteData;
  }

  Future<List<NoteCategoryModel>> getNoteCategoryData() async {
    Database db = await instance.database;
    var categoryTable = await db.query('noteCategory', orderBy: 'id');
    List<NoteCategoryModel> categoryList = categoryTable.isNotEmpty
        ? categoryTable.map((e) => NoteCategoryModel.fromMap(e)).toList()
        : [];
    return categoryList;
  }

  Future<List<AbsenceModel>> getAbsenceByCategory(String category) async {
    Database db = await instance.database;
    var absenceTable = await db.query('absence',
        orderBy: 'id', where: "category = ?", whereArgs: [category]);
    List<AbsenceModel> absenceData = absenceTable.isNotEmpty
        ? absenceTable.map((e) => AbsenceModel.fromMap(e)).toList()
        : [];
    return absenceData;
  }

  Future<GradeDataModel> getGradesByCategory(String category) async {
    Database db = await instance.database;
    var table = await db.query('pointGrade',
        orderBy: 'id', where: "category = ?", whereArgs: [category]);
    List<PointGradeModel> pointGradeData = table.isNotEmpty
        ? table.map((e) => PointGradeModel.fromMap(e)).toList()
        : [];
    table = await db.query('letterGrade',
        orderBy: 'id', where: "category = ?", whereArgs: [category]);
    List<LetterGradeModel> letterGradeData = table.isNotEmpty
        ? table.map((e) => LetterGradeModel.fromMap(e)).toList()
        : [];
    table = await db.query('collegeGrade',
        orderBy: 'id', where: "category = ?", whereArgs: [category]);
    List<CollegeGradeModel> collegeGradeData = table.isNotEmpty
        ? table.map((e) => CollegeGradeModel.fromMap(e)).toList()
        : [];
    table = await db.query('highSchoolGrade',
        orderBy: 'id', where: "category = ?", whereArgs: [category]);
    List<HSGradeModel> highSchoolGradeData = table.isNotEmpty
        ? table.map((e) => HSGradeModel.fromMap(e)).toList()
        : [];
    table = await db.query('percentageGrade',
        orderBy: 'id', where: "category = ?", whereArgs: [category]);
    List<PercentageGradeModel> percentageGradeData = table.isNotEmpty
        ? table.map((e) => PercentageGradeModel.fromMap(e)).toList()
        : [];
    return GradeDataModel(
      collegeGradeData: collegeGradeData,
      highSchoolGradeData: highSchoolGradeData,
      letterGradeData: letterGradeData,
      pointGradeData: pointGradeData,
      percentageGradeData: percentageGradeData,
    );
  }

  Future<List<HSGradeModel>> getHighschoolGradeData() async {
    Database db = await instance.database;
    var table = await db.query('highSchoolGrade');
    List<HSGradeModel> highSchoolGradeData = table.isNotEmpty
        ? table.map((e) => HSGradeModel.fromMap(e)).toList()
        : [];
    return highSchoolGradeData;
  }

  Future<List<CollegeGradeModel>> getCollegeGradeData() async {
    Database db = await instance.database;
    var table = await db.query('collegeGrade');
    List<CollegeGradeModel> collegeGradeData = table.isNotEmpty
        ? table.map((e) => CollegeGradeModel.fromMap(e)).toList()
        : [];
    return collegeGradeData;
  }

  Future<List<PercentageGradeModel>> getPercentageGradeData() async {
    Database db = await instance.database;
    var table = await db.query('percentageGrade');
    List<PercentageGradeModel> percentageGradeData = table.isNotEmpty
        ? table.map((e) => PercentageGradeModel.fromMap(e)).toList()
        : [];
    return percentageGradeData;
  }

  Future<List<LetterGradeModel>> getLetterGradeData() async {
    Database db = await instance.database;
    var table = await db.query('letterGrade');
    List<LetterGradeModel> letterGradeData = table.isNotEmpty
        ? table.map((e) => LetterGradeModel.fromMap(e)).toList()
        : [];
    return letterGradeData;
  }

  Future<List<PointGradeModel>> getPointGradeData() async {
    Database db = await instance.database;
    var table = await db.query('pointGrade');
    List<PointGradeModel> pointGradeData = table.isNotEmpty
        ? table.map((e) => PointGradeModel.fromMap(e)).toList()
        : [];
    return pointGradeData;
  }

  Future<List<AbsenceModel>> getAbsenceData() async {
    Database db = await instance.database;
    var absenceTable = await db.query('absence', orderBy: 'id');
    List<AbsenceModel> absenceList = absenceTable.isNotEmpty
        ? absenceTable.map((e) => AbsenceModel.fromMap(e)).toList()
        : [];
    return absenceList;
  }

  Future<List<TeacherModel>> getTeacherData() async {
    Database db = await instance.database;
    var teacherTable = await db.query('teacher', orderBy: 'id');
    List<TeacherModel> teacherList = teacherTable.isNotEmpty
        ? teacherTable.map((e) => TeacherModel.fromMap(e)).toList()
        : [];
    return teacherList;
  }

  Future<Map<String, List>> getHomePageData() async {
    Map<String, List> data = {};
    List homeworkData = await getHomeworkData('');
    List taskData = await getTaskData('');
    List eventData = await getEventData('');
    data = {
      'homework': homeworkData,
      'task': taskData,
      'event': eventData,
    };
    return data;
  }

  Future<int> add({required String table, required var model}) async {
    Database db = await instance.database;
    return await db.insert(table, model.toMap());
  }

  Future remove({required String table, required int id}) async {
    Database db = await instance.database;
    return await db.delete(table, where: 'id = ?', whereArgs: [id]);
  }

  Future removeDataByCategory(
      {required String table, required String category}) async {
    Database db = await instance.database;
    return await db.delete(table, where: 'category = ?', whereArgs: [category]);
  }

  Future update({required String table, required var model}) async {
    Database db = await instance.database;
    return await db
        .update(table, model.toMap(), where: 'id = ?', whereArgs: [model.id]);
  }

  Future getDataById(String table, int id) async {
    Database db = await instance.database;
    var data = await db.query(table, where: "id = ?", whereArgs: [id]);
    var model = convertToModel(data[0], table);
    return model;
  }

  //sets notificationDateTime column to ''. This is triggered once notification has been shown
  Future<void> removeNotification(
      {required String table, required int id}) async {
    Database db = await instance.database;
    var tableData = await db.query(table, where: "id = ?", whereArgs: [id]);
    var data;
    data = Map.of(tableData[0]);
    data['notificationDateTime'] = '';

    await db.update(table, data, where: 'id = ?', whereArgs: [data['id']]);
  }

  convertToModel(var data, String table) {
    var dataModel;
    if (table == 'homework') {
      dataModel = HomeworkModel.fromMap(data);
    } else if (table == 'event') {
      dataModel = EventModel.fromMap(data);
    } else {
      dataModel = TaskModel.fromMap(data);
    }
    return dataModel;
  }

  Future<List<String>> getTeacherNames() async {
    Database db = await instance.database;
    var teacherTable = await db.query('teacher', orderBy: 'id');
    List<String> teacherNameList = teacherTable.isNotEmpty
        ? teacherTable.map((e) => e['name'].toString()).toList()
        : [];
    return teacherNameList;
  }

  Future<List<String>> getSubjects() async {
    Database db = await instance.database;
    var subjectTable = await db.query('subject', orderBy: 'id');
    List<String> subjectList = subjectTable.isNotEmpty
        ? subjectTable.map((e) => e['subject'].toString()).toList()
        : [];
    return subjectList;
  }

  Future<void> insertInitialData(Database db) async {
    await db.insert('taskCategory',
        CategoryModel(id: 1, category: 'Entertainment').toMap());
    await db.insert(
        'taskCategory', CategoryModel(id: 2, category: 'Work').toMap());

    await db.insert(
        'homeworkCategory', CategoryModel(id: 1, category: 'Easy').toMap());
    await db.insert(
        'homeworkCategory', CategoryModel(id: 2, category: 'Urgent').toMap());

    await db.insert(
        'eventCategory', CategoryModel(id: 1, category: 'Ceremony').toMap());
    await db.insert(
        'eventCategory', CategoryModel(id: 2, category: 'Workshop').toMap());

    await db.insert(
        'noteCategory',
        NoteCategoryModel(
                id: 1,
                category: 'Study Notes',
                description: 'College Lecture Notes')
            .toMap());
  }

  Future<void> createTables(Database db) async {
    await db.execute('''
      CREATE TABLE homework(
        id INTEGER PRIMARY KEY,
        subject TEXT,
        teacher TEXT,
        note TEXT,
        type TEXT,
        notificationDateTime TEXT,
        isDone TEXT,
        pickedDateTime TEXT,
        category TEXT
      )
    ''');
    await db.execute('''
      CREATE TABLE event(
        id INTEGER PRIMARY KEY,
        subject TEXT,
        event TEXT,
        location TEXT,
        note TEXT,
        notificationDateTime TEXT,
        isDone TEXT,
        pickedDateTime TEXT,
        category TEXT
      )
    ''');
    await db.execute('''
      CREATE TABLE task(
        id INTEGER PRIMARY KEY,
        task TEXT,
        note TEXT,
        notificationDateTime TEXT,
        isDone TEXT,
        category TEXT,
        pickedDateTime TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE absence(
        id INTEGER PRIMARY KEY,
        subject TEXT,
        note TEXT,
        teacher TEXT,
        room TEXT,
        category TEXT,
        pickedDateTime TEXT
      )
    ''');
    await db.execute('''
      CREATE TABLE teacher(
        id INTEGER PRIMARY KEY,
        name TEXT,
        phone TEXT,
        email TEXT,
        address TEXT,
        officeHours TEXT,
        website TEXT
      )
    ''');
    await db.execute('''
      CREATE TABLE timetable(
        id INTEGER PRIMARY KEY,
        subject TEXT,
        color TEXT,
        room TEXT,
        teacher TEXT,
        note TEXT,
        start TEXT,
        end TEXT
      )
    ''');
    await db.execute('''
      CREATE TABLE schedule(
        id INTEGER PRIMARY KEY,
        subject TEXT,
        color TEXT,
        room TEXT,
        type TEXT,
        teacher TEXT,
        note TEXT,
        start TEXT,
        end TEXT
      )
    ''');
    await db.execute('''
      CREATE TABLE note(
        id INTEGER PRIMARY KEY,
        title TEXT,
        color TEXT,
        description TEXT,
        pickedDateTime TEXT,
        category TEXT
      )
    ''');
    await db.execute('''
      CREATE TABLE noteCategory(
        id INTEGER PRIMARY KEY,
        category TEXT,
        description TEXT
      )
    ''');
    await db.execute('''
      CREATE TABLE taskCategory(
        id INTEGER PRIMARY KEY,
        category TEXT
      )
    ''');
    await db.execute('''
      CREATE TABLE homeworkCategory(
        id INTEGER PRIMARY KEY,
        category TEXT
      )
    ''');
    await db.execute('''
      CREATE TABLE eventCategory(
        id INTEGER PRIMARY KEY,
        category TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE percentageGrade(
        id INTEGER PRIMARY KEY,
        grade TEXT,
        subject TEXT,
        weight TEXT,
        note TEXT,
        pickedDateTime TEXT,
        category TEXT
      )
    ''');
    await db.execute('''
      CREATE TABLE pointGrade(
        id INTEGER PRIMARY KEY,
        grade TEXT,
        subject TEXT,
        maxPoints TEXT,
        note TEXT,
        pickedDateTime TEXT,
        category TEXT
      )
    ''');
    await db.execute('''
      CREATE TABLE letterGrade(
        id INTEGER PRIMARY KEY,
        grade TEXT,
        subject TEXT,
        weight TEXT,
        note TEXT,
        pickedDateTime TEXT,
        category TEXT
      )
    ''');
    await db.execute('''
      CREATE TABLE collegeGrade(
        id INTEGER PRIMARY KEY,
        grade TEXT,
        subject TEXT,
        credit TEXT,
        note TEXT,
        pickedDateTime TEXT,
        category TEXT
      )
    ''');
    await db.execute('''
      CREATE TABLE highSchoolGrade(
        id INTEGER PRIMARY KEY,
        grade TEXT,
        subject TEXT,
        credit TEXT,
        course TEXT,
        note TEXT,
        pickedDateTime TEXT,
        category TEXT
      )
    ''');
    await db.execute('''
      CREATE TABLE subject(
        id INTEGER PRIMARY KEY,
        subject TEXT,
        room TEXT,
        teacher TEXT,
        category TEXT,
        note TEXT
      )
    ''');
  }
}
