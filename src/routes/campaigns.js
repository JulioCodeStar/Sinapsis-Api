const { Router } = require('express');
const pool = require('../config/db');
const router = Router();

/**
 * @openapi
 * /api/campaigns/{id}/totals:
 *   put:
 *     summary: Recalcula y actualiza los totales de una campaña
 *     tags: [Campaigns]
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: integer
 *     responses:
 *       200:
 *         description: Totales actualizados
 *       400:
 *         description: id inválido
 *       404:
 *         description: Campaña no encontrada
 *       500:
 *         description: Error interno
 */
router.put('/:id/totals', async (req, res) => {
  const id = Number(req.params.id);
  if (!Number.isInteger(id) || id <= 0) {
    return res.status(400).json({ message: 'id inválido' });
  }
  try {
    const [[campaign]] = await pool.query('SELECT id FROM campaigns WHERE id = ?', [id]);
    if (!campaign) return res.status(404).json({ message: 'Campaña no encontrada' });

    const [[t]] = await pool.query(
      `SELECT COUNT(*) AS total_records,
        COALESCE(SUM(shipping_status = 2), 0) AS total_sent,
        COALESCE(SUM(shipping_status = 3), 0) AS total_error
       FROM messages WHERE campaign_id = ?`, [id]);

    await pool.query(
      'UPDATE campaigns SET total_records = ?, total_sent = ?, total_error = ? WHERE id = ?',
      [t.total_records, t.total_sent, t.total_error, id]);

    res.json({ campaign_id: id, ...t });
  } catch (err) {
    console.error(err);
    res.status(500).json({ message: 'Error interno' });
  }
});

/**
 * @openapi
 * /api/campaigns/{id}/status:
 *   put:
 *     summary: Actualiza el estado de proceso de una campaña según sus mensajes pendientes
 *     tags: [Campaigns]
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: integer
 *     responses:
 *       200:
 *         description: Estado actualizado
 *       400:
 *         description: id inválido
 *       404:
 *         description: Campaña no encontrada
 *       500:
 *         description: Error interno
 */
router.put('/:id/status', async (req, res) => {
  const id = Number(req.params.id);
  if (!Number.isInteger(id) || id <= 0) {
    return res.status(400).json({ message: 'id inválido' });
  }
  try {
    const [[campaign]] = await pool.query('SELECT id FROM campaigns WHERE id = ?', [id]);
    if (!campaign) return res.status(404).json({ message: 'Campaña no encontrada' });

    const [[info]] = await pool.query(
      `SELECT COALESCE(SUM(shipping_status = 1), 0) AS pending,
              MAX(shipping_hour) AS final_hour
       FROM messages WHERE campaign_id = ?`, [id]);

    const finished = Number(info.pending) === 0;
    const process_status = finished ? 2 : 1;
    const final_hour = finished ? info.final_hour : null;

    await pool.query(
      'UPDATE campaigns SET process_status = ?, final_hour = ? WHERE id = ?',
      [process_status, final_hour, id]);

    res.json({ campaign_id: id, process_status, final_hour });
  } catch (err) {
    console.error(err);
    res.status(500).json({ message: 'Error interno' });
  }
});

module.exports = router;
