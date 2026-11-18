// Tests for the sign-up/login form checks. These don't need Firebase,
// so `flutter test` runs them anywhere.
import 'package:flutter_test/flutter_test.dart';
import 'package:studyspot/utils/validators.dart';

void main() {
  group('Validators.email', () {
    test('rejects empty and malformed emails', () {
      expect(Validators.email(''), isNotNull);
      expect(Validators.email('jesse'), isNotNull);
      expect(Validators.email('jesse@school'), isNotNull);
    });

    test('accepts a normal email', () {
      expect(Validators.email('jesse@school.edu'), isNull);
      expect(Validators.email('  jesse@school.edu  '), isNull);
    });
  });

  group('Validators.password', () {
    test('requires at least 6 characters', () {
      expect(Validators.password(''), isNotNull);
      expect(Validators.password('12345'), isNotNull);
      expect(Validators.password('123456'), isNull);
    });
  });

  group('Validators.name', () {
    test('rejects blank names', () {
      expect(Validators.name('   '), isNotNull);
      expect(Validators.name('Jesse'), isNull);
    });
  });
}
