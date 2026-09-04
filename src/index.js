require('dotenv').config();
const express = require('express');
const swaggerUi = require('swagger-ui-express');
const swaggerSpec = require('./config/swagger');
const pool = require('./config/db');

const app = express();
app.use(express.json());

app.use('/api-docs', swaggerUi.serve, swaggerUi.setup(swaggerSpec));

/**
 * @openapi
 * /database:
 *   get:
 *     summary: Verifica el estado de la conexión a la base de datos
 *     tags: [Database]
 *     responses:
 *       200:
 *         description: Conexión exitosa
 *       500:
 *         description: Error de conexión
 */
app.get('/database', async (req, res) => {
  try {
    await pool.query('SELECT 1');
    res.json({ status: 'ok', database: 'connected' });
  } catch (err) {
    res.status(500).json({ status: 'error', message: err.message });
  }
});

app.use('/api/campaigns', require('./routes/campaigns'));
app.use('/api/customers', require('./routes/customers'));

app.listen(process.env.PORT, () => {
  console.log(`API escuchando en http://localhost:${process.env.PORT}`);
});
