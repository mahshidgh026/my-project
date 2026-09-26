#!/bin/bash
# ========================================================
# اسکریپت راه‌اندازی خودکار سامانه حضور و غیاب روی ابر آروان
# ========================================================

echo "🌸 در حال راه‌اندازی سرور سامانه حضور و غیاب دبستان..."

# ۱. به‌روزرسانی و نصب Node.js و PM2
apt-get update -y
curl -fsSL https://deb.nodesource.com/setup_20.x | bash -
apt-get install -y nodejs
npm install -g pm2

# ۲. ایجاد پوشه پروژه
mkdir -p /opt/school-attendance/src/config
mkdir -p /opt/school-attendance/src/controllers
mkdir -p /opt/school-attendance/src/middleware
mkdir -p /opt/school-attendance/src/routes
cd /opt/school-attendance

# ۳. ایجاد package.json
cat << 'EOF' > package.json
{
  "name": "school-attendance-backend",
  "version": "1.0.0",
  "description": "Backend API for Girls Elementary School Attendance System on ArvanCloud",
  "main": "src/server.js",
  "scripts": {
    "start": "node src/server.js"
  },
  "dependencies": {
    "bcryptjs": "^2.4.3",
    "cors": "^2.8.5",
    "dotenv": "^16.4.5",
    "express": "^4.19.2",
    "jsonwebtoken": "^9.0.2"
  }
}
EOF

# ۴. ایجاد .env
cat << 'EOF' > .env
PORT=5000
JWT_SECRET=arvan_school_attendance_secret_key_2026_girls_elem
NODE_ENV=production
DB_FILE=./database.sqlite
EOF

# ۵. ایجاد config/db.js
cat << 'EOF' > src/config/db.js
const { DatabaseSync } = require('node:sqlite');
const path = require('path');
const bcrypt = require('bcryptjs');

const dbPath = process.env.DB_FILE || path.join(__dirname, '../../database.sqlite');
const db = new DatabaseSync(dbPath);

console.log('Connected to SQLite database at:', dbPath);

const dbRun = async (sql, params = []) => {
  const stmt = db.prepare(sql);
  const info = stmt.run(...params);
  return {
    lastID: Number(info.lastInsertRowid),
    changes: info.changes
  };
};

const dbAll = async (sql, params = []) => {
  const stmt = db.prepare(sql);
  return stmt.all(...params);
};

const dbGet = async (sql, params = []) => {
  const stmt = db.prepare(sql);
  return stmt.get(...params);
};

const initDB = async () => {
  try {
    db.exec(`
      CREATE TABLE IF NOT EXISTS users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        phone TEXT UNIQUE NOT NULL,
        password TEXT NOT NULL,
        role TEXT NOT NULL CHECK(role IN ('principal', 'staff', 'teacher')),
        class_id INTEGER,
        created_at DATETIME DEFAULT CURRENT_TIMESTAMP
      );
      CREATE TABLE IF NOT EXISTS classes (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        grade INTEGER NOT NULL
      );
      CREATE TABLE IF NOT EXISTS students (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        first_name TEXT NOT NULL,
        last_name TEXT NOT NULL,
        class_id INTEGER NOT NULL,
        student_code TEXT,
        parent_phone TEXT,
        FOREIGN KEY (class_id) REFERENCES classes(id)
      );
      CREATE TABLE IF NOT EXISTS attendance (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        student_id INTEGER NOT NULL,
        class_id INTEGER NOT NULL,
        date TEXT NOT NULL,
        status TEXT NOT NULL CHECK(status IN ('present', 'absent_unexcused', 'absent_excused', 'late')),
        recorded_by INTEGER NOT NULL,
        notes TEXT,
        created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
        UNIQUE(student_id, date),
        FOREIGN KEY (student_id) REFERENCES students(id),
        FOREIGN KEY (class_id) REFERENCES classes(id),
        FOREIGN KEY (recorded_by) REFERENCES users(id)
      );
    `);

    const existingClasses = await dbAll('SELECT * FROM classes');
    if (existingClasses.length === 0) {
      console.log('Seeding initial classes and sample data for Girls Elementary School...');
      const classesData = [
        { name: 'اول یاس', grade: 1 },
        { name: 'اول نرگس', grade: 1 },
        { name: 'دوم شکوفه', grade: 2 },
        { name: 'سوم بهار', grade: 3 },
        { name: 'چهارم ترنج', grade: 4 },
        { name: 'پنجم نسترن', grade: 5 },
        { name: 'ششم نیلوفر', grade: 6 }
      ];

      for (const c of classesData) {
        await dbRun('INSERT INTO classes (name, grade) VALUES (?, ?)', [c.name, c.grade]);
      }

      const hashedPassword = await bcrypt.hash('123456', 10);
      await dbRun(`
        INSERT INTO users (name, phone, password, role, class_id)
        VALUES 
        ('خانم دکتر مهدوی (مدیر مدرسه)', '09121111111', ?, 'principal', NULL),
        ('خانم کمالی (معاون آموزشی)', '09122222222', ?, 'staff', NULL),
        ('خانم احمدی (معلم پایه اول یاس)', '09123333333', ?, 'teacher', 1),
        ('خانم رضایی (معلم پایه دوم شکوفه)', '09124444444', ?, 'teacher', 3)
      `, [hashedPassword, hashedPassword, hashedPassword, hashedPassword]);

      const studentsClass1 = [
        ['فاطمه', 'محمدی', 1, '101', '09129876501'],
        ['زهرا', 'حسینی', 1, '102', '09129876502'],
        ['زینب', 'کریمی', 1, '103', '09129876503'],
        ['ریحانه', 'صادقی', 1, '104', '09129876504'],
        ['یسنا', 'جعفری', 1, '105', '09129876505'],
        ['باران', 'موسوی', 1, '106', '09129876506'],
        ['هلیا', 'طاهری', 1, '107', '09129876507'],
        ['آوا', 'قاسمی', 1, '108', '09129876508'],
        ['ملیکا', 'اکبری', 1, '109', '09129876509'],
        ['ستایش', 'نیک‌پور', 1, '110', '09129876510']
      ];

      for (const s of studentsClass1) {
        await dbRun('INSERT INTO students (first_name, last_name, class_id, student_code, parent_phone) VALUES (?, ?, ?, ?, ?)', s);
      }

      const studentsClass3 = [
        ['پرنیان', 'احمدیان', 3, '301', '09129876521'],
        ['نازنین زهرا', 'امینی', 3, '302', '09129876522'],
        ['مهسا', 'کاظمی', 3, '303', '09129876523'],
        ['سوگند', 'رحیمی', 3, '304', '09129876524'],
        ['رها', 'فرهادی', 3, '305', '09129876525'],
        ['دیبا', 'افشار', 3, '306', '09129876526'],
        ['ترنم', 'محمودی', 3, '307', '09129876527'],
        ['النا', 'باقری', 3, '308', '09129876528']
      ];

      for (const s of studentsClass3) {
        await dbRun('INSERT INTO students (first_name, last_name, class_id, student_code, parent_phone) VALUES (?, ?, ?, ?, ?)', s);
      }
      console.log('Seeding completed successfully!');
    }
  } catch (error) {
    console.error('Database initialization error:', error);
  }
};

module.exports = { db, dbRun, dbAll, dbGet, initDB };
EOF

# ۶. ایجاد middleware/auth.js
cat << 'EOF' > src/middleware/auth.js
const jwt = require('jsonwebtoken');

const authMiddleware = (req, res, next) => {
  const authHeader = req.headers['authorization'];
  if (!authHeader) {
    return res.status(401).json({ message: 'توکن امنیتی یافت نشد.' });
  }
  const token = authHeader.startsWith('Bearer ') ? authHeader.substring(7) : authHeader;
  try {
    const decoded = jwt.verify(token, process.env.JWT_SECRET || 'default_secret');
    req.user = decoded;
    next();
  } catch (err) {
    return res.status(403).json({ message: 'توکن نامعتبر یا منقضی شده است.' });
  }
};

const isStaffOrPrincipal = (req, res, next) => {
  if (req.user && (req.user.role === 'principal' || req.user.role === 'staff')) {
    return next();
  }
  return res.status(403).json({ message: 'دسترسی فقط برای مدیر یا کادر مدرسه مجاز است.' });
};

module.exports = { authMiddleware, isStaffOrPrincipal };
EOF

# ۷. ایجاد کنترلرها
cat << 'EOF' > src/controllers/authController.js
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const { dbGet, dbRun } = require('../config/db');

exports.register = async (req, res) => {
  try {
    const { name, phone, password, role, class_id } = req.body;
    if (!name || !phone || !password || !role) return res.status(400).json({ message: 'فیلدها ناقص است.' });
    const existingUser = await dbGet('SELECT id FROM users WHERE phone = ?', [phone]);
    if (existingUser) return res.status(400).json({ message: 'شماره قبلاً ثبت شده است.' });
    const hashedPassword = await bcrypt.hash(password, 10);
    const result = await dbRun('INSERT INTO users (name, phone, password, role, class_id) VALUES (?, ?, ?, ?, ?)', [name, phone, hashedPassword, role, class_id || null]);
    const token = jwt.sign({ id: result.lastID, phone, role, name }, process.env.JWT_SECRET || 'default_secret', { expiresIn: '30d' });
    return res.status(201).json({ message: 'ثبت‌نام با موفقیت انجام شد.', token, user: { id: result.lastID, name, phone, role, class_id: class_id || null } });
  } catch (error) {
    return res.status(500).json({ message: 'خطای سرور.' });
  }
};

exports.login = async (req, res) => {
  try {
    const { phone, password } = req.body;
    if (!phone || !password) return res.status(400).json({ message: 'شماره و رمز الزامی است.' });
    const user = await dbGet('SELECT * FROM users WHERE phone = ?', [phone]);
    if (!user) return res.status(401).json({ message: 'کاربر یافت نشد.' });
    const isMatch = await bcrypt.compare(password, user.password);
    if (!isMatch) return res.status(401).json({ message: 'رمز عبور اشتباه است.' });
    const token = jwt.sign({ id: user.id, phone: user.phone, role: user.role, name: user.name, class_id: user.class_id }, process.env.JWT_SECRET || 'default_secret', { expiresIn: '30d' });
    let className = null;
    if (user.class_id) {
      const classInfo = await dbGet('SELECT name FROM classes WHERE id = ?', [user.class_id]);
      if (classInfo) className = classInfo.name;
    }
    return res.json({ message: 'ورود موفقیت‌آمیز بود.', token, user: { id: user.id, name: user.name, phone: user.phone, role: user.role, class_id: user.class_id, class_name: className } });
  } catch (error) {
    return res.status(500).json({ message: 'خطای سرور در ورود.' });
  }
};

exports.getMe = async (req, res) => {
  try {
    const user = await dbGet('SELECT id, name, phone, role, class_id, created_at FROM users WHERE id = ?', [req.user.id]);
    if (!user) return res.status(404).json({ message: 'کاربر یافت نشد.' });
    let className = null;
    if (user.class_id) {
      const classInfo = await dbGet('SELECT name FROM classes WHERE id = ?', [user.class_id]);
      if (classInfo) className = classInfo.name;
    }
    return res.json({ user: { ...user, class_name: className } });
  } catch (error) {
    return res.status(500).json({ message: 'خطا در اطلاعات کاربر.' });
  }
};
EOF

cat << 'EOF' > src/controllers/classController.js
const { dbAll, dbRun, dbGet } = require('../config/db');

exports.getClasses = async (req, res) => {
  try {
    const classes = await dbAll(`
      SELECT c.id, c.name, c.grade, COUNT(s.id) as student_count
      FROM classes c
      LEFT JOIN students s ON c.id = s.class_id
      GROUP BY c.id
      ORDER BY c.grade ASC, c.name ASC
    `);
    return res.json(classes);
  } catch (error) {
    return res.status(500).json({ message: 'خطا در کلاس‌ها.' });
  }
};

exports.createClass = async (req, res) => {
  try {
    const { name, grade } = req.body;
    const result = await dbRun('INSERT INTO classes (name, grade) VALUES (?, ?)', [name, grade]);
    const newClass = await dbGet('SELECT * FROM classes WHERE id = ?', [result.lastID]);
    return res.status(201).json({ message: 'کلاس ایجاد شد.', class: newClass });
  } catch (error) {
    return res.status(500).json({ message: 'خطا در ایجاد کلاس.' });
  }
};
EOF

cat << 'EOF' > src/controllers/studentController.js
const { dbAll, dbRun, dbGet } = require('../config/db');

exports.getStudents = async (req, res) => {
  try {
    const { class_id } = req.query;
    let query = 'SELECT s.id, s.first_name, s.last_name, s.student_code, s.parent_phone, s.class_id, c.name as class_name FROM students s JOIN classes c ON s.class_id = c.id';
    const params = [];
    if (class_id) {
      query += ' WHERE s.class_id = ?';
      params.push(class_id);
    }
    query += ' ORDER BY s.last_name ASC, s.first_name ASC';
    const students = await dbAll(query, params);
    return res.json(students);
  } catch (error) {
    return res.status(500).json({ message: 'خطا در دانش‌آموزان.' });
  }
};

exports.createStudent = async (req, res) => {
  try {
    const { first_name, last_name, class_id, student_code, parent_phone } = req.body;
    const result = await dbRun('INSERT INTO students (first_name, last_name, class_id, student_code, parent_phone) VALUES (?, ?, ?, ?, ?)', [first_name, last_name, class_id, student_code || null, parent_phone || null]);
    const newStudent = await dbGet('SELECT * FROM students WHERE id = ?', [result.lastID]);
    return res.status(201).json({ message: 'دانش‌آموز ثبت شد.', student: newStudent });
  } catch (error) {
    return res.status(500).json({ message: 'خطا در ثبت دانش‌آموز.' });
  }
};
EOF

cat << 'EOF' > src/controllers/attendanceController.js
const { dbAll, dbRun } = require('../config/db');

exports.recordBatch = async (req, res) => {
  try {
    const { class_id, date, records } = req.body;
    const recorded_by = req.user.id;
    for (const item of records) {
      const { student_id, status, notes } = item;
      if (!student_id || !status) continue;
      await dbRun(`
        INSERT INTO attendance (student_id, class_id, date, status, recorded_by, notes)
        VALUES (?, ?, ?, ?, ?, ?)
        ON CONFLICT(student_id, date) 
        DO UPDATE SET status = excluded.status, notes = excluded.notes, recorded_by = excluded.recorded_by, class_id = excluded.class_id
      `, [student_id, class_id, date, status, recorded_by, notes || null]);
    }
    return res.json({ message: 'حضور و غیاب ثبت شد.', total_recorded: records.length, date, class_id });
  } catch (error) {
    return res.status(500).json({ message: 'خطا در ثبت حضور غیاب.' });
  }
};

exports.getByClassAndDate = async (req, res) => {
  try {
    const { class_id, date } = req.query;
    const query = `
      SELECT s.id as student_id, s.first_name, s.last_name, s.student_code, s.parent_phone, a.id as attendance_id, a.status, a.notes, a.date, u.name as recorded_by_name
      FROM students s
      LEFT JOIN attendance a ON s.id = a.student_id AND a.date = ?
      LEFT JOIN users u ON a.recorded_by = u.id
      WHERE s.class_id = ?
      ORDER BY s.last_name ASC, s.first_name ASC
    `;
    const list = await dbAll(query, [date, class_id]);
    return res.json(list);
  } catch (error) {
    return res.status(500).json({ message: 'خطا در دریافت حضور و غیاب.' });
  }
};
EOF

cat << 'EOF' > src/controllers/dashboardController.js
const { dbAll, dbGet } = require('../config/db');

exports.getSummary = async (req, res) => {
  try {
    const { date } = req.query;
    const totalStudentsRow = await dbGet('SELECT COUNT(*) as count FROM students');
    const totalStudents = totalStudentsRow ? totalStudentsRow.count : 0;
    const statsRows = await dbAll('SELECT status, COUNT(*) as count FROM attendance WHERE date = ? GROUP BY status', [date]);

    let present = 0, absentUnexcused = 0, absentExcused = 0, late = 0;
    statsRows.forEach(row => {
      if (row.status === 'present') present = row.count;
      else if (row.status === 'absent_unexcused') absentUnexcused = row.count;
      else if (row.status === 'absent_excused') absentExcused = row.count;
      else if (row.status === 'late') late = row.count;
    });

    const totalRecorded = present + absentUnexcused + absentExcused + late;
    const attendancePercentage = totalRecorded > 0 ? Math.round(((present + late) / totalRecorded) * 100) : 0;

    const classStats = await dbAll(`
      SELECT c.id as class_id, c.name as class_name, c.grade,
        COUNT(DISTINCT s.id) as total_students,
        COUNT(DISTINCT CASE WHEN a.status = 'present' THEN a.id END) as present_count,
        COUNT(DISTINCT CASE WHEN a.status = 'absent_unexcused' THEN a.id END) as absent_unexcused_count,
        COUNT(DISTINCT CASE WHEN a.status = 'absent_excused' THEN a.id END) as absent_excused_count,
        COUNT(DISTINCT CASE WHEN a.status = 'late' THEN a.id END) as late_count,
        COUNT(DISTINCT a.id) as recorded_count
      FROM classes c
      LEFT JOIN students s ON c.id = s.class_id
      LEFT JOIN attendance a ON s.id = a.student_id AND a.date = ?
      GROUP BY c.id
      ORDER BY c.grade ASC, c.name ASC
    `, [date]);

    return res.json({
      date,
      overall: { total_students: totalStudents, total_recorded: totalRecorded, present, absent_unexcused: absentUnexcused, absent_excused: absentExcused, late, attendance_percentage: attendancePercentage },
      classes: classStats.map(c => ({ ...c, is_submitted: c.recorded_count > 0 && c.recorded_count >= c.total_students }))
    });
  } catch (error) {
    return res.status(500).json({ message: 'خطا در آمار داشبورد.' });
  }
};

exports.getAbsentees = async (req, res) => {
  try {
    const { date, class_id } = req.query;
    let query = `
      SELECT s.id as student_id, s.first_name, s.last_name, s.student_code, s.parent_phone, c.id as class_id, c.name as class_name, a.status, a.notes, a.date, u.name as teacher_name
      FROM attendance a
      JOIN students s ON a.student_id = s.id
      JOIN classes c ON a.class_id = c.id
      JOIN users u ON a.recorded_by = u.id
      WHERE a.date = ? AND a.status IN ('absent_unexcused', 'absent_excused', 'late')
    `;
    const params = [date];
    if (class_id) {
      query += ' AND a.class_id = ?';
      params.push(class_id);
    }
    query += ' ORDER BY c.grade ASC, c.name ASC, s.last_name ASC';
    const absentees = await dbAll(query, params);
    return res.json(absentees);
  } catch (error) {
    return res.status(500).json({ message: 'خطا در لیست غایبین.' });
  }
};
EOF

# ۸. ایجاد فایل‌های روت
cat << 'EOF' > src/routes/authRoutes.js
const express = require('express');
const router = express.Router();
const authController = require('../controllers/authController');
const { authMiddleware } = require('../middleware/auth');
router.post('/register', authController.register);
router.post('/login', authController.login);
router.get('/me', authMiddleware, authController.getMe);
module.exports = router;
EOF

cat << 'EOF' > src/routes/classRoutes.js
const express = require('express');
const router = express.Router();
const classController = require('../controllers/classController');
const { authMiddleware, isStaffOrPrincipal } = require('../middleware/auth');
router.get('/', authMiddleware, classController.getClasses);
router.post('/', authMiddleware, isStaffOrPrincipal, classController.createClass);
module.exports = router;
EOF

cat << 'EOF' > src/routes/studentRoutes.js
const express = require('express');
const router = express.Router();
const studentController = require('../controllers/studentController');
const { authMiddleware, isStaffOrPrincipal } = require('../middleware/auth');
router.get('/', authMiddleware, studentController.getStudents);
router.post('/', authMiddleware, isStaffOrPrincipal, studentController.createStudent);
module.exports = router;
EOF

cat << 'EOF' > src/routes/attendanceRoutes.js
const express = require('express');
const router = express.Router();
const attendanceController = require('../controllers/attendanceController');
const { authMiddleware } = require('../middleware/auth');
router.post('/batch', authMiddleware, attendanceController.recordBatch);
router.get('/', authMiddleware, attendanceController.getByClassAndDate);
module.exports = router;
EOF

cat << 'EOF' > src/routes/dashboardRoutes.js
const express = require('express');
const router = express.Router();
const dashboardController = require('../controllers/dashboardController');
const { authMiddleware, isStaffOrPrincipal } = require('../middleware/auth');
router.get('/summary', authMiddleware, isStaffOrPrincipal, dashboardController.getSummary);
router.get('/absentees', authMiddleware, isStaffOrPrincipal, dashboardController.getAbsentees);
module.exports = router;
EOF

# ۹. ایجاد server.js اصلی
cat << 'EOF' > src/server.js
require('dotenv').config();
const express = require('express');
const cors = require('cors');
const { initDB } = require('./config/db');

const authRoutes = require('./routes/authRoutes');
const classRoutes = require('./routes/classRoutes');
const studentRoutes = require('./routes/studentRoutes');
const attendanceRoutes = require('./routes/attendanceRoutes');
const dashboardRoutes = require('./routes/dashboardRoutes');

const app = express();
const PORT = process.env.PORT || 5000;

app.use(cors({ origin: '*', methods: ['GET', 'POST', 'PUT', 'DELETE', 'OPTIONS'], allowedHeaders: ['Content-Type', 'Authorization'] }));
app.use(express.json());

app.use('/api/auth', authRoutes);
app.use('/api/classes', classRoutes);
app.use('/api/students', studentRoutes);
app.use('/api/attendance', attendanceRoutes);
app.use('/api/dashboard', dashboardRoutes);

app.get('/api/health', (req, res) => {
  res.json({ status: 'ok', message: 'سامانه حضور و غیاب دبستان فعال است', timestamp: new Date().toISOString() });
});

initDB().then(() => {
  app.listen(PORT, '0.0.0.0', () => {
    console.log(`🌸 سرور سیستم حضور و غیاب دبستان روی پورت ${PORT} فعال است.`);
  });
}).catch(err => {
  console.error('Failed to start server:', err);
});
EOF

# ۱۰. نصب پکیج‌های پروژه
npm install

# ۱۱. راه‌اندازی با PM2 به صورت دائمی
pm2 delete school-backend || true
pm2 start src/server.js --name "school-backend"
pm2 save
pm2 startup

echo "=========================================================="
echo "✓ سرور با موفقیت کامل راه‌اندازی شد!"
echo "تست سلامت سرویس:"
curl -s http://localhost:5000/api/health
echo ""
echo "=========================================================="
