import 'dart:typed_data';

import 'package:health_repository/health_repository.dart';

abstract class HealthRepository {
  Future<List<Health>> getMyHealth(DateTime date);

  Future<void> setHealth(Health health, {List<int>? imageSrc});

  Future<void> removeHealth(String healthId);

  Future<Health> addHealth(Health health, {List<int>? imageSrc});

  Future<Health> getHealth(String healthId);

  Future<Uint8List?> getImage(String userId);
}