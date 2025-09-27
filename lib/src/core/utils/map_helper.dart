import 'package:url_launcher/url_launcher.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class MapHelper {
  /// فتح الخرائط بالعنوان المحدد
  static Future<void> openMapWithAddress(String address) async {
    try {
      final encodedAddress = Uri.encodeComponent(address);

      // جرب فتح Google Maps أولاً
      final googleMapsUrl = Uri.parse(
        'https://www.google.com/maps/search/?api=1&query=$encodedAddress',
      );

      if (await canLaunchUrl(googleMapsUrl)) {
        await launchUrl(googleMapsUrl, mode: LaunchMode.externalApplication);
      } else {
        // إذا فشل، جرب Apple Maps (للـ iOS)
        final appleMapsUrl = Uri.parse(
          'https://maps.apple.com/?q=$encodedAddress',
        );
        if (await canLaunchUrl(appleMapsUrl)) {
          await launchUrl(appleMapsUrl, mode: LaunchMode.externalApplication);
        } else {
          throw 'لا يمكن فتح تطبيق الخرائط';
        }
      }
    } catch (e) {
      throw 'خطأ في فتح الخرائط: $e';
    }
  }

  /// فتح الخرائط بالإحداثيات
  static Future<void> openMapWithCoordinates(
    double latitude,
    double longitude,
  ) async {
    try {
      // جرب فتح Google Maps أولاً
      final googleMapsUrl = Uri.parse(
        'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude',
      );

      if (await canLaunchUrl(googleMapsUrl)) {
        await launchUrl(googleMapsUrl, mode: LaunchMode.externalApplication);
      } else {
        // إذا فشل، جرب Apple Maps
        final appleMapsUrl = Uri.parse(
          'https://maps.apple.com/?q=$latitude,$longitude',
        );
        if (await canLaunchUrl(appleMapsUrl)) {
          await launchUrl(appleMapsUrl, mode: LaunchMode.externalApplication);
        } else {
          throw 'لا يمكن فتح تطبيق الخرائط';
        }
      }
    } catch (e) {
      throw 'خطأ في فتح الخرائط: $e';
    }
  }

  /// الحصول على الموقع الحالي
  static Future<Position> getCurrentLocation() async {
    try {
      bool serviceEnabled;
      LocationPermission permission;

      // التحقق من تفعيل خدمات الموقع
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        // محاولة فتح إعدادات الموقع
        bool opened = await Geolocator.openLocationSettings();
        if (!opened) {
          throw 'خدمات الموقع غير مفعلة. يرجى تفعيلها من الإعدادات';
        }
        // إعادة التحقق بعد محاولة الفتح
        serviceEnabled = await Geolocator.isLocationServiceEnabled();
        if (!serviceEnabled) {
          throw 'خدمات الموقع غير مفعلة';
        }
      }

      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw 'تم رفض إذن الوصول للموقع';
        }
      }

      if (permission == LocationPermission.deniedForever) {
        // محاولة فتح إعدادات التطبيق
        bool opened = await Geolocator.openAppSettings();
        if (opened) {
          throw 'تم رفض إذن الوصول للموقع نهائياً. يرجى السماح بالوصول للموقع من إعدادات التطبيق';
        } else {
          throw 'تم رفض إذن الوصول للموقع نهائياً';
        }
      }

      return await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: 10,
        ),
      );
    } catch (e) {
      if (e.toString().contains('PlatformException') ||
          e.toString().contains('MissingPluginException')) {
        throw 'خطأ في النظام: تأكد من إعطاء الصلاحيات المطلوبة للتطبيق';
      }
      rethrow;
    }
  }

  /// تحويل الإحداثيات إلى عنوان
  static Future<String> getAddressFromCoordinates(
    double latitude,
    double longitude,
  ) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        latitude,
        longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];

        // تكوين العنوان بالشكل المطلوب
        String street = place.street ?? '';
        String locality = place.locality ?? '';
        String administrativeArea = place.administrativeArea ?? '';

        // إنشاء العنوان بالتنسيق المطلوب
        List<String> addressParts = [];

        if (street.isNotEmpty) addressParts.add(street);
        if (locality.isNotEmpty) addressParts.add(locality);
        if (administrativeArea.isNotEmpty && administrativeArea != locality) {
          addressParts.add(administrativeArea);
        }

        String address = addressParts.join(', ');

        return address.isNotEmpty ? address : 'عنوان غير محدد';
      } else {
        return 'عنوان غير محدد';
      }
    } catch (e) {
      throw 'خطأ في الحصول على العنوان: $e';
    }
  }

  /// تحويل العنوان إلى إحداثيات
  static Future<Position> getCoordinatesFromAddress(String address) async {
    try {
      List<Location> locations = await locationFromAddress(address);

      if (locations.isNotEmpty) {
        Location location = locations[0];
        return Position(
          longitude: location.longitude,
          latitude: location.latitude,
          timestamp: DateTime.now(),
          accuracy: 0,
          altitude: 0,
          altitudeAccuracy: 0,
          heading: 0,
          headingAccuracy: 0,
          speed: 0,
          speedAccuracy: 0,
        );
      } else {
        throw 'لم يتم العثور على الموقع';
      }
    } catch (e) {
      throw 'خطأ في الحصول على الإحداثيات: $e';
    }
  }
}
