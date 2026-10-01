# Frontend

این پوشه شامل رابط‌های کاربری سامانه است:

- `lib/`: اپلیکیشن Flutter شامل مدل‌ها، providerها، صفحه‌ها، سرویس API و ویجت‌ها
- `pubspec.yaml`: وابستگی‌ها و تنظیمات پروژه Flutter
- `web_portal/`: نسخه وب مستقل سامانه که توسط بک‌اند سرو می‌شود

## اجرای اپلیکیشن Flutter

```bash
cd frontend
flutter pub get
flutter run
```

## مسیر وب‌پرتال

وب‌پرتال از طریق بک‌اند در مسیرهای `/`، `/admin` و `/teacher` ارائه می‌شود. فایل اصلی آن در `frontend/web_portal/index.html` قرار دارد.
