// Package imports:
import 'package:permission_handler/permission_handler.dart';

class PermissionsHelper {
  Future<void> requestStorage() async {
    Permission storagePermission = Permission.storage;
    await storagePermission.request();
  }

  Future<bool> canAccessStorage() async {
    PermissionStatus result = await Permission.storage.status;
    return result.isGranted ? true : false;
  }
}
