#!/bin/bash
mkdir -p /opt/school-attendance
cat << 'EOF_HTML' > /opt/school-attendance/index.html
<!DOCTYPE html>
<html lang="fa" dir="rtl">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>سامانه هوشمند حضور و غیاب دبستان دخترانه پرنیان</title>
  <script src="https://www.gstatic.com/antigravity/web/dev/tailwindcss.min.js"></script>
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Vazirmatn:wght@300;400;500;600;700;800;900&display=swap" rel="stylesheet">
  <style>
    body {
      font-family: 'Vazirmatn', -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
    }
    @media print {
      .no-print {
        display: none !important;
      }
      .print-only {
        display: block !important;
      }
      body {
        background-color: white !important;
        color: black !important;
        padding: 0 !important;
      }
    }
    .print-only {
      display: none;
    }
    ::-webkit-scrollbar {
      width: 6px;
      height: 6px;
    }
    ::-webkit-scrollbar-track {
      background: #f1f5f9;
    }
    ::-webkit-scrollbar-thumb {
      background: #cbd5e1;
      border-radius: 9999px;
    }
    ::-webkit-scrollbar-thumb:hover {
      background: #94a3b8;
    }
  </style>
</head>
<body class="bg-slate-50 text-slate-800 min-h-screen flex flex-col antialiased selection:bg-pink-200 selection:text-pink-900">

  <!-- ============================================================== -->
  <!-- 1. HEADER & TOP NAVIGATION                                      -->
  <!-- ============================================================== -->
  <header class="no-print bg-gradient-to-r from-purple-700 via-indigo-600 to-pink-600 text-white shadow-lg sticky top-0 z-40">
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-3.5">
      <div class="flex items-center justify-between">
        
        <!-- School Brand -->
        <div class="flex items-center space-x-reverse space-x-3.5 cursor-pointer" onclick="navigate('dashboard')">
          <div class="w-11 h-11 rounded-2xl bg-white/20 backdrop-blur-md border border-white/30 flex items-center justify-center text-2xl shadow-inner transform transition hover:scale-105">
            🌸
          </div>
          <div>
            <div class="flex items-center gap-2">
              <h1 class="font-extrabold text-base sm:text-lg tracking-tight">دبستان دخترانه پرنیان</h1>
              <span class="text-[10px] bg-pink-500/40 border border-pink-300/40 text-pink-100 px-2 py-0.5 rounded-full font-bold">دوره اول و دوم</span>
            </div>
            <p class="text-xs text-purple-100/90 font-medium">سامانه هوشمند ثبت، پیگیری و تحلیل حضور و غیاب کلاسی</p>
          </div>
        </div>

        <!-- Center: Date & Time Display -->
        <div class="hidden md:flex items-center gap-3 bg-white/10 backdrop-blur-md px-4 py-1.5 rounded-xl border border-white/20 text-xs text-white">
          <span class="flex items-center gap-1.5">
            <svg class="w-4 h-4 text-purple-200" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z"></path></svg>
            <span id="headerLiveDate" class="font-bold">امروز</span>
          </span>
          <span class="text-white/40">|</span>
          <span class="flex items-center gap-1.5">
            <svg class="w-4 h-4 text-pink-200" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z"></path></svg>
            <span id="headerLiveTime" class="font-semibold font-mono">08:00</span>
          </span>
        </div>

        <!-- Left Actions: User Profile & Connection Status -->
        <div class="flex items-center gap-3">
          <div id="connectionBadge" class="hidden sm:inline-flex items-center px-2.5 py-1 rounded-full text-xs font-semibold bg-emerald-500/20 text-emerald-100 border border-emerald-400/30">
            <span class="w-2 h-2 rounded-full bg-emerald-400 ml-1.5 animate-pulse"></span>
            <span id="connectionText">سرور فعال</span>
          </div>

          <div id="userProfileArea" class="flex items-center gap-2"></div>
        </div>

      </div>

      <!-- Navigation Bar -->
      <nav id="mainNav" class="mt-3 pt-2.5 border-t border-white/15 flex items-center justify-between gap-2 overflow-x-auto text-xs sm:text-sm font-semibold">
        <div class="flex items-center gap-1 sm:gap-2">
          <button id="navDashboard" onclick="navigate('dashboard')" class="nav-btn px-3 py-1.5 rounded-lg transition-all flex items-center gap-1.5 bg-white text-purple-900 shadow-sm font-bold">
            <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 6a2 2 0 012-2h2a2 2 0 012 2v2a2 2 0 01-2 2H6a2 2 0 01-2-2V6zM14 6a2 2 0 012-2h2a2 2 0 012 2v2a2 2 0 01-2 2h-2a2 2 0 01-2-2V6zM4 16a2 2 0 012-2h2a2 2 0 012 2v2a2 2 0 01-2 2H6a2 2 0 01-2-2v-2zM14 16a2 2 0 012-2h2a2 2 0 012 2v2a2 2 0 01-2 2h-2a2 2 0 01-2-2v-2z"></path></svg>
            <span>داشبورد مدیر و کادر</span>
          </button>
          <button id="navTeacher" onclick="navigate('teacher')" class="nav-btn px-3 py-1.5 rounded-lg transition-all flex items-center gap-1.5 text-white/90 hover:bg-white/10 hover:text-white">
            <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M11 5H6a2 2 0 00-2 2v11a2 2 0 002 2h11a2 2 0 002-2v-5m-1.414-9.414a2 2 0 112.828 2.828L11.828 15H9v-2.828l8.586-8.586z"></path></svg>
            <span>دفتر حضور غیاب معلم</span>
          </button>
          <button id="navAbsentees" onclick="navigate('absentees')" class="nav-btn px-3 py-1.5 rounded-lg transition-all flex items-center gap-1.5 text-white/90 hover:bg-white/10 hover:text-white">
            <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-3L13.732 4c-.77-1.333-2.694-1.333-3.464 0L3.34 16c-.77 1.333.192 3 1.732 3z"></path></svg>
            <span>لیست غایبین روز و تماس با اولیا</span>
            <span id="navAbsenteesCount" class="bg-rose-500 text-white text-[11px] font-bold px-1.5 py-0.2 rounded-full">۰</span>
          </button>
          <button id="navStudents" onclick="navigate('students')" class="nav-btn px-3 py-1.5 rounded-lg transition-all flex items-center gap-1.5 text-white/90 hover:bg-white/10 hover:text-white">
            <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4.354a4 4 0 110 5.292M15 21H3v-1a6 6 0 0112 0v1zm0 0h6v-1a6 6 0 00-9-5.197M13 7a4 4 0 11-8 0 4 4 0 018 0z"></path></svg>
            <span>مدیریت دانش‌آموزان و کلاس‌ها</span>
          </button>
        </div>

        <div class="flex items-center gap-2 text-white">
          <label class="text-xs text-purple-100 hidden sm:inline">تاریخ:</label>
          <input type="text" id="activeDateInput" onchange="changeActiveDate(this.value)" value="1403/07/04" class="bg-white/20 backdrop-blur-md text-white border border-white/30 rounded-lg text-xs px-2.5 py-1 font-semibold focus:outline-none focus:ring-2 focus:ring-white w-28 text-center font-mono">
        </div>
      </nav>
    </div>
  </header>

  <!-- ============================================================== -->
  <!-- MAIN CONTENT CONTAINER                                         -->
  <!-- ============================================================== -->
  <main class="flex-1 max-w-7xl w-full mx-auto px-4 sm:px-6 lg:px-8 py-6">

    <!-- ============================================================ -->
    <!-- VIEW 1: PRINCIPAL / ADMIN DASHBOARD                          -->
    <!-- ============================================================ -->
    <section id="viewDashboard" class="space-y-6">
      
      <!-- Top Overview Banner -->
      <div class="bg-gradient-to-l from-purple-500 via-indigo-600 to-purple-800 text-white rounded-3xl p-6 shadow-md relative overflow-hidden">
        <div class="absolute -right-10 -bottom-10 w-44 h-44 bg-white/10 rounded-full blur-2xl pointer-events-none"></div>
        <div class="flex flex-col md:flex-row md:items-center justify-between gap-4 relative z-10">
          <div>
            <div class="inline-flex items-center gap-2 bg-white/20 backdrop-blur-md px-3 py-1 rounded-full text-xs font-semibold mb-2 text-purple-100">
              <span>📊 گزارش تجمیعی حضور و غیاب دبستان دخترانه پرنیان</span>
              <span>•</span>
              <span id="dashTodayPersianDate">تاریخ روز</span>
            </div>
            <h2 class="text-2xl sm:text-3xl font-extrabold tracking-tight">میزان حضور کل مدرسه: <span id="dashTotalPercent" class="text-emerald-300">۰٪</span></h2>
            <p class="text-purple-100 text-sm mt-1">تعداد کل دانش‌آموزان ثبت‌شده: <span id="dashTotalStudentsCount" class="font-bold">۰</span> نفر در <span id="dashTotalClassesCount" class="font-bold">۰</span> کلاس</p>
          </div>

          <div class="flex flex-wrap items-center gap-2.5">
            <button onclick="window.print()" class="px-4 py-2 rounded-xl bg-white/15 hover:bg-white/25 border border-white/30 text-white font-bold text-xs sm:text-sm flex items-center gap-2 transition">
              <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 17h2a2 2 0 002-2v-4a2 2 0 00-2-2H5a2 2 0 00-2 2v4a2 2 0 002 2h2m2 4h6a2 2 0 002-2v-4a2 2 0 00-2-2H9a2 2 0 00-2 2v4a2 2 0 002 2zm8-12V5a2 2 0 00-2-2H9a2 2 0 00-2 2v4h10z"></path></svg>
              <span>چاپ فرم رسمی (PDF)</span>
            </button>
            <button onclick="exportToCsv()" class="px-4 py-2 rounded-xl bg-emerald-500 hover:bg-emerald-600 text-white font-bold text-xs sm:text-sm flex items-center gap-2 shadow-sm transition">
              <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 16v1a3 3 0 003 3h10a3 3 0 003-3v-1m-4-4l-4 4m0 0l-4-4m4 4V4"></path></svg>
              <span>خروجی اکسل (Excel)</span>
            </button>
          </div>
        </div>

        <div class="mt-5 w-full bg-white/20 rounded-full h-3 overflow-hidden backdrop-blur-sm p-0.5">
          <div id="dashProgressBar" class="bg-gradient-to-r from-emerald-400 to-teal-300 h-full rounded-full transition-all duration-700 shadow-sm" style="width: 0%;"></div>
        </div>
      </div>

      <!-- KPI Stat Cards -->
      <div class="grid grid-cols-2 lg:grid-cols-4 gap-4 sm:gap-5">
        <div class="bg-white rounded-2xl p-4 sm:p-5 border border-emerald-100 shadow-sm flex items-center justify-between hover:shadow-md transition">
          <div>
            <p class="text-xs sm:text-sm text-slate-500 font-semibold">حاضرین در کلاس</p>
            <h3 id="statPresentCount" class="text-2xl sm:text-3xl font-extrabold text-emerald-600 mt-1">۰</h3>
            <span class="text-[11px] text-emerald-700 font-medium">دانش‌آموز حاضر</span>
          </div>
          <div class="w-12 h-12 rounded-2xl bg-emerald-50 text-emerald-600 flex items-center justify-center text-xl">✅</div>
        </div>

        <div class="bg-white rounded-2xl p-4 sm:p-5 border border-rose-100 shadow-sm flex items-center justify-between hover:shadow-md transition cursor-pointer" onclick="navigate('absentees')">
          <div>
            <p class="text-xs sm:text-sm text-slate-500 font-semibold">غایب غیرموجه</p>
            <h3 id="statAbsentUnexcusedCount" class="text-2xl sm:text-3xl font-extrabold text-rose-600 mt-1">۰</h3>
            <span class="text-[11px] text-rose-700 font-medium">نیازمند پیگیری با اولیا</span>
          </div>
          <div class="w-12 h-12 rounded-2xl bg-rose-50 text-rose-600 flex items-center justify-center text-xl">🚨</div>
        </div>

        <div class="bg-white rounded-2xl p-4 sm:p-5 border border-sky-100 shadow-sm flex items-center justify-between hover:shadow-md transition">
          <div>
            <p class="text-xs sm:text-sm text-slate-500 font-semibold">غایب موجه (پزشکی)</p>
            <h3 id="statAbsentExcusedCount" class="text-2xl sm:text-3xl font-extrabold text-sky-600 mt-1">۰</h3>
            <span class="text-[11px] text-sky-700 font-medium">با هماهنگی قبلی</span>
          </div>
          <div class="w-12 h-12 rounded-2xl bg-sky-50 text-sky-600 flex items-center justify-center text-xl">🩺</div>
        </div>

        <div class="bg-white rounded-2xl p-4 sm:p-5 border border-amber-100 shadow-sm flex items-center justify-between hover:shadow-md transition">
          <div>
            <p class="text-xs sm:text-sm text-slate-500 font-semibold">تأخیر ورود</p>
            <h3 id="statLateCount" class="text-2xl sm:text-3xl font-extrabold text-amber-600 mt-1">۰</h3>
            <span class="text-[11px] text-amber-700 font-medium">ورود با تأخیر</span>
          </div>
          <div class="w-12 h-12 rounded-2xl bg-amber-50 text-amber-600 flex items-center justify-center text-xl">⏱️</div>
        </div>
      </div>

      <!-- Class Status Table & Quick Absentees -->
      <div class="grid grid-cols-1 lg:grid-cols-3 gap-6">
        <div class="lg:col-span-2 bg-white rounded-2xl border border-slate-200/80 shadow-sm p-5">
          <div class="flex items-center justify-between mb-4">
            <div>
              <h3 class="text-base font-bold text-slate-900 flex items-center gap-2">
                <span>🏫</span>
                <span>وضعیت حضور و غیاب کلاس‌های دبستان پرنیان</span>
              </h3>
              <p class="text-xs text-slate-500">بررسی روند ثبت حضور و غیاب توسط معلمان گرامی</p>
            </div>
            <button onclick="openAddClassModal()" class="text-xs font-bold text-purple-700 bg-purple-50 hover:bg-purple-100 border border-purple-200 px-3 py-1.5 rounded-xl transition">
              + تعریف کلاس جدید
            </button>
          </div>

          <div class="overflow-x-auto">
            <table class="w-full text-right text-xs sm:text-sm">
              <thead>
                <tr class="border-b border-slate-100 text-slate-400 font-semibold">
                  <th class="py-2.5 px-3">نام کلاس</th>
                  <th class="py-2.5 px-3">معلم کلاس</th>
                  <th class="py-2.5 px-3 text-center">تعداد دانش‌آموزان</th>
                  <th class="py-2.5 px-3 text-center">درصد حضور</th>
                  <th class="py-2.5 px-3 text-center">وضعیت</th>
                  <th class="py-2.5 px-3 text-center">عملیات</th>
                </tr>
              </thead>
              <tbody id="classesTableBody" class="divide-y divide-slate-100 text-slate-700 font-medium">
                <!-- Dynamically rendered -->
              </tbody>
            </table>
          </div>
        </div>

        <!-- Quick Absentees Widget -->
        <div class="bg-white rounded-2xl border border-slate-200/80 shadow-sm p-5 flex flex-col justify-between">
          <div>
            <div class="flex items-center justify-between mb-3">
              <h3 class="text-base font-bold text-slate-900 flex items-center gap-2">
                <span>📞</span>
                <span>غایبین نیازمند تماس تلفنی</span>
              </h3>
              <button onclick="navigate('absentees')" class="text-xs font-bold text-indigo-600 hover:text-indigo-800">
                مشاهده همه ←
              </button>
            </div>
            <p class="text-xs text-slate-500 mb-4">تماس فوری با والدین دانش‌آموزان غایب</p>

            <div id="quickAbsenteesList" class="space-y-3">
              <!-- Dynamically rendered -->
            </div>
          </div>

          <div class="mt-4 pt-3 border-t border-slate-100">
            <button onclick="navigate('teacher')" class="w-full py-2.5 px-4 rounded-xl bg-purple-50 hover:bg-purple-100 text-purple-700 font-bold text-xs sm:text-sm flex items-center justify-center gap-2 transition">
              <span>👩‍🏫 ورود به دفتر حضور و غیاب معلم</span>
            </button>
          </div>
        </div>
      </div>

    </section>

    <!-- ============================================================ -->
    <!-- VIEW 2: TEACHER ATTENDANCE PORTAL                           -->
    <!-- ============================================================ -->
    <section id="viewTeacher" class="hidden space-y-6">
      
      <div class="bg-white rounded-2xl border border-slate-200/80 shadow-sm p-4 sm:p-5 flex flex-col md:flex-row md:items-center justify-between gap-4">
        <div>
          <div class="flex items-center gap-2">
            <span class="w-8 h-8 rounded-xl bg-purple-100 text-purple-700 flex items-center justify-center font-bold text-sm">👩‍🏫</span>
            <h2 class="text-lg sm:text-xl font-extrabold text-slate-900">دفتر حضور و غیاب معلم</h2>
          </div>
          <p class="text-xs text-slate-500 mt-1">مشاهده لیست دانش‌آموزان دختر، ثبت وضعیت حضور و ثبت نام دانش‌آموز جدید</p>
        </div>

        <div class="flex flex-wrap items-center gap-3">
          <!-- Class Selector -->
          <div class="flex items-center gap-2">
            <label class="text-xs font-bold text-slate-600">کلاس:</label>
            <select id="teacherClassSelect" onchange="loadTeacherClass(this.value)" class="bg-slate-50 border border-slate-300 rounded-xl px-3 py-2 text-xs sm:text-sm font-bold text-slate-800 focus:ring-2 focus:ring-purple-500 focus:outline-none">
              <!-- Populated dynamically -->
            </select>
          </div>

          <!-- Add Student Button for Teacher -->
          <button onclick="openAddStudentModal()" class="px-3.5 py-2 rounded-xl bg-purple-600 text-white hover:bg-purple-700 font-bold text-xs sm:text-sm flex items-center gap-1.5 shadow-sm transition">
            <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4"></path></svg>
            <span>+ افزودن دانش‌آموز به این کلاس</span>
          </button>

          <!-- Quick Mark All Present -->
          <button onclick="markAllPresent()" class="px-3.5 py-2 rounded-xl bg-emerald-50 text-emerald-700 hover:bg-emerald-100 border border-emerald-200 font-bold text-xs sm:text-sm flex items-center gap-1.5 transition">
            <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7"></path></svg>
            <span>حاضر زدن همه</span>
          </button>
        </div>
      </div>

      <!-- Attendance Table Card -->
      <div class="bg-white rounded-2xl border border-slate-200/80 shadow-sm overflow-hidden">
        <div class="p-4 bg-purple-50/60 border-b border-purple-100 flex items-center justify-between">
          <div class="flex items-center gap-2 text-xs sm:text-sm font-bold text-purple-900">
            <span>کلاس: <span id="teacherCurrentClassName" class="text-indigo-700 font-extrabold">—</span></span>
            <span class="text-slate-400">•</span>
            <span class="text-slate-600 font-medium">تعداد: <span id="teacherStudentCount" class="font-bold">۰</span> نفر</span>
          </div>

          <div class="flex items-center gap-4 text-xs font-bold">
            <span class="text-emerald-700 flex items-center gap-1"><span class="w-2.5 h-2.5 rounded-full bg-emerald-500"></span> حاضر: <span id="teacherCurrentPresentCount">۰</span></span>
            <span class="text-rose-700 flex items-center gap-1"><span class="w-2.5 h-2.5 rounded-full bg-rose-500"></span> غایب: <span id="teacherCurrentAbsentCount">۰</span></span>
          </div>
        </div>

        <div id="teacherStudentListContainer" class="divide-y divide-slate-100 min-h-[150px]">
          <!-- Student Rows -->
        </div>

        <div class="p-4 sm:p-5 bg-slate-50 border-t border-slate-200/80 flex flex-col sm:flex-row sm:items-center justify-between gap-3">
          <div class="text-xs text-slate-500 flex items-center gap-1.5">
            <svg class="w-4 h-4 text-slate-400" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 16h-1v-4h-1m1-4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"></path></svg>
            <span>پس از ثبت، اطلاعات به دفتر دبستان پرنیان ارسال و در کارنامه حضور و غیاب ثبت می‌شود.</span>
          </div>

          <button onclick="submitAttendanceBatch()" id="btnSubmitAttendance" class="px-6 py-3 rounded-xl bg-gradient-to-r from-purple-600 to-indigo-600 hover:from-purple-700 hover:to-indigo-700 text-white font-extrabold text-sm shadow-md hover:shadow-lg transition-all flex items-center justify-center gap-2">
            <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z"></path></svg>
            <span>ثبت و ارسال نهایی به دفتر مدرسه</span>
          </button>
        </div>
      </div>

    </section>

    <!-- ============================================================ -->
    <!-- VIEW 3: ABSENTEES LIST & PARENT CALLING                     -->
    <!-- ============================================================ -->
    <section id="viewAbsentees" class="hidden space-y-6">
      <div class="bg-white rounded-2xl border border-slate-200/80 shadow-sm p-5 flex flex-col sm:flex-row sm:items-center justify-between gap-4">
        <div>
          <div class="flex items-center gap-2">
            <span class="w-8 h-8 rounded-xl bg-rose-100 text-rose-700 flex items-center justify-center font-bold text-sm">📋</span>
            <h2 class="text-lg sm:text-xl font-extrabold text-slate-900">لیست غایبین و پیگیری اولیا</h2>
          </div>
          <p class="text-xs text-slate-500 mt-1">مشاهده تمام دانش‌آموزانی که امروز غایب بوده‌اند به همراه شماره تماس اولیا.</p>
        </div>

        <div class="flex items-center gap-2">
          <button onclick="window.print()" class="px-3.5 py-2 rounded-xl bg-slate-100 hover:bg-slate-200 text-slate-700 font-bold text-xs sm:text-sm flex items-center gap-1.5 transition">
            <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 17h2a2 2 0 002-2v-4a2 2 0 00-2-2H5a2 2 0 00-2 2v4a2 2 0 002 2h2m2 4h6a2 2 0 002-2v-4a2 2 0 00-2-2H9a2 2 0 00-2 2v4a2 2 0 002 2zm8-12V5a2 2 0 00-2-2H9a2 2 0 00-2 2v4h10z"></path></svg>
            <span>چاپ برگه غایبین امروز</span>
          </button>
        </div>
      </div>

      <div class="bg-white rounded-2xl border border-slate-200/80 shadow-sm overflow-hidden">
        <div class="overflow-x-auto">
          <table class="w-full text-right text-xs sm:text-sm">
            <thead>
              <tr class="bg-slate-50 border-b border-slate-200 text-slate-500 font-semibold">
                <th class="py-3 px-4">ردیف</th>
                <th class="py-3 px-4">نام و نام خانوادگی</th>
                <th class="py-3 px-4">کلاس</th>
                <th class="py-3 px-4">کد دانش‌آموزی</th>
                <th class="py-3 px-4">نوع وضعیت</th>
                <th class="py-3 px-4">علت / توضیحات</th>
                <th class="py-3 px-4">شماره تماس ولی</th>
                <th class="py-3 px-4 text-center">اقدام سریع</th>
              </tr>
            </thead>
            <tbody id="absenteesTableFullBody" class="divide-y divide-slate-100 text-slate-700">
              <!-- Rendered dynamically -->
            </tbody>
          </table>
        </div>
      </div>
    </section>

    <!-- ============================================================ -->
    <!-- VIEW 4: STUDENTS & CLASSES MANAGEMENT                       -->
    <!-- ============================================================ -->
    <section id="viewStudents" class="hidden space-y-6">
      <div class="bg-white rounded-2xl border border-slate-200/80 shadow-sm p-5 flex flex-col sm:flex-row sm:items-center justify-between gap-4">
        <div>
          <div class="flex items-center gap-2">
            <span class="w-8 h-8 rounded-xl bg-indigo-100 text-indigo-700 flex items-center justify-center font-bold text-sm">👥</span>
            <h2 class="text-lg sm:text-xl font-extrabold text-slate-900">مدیریت دانش‌آموزان و کلاس‌ها</h2>
          </div>
          <p class="text-xs text-slate-500 mt-1">دبستان دخترانه پرنیان - ثبت مشخصات دانش‌آموزان و شماره تماس اولیا</p>
        </div>

        <div class="flex items-center gap-2">
          <button onclick="openAddClassModal()" class="px-3.5 py-2.5 rounded-xl bg-purple-50 text-purple-700 hover:bg-purple-100 border border-purple-200 font-bold text-xs sm:text-sm flex items-center gap-1.5 transition">
            <span>+ تعریف کلاس جدید</span>
          </button>
          <button onclick="openAddStudentModal()" class="px-4 py-2.5 rounded-xl bg-purple-600 hover:bg-purple-700 text-white font-bold text-xs sm:text-sm flex items-center gap-1.5 shadow-sm transition">
            <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4"></path></svg>
            <span>+ ثبت دانش‌آموز جدید</span>
          </button>
        </div>
      </div>

      <div class="bg-white rounded-2xl border border-slate-200/80 shadow-sm p-5">
        <div class="flex flex-col sm:flex-row sm:items-center justify-between gap-3 mb-4">
          <div class="flex items-center gap-3">
            <label class="text-xs font-bold text-slate-600">فیلتر بر اساس کلاس:</label>
            <select id="manageClassFilter" onchange="renderManageStudentsTable(this.value)" class="bg-slate-50 border border-slate-300 rounded-xl px-3 py-1.5 text-xs font-bold text-slate-800 focus:outline-none">
              <option value="all">تمام کلاس‌ها</option>
            </select>
          </div>

          <div class="relative">
            <input type="text" id="searchStudentInput" onkeyup="filterStudentSearch(this.value)" placeholder="جستجوی نام، کد دانش‌آموزی..." class="bg-slate-50 border border-slate-300 rounded-xl text-xs px-3 py-2 pr-8 w-64 focus:outline-none focus:ring-2 focus:ring-purple-400">
            <span class="absolute right-2.5 top-2.5 text-slate-400 text-xs">🔍</span>
          </div>
        </div>

        <div class="overflow-x-auto">
          <table class="w-full text-right text-xs sm:text-sm">
            <thead>
              <tr class="bg-slate-50 border-b border-slate-200 text-slate-500 font-semibold">
                <th class="py-3 px-3">ردیف</th>
                <th class="py-3 px-3">نام و نام خانوادگی</th>
                <th class="py-3 px-3">کلاس</th>
                <th class="py-3 px-3">کد دانش‌آموزی</th>
                <th class="py-3 px-3">شماره تماس ولی</th>
                <th class="py-3 px-3 text-center">عملیات</th>
              </tr>
            </thead>
            <tbody id="manageStudentsTableBody" class="divide-y divide-slate-100 text-slate-700">
              <!-- Rendered dynamically -->
            </tbody>
          </table>
        </div>
      </div>
    </section>

  </main>

  <!-- ============================================================== -->
  <!-- MODAL: ADD STUDENT                                             -->
  <!-- ============================================================== -->
  <div id="addStudentModal" class="fixed inset-0 bg-slate-900/50 backdrop-blur-sm z-50 hidden flex items-center justify-center p-4">
    <div class="bg-white rounded-3xl max-w-md w-full p-6 shadow-2xl border border-slate-100 transform transition-all">
      <div class="flex items-center justify-between pb-3 border-b border-slate-100 mb-4">
        <h3 class="font-extrabold text-base text-slate-900 flex items-center gap-2">
          <span>🌸</span>
          <span>ثبت نام دانش‌آموز در دبستان پرنیان</span>
        </h3>
        <button onclick="closeAddStudentModal()" class="text-slate-400 hover:text-slate-600 text-lg font-bold">✕</button>
      </div>

      <form onsubmit="handleSaveNewStudent(event)" class="space-y-3.5">
        <div>
          <label class="block text-xs font-bold text-slate-700 mb-1">نام دانش‌آموز:</label>
          <input type="text" id="newStudentFirstName" required placeholder="مثال: پرنیان" class="w-full bg-slate-50 border border-slate-300 rounded-xl px-3 py-2 text-xs focus:ring-2 focus:ring-purple-400 focus:outline-none">
        </div>
        <div>
          <label class="block text-xs font-bold text-slate-700 mb-1">نام خانوادگی:</label>
          <input type="text" id="newStudentLastName" required placeholder="مثال: حسینی" class="w-full bg-slate-50 border border-slate-300 rounded-xl px-3 py-2 text-xs focus:ring-2 focus:ring-purple-400 focus:outline-none">
        </div>
        <div>
          <label class="block text-xs font-bold text-slate-700 mb-1">کلاس مربوطه:</label>
          <select id="newStudentClassId" class="w-full bg-slate-50 border border-slate-300 rounded-xl px-3 py-2 text-xs focus:ring-2 focus:ring-purple-400 focus:outline-none">
            <!-- Dynamically populated -->
          </select>
        </div>
        <div>
          <label class="block text-xs font-bold text-slate-700 mb-1">کد دانش‌آموزی (اختیاری):</label>
          <input type="text" id="newStudentCode" placeholder="مثال: 101" class="w-full bg-slate-50 border border-slate-300 rounded-xl px-3 py-2 text-xs focus:ring-2 focus:ring-purple-400 focus:outline-none">
        </div>
        <div>
          <label class="block text-xs font-bold text-slate-700 mb-1">شماره همراه ولی (پدر یا مادر):</label>
          <input type="tel" id="newStudentParentPhone" required placeholder="مثال: 09121234567" class="w-full bg-slate-50 border border-slate-300 rounded-xl px-3 py-2 text-xs focus:ring-2 focus:ring-purple-400 focus:outline-none font-mono">
        </div>

        <div class="pt-3 flex items-center justify-end gap-2">
          <button type="button" onclick="closeAddStudentModal()" class="px-4 py-2 rounded-xl text-xs font-bold text-slate-600 hover:bg-slate-100 transition">انصراف</button>
          <button type="submit" class="px-5 py-2 rounded-xl bg-purple-600 hover:bg-purple-700 text-white font-bold text-xs shadow-md transition">ذخیره دانش‌آموز</button>
        </div>
      </form>
    </div>
  </div>

  <!-- ============================================================== -->
  <!-- MODAL: ADD CLASS                                               -->
  <!-- ============================================================== -->
  <div id="addClassModal" class="fixed inset-0 bg-slate-900/50 backdrop-blur-sm z-50 hidden flex items-center justify-center p-4">
    <div class="bg-white rounded-3xl max-w-sm w-full p-6 shadow-2xl border border-slate-100">
      <div class="flex items-center justify-between pb-3 border-b border-slate-100 mb-4">
        <h3 class="font-extrabold text-base text-slate-900 flex items-center gap-2">
          <span>🏫</span>
          <span>تعریف کلاس جدید در دبستان پرنیان</span>
        </h3>
        <button onclick="closeAddClassModal()" class="text-slate-400 hover:text-slate-600 text-lg font-bold">✕</button>
      </div>

      <form onsubmit="handleSaveNewClass(event)" class="space-y-3.5">
        <div>
          <label class="block text-xs font-bold text-slate-700 mb-1">نام کلاس:</label>
          <input type="text" id="newClassName" required placeholder="مثال: اول پرنیان، دوم یاس..." class="w-full bg-slate-50 border border-slate-300 rounded-xl px-3 py-2 text-xs focus:ring-2 focus:ring-purple-400 focus:outline-none">
        </div>
        <div>
          <label class="block text-xs font-bold text-slate-700 mb-1">پایه تحصیلی:</label>
          <select id="newClassGrade" class="w-full bg-slate-50 border border-slate-300 rounded-xl px-3 py-2 text-xs focus:ring-2 focus:ring-purple-400 focus:outline-none">
            <option value="1">پایه اول ابتدایی</option>
            <option value="2">پایه دوم ابتدایی</option>
            <option value="3">پایه سوم ابتدایی</option>
            <option value="4">پایه چهارم ابتدایی</option>
            <option value="5">پایه پنجم ابتدایی</option>
            <option value="6">پایه ششم ابتدایی</option>
          </select>
        </div>

        <div class="pt-3 flex items-center justify-end gap-2">
          <button type="button" onclick="closeAddClassModal()" class="px-4 py-2 rounded-xl text-xs font-bold text-slate-600 hover:bg-slate-100 transition">انصراف</button>
          <button type="submit" class="px-5 py-2 rounded-xl bg-purple-600 hover:bg-purple-700 text-white font-bold text-xs shadow-md transition">ایجاد کلاس</button>
        </div>
      </form>
    </div>
  </div>

  <!-- ============================================================== -->
  <!-- MODAL: USER AUTH & REGISTRATION (مدیر، معاون، معلم)            -->
  <!-- ============================================================== -->
  <div id="authModal" class="fixed inset-0 bg-slate-900/60 backdrop-blur-sm z-50 hidden flex items-center justify-center p-4">
    <div class="bg-white rounded-3xl max-w-md w-full p-6 shadow-2xl border border-slate-100 text-right">
      
      <!-- Top Icon & Header -->
      <div class="text-center mb-4">
        <div class="w-14 h-14 mx-auto rounded-2xl bg-gradient-to-tr from-purple-500 to-pink-500 text-white flex items-center justify-center text-3xl shadow-md mb-2">🌸</div>
        <h3 class="text-lg font-black text-slate-900">سامانه دبستان دخترانه پرنیان</h3>
        <p class="text-xs text-slate-500">ثبت‌نام و ورود معلمان و کادر مدرسه</p>
      </div>

      <!-- Auth Tabs: Login vs Register -->
      <div class="bg-slate-100 p-1 rounded-2xl flex gap-1 mb-4">
        <button id="tabBtnRegister" onclick="switchAuthTab('register')" class="flex-1 py-2 rounded-xl text-xs font-extrabold transition-all bg-white text-purple-900 shadow-sm">
          ثبت‌نام کادر و معلمان
        </button>
        <button id="tabBtnLogin" onclick="switchAuthTab('login')" class="flex-1 py-2 rounded-xl text-xs font-extrabold transition-all text-slate-600 hover:text-slate-900">
          ورود با رمز عبور
        </button>
      </div>

      <!-- REGISTRATION FORM -->
      <form id="formRegister" onsubmit="handleRegister(event)" class="space-y-3">
        <div>
          <label class="block text-xs font-bold text-slate-700 mb-1">سمت / نقش شما در مدرسه:</label>
          <select id="regRole" onchange="toggleRegRoleFields(this.value)" class="w-full bg-slate-50 border border-slate-300 rounded-xl px-3 py-2 text-xs font-bold focus:ring-2 focus:ring-purple-400 focus:outline-none">
            <option value="teacher">👩‍🏫 معلم کلاس (آموزگار)</option>
            <option value="principal">👩‍💼 مدیر مدرسه (دسترسی کل)</option>
            <option value="staff">👩‍💼 معاون آموزشی / انضباطی</option>
            <option value="other">🧑‍💼 سایر کادر اجرایی مدرسه</option>
          </select>
        </div>

        <div id="regClassGroup">
          <label class="block text-xs font-bold text-slate-700 mb-1">نام کلاسی که تدریس می‌کنید:</label>
          <input type="text" id="regClassName" placeholder="مثال: اول پرنیان، دوم شکوفه..." class="w-full bg-slate-50 border border-slate-300 rounded-xl px-3 py-2 text-xs focus:ring-2 focus:ring-purple-400 focus:outline-none">
          <p class="text-[10px] text-slate-400 mt-0.5">در صورت جدید بودن نام کلاس، به صورت خودکار در دبستان پرنیان ساخته می‌شود.</p>
        </div>

        <div>
          <label class="block text-xs font-bold text-slate-700 mb-1">نام و نام خانوادگی:</label>
          <input type="text" id="regName" required placeholder="مثال: مریم محمدی" class="w-full bg-slate-50 border border-slate-300 rounded-xl px-3 py-2 text-xs focus:ring-2 focus:ring-purple-400 focus:outline-none">
        </div>

        <div>
          <label class="block text-xs font-bold text-slate-700 mb-1">شماره تلفن همراه:</label>
          <input type="tel" id="regPhone" required placeholder="مثال: 09121234567" class="w-full bg-slate-50 border border-slate-300 rounded-xl px-3 py-2 text-xs font-mono focus:ring-2 focus:ring-purple-400 focus:outline-none">
        </div>

        <div>
          <label class="block text-xs font-bold text-slate-700 mb-1">رمز عبور دلخواه:</label>
          <input type="password" id="regPassword" required placeholder="حداقل ۴ کاراکتر" class="w-full bg-slate-50 border border-slate-300 rounded-xl px-3 py-2 text-xs font-mono focus:ring-2 focus:ring-purple-400 focus:outline-none">
        </div>

        <button type="submit" class="w-full py-2.5 mt-2 rounded-xl bg-purple-600 hover:bg-purple-700 text-white font-extrabold text-xs shadow-md transition">
          ثبت‌نام و ورود به سامانه پرنیان
        </button>
      </form>

      <!-- LOGIN FORM -->
      <form id="formLogin" onsubmit="handleLogin(event)" class="space-y-3 hidden">
        <div>
          <label class="block text-xs font-bold text-slate-700 mb-1">شماره تلفن همراه:</label>
          <input type="tel" id="loginPhone" required placeholder="مثال: 09121234567" class="w-full bg-slate-50 border border-slate-300 rounded-xl px-3 py-2 text-xs font-mono focus:ring-2 focus:ring-purple-400 focus:outline-none">
        </div>

        <div>
          <label class="block text-xs font-bold text-slate-700 mb-1">رمز عبور:</label>
          <input type="password" id="loginPassword" required placeholder="رمز عبور شما" class="w-full bg-slate-50 border border-slate-300 rounded-xl px-3 py-2 text-xs font-mono focus:ring-2 focus:ring-purple-400 focus:outline-none">
        </div>

        <button type="submit" class="w-full py-2.5 mt-2 rounded-xl bg-indigo-600 hover:bg-indigo-700 text-white font-extrabold text-xs shadow-md transition">
          ورود به حساب کاربری
        </button>
      </form>

      <div class="mt-4 pt-3 border-t border-slate-100 flex items-center justify-between text-xs">
        <button onclick="closeAuthModal()" class="text-slate-400 hover:text-slate-600 font-bold">بستن پنجره</button>
        <button onclick="resetAllDataConfirm()" class="text-rose-400 hover:text-rose-600 text-[11px]">پاکسازی و شروع مجدد</button>
      </div>

    </div>
  </div>

  <!-- Toast Notification -->
  <div id="toast" class="fixed bottom-5 left-5 z-50 hidden bg-slate-900 text-white px-4 py-3 rounded-2xl shadow-xl flex items-center gap-2.5 text-xs font-bold border border-slate-700 transition-all duration-300">
    <span id="toastIcon">✅</span>
    <span id="toastMsg">عملیات با موفقیت انجام شد</span>
  </div>

  <!-- ============================================================== -->
  <!-- PRINT TEMPLATE (دبستان دخترانه پرنیان)                         -->
  <!-- ============================================================== -->
  <div class="print-only p-8 text-black text-right">
    <div class="border-b-2 border-black pb-4 mb-6 flex justify-between items-center">
      <div>
        <h2 class="text-xl font-bold">جمهوری اسلامی ایران - وزارت آموزش و پرورش</h2>
        <h3 class="text-lg font-bold">دبستان دخترانه پرنیان</h3>
        <p class="text-sm">فرم رسمی حضور و غیاب کلاسی روزانه</p>
      </div>
      <div class="text-left text-sm">
        <p><strong>تاریخ:</strong> <span class="printDate">۱۴۰۳/۰۷/۰۴</span></p>
        <p><strong>سال تحصیلی:</strong> ۱۴۰۳ - ۱۴۰۴</p>
      </div>
    </div>

    <div class="mb-4">
      <h4 class="font-bold text-base mb-2">لیست غایبین و وضعیت حضور امروز:</h4>
      <table class="w-full border-collapse border border-black text-sm">
        <thead>
          <tr class="bg-slate-100">
            <th class="border border-black p-2">ردیف</th>
            <th class="border border-black p-2">نام و نام خانوادگی</th>
            <th class="border border-black p-2">کلاس</th>
            <th class="border border-black p-2">وضعیت</th>
            <th class="border border-black p-2">علت / توضیحات</th>
            <th class="border border-black p-2">شماره تماس ولی</th>
          </tr>
        </thead>
        <tbody id="printTableBody"></tbody>
      </table>
    </div>

    <div class="mt-12 flex justify-between text-sm pt-8">
      <div class="text-center w-48">
        <p class="font-bold">امضای آموزگار مربوطه</p>
        <div class="h-16"></div>
      </div>
      <div class="text-center w-48">
        <p class="font-bold">امضای معاون آموزشی</p>
        <div class="h-16"></div>
      </div>
      <div class="text-center w-48">
        <p class="font-bold">مهر و امضای مدیر دبستان پرنیان</p>
        <div class="h-16"></div>
      </div>
    </div>
  </div>

  <!-- ============================================================== -->
  <!-- JAVASCRIPT APPLICATION LOGIC                                   -->
  <!-- ============================================================== -->
  <script>
    const API_BASE = 'http://85.198.51.92:5000/api';

    // Application state with ZERO mock data
    const EMPTY_STATE = {
      schoolName: 'دبستان دخترانه پرنیان',
      currentUser: null, // null until registered/logged in
      currentDate: '1403/07/04',
      classes: [],
      users: [],
      students: [],
      attendance: {}
    };

    let appData = (() => {
      const saved = localStorage.getItem('school_attendance_pernian_v1');
      if (saved) {
        try { 
          const parsed = JSON.parse(saved);
          if (parsed && parsed.schoolName === 'دبستان دخترانه پرنیان') return parsed;
        } catch (_) {}
      }
      return EMPTY_STATE;
    })();

    function saveState() {
      localStorage.setItem('school_attendance_pernian_v1', JSON.stringify(appData));
    }

    function toPersianDigits(num) {
      if (num === null || num === undefined) return '';
      const persianDigits = ['۰', '۱', '۲', '۳', '۴', '۵', '۶', '۷', '۸', '۹'];
      return num.toString().replace(/[0-9]/g, w => persianDigits[+w]);
    }

    let currentTab = 'dashboard';
    function navigate(tabName) {
      currentTab = tabName;
      document.querySelectorAll('main > section').forEach(sec => sec.classList.add('hidden'));
      
      const tabMap = {
        'dashboard': 'viewDashboard',
        'teacher': 'viewTeacher',
        'absentees': 'viewAbsentees',
        'students': 'viewStudents'
      };
      
      const activeEl = document.getElementById(tabMap[tabName]);
      if (activeEl) activeEl.classList.remove('hidden');

      document.querySelectorAll('.nav-btn').forEach(btn => {
        btn.classList.remove('bg-white', 'text-purple-900', 'font-bold', 'shadow-sm');
        btn.classList.add('text-white/90', 'hover:bg-white/10');
      });

      const activeNavBtn = {
        'dashboard': 'navDashboard',
        'teacher': 'navTeacher',
        'absentees': 'navAbsentees',
        'students': 'navStudents'
      }[tabName];

      const btnEl = document.getElementById(activeNavBtn);
      if (btnEl) {
        btnEl.classList.remove('text-white/90', 'hover:bg-white/10');
        btnEl.classList.add('bg-white', 'text-purple-900', 'font-bold', 'shadow-sm');
      }

      if (tabName === 'dashboard') renderDashboard();
      if (tabName === 'teacher') renderTeacherPortal();
      if (tabName === 'absentees') renderAbsenteesView();
      if (tabName === 'students') renderManageStudentsTable();
      
      window.scrollTo({ top: 0, behavior: 'smooth' });
    }

    function updateClock() {
      const now = new Date();
      const timeStr = now.toLocaleTimeString('fa-IR', { hour: '2-digit', minute: '2-digit' });
      const timeEl = document.getElementById('headerLiveTime');
      if (timeEl) timeEl.textContent = timeStr;
    }
    setInterval(updateClock, 1000);
    updateClock();

    // Check Cloud Server Connectivity
    async function checkServerHealth() {
      try {
        const res = await fetch(`${API_BASE}/health`, { method: 'GET', mode: 'cors' });
        if (res.ok) {
          const badge = document.getElementById('connectionBadge');
          const txt = document.getElementById('connectionText');
          if (badge && txt) {
            badge.className = 'hidden sm:inline-flex items-center px-2.5 py-1 rounded-full text-xs font-semibold bg-emerald-500/20 text-emerald-100 border border-emerald-400/30';
            txt.textContent = 'سرور آروان متصل است';
          }
        }
      } catch (err) {
        const badge = document.getElementById('connectionBadge');
        const txt = document.getElementById('connectionText');
        if (badge && txt) {
          badge.className = 'hidden sm:inline-flex items-center px-2.5 py-1 rounded-full text-xs font-semibold bg-amber-500/20 text-amber-100 border border-amber-400/30';
          txt.textContent = 'حالت محلی پرنیان (پایدار)';
        }
      }
    }
    checkServerHealth();

    // ==============================================================
    // 2. DASHBOARD LOGIC
    // ==============================================================
    function renderDashboard() {
      const date = appData.currentDate;
      const students = appData.students;
      let present = 0, absentUnexcused = 0, absentExcused = 0, late = 0;

      students.forEach(s => {
        const key = `${date}_${s.id}`;
        const rec = appData.attendance[key];
        if (rec) {
          if (rec.status === 'present') present++;
          else if (rec.status === 'absent_unexcused') absentUnexcused++;
          else if (rec.status === 'absent_excused') absentExcused++;
          else if (rec.status === 'late') late++;
        }
      });

      const totalRecorded = present + absentUnexcused + absentExcused + late;
      const totalStudents = students.length;
      const pct = totalRecorded > 0 ? Math.round(((present + late) / totalRecorded) * 100) : 0;

      document.getElementById('dashTotalPercent').textContent = toPersianDigits(pct) + '٪';
      document.getElementById('dashTotalStudentsCount').textContent = toPersianDigits(totalStudents);
      document.getElementById('dashTotalClassesCount').textContent = toPersianDigits(appData.classes.length);
      document.getElementById('dashProgressBar').style.width = `${pct}%`;

      document.getElementById('statPresentCount').textContent = toPersianDigits(present);
      document.getElementById('statAbsentUnexcusedCount').textContent = toPersianDigits(absentUnexcused);
      document.getElementById('statAbsentExcusedCount').textContent = toPersianDigits(absentExcused);
      document.getElementById('statLateCount').textContent = toPersianDigits(late);

      const totalAbsents = absentUnexcused + absentExcused + late;
      const absBadge = document.getElementById('navAbsenteesCount');
      if (absBadge) absBadge.textContent = toPersianDigits(totalAbsents);

      // Render Classes Table
      const tbody = document.getElementById('classesTableBody');
      tbody.innerHTML = '';

      if (appData.classes.length === 0) {
        tbody.innerHTML = `
          <tr>
            <td colspan="6" class="text-center py-8 text-slate-400">
              <div class="text-2xl mb-1">🌸</div>
              <p class="font-bold">هنوز کلاسی ثبت نشده است.</p>
              <p class="text-xs mt-1">با ثبت‌نام معلمان یا کلیک بر روی «تعریف کلاس جدید»، کلاس‌ها به صورت خودکار اینجا نمایش می‌یابند.</p>
            </td>
          </tr>
        `;
      } else {
        appData.classes.forEach(c => {
          const classStudents = students.filter(s => s.classId === c.id);
          const count = classStudents.length;

          let classPresent = 0;
          let recordedCount = 0;

          classStudents.forEach(s => {
            const rec = appData.attendance[`${date}_${s.id}`];
            if (rec) {
              recordedCount++;
              if (rec.status === 'present' || rec.status === 'late') classPresent++;
            }
          });

          const classPct = count > 0 && recordedCount > 0 ? Math.round((classPresent / count) * 100) : 0;
          const isSubmitted = count > 0 && recordedCount >= count;

          const tr = document.createElement('tr');
          tr.className = 'hover:bg-slate-50/80 transition';
          tr.innerHTML = `
            <td class="py-3 px-3">
              <div class="font-bold text-slate-900">${c.name}</div>
              <div class="text-[11px] text-slate-400">پایه ${toPersianDigits(c.grade || 1)} ابتدایی</div>
            </td>
            <td class="py-3 px-3 text-slate-600 font-semibold">${c.teacherName || 'آموزگار ثبت‌نام نکرده'}</td>
            <td class="py-3 px-3 text-center">
              <span class="font-bold text-slate-800">${toPersianDigits(count)}</span> نفر
            </td>
            <td class="py-3 px-3 text-center">
              <span class="font-extrabold ${classPct >= 90 ? 'text-emerald-600' : 'text-amber-600'}">${toPersianDigits(classPct)}٪</span>
            </td>
            <td class="py-3 px-3 text-center">
              ${count === 0 
                ? `<span class="inline-flex items-center px-2 py-0.5 rounded-full text-xs font-bold bg-slate-100 text-slate-500">بدون دانش‌آموز</span>`
                : isSubmitted 
                ? `<span class="inline-flex items-center px-2 py-0.5 rounded-full text-xs font-bold bg-emerald-100 text-emerald-800">✓ ثبت شده</span>` 
                : `<span class="inline-flex items-center px-2 py-0.5 rounded-full text-xs font-bold bg-amber-100 text-amber-800">⏳ در انتظار ثبت</span>`}
            </td>
            <td class="py-3 px-3 text-center">
              <button onclick="openClassInTeacherView(${c.id})" class="px-2.5 py-1 rounded-lg bg-purple-50 hover:bg-purple-100 text-purple-700 text-xs font-bold transition">
                مشاهده و ثبت
              </button>
            </td>
          `;
          tbody.appendChild(tr);
        });
      }

      // Quick Absentees
      const quickContainer = document.getElementById('quickAbsenteesList');
      quickContainer.innerHTML = '';

      const absenteesList = students.filter(s => {
        const rec = appData.attendance[`${date}_${s.id}`];
        return rec && (rec.status === 'absent_unexcused' || rec.status === 'absent_excused' || rec.status === 'late');
      });

      if (absenteesList.length === 0) {
        quickContainer.innerHTML = `<div class="p-4 text-center text-xs text-slate-400 bg-slate-50 rounded-xl">امروز غایبی ثبت نشده است.</div>`;
      } else {
        absenteesList.slice(0, 4).forEach(s => {
          const rec = appData.attendance[`${date}_${s.id}`];
          const classObj = appData.classes.find(c => c.id === s.classId);
          const isUnexcused = rec.status === 'absent_unexcused';
          
          const card = document.createElement('div');
          card.className = `p-3 rounded-xl border flex items-center justify-between ${isUnexcused ? 'bg-rose-50/60 border-rose-200' : 'bg-sky-50/60 border-sky-200'}`;
          card.innerHTML = `
            <div>
              <div class="flex items-center gap-1.5">
                <span class="font-extrabold text-xs text-slate-900">${s.firstName} ${s.lastName}</span>
                <span class="text-[10px] ${isUnexcused ? 'bg-rose-200 text-rose-800' : 'bg-sky-200 text-sky-800'} px-1.5 py-0.2 rounded font-bold">
                  ${isUnexcused ? 'غایب غیرموجه' : 'غایب موجه'}
                </span>
              </div>
              <p class="text-[11px] text-slate-500 mt-0.5">کلاس: ${classObj ? classObj.name : ''} • ولی: ${toPersianDigits(s.parentPhone || 'ندارد')}</p>
            </div>
            ${s.parentPhone ? `
              <a href="tel:${s.parentPhone}" class="p-2 rounded-xl bg-white text-indigo-600 hover:bg-indigo-600 hover:text-white border border-slate-200 shadow-sm transition flex items-center justify-center" title="تماس با ولی">
                <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 5a2 2 0 012-2h3.28a1 1 0 01.948.684l1.498 4.493a1 1 0 01-.502 1.21l-2.257 1.13a11.042 11.042 0 005.516 5.516l1.13-2.257a1 1 0 011.21-.502l4.493 1.498a1 1 0 01.684.949V19a2 2 0 01-2 2h-1C9.716 21 3 14.284 3 6V5z"></path></svg>
              </a>
            ` : ''}
          `;
          quickContainer.appendChild(card);
        });
      }
    }

    // ==============================================================
    // 3. TEACHER PORTAL LOGIC
    // ==============================================================
    let activeTeacherClassId = null;

    function renderTeacherPortal() {
      const select = document.getElementById('teacherClassSelect');
      select.innerHTML = '';

      if (appData.classes.length === 0) {
        select.innerHTML = '<option value="">ابتدا یک کلاس تعریف کنید</option>';
        document.getElementById('teacherCurrentClassName').textContent = 'هیچ کلاسی وجود ندارد';
        document.getElementById('teacherStudentCount').textContent = '۰';
        document.getElementById('teacherStudentListContainer').innerHTML = `
          <div class="text-center py-12 px-4">
            <div class="text-3xl mb-2">🌸</div>
            <p class="font-bold text-sm text-slate-800">هیچ کلاسی در دبستان پرنیان ثبت نشده است.</p>
            <p class="text-xs text-slate-500 mt-1">با ثبت‌نام آموزگار یا با زدن دکمه «تعریف کلاس جدید»، کلاس خود را ایجاد فرمایید.</p>
            <button onclick="openAddClassModal()" class="mt-3 px-4 py-2 rounded-xl bg-purple-600 text-white text-xs font-bold shadow-sm hover:bg-purple-700 transition">
              + تعریف اولین کلاس
            </button>
          </div>
        `;
        return;
      }

      // If current user is a teacher with an assigned class, select it
      if (appData.currentUser && appData.currentUser.role === 'teacher' && appData.currentUser.class_id) {
        activeTeacherClassId = appData.currentUser.class_id;
      } else if (!activeTeacherClassId && appData.classes.length > 0) {
        activeTeacherClassId = appData.classes[0].id;
      }

      appData.classes.forEach(c => {
        const opt = document.createElement('option');
        opt.value = c.id;
        opt.textContent = `${c.name} ${c.teacherName ? `(${c.teacherName})` : ''}`;
        if (c.id === activeTeacherClassId) opt.selected = true;
        select.appendChild(opt);
      });

      loadTeacherClass(activeTeacherClassId);
    }

    function openClassInTeacherView(classId) {
      activeTeacherClassId = classId;
      navigate('teacher');
    }

    function loadTeacherClass(classId) {
      activeTeacherClassId = parseInt(classId);
      const classObj = appData.classes.find(c => c.id === activeTeacherClassId);
      if (!classObj) return;

      document.getElementById('teacherCurrentClassName').textContent = classObj.name;
      const classStudents = appData.students.filter(s => s.classId === activeTeacherClassId);
      document.getElementById('teacherStudentCount').textContent = toPersianDigits(classStudents.length);

      const container = document.getElementById('teacherStudentListContainer');
      container.innerHTML = '';

      if (classStudents.length === 0) {
        container.innerHTML = `
          <div class="text-center py-12 px-4">
            <div class="text-3xl mb-2">👧</div>
            <p class="font-bold text-sm text-slate-800">هنوز دانش‌آموزی برای کلاس «${classObj.name}» ثبت نشده است.</p>
            <p class="text-xs text-slate-500 mt-1">آموزگار گرامی، لطفاً با کلیک بر روی دکمه زیر، اسامی دختران کلاستان را اضافه فرمایید:</p>
            <button onclick="openAddStudentModal()" class="mt-3 px-5 py-2.5 rounded-xl bg-purple-600 hover:bg-purple-700 text-white text-xs font-bold shadow-md transition flex items-center gap-1.5 mx-auto">
              <span>+ افزودن اسامی دانش‌آموزان این کلاس</span>
            </button>
          </div>
        `;
        document.getElementById('teacherCurrentPresentCount').textContent = '۰';
        document.getElementById('teacherCurrentAbsentCount').textContent = '۰';
        return;
      }

      let presentCount = 0;
      let absentCount = 0;

      classStudents.forEach((s, idx) => {
        const key = `${appData.currentDate}_${s.id}`;
        let rec = appData.attendance[key] || { status: 'present', notes: '' };
        if (rec.status === 'present' || rec.status === 'late') presentCount++;
        else absentCount++;

        const row = document.createElement('div');
        row.className = 'p-3.5 sm:p-4 hover:bg-slate-50/80 transition flex flex-col md:flex-row md:items-center justify-between gap-3';
        row.innerHTML = `
          <div class="flex items-center space-x-reverse space-x-3">
            <span class="text-xs font-bold text-slate-400 w-5">${toPersianDigits(idx + 1)}</span>
            <div class="w-10 h-10 rounded-full bg-gradient-to-tr from-pink-400 to-purple-400 text-white font-bold flex items-center justify-center text-sm shadow-sm">
              ${s.firstName[0]}
            </div>
            <div>
              <div class="font-extrabold text-sm text-slate-900">${s.firstName} ${s.lastName}</div>
              <div class="text-[11px] text-slate-400">کد: ${toPersianDigits(s.studentCode || '—')} • ولی: ${toPersianDigits(s.parentPhone || '—')}</div>
            </div>
          </div>

          <div class="flex flex-wrap items-center gap-2">
            <button type="button" onclick="setStudentStatus(${s.id}, 'present')" class="status-btn px-3 py-1.5 rounded-xl text-xs font-bold transition flex items-center gap-1 ${rec.status === 'present' ? 'bg-emerald-600 text-white shadow-sm' : 'bg-slate-100 text-slate-600 hover:bg-slate-200'}">
              <span>✓ حاضر</span>
            </button>
            <button type="button" onclick="setStudentStatus(${s.id}, 'absent_unexcused')" class="status-btn px-3 py-1.5 rounded-xl text-xs font-bold transition flex items-center gap-1 ${rec.status === 'absent_unexcused' ? 'bg-rose-600 text-white shadow-sm' : 'bg-slate-100 text-slate-600 hover:bg-slate-200'}">
              <span>✕ غایب غیرموجه</span>
            </button>
            <button type="button" onclick="setStudentStatus(${s.id}, 'absent_excused')" class="status-btn px-3 py-1.5 rounded-xl text-xs font-bold transition flex items-center gap-1 ${rec.status === 'absent_excused' ? 'bg-sky-600 text-white shadow-sm' : 'bg-slate-100 text-slate-600 hover:bg-slate-200'}">
              <span>🩺 غایب موجه</span>
            </button>
            <button type="button" onclick="setStudentStatus(${s.id}, 'late')" class="status-btn px-3 py-1.5 rounded-xl text-xs font-bold transition flex items-center gap-1 ${rec.status === 'late' ? 'bg-amber-600 text-white shadow-sm' : 'bg-slate-100 text-slate-600 hover:bg-slate-200'}">
              <span>⏱️ تأخیر</span>
            </button>

            <input type="text" placeholder="یادداشت..." value="${rec.notes || ''}" onchange="setStudentNote(${s.id}, this.value)" class="bg-slate-50 border border-slate-200 rounded-xl px-2.5 py-1 text-xs text-slate-700 w-28 focus:w-40 focus:ring-2 focus:ring-purple-400 focus:outline-none transition-all">
          </div>
        `;
        container.appendChild(row);
      });

      document.getElementById('teacherCurrentPresentCount').textContent = toPersianDigits(presentCount);
      document.getElementById('teacherCurrentAbsentCount').textContent = toPersianDigits(absentCount);
    }

    function setStudentStatus(studentId, status) {
      const key = `${appData.currentDate}_${studentId}`;
      if (!appData.attendance[key]) {
        appData.attendance[key] = { status: 'present', notes: '' };
      }
      appData.attendance[key].status = status;
      saveState();
      loadTeacherClass(activeTeacherClassId);
    }

    function setStudentNote(studentId, note) {
      const key = `${appData.currentDate}_${studentId}`;
      if (!appData.attendance[key]) {
        appData.attendance[key] = { status: 'present', notes: '' };
      }
      appData.attendance[key].notes = note;
      saveState();
    }

    function markAllPresent() {
      const classStudents = appData.students.filter(s => s.classId === activeTeacherClassId);
      if (classStudents.length === 0) return;
      classStudents.forEach(s => {
        const key = `${appData.currentDate}_${s.id}`;
        appData.attendance[key] = { status: 'present', notes: '' };
      });
      saveState();
      loadTeacherClass(activeTeacherClassId);
      showToast('🌸 همه دانش‌آموزان این کلاس حاضر علامت‌گذاری شدند.');
    }

    async function submitAttendanceBatch() {
      const classStudents = appData.students.filter(s => s.classId === activeTeacherClassId);
      if (classStudents.length === 0) {
        showToast('ابتدا دانش‌آموزان کلاس را ثبت فرمایید.', '⚠️');
        return;
      }

      const records = classStudents.map(s => {
        const rec = appData.attendance[`${appData.currentDate}_${s.id}`] || { status: 'present', notes: '' };
        return {
          student_id: s.id,
          status: rec.status,
          notes: rec.notes
        };
      });

      saveState();

      try {
        await fetch(`${API_BASE}/attendance/batch`, {
          method: 'POST',
          headers: { 'Content-Type': 'application/json' },
          body: JSON.stringify({
            class_id: activeTeacherClassId,
            date: appData.currentDate,
            records: records
          })
        });
      } catch (_) {}

      showToast('✓ حضور و غیاب با موفقیت به دفتر دبستان پرنیان ارسال شد.');
    }

    // ==============================================================
    // 4. ABSENTEES & PRINT VIEW LOGIC
    // ==============================================================
    function renderAbsenteesView() {
      const date = appData.currentDate;
      const tbody = document.getElementById('absenteesTableFullBody');
      const printBody = document.getElementById('printTableBody');
      tbody.innerHTML = '';
      printBody.innerHTML = '';

      const absentees = appData.students.filter(s => {
        const rec = appData.attendance[`${date}_${s.id}`];
        return rec && (rec.status === 'absent_unexcused' || rec.status === 'absent_excused' || rec.status === 'late');
      });

      if (absentees.length === 0) {
        tbody.innerHTML = `<tr><td colspan="8" class="text-center py-8 text-slate-400 font-bold">برای این تاریخ، هیچ غایبی ثبت نشده است.</td></tr>`;
        return;
      }

      absentees.forEach((s, idx) => {
        const rec = appData.attendance[`${date}_${s.id}`];
        const classObj = appData.classes.find(c => c.id === s.classId);

        let statusBadge = '';
        let statusTitle = '';
        if (rec.status === 'absent_unexcused') {
          statusBadge = '<span class="px-2.5 py-1 rounded-full text-xs font-extrabold bg-rose-100 text-rose-700">غایب غیرموجه</span>';
          statusTitle = 'غایب غیرموجه';
        } else if (rec.status === 'absent_excused') {
          statusBadge = '<span class="px-2.5 py-1 rounded-full text-xs font-extrabold bg-sky-100 text-sky-700">غایب موجه</span>';
          statusTitle = 'غایب موجه';
        } else if (rec.status === 'late') {
          statusBadge = '<span class="px-2.5 py-1 rounded-full text-xs font-extrabold bg-amber-100 text-amber-700">تأخیر ورود</span>';
          statusTitle = 'تأخیر ورود';
        }

        const tr = document.createElement('tr');
        tr.className = 'hover:bg-slate-50 transition';
        tr.innerHTML = `
          <td class="py-3 px-4 font-bold text-slate-400">${toPersianDigits(idx + 1)}</td>
          <td class="py-3 px-4 font-extrabold text-slate-900">${s.firstName} ${s.lastName}</td>
          <td class="py-3 px-4 text-slate-600 font-semibold">${classObj ? classObj.name : ''}</td>
          <td class="py-3 px-4 font-mono text-slate-500">${toPersianDigits(s.studentCode || '—')}</td>
          <td class="py-3 px-4">${statusBadge}</td>
          <td class="py-3 px-4 text-xs text-slate-500">${rec.notes || '—'}</td>
          <td class="py-3 px-4 font-mono font-bold text-slate-700">${toPersianDigits(s.parentPhone || '—')}</td>
          <td class="py-3 px-4 text-center">
            <div class="flex items-center justify-center gap-1.5">
              ${s.parentPhone ? `
                <a href="tel:${s.parentPhone}" class="px-3 py-1.5 rounded-xl bg-indigo-600 hover:bg-indigo-700 text-white text-xs font-bold flex items-center gap-1 shadow-sm transition">
                  <span>📞 تماس</span>
                </a>
              ` : ''}
              ${rec.status === 'absent_unexcused' ? `
                <button onclick="changeToExcused(${s.id})" class="px-2.5 py-1.5 rounded-xl bg-sky-50 hover:bg-sky-100 text-sky-700 text-xs font-bold border border-sky-200 transition" title="تبدیل به موجه">
                  موجه کردن
                </button>
              ` : ''}
            </div>
          </td>
        `;
        tbody.appendChild(tr);

        const ptr = document.createElement('tr');
        ptr.innerHTML = `
          <td class="border border-black p-2 text-center">${toPersianDigits(idx + 1)}</td>
          <td class="border border-black p-2 font-bold">${s.firstName} ${s.lastName}</td>
          <td class="border border-black p-2 text-center">${classObj ? classObj.name : ''}</td>
          <td class="border border-black p-2 text-center">${statusTitle}</td>
          <td class="border border-black p-2">${rec.notes || '—'}</td>
          <td class="border border-black p-2 text-center">${toPersianDigits(s.parentPhone || '—')}</td>
        `;
        printBody.appendChild(ptr);
      });
    }

    function changeToExcused(studentId) {
      const key = `${appData.currentDate}_${studentId}`;
      if (appData.attendance[key]) {
        appData.attendance[key].status = 'absent_excused';
        appData.attendance[key].notes = 'تأیید تلفنی اولیا با دفتر دبستان پرنیان';
        saveState();
        renderAbsenteesView();
        showToast('✓ وضعیت دانش‌آموز به «غایب موجه» تغییر یافت.');
      }
    }

    // ==============================================================
    // 5. MANAGE STUDENTS & CLASSES LOGIC
    // ==============================================================
    function renderManageStudentsTable(filterClass = 'all') {
      // Populate Class Filter & Modals
      const filterSelect = document.getElementById('manageClassFilter');
      filterSelect.innerHTML = `<option value="all">تمام کلاس‌ها (${toPersianDigits(appData.students.length)} دانش‌آموز)</option>`;
      
      const modalSelect = document.getElementById('newStudentClassId');
      modalSelect.innerHTML = '';

      appData.classes.forEach(c => {
        const cCount = appData.students.filter(s => s.classId === c.id).length;
        
        const opt = document.createElement('option');
        opt.value = c.id;
        opt.textContent = `${c.name} (${toPersianDigits(cCount)} دانش‌آموز)`;
        if (filterClass == c.id) opt.selected = true;
        filterSelect.appendChild(opt);

        const opt2 = document.createElement('option');
        opt2.value = c.id;
        opt2.textContent = c.name;
        if (activeTeacherClassId == c.id) opt2.selected = true;
        modalSelect.appendChild(opt2);
      });

      const tbody = document.getElementById('manageStudentsTableBody');
      tbody.innerHTML = '';

      let list = appData.students;
      if (filterClass !== 'all') {
        list = list.filter(s => s.classId === parseInt(filterClass));
      }

      if (list.length === 0) {
        tbody.innerHTML = `
          <tr>
            <td colspan="6" class="text-center py-8 text-slate-400">
              دانش‌آموزی ثبت نشده است. روی دکمه «+ ثبت دانش‌آموز جدید» کلیک فرمایید.
            </td>
          </tr>
        `;
        return;
      }

      list.forEach((s, idx) => {
        const classObj = appData.classes.find(c => c.id === s.classId);
        const tr = document.createElement('tr');
        tr.className = 'hover:bg-slate-50 transition';
        tr.innerHTML = `
          <td class="py-3 px-3 font-bold text-slate-400">${toPersianDigits(idx + 1)}</td>
          <td class="py-3 px-3 font-extrabold text-slate-900">${s.firstName} ${s.lastName}</td>
          <td class="py-3 px-3 font-semibold text-slate-600">${classObj ? classObj.name : ''}</td>
          <td class="py-3 px-3 font-mono text-slate-500">${toPersianDigits(s.studentCode || '—')}</td>
          <td class="py-3 px-3 font-mono text-slate-700 font-bold">${toPersianDigits(s.parentPhone || '—')}</td>
          <td class="py-3 px-3 text-center">
            <button onclick="deleteStudent(${s.id})" class="text-rose-500 hover:text-rose-700 font-bold text-xs p-1">
              حذف
            </button>
          </td>
        `;
        tbody.appendChild(tr);
      });
    }

    function filterStudentSearch(query) {
      const q = query.trim().toLowerCase();
      const rows = document.querySelectorAll('#manageStudentsTableBody tr');
      rows.forEach(r => {
        const text = r.textContent.toLowerCase();
        r.style.display = text.includes(q) ? '' : 'none';
      });
    }

    function openAddStudentModal() {
      if (appData.classes.length === 0) {
        showToast('ابتدا یک کلاس تعریف فرمایید.', '⚠️');
        openAddClassModal();
        return;
      }
      renderManageStudentsTable(activeTeacherClassId || 'all');
      document.getElementById('addStudentModal').classList.remove('hidden');
    }

    function closeAddStudentModal() {
      document.getElementById('addStudentModal').classList.add('hidden');
    }

    async function handleSaveNewStudent(e) {
      e.preventDefault();
      const firstName = document.getElementById('newStudentFirstName').value.trim();
      const lastName = document.getElementById('newStudentLastName').value.trim();
      const classId = parseInt(document.getElementById('newStudentClassId').value);
      const studentCode = document.getElementById('newStudentCode').value.trim();
      const parentPhone = document.getElementById('newStudentParentPhone').value.trim();

      const newId = appData.students.length > 0 ? Math.max(...appData.students.map(s => s.id)) + 1 : 1;
      const newStudent = { id: newId, firstName, lastName, classId, studentCode, parentPhone };
      appData.students.push(newStudent);
      
      // Default mark present for today
      appData.attendance[`${appData.currentDate}_${newId}`] = { status: 'present', notes: '' };
      saveState();

      // Sync with server API
      try {
        await fetch(`${API_BASE}/students`, {
          method: 'POST',
          headers: { 'Content-Type': 'application/json' },
          body: JSON.stringify({
            first_name: firstName,
            last_name: lastName,
            class_id: classId,
            student_code: studentCode,
            parent_phone: parentPhone
          })
        });
      } catch (_) {}

      // Reset form
      document.getElementById('newStudentFirstName').value = '';
      document.getElementById('newStudentLastName').value = '';
      document.getElementById('newStudentCode').value = '';
      document.getElementById('newStudentParentPhone').value = '';

      closeAddStudentModal();
      if (currentTab === 'teacher') loadTeacherClass(activeTeacherClassId);
      else renderManageStudentsTable();
      showToast(`🌸 دانش‌آموز «${firstName} ${lastName}» با موفقیت اضافه شد.`);
    }

    function openAddClassModal() {
      document.getElementById('addClassModal').classList.remove('hidden');
    }

    function closeAddClassModal() {
      document.getElementById('addClassModal').classList.add('hidden');
    }

    async function handleSaveNewClass(e) {
      e.preventDefault();
      const name = document.getElementById('newClassName').value.trim();
      const grade = parseInt(document.getElementById('newClassGrade').value);

      const newId = appData.classes.length > 0 ? Math.max(...appData.classes.map(c => c.id)) + 1 : 1;
      const newClass = { id: newId, name, grade, teacherName: appData.currentUser ? appData.currentUser.name : '' };
      appData.classes.push(newClass);
      saveState();

      // Sync with server API
      try {
        await fetch(`${API_BASE}/classes`, {
          method: 'POST',
          headers: { 'Content-Type': 'application/json' },
          body: JSON.stringify({ name, grade })
        });
      } catch (_) {}

      document.getElementById('newClassName').value = '';
      closeAddClassModal();
      activeTeacherClassId = newId;
      navigate(currentTab);
      showToast(`کلاس «${name}» با موفقیت در دبستان پرنیان ایجاد شد.`);
    }

    async function deleteStudent(studentId) {
      if (!confirm('آیا از حذف این دانش‌آموز اطمینان دارید؟')) return;
      appData.students = appData.students.filter(s => s.id !== studentId);
      saveState();

      try {
        await fetch(`${API_BASE}/students?id=${studentId}`, { method: 'DELETE' });
      } catch (_) {}

      renderManageStudentsTable();
      showToast('دانش‌آموز حذف شد.');
    }

    // ==============================================================
    // 6. CSV / EXCEL EXPORT
    // ==============================================================
    function exportToCsv() {
      if (appData.students.length === 0) {
        showToast('دانش‌آموزی برای خروجی اکسل وجود ندارد.', '⚠️');
        return;
      }
      let csvContent = "\uFEFFنام دانش آموز,نام خانوادگی,کلاس,وضعیت حضور,علت/توضیحات,شماره ولی,تاریخ,مدرسه\n";
      appData.students.forEach(s => {
        const classObj = appData.classes.find(c => c.id === s.classId);
        const rec = appData.attendance[`${appData.currentDate}_${s.id}`] || { status: 'ثبت نشده', notes: '' };
        
        let statusTitle = 'حاضر';
        if (rec.status === 'absent_unexcused') statusTitle = 'غایب غیرموجه';
        else if (rec.status === 'absent_excused') statusTitle = 'غایب موجه';
        else if (rec.status === 'late') statusTitle = 'تأخیر';

        csvContent += `"${s.firstName}","${s.lastName}","${classObj ? classObj.name : ''}","${statusTitle}","${rec.notes || ''}","${s.parentPhone || ''}","${appData.currentDate}","دبستان دخترانه پرنیان"\n`;
      });

      const blob = new Blob([csvContent], { type: 'text/csv;charset=utf-8;' });
      const url = URL.createObjectURL(blob);
      const a = document.createElement('a');
      a.href = url;
      a.download = `حضور_غیاب_دبستان_پرنیان_${appData.currentDate.replace(/\//g, '-')}.csv`;
      document.body.appendChild(a);
      a.click();
      document.body.removeChild(a);
      showToast('📥 فایل اکسل با موفقیت دانلود شد.');
    }

    // ==============================================================
    // 7. USER AUTH & REGISTRATION LOGIC
    // ==============================================================
    function renderUserProfile() {
      const container = document.getElementById('userProfileArea');
      const u = appData.currentUser;

      if (!u) {
        container.innerHTML = `
          <button onclick="openAuthModal('register')" class="px-3 py-1.5 rounded-xl bg-white text-purple-900 font-extrabold text-xs shadow-sm hover:bg-purple-50 transition flex items-center gap-1.5">
            <span>👤 ثبت‌نام / ورود کادر</span>
          </button>
        `;
        return;
      }

      container.innerHTML = `
        <div class="flex items-center gap-2 cursor-pointer bg-white/10 hover:bg-white/20 px-3 py-1.5 rounded-2xl border border-white/20 transition" onclick="openAuthModal('register')">
          <div class="w-7 h-7 rounded-full bg-white text-purple-700 flex items-center justify-center font-bold text-xs shadow-inner">
            ${u.role === 'principal' ? '👩‍💼' : (u.role === 'teacher' ? '👩‍🏫' : '🧑‍💼')}
          </div>
          <div class="text-right hidden sm:block">
            <div class="text-xs font-bold leading-none">${u.name}</div>
            <div class="text-[10px] text-purple-200 mt-0.5 leading-none">${u.roleTitle || 'کادر پرنیان'}</div>
          </div>
        </div>
      `;
    }

    function openAuthModal(mode = 'register') {
      switchAuthTab(mode);
      document.getElementById('authModal').classList.remove('hidden');
    }

    function closeAuthModal() {
      document.getElementById('authModal').classList.add('hidden');
    }

    function switchAuthTab(tab) {
      const btnReg = document.getElementById('tabBtnRegister');
      const btnLog = document.getElementById('tabBtnLogin');
      const formReg = document.getElementById('formRegister');
      const formLog = document.getElementById('formLogin');

      if (tab === 'register') {
        btnReg.className = 'flex-1 py-2 rounded-xl text-xs font-extrabold transition-all bg-white text-purple-900 shadow-sm';
        btnLog.className = 'flex-1 py-2 rounded-xl text-xs font-extrabold transition-all text-slate-600 hover:text-slate-900';
        formReg.classList.remove('hidden');
        formLog.classList.add('hidden');
      } else {
        btnLog.className = 'flex-1 py-2 rounded-xl text-xs font-extrabold transition-all bg-white text-purple-900 shadow-sm';
        btnReg.className = 'flex-1 py-2 rounded-xl text-xs font-extrabold transition-all text-slate-600 hover:text-slate-900';
        formLog.classList.remove('hidden');
        formReg.classList.add('hidden');
      }
    }

    function toggleRegRoleFields(role) {
      const classGroup = document.getElementById('regClassGroup');
      if (role === 'teacher') {
        classGroup.classList.remove('hidden');
      } else {
        classGroup.classList.add('hidden');
      }
    }

    async function handleRegister(e) {
      e.preventDefault();
      const role = document.getElementById('regRole').value;
      const name = document.getElementById('regName').value.trim();
      const phone = document.getElementById('regPhone').value.trim();
      const password = document.getElementById('regPassword').value.trim();
      const className = document.getElementById('regClassName').value.trim();

      let roleTitle = 'آموزگار';
      if (role === 'principal') roleTitle = 'مدیر دبستان پرنیان';
      else if (role === 'staff') roleTitle = 'معاون مدرسه';
      else if (role === 'other') roleTitle = 'کادر اجرایی';

      let classId = null;
      if (role === 'teacher' && className) {
        let existingClass = appData.classes.find(c => c.name === className);
        if (!existingClass) {
          const newCId = appData.classes.length > 0 ? Math.max(...appData.classes.map(c => c.id)) + 1 : 1;
          existingClass = { id: newCId, name: className, grade: 1, teacherName: name };
          appData.classes.push(existingClass);
        } else {
          existingClass.teacherName = name;
        }
        classId = existingClass.id;
        activeTeacherClassId = classId;
      }

      const newUser = {
        id: appData.users.length + 1,
        name,
        phone,
        role,
        roleTitle,
        class_id: classId
      };

      appData.users.push(newUser);
      appData.currentUser = newUser;
      saveState();

      // Sync with server API
      try {
        await fetch(`${API_BASE}/auth/register`, {
          method: 'POST',
          headers: { 'Content-Type': 'application/json' },
          body: JSON.stringify({ name, phone, password, role, class_name: className, class_id: classId })
        });
      } catch (_) {}

      renderUserProfile();
      closeAuthModal();

      if (role === 'teacher') {
        navigate('teacher');
        showToast(`🌸 آموزگار گرامی «${name}» خوش آمدید! کلاس «${className || ''}» برای شما آماده است.`);
      } else {
        navigate('dashboard');
        showToast(`🌸 «${name}» عزیز، ورود شما به عنوان ${roleTitle} دبستان پرنیان انجام شد.`);
      }
    }

    async function handleLogin(e) {
      e.preventDefault();
      const phone = document.getElementById('loginPhone').value.trim();
      const password = document.getElementById('loginPassword').value.trim();

      let user = appData.users.find(u => u.phone === phone);
      if (!user) {
        // Try server login
        try {
          const res = await fetch(`${API_BASE}/auth/login`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ phone, password })
          });
          const data = await res.json();
          if (res.ok && data.user) {
            user = data.user;
          }
        } catch (_) {}
      }

      if (!user) {
        showToast('شماره یا رمز اشتباه است. در صورت نیاز، ابتدا ثبت‌نام کنید.', '⚠️');
        return;
      }

      appData.currentUser = user;
      saveState();
      renderUserProfile();
      closeAuthModal();

      if (user.role === 'teacher') {
        if (user.class_id) activeTeacherClassId = user.class_id;
        navigate('teacher');
      } else {
        navigate('dashboard');
      }
      showToast(`خوش آمدید ${user.name}`);
    }

    function resetAllDataConfirm() {
      if (!confirm('آیا مایلید تمام داده‌های ثبت‌شده را پاکسازی کنید و سامانه پرنیان از نو راه‌اندازی شود؟')) return;
      localStorage.removeItem('school_attendance_pernian_v1');
      appData = {
        schoolName: 'دبستان دخترانه پرنیان',
        currentUser: null,
        currentDate: '1403/07/04',
        classes: [],
        users: [],
        students: [],
        attendance: {}
      };
      saveState();
      location.reload();
    }

    function changeActiveDate(newDate) {
      appData.currentDate = newDate;
      saveState();
      document.querySelectorAll('.printDate').forEach(el => el.textContent = newDate);
      document.getElementById('dashTodayPersianDate').textContent = newDate;
      navigate(currentTab);
      showToast(`تاریخ به ${newDate} تنظیم شد.`);
    }

    function showToast(message, icon = '✅') {
      const toast = document.getElementById('toast');
      document.getElementById('toastIcon').textContent = icon;
      document.getElementById('toastMsg').textContent = message;
      toast.classList.remove('hidden');
      setTimeout(() => { toast.classList.add('hidden'); }, 3500);
    }

    // --- On Application Start ---
    window.addEventListener('DOMContentLoaded', () => {
      document.getElementById('dashTodayPersianDate').textContent = appData.currentDate;
      document.getElementById('activeDateInput').value = appData.currentDate;
      document.querySelectorAll('.printDate').forEach(el => el.textContent = appData.currentDate);

      renderUserProfile();
      renderDashboard();

      // If no users registered yet, prompt auth modal after slight delay
      if (!appData.currentUser && appData.users.length === 0) {
        setTimeout(() => {
          openAuthModal('register');
        }, 600);
      }
    });
  </script>
</body>
</html>

EOF_HTML

cat << 'EOF_SRV' > /opt/school-attendance/server.js
// Standalone zero-dependency HTTP server for School Attendance System
const http = require('http');
const fs = require('fs');
const path = require('path');
const crypto = require('crypto');

const PORT = process.env.PORT || 5000;
const DB_FILE = path.join(__dirname, 'school_data.json');
const JWT_SECRET = 'arvan_school_attendance_secret_key_2026_girls_elem';

// Simple HMAC-SHA256 Token generator and validator (No external jwt needed)
function signToken(payload) {
  const header = Buffer.from(JSON.stringify({ alg: 'HS256', typ: 'JWT' })).toString('base64url');
  const body = Buffer.from(JSON.stringify({ ...payload, exp: Date.now() + 30 * 24 * 3600 * 1000 })).toString('base64url');
  const signature = crypto.createHmac('sha256', JWT_SECRET).update(`${header}.${body}`).digest('base64url');
  return `${header}.${body}.${signature}`;
}

function verifyToken(token) {
  try {
    const [header, body, signature] = token.split('.');
    const expected = crypto.createHmac('sha256', JWT_SECRET).update(`${header}.${body}`).digest('base64url');
    if (signature !== expected) return null;
    const data = JSON.parse(Buffer.from(body, 'base64url').toString('utf8'));
    if (data.exp && Date.now() > data.exp) return null;
    return data;
  } catch (_) {
    return null;
  }
}

function hashPassword(pass) {
  return crypto.createHash('sha256').update(pass + 'arvan_salt').digest('hex');
}

// Database initial state & storage
function loadData() {
  if (fs.existsSync(DB_FILE)) {
    try {
      const data = JSON.parse(fs.readFileSync(DB_FILE, 'utf8'));
      if (data && typeof data === 'object') return data;
    } catch (_) {}
  }

  const initial = {
    school_name: 'دبستان دخترانه پرنیان',
    classes: [],
    users: [],
    students: [],
    attendance: []
  };
  saveData(initial);
  return initial;
}

function saveData(data) {
  fs.writeFileSync(DB_FILE, JSON.stringify(data, null, 2), 'utf8');
}

let db = loadData();

// HTTP Server
const server = http.createServer((req, res) => {
  // CORS Headers
  res.setHeader('Access-Control-Allow-Origin', '*');
  res.setHeader('Access-Control-Allow-Methods', 'GET, POST, PUT, DELETE, OPTIONS');
  res.setHeader('Access-Control-Allow-Headers', 'Content-Type, Authorization');

  if (req.method === 'OPTIONS') {
    res.writeHead(204);
    res.end();
    return;
  }

  const parsedUrl = new URL(req.url, `http://${req.headers.host || 'localhost'}`);
  const pathname = parsedUrl.pathname;
  const query = Object.fromEntries(parsedUrl.searchParams);

  // Helper response
  const json = (status, payload) => {
    res.writeHead(status, { 'Content-Type': 'application/json; charset=utf-8' });
    res.end(JSON.stringify(payload));
  };

  // Auth checker
  const authenticate = () => {
    const authHeader = req.headers['authorization'];
    if (!authHeader) return null;
    const token = authHeader.startsWith('Bearer ') ? authHeader.substring(7) : authHeader;
    return verifyToken(token);
  };

  // Read Body
  let bodyStr = '';
  req.on('data', chunk => { bodyStr += chunk; });
  req.on('end', () => {
    let body = {};
    if (bodyStr) {
      try { body = JSON.parse(bodyStr); } catch (_) {}
    }

    // --- Routes ---

    // 0. Serve Web Portal Frontend
    if ((pathname === '/' || pathname === '/index.html' || pathname === '/admin' || pathname === '/teacher') && (req.method === 'GET' || req.method === 'HEAD')) {
      const candidates = [
        path.join(__dirname, 'index.html'),
        path.join(__dirname, '../web_portal/index.html'),
        '/opt/school-attendance/index.html'
      ];
      for (const p of candidates) {
        if (fs.existsSync(p)) {
          res.writeHead(200, { 'Content-Type': 'text/html; charset=utf-8' });
          res.end(fs.readFileSync(p, 'utf8'));
          return;
        }
      }
    }

    // 1. Health
    if (pathname === '/api/health' && req.method === 'GET') {
      return json(200, { status: 'ok', message: 'سامانه حضور و غیاب دبستان دخترانه فعال است', timestamp: new Date().toISOString() });
    }

    // 2. Login
    if (pathname === '/api/auth/login' && req.method === 'POST') {
      const { phone, password } = body;
      const user = db.users.find(u => u.phone === phone);
      if (!user || user.password !== hashPassword(password)) {
        return json(401, { message: 'شماره تلفن یا رمز عبور اشتباه است.' });
      }
      const token = signToken({ id: user.id, phone: user.phone, role: user.role, name: user.name, class_id: user.class_id });
      let className = null;
      if (user.class_id) {
        const c = db.classes.find(cls => cls.id === user.class_id);
        if (c) className = c.name;
      }
      return json(200, {
        message: 'ورود موفقیت‌آمیز بود.',
        token,
        user: { id: user.id, name: user.name, phone: user.phone, role: user.role, class_id: user.class_id, class_name: className }
      });
    }

    // 3. Register
    if (pathname === '/api/auth/register' && req.method === 'POST') {
      const { name, phone, password, role, class_id, class_name } = body;
      if (!name || !phone || !password || !role) {
        return json(400, { message: 'لطفاً تمامی فیلدهای الزامی را پر کنید.' });
      }
      if (db.users.some(u => u.phone === phone)) {
        return json(400, { message: 'این شماره همراه قبلاً در سامانه ثبت شده است.' });
      }

      let finalClassId = class_id ? parseInt(class_id) : null;
      if (role === 'teacher' && class_name && !finalClassId) {
        let existingClass = db.classes.find(c => c.name.trim() === class_name.trim());
        if (!existingClass) {
          existingClass = {
            id: (db.classes[db.classes.length - 1]?.id || 0) + 1,
            name: class_name.trim(),
            grade: 1
          };
          db.classes.push(existingClass);
        }
        finalClassId = existingClass.id;
      }

      const newUser = {
        id: (db.users[db.users.length - 1]?.id || 0) + 1,
        name: name.trim(),
        phone: phone.trim(),
        password: hashPassword(password),
        role,
        class_id: finalClassId
      };
      db.users.push(newUser);
      saveData(db);
      const token = signToken({ id: newUser.id, phone: newUser.phone, role: newUser.role, name: newUser.name, class_id: newUser.class_id });
      let assignedClassName = null;
      if (newUser.class_id) {
        const c = db.classes.find(cls => cls.id === newUser.class_id);
        if (c) assignedClassName = c.name;
      }
      return json(201, { message: 'ثبت‌نام با موفقیت انجام شد.', token, user: { ...newUser, class_name: assignedClassName } });
    }

    // 4. Me
    if (pathname === '/api/auth/me' && req.method === 'GET') {
      const userPayload = authenticate();
      if (!userPayload) return json(401, { message: 'احراز هویت نامعتبر است.' });
      const user = db.users.find(u => u.id === userPayload.id);
      if (!user) return json(404, { message: 'کاربر یافت نشد.' });
      let className = null;
      if (user.class_id) {
        const c = db.classes.find(cls => cls.id === user.class_id);
        if (c) className = c.name;
      }
      return json(200, { user: { id: user.id, name: user.name, phone: user.phone, role: user.role, class_id: user.class_id, class_name: className } });
    }

    // 5. Classes (GET & POST)
    if (pathname === '/api/classes' && req.method === 'GET') {
      const list = db.classes.map(c => {
        const count = db.students.filter(s => s.class_id === c.id).length;
        const teacher = db.users.find(u => u.role === 'teacher' && u.class_id === c.id);
        return { ...c, student_count: count, teacher_name: teacher ? teacher.name : 'بدون معلم' };
      });
      return json(200, list);
    }
    if (pathname === '/api/classes' && req.method === 'POST') {
      const { name, grade } = body;
      if (!name) return json(400, { message: 'نام کلاس الزامی است.' });
      const newClass = {
        id: (db.classes[db.classes.length - 1]?.id || 0) + 1,
        name: name.trim(),
        grade: grade ? parseInt(grade) : 1
      };
      db.classes.push(newClass);
      saveData(db);
      return json(201, { message: 'کلاس با موفقیت ثبت شد.', class: newClass });
    }

    // 6. Students (GET, POST, DELETE)
    if (pathname === '/api/students' && req.method === 'GET') {
      const classId = query.class_id ? parseInt(query.class_id) : null;
      let list = classId ? db.students.filter(s => s.class_id === classId) : db.students;
      const resList = list.map(s => {
        const c = db.classes.find(cls => cls.id === s.class_id);
        return { ...s, class_name: c ? c.name : '' };
      });
      return json(200, resList);
    }
    if (pathname === '/api/students' && req.method === 'POST') {
      const { first_name, last_name, class_id, student_code, parent_phone } = body;
      if (!first_name || !last_name || !class_id) {
        return json(400, { message: 'نام، نام خانوادگی و کلاس الزامی است.' });
      }
      const newStudent = {
        id: (db.students[db.students.length - 1]?.id || 0) + 1,
        first_name: first_name.trim(),
        last_name: last_name.trim(),
        class_id: parseInt(class_id),
        student_code: student_code ? student_code.trim() : null,
        parent_phone: parent_phone ? parent_phone.trim() : null
      };
      db.students.push(newStudent);
      saveData(db);
      return json(201, { message: 'دانش‌آموز با موفقیت ثبت شد.', student: newStudent });
    }
    if (pathname === '/api/students' && req.method === 'DELETE') {
      const id = query.id ? parseInt(query.id) : (body.id ? parseInt(body.id) : null);
      if (!id) return json(400, { message: 'شناسه دانش‌آموز الزامی است.' });
      db.students = db.students.filter(s => s.id !== id);
      db.attendance = db.attendance.filter(a => a.student_id !== id);
      saveData(db);
      return json(200, { message: 'دانش‌آموز با موفقیت حذف شد.' });
    }

    // 7. Get Attendance by Class and Date
    if (pathname === '/api/attendance' && req.method === 'GET') {
      const classId = parseInt(query.class_id);
      const date = query.date;
      const classStudents = db.students.filter(s => s.class_id === classId);
      const records = classStudents.map(s => {
        const rec = db.attendance.find(a => a.student_id === s.id && a.date === date);
        const recorder = rec ? db.users.find(u => u.id === rec.recorded_by) : null;
        return {
          student_id: s.id,
          first_name: s.first_name,
          last_name: s.last_name,
          student_code: s.student_code,
          parent_phone: s.parent_phone,
          attendance_id: rec ? rec.id : null,
          status: rec ? rec.status : 'present',
          notes: rec ? rec.notes : null,
          date,
          recorded_by_name: recorder ? recorder.name : null
        };
      });
      return json(200, records);
    }

    // 8. Record Batch Attendance
    if (pathname === '/api/attendance/batch' && req.method === 'POST') {
      const user = authenticate();
      if (!user) return json(401, { message: 'ابتدا وارد شوید.' });
      const { class_id, date, records } = body;
      if (!Array.isArray(records)) return json(400, { message: 'فرمت داده نادرست است.' });

      for (const item of records) {
        const idx = db.attendance.findIndex(a => a.student_id === item.student_id && a.date === date);
        if (idx !== -1) {
          db.attendance[idx].status = item.status;
          db.attendance[idx].notes = item.notes || null;
          db.attendance[idx].recorded_by = user.id;
        } else {
          db.attendance.push({
            id: (db.attendance[db.attendance.length - 1]?.id || 0) + 1,
            student_id: item.student_id,
            class_id: parseInt(class_id),
            date,
            status: item.status,
            recorded_by: user.id,
            notes: item.notes || null
          });
        }
      }
      saveData(db);
      return json(200, { message: 'حضور و غیاب با موفقیت ثبت شد.', total_recorded: records.length });
    }

    // 9. Dashboard Summary
    if (pathname === '/api/dashboard/summary' && req.method === 'GET') {
      const date = query.date;
      const totalStudents = db.students.length;
      const dayRecords = db.attendance.filter(a => a.date === date);

      let present = 0, absentUnexcused = 0, absentExcused = 0, late = 0;
      dayRecords.forEach(r => {
        if (r.status === 'present') present++;
        else if (r.status === 'absent_unexcused') absentUnexcused++;
        else if (r.status === 'absent_excused') absentExcused++;
        else if (r.status === 'late') late++;
      });

      const totalRecorded = present + absentUnexcused + absentExcused + late;
      const attendancePercentage = totalRecorded > 0 ? Math.round(((present + late) / totalRecorded) * 100) : 0;

      const classBreakdown = db.classes.map(c => {
        const studs = db.students.filter(s => s.class_id === c.id);
        const classRecs = dayRecords.filter(r => r.class_id === c.id);
        const cPres = classRecs.filter(r => r.status === 'present').length;
        const cAbsU = classRecs.filter(r => r.status === 'absent_unexcused').length;
        const cAbsE = classRecs.filter(r => r.status === 'absent_excused').length;
        const cLate = classRecs.filter(r => r.status === 'late').length;
        return {
          class_id: c.id,
          class_name: c.name,
          grade: c.grade,
          total_students: studs.length,
          present_count: cPres,
          absent_unexcused_count: cAbsU,
          absent_excused_count: cAbsE,
          late_count: cLate,
          recorded_count: classRecs.length,
          is_submitted: classRecs.length > 0 && classRecs.length >= studs.length
        };
      });

      return json(200, {
        date,
        overall: { total_students: totalStudents, total_recorded: totalRecorded, present, absent_unexcused: absentUnexcused, absent_excused: absentExcused, late, attendance_percentage: attendancePercentage },
        classes: classBreakdown
      });
    }

    // 10. Dashboard Absentees
    if (pathname === '/api/dashboard/absentees' && req.method === 'GET') {
      const date = query.date;
      const abs = db.attendance.filter(a => a.date === date && (a.status === 'absent_unexcused' || a.status === 'absent_excused' || a.status === 'late'));
      const list = abs.map(a => {
        const student = db.students.find(s => s.id === a.student_id);
        const c = db.classes.find(cls => cls.id === a.class_id);
        const recorder = db.users.find(u => u.id === a.recorded_by);
        return {
          student_id: a.student_id,
          first_name: student ? student.first_name : '',
          last_name: student ? student.last_name : '',
          student_code: student ? student.student_code : '',
          parent_phone: student ? student.parent_phone : '',
          class_id: a.class_id,
          class_name: c ? c.name : '',
          status: a.status,
          notes: a.notes,
          date: a.date,
          teacher_name: recorder ? recorder.name : 'معلم کلاس'
        };
      });
      return json(200, list);
    }

    // Default 404
    json(404, { message: 'آدرس مورد نظر یافت نشد.' });
  });
});

server.listen(PORT, '0.0.0.0', () => {
  console.log(`====================================================`);
  console.log(`🌸 سرور مستقل سیستم حضور و غیاب دبستان روی پورت ${PORT} فعال است`);
  console.log(`🚀 بدون نیاز به npm - کاملاً پایدار و با ذخیره دائمی`);
  console.log(`====================================================`);
});

EOF_SRV

# Configure to listen on both port 80 and 5000 via iptables or port 80 directly
iptables -t nat -A PREROUTING -p tcp --dport 80 -j REDIRECT --to-port 5000 2>/dev/null || true

systemctl restart school-backend 2>/dev/null || pm2 restart all 2>/dev/null || (pkill -f "node.*server.js" || true; nohup node /opt/school-attendance/server.js > /opt/school-attendance/server.log 2>&1 &)

echo "=========================================================="
echo "🌸 وب‌سایت اختصاصی حضور و غیاب دبستان با موفقیت روی سرور آروان نصب شد!"
echo "تست خروجی:"
curl -s http://localhost:5000/api/health
echo ""
echo "=========================================================="
