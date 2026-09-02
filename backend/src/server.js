if (typeof process.loadEnvFile === 'function') {
  try {
    process.loadEnvFile();
  } catch (error) {
    if (error.code !== 'ENOENT') {
      throw error;
    }
  }
}

const { createHttpServer } = require('./infrastructure/http/http-server');

const port = Number(process.env.PORT) || 3000;
const server = createHttpServer();
server.listen(port, () => {
  console.log(`Servidor rodando em http://localhost:${port}`);
});
