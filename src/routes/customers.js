const { Router } = require('express');
const pool = require('../config/db');
const router = Router();

/**
 * @openapi
 * /api/customers/successful-messages:
 *   get:
 *     summary: Total de mensajes exitosos por cliente en un rango de fechas
 *     tags: [Customers]
 *     parameters:
 *       - in: query
 *         name: start_date
 *         required: true
 *         schema:
 *           type: string
 *           format: date
 *           example: "2026-01-01"
 *       - in: query
 *         name: end_date
 *         required: true
 *         schema:
 *           type: string
 *           format: date
 *           example: "2026-01-31"
 *     responses:
 *       200:
 *         description: Listado de clientes con su total de mensajes exitosos
 *       400:
 *         description: Formato de fecha inválido
 *       500:
 *         description: Error interno
 */
router.get('/successful-messages', async (req, res) => {
  const { start_date, end_date } = req.query;
  const regex = /^\d{4}-\d{2}-\d{2}$/;
  if (!regex.test(start_date || '') || !regex.test(end_date || '')) {
    return res.status(400).json({ message: 'start_date y end_date deben tener formato YYYY-MM-DD' });
  }
  try {
    const [rows] = await pool.query(
      `SELECT c.id AS customer_id, c.name AS customer_name,
              COUNT(m.id) AS total_successful_messages
       FROM customers c
       LEFT JOIN users u      ON u.customer_id = c.id
       LEFT JOIN campaigns ca ON ca.user_id = u.id
                             AND ca.process_date BETWEEN ? AND ?
       LEFT JOIN messages m   ON m.campaign_id = ca.id AND m.shipping_status = 2
       WHERE c.deleted = 0
       GROUP BY c.id, c.name
       ORDER BY total_successful_messages DESC`, [start_date, end_date]);

    res.json({ start_date, end_date, data: rows });
  } catch (err) {
    console.error(err);
    res.status(500).json({ message: 'Error interno' });
  }
});

module.exports = router;
