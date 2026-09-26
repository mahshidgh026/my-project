const { Client } = require('ssh2');

const conn = new Client();
conn.on('ready', () => {
  console.log('SSH Client :: Connection and Authentication Ready!');
  conn.exec('uname -a; whoami; node -v || echo "Node not installed"; which docker || echo "Docker not installed"', (err, stream) => {
    if (err) throw err;
    stream.on('close', (code, signal) => {
      console.log('Stream :: close :: code: ' + code);
      conn.end();
    }).on('data', (data) => {
      console.log('STDOUT: ' + data);
    }).stderr.on('data', (data) => {
      console.log('STDERR: ' + data);
    });
  });
}).on('error', (err) => {
  console.error('SSH Connection Error:', err);
}).connect({
  host: '85.198.51.92',
  port: 22,
  username: 'root',
  password: '@M13821382m',
  readyTimeout: 20000
});
