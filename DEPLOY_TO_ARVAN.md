# راهنمای جامع استقرار سامانه حضور و غیاب دبستان روی ابر آروان (ArvanCloud)

این پروژه شامل دو بخش مجزا است:
1. **بخش بک‌اند (Node.js + Express):** مستقر روی ابر آروان با دیتابیس پایدار و توکن امنیتی JWT.
2. **بخش فرانت‌اند (Flutter):** اپلیکیشن موبایل، وب یا تبلت برای معلمان و کادر مدرسه با تقویم شمسی و رابط کاربری راست‌چین (RTL).

---

## 🚀 روش ۱: استقرار روی سرور ابری آروان (ArvanCloud VPS) - [پیشنهادی]

اگر در ابر آروان یک سرور ابری لینوکس (مثلاً Ubuntu 22.04 یا 24.04) ایجاد کرده‌اید، می‌توانید به یکی از دو روش زیر پروژه را بالا بیاورید:

### شیوه الف) با استفاده از Docker (ساده‌ترین روش)

۱. وارد سرور ابری خود از طریق SSH شوید:
```bash
ssh root@YOUR_ARVAN_SERVER_IP
```

۲. فایل‌های پوشه `backend` را روی سرور آپلود کنید (یا از طریق Git کلون کنید):
```bash
mkdir -p /opt/school-attendance
cd /opt/school-attendance
git clone https://github.com/mahshidgh026/my-project.git .
cp backend/.env.example backend/.env
# مقدار JWT_SECRET را در backend/.env با یک مقدار تصادفی قوی عوض کنید
```

۳. با اجرای دستور زیر با Docker Compose کانتینر را اجرا کنید:
```bash
docker compose up -d --build
```
سرور شما روی پورت داخلی `5000` به صورت پس‌زمینه و همیشه روشن فعال خواهد شد. پورت `5000` را عمومی نکنید؛ دامنه باید از طریق reverse proxy یا Cloud Proxy آروان به آن وصل شود.

---

### شیوه ب) با استفاده از PM2 و Node.js

اگر ترجیح می‌دهید بدون داکر اجرا کنید:

۱. نصب Node.js و PM2 روی سرور:
```bash
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
sudo apt-get install -y nodejs
sudo npm install -g pm2
```

۲. نصب پکیج‌ها و راه‌اندازی سرور با مدیریت دائمی PM2:
```bash
cd /opt/school-attendance
cp backend/.env.example backend/.env
# مقدار JWT_SECRET را در backend/.env با یک مقدار تصادفی قوی عوض کنید
cd backend
npm install --omit=dev
pm2 start server.js --name "school-backend"
pm2 save
pm2 startup
```

---

> **نکته:** فایل‌های قدیمی `setup-server.sh` و `deploy_to_server.sh` از مخزن حذف شده‌اند؛ آن‌ها مربوط به معماری قبلی بودند. برای نسخه فعلی از Docker Compose یا اجرای مستقیم `backend/server.js` استفاده کنید.

## 🧪 بررسی استقرار

پس از اجرای سرویس، این آدرس باید پاسخ `status: ok` بدهد:

```bash
curl http://127.0.0.1:5000/api/health
```

## 🔒 راه‌اندازی دامنه و HTTPS رایگان (SSL) روی آروان

برای اینکه اپلیکیشن بدون مشکل امنیتی به سرور وصل شود:
1. در پنل ابر آروان، دامنه یا زیردامنه خود (مثلاً `school-api.yourdomain.ir`) را به IP سرور ابری متصل کنید و قابلیت CDN یا ابری (Cloud Proxy) را فعال نمایید.
2. با فعال کردن گواهی SSL رایگان ابر آروان، تمام درخواست‌ها به صورت خودکار HTTPS رمزنگاری‌شده خواهند بود.

---

## 📱 اتصال اپلیکیشن فلاتر به سرور ابر آروان

برای متصل کردن اپلیکیشن فلاتر به سرور ابر آروان:

### راهکار اول (از داخل کد):
در فایل `frontend/lib/services/api_service.dart`، متغیر `baseUrl` را تغییر دهید:
```dart
static String baseUrl = const String.fromEnvironment('API_BASE_URL');
// یا با IP مستقیم:
// static String baseUrl = 'http://185.x.x.x:5000/api';
```

### راهکار دوم (از داخل خود برنامه):
در صفحه ورود به سیستم (Login)، آیکون **چرخ‌دنده (تنظیمات)** در بالای صفحه قرار دارد. با کلیک روی آن می‌توانید آدرس سرور آروان خود را به سادگی وارد و ذخیره کنید!

---

## 👥 ایجاد حساب اولیه

فایل `backend/school_data.json` در مخزن به‌صورت خالی نگه داشته شده و حساب پیش‌فرض ندارد. بعد از استقرار، یک حساب مدیر را از مسیر ثبت‌نام وب‌پرتال ایجاد کنید و سپس اطلاعات دسترسی را در اختیار کاربران قرار دهید.

---

## 🖥 نحوه اجرای پروژه فلاتر روی سیستم شما

۱. وارد پوشه `frontend` شوید:
```bash
cd frontend
```

۲. پکیج‌ها را دریافت کنید:
```bash
flutter pub get
```

۳. اجرای برنامه روی شبیه‌ساز، مرورگر یا گوشی:
```bash
flutter run --dart-define=API_BASE_URL=https://api.example.com/api
```
یا کافی است این پوشه را در **VS Code** یا **Android Studio** باز کرده و دکمه **Run** را بزنید.
