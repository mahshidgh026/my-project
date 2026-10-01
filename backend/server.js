// Standalone zero-dependency HTTP server for School Attendance System
const http = require('http');
const fs = require('fs');
const path = require('path');
const crypto = require('crypto');
require('dotenv').config({ path: path.join(__dirname, '.env') });
const PORT = Number(process.env.PORT || 5000);
const configuredDataFile = process.env.DATA_FILE || 'school_data.json';
const DB_FILE = path.isAbsolute(configuredDataFile)
  ? configuredDataFile
  : path.join(__dirname, configuredDataFile);
const JWT_SECRET = process.env.JWT_SECRET || 'change-this-secret-before-production';

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

// HTTP Server Handler
const requestHandler = (req, res) => {
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
        path.join(__dirname, '../frontend/web_portal/index.html'),
        // Legacy deployment layout fallback
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
};

const server = http.createServer(requestHandler);
server.listen(PORT, '0.0.0.0', () => {
  console.log(`🌸 سرور دبستان پرنیان روی پورت ${PORT} فعال شد`);
});
