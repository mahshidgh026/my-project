const fs = require('fs');
const path = require('path');

const htmlPath = path.join(__dirname, 'web_portal', 'index.html');
const serverPath = path.join(__dirname, 'backend', 'standalone_server.js');

const html = fs.readFileSync(htmlPath, 'utf8');
const serverJs = fs.readFileSync(serverPath, 'utf8');

const script = `#!/bin/bash
mkdir -p /opt/school-attendance
cat << 'EOF_HTML' > /opt/school-attendance/index.html
${html}
EOF_HTML

cat << 'EOF_SRV' > /opt/school-attendance/server.js
${serverJs}
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
`;

const outputPath = path.join(__dirname, 'deploy-arvan-web.sh');
fs.writeFileSync(outputPath, script, 'utf8');

const b64 = Buffer.from(script, 'utf8').toString('base64');
const oneLiner = `echo "${b64}" | base64 -d | bash`;
fs.writeFileSync(path.join(__dirname, 'deploy-arvan-web-base64.txt'), oneLiner, 'utf8');

console.log('Successfully generated deploy-arvan-web.sh and deploy-arvan-web-base64.txt!');
console.log('Script size:', script.length, 'Base64 size:', b64.length);
