const swaggerJsdoc = require('swagger-jsdoc');

const options = {
  definition: {
    openapi: '3.0.0',
    info: {
      title: 'Sinapsis API',
      version: '1.0.0',
      description: 'Documentación de la API de Sinapsis (campañas y clientes)',
    },
    servers: [
      { url: `http://localhost:${process.env.PORT || 3000}`, description: 'Servidor local' },
    ],
  },
  apis: ['./src/index.js', './src/routes/*.js'],
};

module.exports = swaggerJsdoc(options);
