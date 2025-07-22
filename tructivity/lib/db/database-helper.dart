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
    required T Function(Map<String, dynamic> data, String docId) fromMap,
  }) async {
    Query<Map<String, dynamic>> query = _db.collection(collection);
    if (category != null && category != 'All' && category.isNotEmpty) {
      query = query.where('category', isEqualTo: category);
    }

    final snapshot = await query.get();
    return snapshot.docs.map((doc) {
      return fromMap(doc.data(), doc.id);
    }).toList();
  }

  Future<List<SubjectModel>> getSubjectData() async =>
      _getList('subject', fromMap: (e, id) => SubjectModel.fromMap(e, id));

  Future<List<SubjectModel>> getSubjectsByCategory(String category) async =>
      _getList('subject',
          category: category, fromMap: (e, id) => SubjectModel.fromMap(e, id));

  Future<List<HomeworkModel>> getHomeworkData(String category) async =>
      _getList('homework',
          category: category, fromMap: (e, id) => HomeworkModel.fromMap(e, id));

  Future<List<EventModel>> getEventData(String category) async =>
      _getList('event',
          category: category, fromMap: (e, id) => EventModel.fromMap(e, id));

  Future<List<TaskModel>> getTaskData(String category) async => _getList('task',
      category: category, fromMap: (e, id) => TaskModel.fromMap(e, id));

  Future<List<CategoryModel>> getCategoryData(String collection) async =>
      _getList(collection, fromMap: (e, id) => CategoryModel.fromMap(e, id));

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
      _getList('timetable', fromMap: (e, id) => TimetableDataModel.fromMap(e, id));

  Future<List<ScheduleModel>> getScheduleData() async =>
      _getList('schedule', fromMap: (e, id) => ScheduleModel.fromMap(e, id));

  Future<List<NoteModel>> getNoteData() async =>
      _getList('note', fromMap: (e, id) => NoteModel.fromMap(e, id));

  Future<List<NoteModel>> getNotesByCategory(String category) async =>
      _getList('note',
          category: category, fromMap: (e, id) => NoteModel.fromMap(e, id));

  Future<List<NoteCategoryModel>> getNoteCategoryData() async =>
      _getList('noteCategory', fromMap: (e, id) => NoteCategoryModel.fromMap(e, id));

  Future<List<AbsenceModel>> getAbsenceByCategory(String category) async =>
      _getList('absence',
          category: category, fromMap: (e, id) => AbsenceModel.fromMap(e, id));

  Future<List<AbsenceModel>> getAbsenceData() async =>
      _getList('absence', fromMap: (e, id) => AbsenceModel.fromMap(e, id));

  Future<List<TeacherModel>> getTeacherData() async {
    try {
      final snapshot = await _db.collection('teacher').get();
      return snapshot.docs
          .map((doc) => TeacherModel.fromMap(doc.data(), doc.id))
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
    try {
      if (model.id != null) {
        // If ID is provided, use it as document ID
        await _db.collection(table).doc(model.id).set(model.toMap());
      } else {
        // If no ID, let Firestore generate one
        DocumentReference docRef = await _db.collection(table).add(model.toMap());
        // Update the model with the new ID if needed
        if (model is dynamic && model.id == null) {
          model.id = docRef.id;
        }
      }
      return 1;
    } catch (e) {
      print("Error adding document: $e");
      return 0;
    }
  }

  Future<int> update({required String table, required dynamic model}) async {
    try {
      if (model.id == null) {
        print("Cannot update document without ID");
        return 0;
      }
      
      await _db.collection(table).doc(model.id).set(
            model.toMap(),
            SetOptions(merge: true),
          );
      return 1;
    } catch (e) {
      print("Error updating document: $e");
      return 0;
    }
  }

  Future<int> remove({required String table, required String id}) async {
    try {
      await _db.collection(table).doc(id).delete();
      return 1;
    } catch (e) {
      print("Error removing document: $e");
      return 0;
    }
  }

  Future<int> removeDataByCategory({
    required String table,
    required String category,
  }) async {
    try {
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
    } catch (e) {
      print("Error removing data by category: $e");
      return 0;
    }
  }

  Future getDataById(String table, String id) async {
    try {
      final doc = await _db.collection(table).doc(id).get();
      final data = doc.data();
      if (data == null) return null;
      return convertToModel(data, table, id);
    } catch (e) {
      print("Error getting document by ID: $e");
      return null;
    }
  }

  Future<void> removeNotification({
    required String table,
    required String id,
  }) async {
    try {
      final doc = await _db.collection(table).doc(id).get();
      final data = doc.data();
      if (data != null) {
        data['notificationDateTime'] = '';
        await _db.collection(table).doc(id).set(data);
      }
    } catch (e) {
      print("Error removing notification: $e");
    }
  }

  dynamic convertToModel(Map<String, dynamic> data, String table, String docId) {
    switch (table) {
      case 'homework':
        return HomeworkModel.fromMap(data, docId);
      case 'event':
        return EventModel.fromMap(data, docId);
      case 'task':
      default:
        return TaskModel.fromMap(data, docId);
    }
  }

  Future<List<String>> getTeacherNames() async {
    try {
      final snapshot = await _db.collection('teacher').get();
      return snapshot.docs.map((e) => e.data()['name'].toString()).toList();
    } catch (e) {
      print("Error getting teacher names: $e");
      return [];
    }
  }

  Future<List<String>> getSubjects() async {
    try {
      final snapshot = await _db.collection('subject').get();
      return snapshot.docs.map((e) => e.data()['subject'].toString()).toList();
    } catch (e) {
      print("Error getting subjects: $e");
      return [];
    }
  }

  Future<GradeDataModel> getGradesByCategory(String category) async {
    Future<List<T>> fetch<T>(
        String collection, T Function(Map<String, dynamic>, String) fromMap) async {
      final snap = await _db
          .collection(collection)
          .where('category', isEqualTo: category)
          .get();
      return snap.docs
          .map((d) => fromMap(d.data(), d.id))
          .toList();
    }

    return GradeDataModel(
      collegeGradeData:
          await fetch('collegeGrade', (e, id) => CollegeGradeModel.fromMap(e, id)),
      highSchoolGradeData:
          await fetch('highSchoolGrade', (e, id) => HSGradeModel.fromMap(e, id)),
      letterGradeData:
          await fetch('letterGrade', (e, id) => LetterGradeModel.fromMap(e, id)),
      pointGradeData:
          await fetch('pointGrade', (e, id) => PointGradeModel.fromMap(e, id)),
      percentageGradeData: await fetch(
          'percentageGrade', (e, id) => PercentageGradeModel.fromMap(e, id)),
    );
  }
}
