class CourseModel{
  String? _courseId;
  String? _teacherId;
  String? _teacherName;
  String? _courseName;

  CourseModel(this._courseId, this._teacherId, this._teacherName, this._courseName);

  String? get getTeacherName => _teacherName;

  String? get getTeacherId => _teacherId;

  String? get getCourseId => _courseId;

  String? get getCourseName => _courseName;
}