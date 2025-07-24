const express = require('express');
const router = express.Router();
const services = require('../data/services');

// GET /api/services - 获取所有服务分类
router.get('/', (req, res) => {
  try {
    res.json({
      status: 'success',
      message: 'Services retrieved successfully',
      data: services,
      total: services.length,
      timestamp: new Date().toISOString()
    });
  } catch (error) {
    res.status(500).json({
      status: 'error',
      message: 'Failed to retrieve services',
      error: error.message
    });
  }
});

// GET /api/services/:id - 获取特定服务分类
router.get('/:id', (req, res) => {
  try {
    const { id } = req.params;
    const service = services.find(s => s.id === id);
    
    if (!service) {
      return res.status(404).json({
        status: 'error',
        message: 'Service category not found'
      });
    }
    
    res.json({
      status: 'success',
      message: 'Service category retrieved successfully',
      data: service,
      timestamp: new Date().toISOString()
    });
  } catch (error) {
    res.status(500).json({
      status: 'error',
      message: 'Failed to retrieve service category',
      error: error.message
    });
  }
});

module.exports = router;