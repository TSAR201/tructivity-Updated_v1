// Firestore-based replacement for your original DatabaseHelper
// Keeps the method signatures intact to avoid any UI changes

import 'package:cloud_firestore/cloud_firestore.dart';
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

class DatabaseHelper {
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<List<T>> _getList<T>(
    String collection, {
    String? category,
    required T Function(Map<String, dynamic> data) fromMap,
  }) async {
    Query<Map<String, dynamic>> query = _db.collection(collection);
    if (category != null && category != 'All' && category.isNotEmpty) {
      query = query.where('category', isEqualTo: category);
    }
    query = query.orderBy('id');

    final snapshot = await query.get();
    return snapshot.docs.map((doc) {
      final data = doc.data();
      data['id'] = int.tryParse(doc.id) ?? doc.id;
      return fromMap(data);
    }).toList();
  }

  Future<List<SubjectModel>> getSubjectData() async =>
      _getList('subject', fromMap: (e) => SubjectModel.fromMap(e));

  Future<List<SubjectModel>> getSubjectsByCategory(String category) async =>
      _getList('subject',
          category: category, fromMap: (e) => SubjectModel.fromMap(e));

  Future<List<HomeworkModel>> getHomeworkData(String category) async =>
      _getList('homework',
          category: category, fromMap: (e) => HomeworkModel.fromMap(e));

  Future<List<EventModel>> getEventData(String category) async =>
      _getList('event',
          category: category, fromMap: (e) => EventModel.fromMap(e));

  Future<List<TaskModel>> getTaskData(String category) async => _getList('task',
      category: category, fromMap: (e) => TaskModel.fromMap(e));

  Future<List<CategoryModel>> getCategoryData(String collection) async =>
      _getList(collection, fromMap: (e) => CategoryModel.fromMap(e));

  Future<Map<String, List>> getHomeworkPageData(String category) async => {
        'homeworkData': await getHomeworkData(category),
        'categoryData': await getCategoryData('homeworkCategory')
      };

  Future<Map<String, List>> getTaskPageData(String category) async => {
        'taskData': await getTaskData(category),
        'categoryData': await getCategoryData('taskCategory')
      };

  Future<Map<String, List>> getEventPageData(String category) async => {
        'eventData': await getEventData(category),
        'categoryData': await getCategoryData('eventCategory')
      };

  Future<bool> categoryExists(String collection, String category) async {
    final snapshot = await _db
        .collection(collection)
        .where('category', isEqualTo: category)
        .get();
    return snapshot.docs.isNotEmpty;
  }

  Future<List<TimetableDataModel>> getTimetableData() async =>
      _getList('timetable', fromMap: (e) => TimetableDataModel.fromMap(e));

  Future<List<ScheduleModel>> getScheduleData() async =>
      _getList('schedule', fromMap: (e) => ScheduleModel.fromMap(e));

  Future<List<NoteModel>> getNoteData() async =>
      _getList('note', fromMap: (e) => NoteModel.fromMap(e));

  Future<List<NoteModel>> getNotesByCategory(String category) async =>
      _getList('note',
          category: category, fromMap: (e) => NoteModel.fromMap(e));

  Future<List<NoteCategoryModel>> getNoteCategoryData() async =>
      _getList('noteCategory', fromMap: (e) => NoteCategoryModel.fromMap(e));

  Future<List<AbsenceModel>> getAbsenceByCategory(String category) async =>
      _getList('absence',
          category: category, fromMap: (e) => AbsenceModel.fromMap(e));

  Future<List<AbsenceModel>> getAbsenceData() async =>
      _getList('absence', fromMap: (e) => AbsenceModel.fromMap(e));

  Future<List<TeacherModel>> getTeacherData() async {
    try {
      final snapshot =
          await FirebaseFirestore.instance.collection('teacher').get();

      return snapshot.docs
          .map((doc) => TeacherModel.fromMap({
                ...doc.data(),
                'id': doc.id, // ← ✅ Inject document ID here
              }))
          .toList();
    } catch (e) {
      print("Error fetching teacher data: $e");
      return [];
    }
  }

  Future<Map<String, List>> getHomePageData() async => {
        'homework': await getHomeworkData(''),
        'task': await getTaskData(''),
        'event': await getEventData(''),
      };

  Future<int> add({required String table, required dynamic model}) async {
    final ref = _db.collection(table).doc(model.id?.toString());
    await ref.set(model.toMap());
    return 1;
  }

  Future<int> update({required String table, required dynamic model}) async {
    await _db.collection(table).doc(model.id.toString()).set(
          model.toMap(),
          SetOptions(merge: true),
        );
    return 1;
  }

  Future<int> remove({required String table, required int id}) async {
    await _db.collection(table).doc(id.toString()).delete();
    return 1;
  }

  Future<int> removeDataByCategory({
    required String table,
    required String category,
  }) async {
    final snapshot = await _db
        .collection(table)
        .where('category', isEqualTo: category)
        .get();
    final batch = _db.batch();
    for (var doc in snapshot.docs) {
      batch.delete(doc.reference);
    }
    await batch.commit();
    return 1;
  }

  Future getDataById(String table, int id) async {
    final doc = await _db.collection(table).doc(id.toString()).get();
    final data = doc.data();
    if (data == null) return null;
    data['id'] = id;
    return convertToModel(data, table);
  }

  Future<void> removeNotification({
    required String table,
    required int id,
  }) async {
    final doc = await _db.collection(table).doc(id.toString()).get();
    final data = doc.data();
    if (data != null) {
      data['notificationDateTime'] = '';
      await _db.collection(table).doc(id.toString()).set(data);
    }
  }

  dynamic convertToModel(Map<String, dynamic> data, String table) {
    switch (table) {
      case 'homework':
        return HomeworkModel.fromMap(data);
      case 'event':
        return EventModel.fromMap(data);
      case 'task':
      default:
        return TaskModel.fromMap(data);
    }
  }

  Future<List<String>> getTeacherNames() async {
    final snapshot = await _db.collection('teacher').orderBy('id').get();
    return snapshot.docs.map((e) => e.data()['name'].toString()).toList();
  }

  Future<List<String>> getSubjects() async {
    final snapshot = await _db.collection('subject').orderBy('id').get();
    return snapshot.docs.map((e) => e.data()['subject'].toString()).toList();
  }

  Future<GradeDataModel> getGradesByCategory(String category) async {
    Future<List<T>> fetch<T>(
        String collection, T Function(Map<String, dynamic>) fromMap) async {
      final snap = await _db
          .collection(collection)
          .where('category', isEqualTo: category)
          .orderBy('id')
          .get();
      return snap.docs
          .map((d) => fromMap({...d.data(), 'id': int.tryParse(d.id) ?? d.id}))
          .toList();
    }

    return GradeDataModel(
      collegeGradeData:
          await fetch('collegeGrade', (e) => CollegeGradeModel.fromMap(e)),
      highSchoolGradeData:
          await fetch('highSchoolGrade', (e) => HSGradeModel.fromMap(e)),
      letterGradeData:
          await fetch('letterGrade', (e) => LetterGradeModel.fromMap(e)),
      pointGradeData:
          await fetch('pointGrade', (e) => PointGradeModel.fromMap(e)),
      percentageGradeData: await fetch(
          'percentageGrade', (e) => PercentageGradeModel.fromMap(e)),
    );
  }
}
