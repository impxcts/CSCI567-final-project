import 'package:cloud_firestore/cloud_firestore.dart';

/// Where a study group is in its life cycle.
/// `active` means the organizer has checked in with a photo.
enum GroupStatus { scheduled, active, ended }

/// One "looking for group" post, stored in the `study_groups` collection.
class StudyGroup {
  const StudyGroup({
    required this.id,
    required this.classCode,
    required this.title,
    required this.locationName,
    required this.location,
    required this.startTime,
    required this.organizerId,
    required this.organizerName,
    this.memberIds = const [],
    this.status = GroupStatus.scheduled,
    this.checkInPhotoUrl,
  });

  final String id;
  final String classCode; // e.g. "CSCI 567"
  final String title; // e.g. "Midterm review"
  final String locationName; // e.g. "Library, 3rd floor"
  final GeoPoint? location; // coordinates used for distance + check-in checks
  final DateTime startTime;
  final String organizerId;
  final String organizerName;
  final List<String> memberIds;
  final GroupStatus status;
  final String? checkInPhotoUrl;

  bool get isCheckedIn => status == GroupStatus.active;

  factory StudyGroup.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? <String, dynamic>{};
    return StudyGroup(
      id: doc.id,
      classCode: data['classCode'] as String? ?? '',
      title: data['title'] as String? ?? '',
      locationName: data['locationName'] as String? ?? '',
      location: data['location'] as GeoPoint?,
      startTime:
          (data['startTime'] as Timestamp?)?.toDate() ?? DateTime.now(),
      organizerId: data['organizerId'] as String? ?? '',
      organizerName: data['organizerName'] as String? ?? '',
      memberIds: List<String>.from(data['memberIds'] as List? ?? const []),
      status: GroupStatus.values.asNameMap()[data['status']] ??
          GroupStatus.scheduled,
      checkInPhotoUrl: data['checkInPhotoUrl'] as String?,
    );
  }

  Map<String, dynamic> toMap() => {
        'classCode': classCode,
        'title': title,
        'locationName': locationName,
        'location': location,
        'startTime': Timestamp.fromDate(startTime),
        'organizerId': organizerId,
        'organizerName': organizerName,
        'memberIds': memberIds,
        'status': status.name,
        'checkInPhotoUrl': checkInPhotoUrl,
        'createdAt': FieldValue.serverTimestamp(),
      };
}
