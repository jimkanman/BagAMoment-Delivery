
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsUtil {
  static const deliveryIdKey = 'deliveryId';
  static const deliveryReservationIdKey = 'deliveryReservationId';
  static const storageReservationIdKey = 'storageReservationId';

  _SharedPrefsUtil(){}

  /// 배송 ID 저장
  static Future<void> saveDeliveryId(int deliveryId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(deliveryIdKey, deliveryId);
  }

  /// 저장된 배송 ID 가져오기
  static Future<int?> getDeliveryId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(deliveryIdKey);
  }

  /// 배송 ID 삭제
  static Future<void> clearDeliveryId() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(deliveryIdKey);
  }

  static Future<void> save(String key, int value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(key, value);
  }

  static Future<int?> get(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(key);
  }

  static Future<void> clear(String key) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(key);
  }

}
