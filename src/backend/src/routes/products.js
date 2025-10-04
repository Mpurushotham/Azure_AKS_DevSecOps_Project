const express = require('express');
const router = express.Router();

// Get all products
router.get('/', async (req, res) => {
  try {
    // TODO: Fetch from database
    const products = [
      { id: 1, name: 'Product 1', price: 29.99, stock: 100 },
      { id: 2, name: 'Product 2', price: 49.99, stock: 50 }
    ];
    res.json(products);
  } catch (error) {
    res.status(500).json({ error: 'Server error' });
  }
});

// Get single product
router.get('/:id', async (req, res) => {
  try {
    // TODO: Fetch from database
    const product = { id: req.params.id, name: 'Product', price: 29.99 };
    res.json(product);
  } catch (error) {
    res.status(500).json({ error: 'Server error' });
  }
});

module.exports = router;
