const express = require('express');
const cors = require('cors');
const app = express();
const PORT = process.env.PORT || 3500;

app.use(cors({ origin: 'http://localhost:4300' }));
app.use(express.json());

let ventas = [
  { id: 1, titulo: 'Casa en Centro', precio: 120000, vendido: false },
  { id: 2, titulo: 'Departamento en Playa', precio: 90000, vendido: false }
];

app.get('/', (req, res) => {
  res.send('API Ventas Casa - Backend');
});

app.get('/api/ventas', (req, res) => {
  res.json(ventas);
});

app.get('/api/ventas/:id', (req, res) => {
  const id = Number(req.params.id);
  const venta = ventas.find(v => v.id === id);
  if (!venta) return res.status(404).json({ error: 'Venta no encontrada' });
  res.json(venta);
});

app.post('/api/ventas', (req, res) => {
  const { titulo, precio } = req.body;
  if (!titulo || typeof precio !== 'number') {
    return res.status(400).json({ error: 'Datos inválidos' });
  }
  const id = ventas.length ? Math.max(...ventas.map(v => v.id)) + 1 : 1;
  const nueva = { id, titulo, precio, vendido: false };
  ventas.push(nueva);
  res.status(201).json(nueva);
});

app.put('/api/ventas/:id', (req, res) => {
  const id = Number(req.params.id);
  const venta = ventas.find(v => v.id === id);
  if (!venta) return res.status(404).json({ error: 'Venta no encontrada' });
  const { titulo, precio, vendido } = req.body;
  if (titulo !== undefined) venta.titulo = titulo;
  if (precio !== undefined) venta.precio = precio;
  if (vendido !== undefined) venta.vendido = !!vendido;
  res.json(venta);
});

app.delete('/api/ventas/:id', (req, res) => {
  const id = Number(req.params.id);
  const index = ventas.findIndex(v => v.id === id);
  if (index === -1) return res.status(404).json({ error: 'Venta no encontrada' });
  const removed = ventas.splice(index, 1)[0];
  res.json(removed);
});

app.listen(PORT, () => console.log(`Ventas backend running on port ${PORT}`));
