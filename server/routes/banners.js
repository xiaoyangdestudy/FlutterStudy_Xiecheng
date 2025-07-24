const express = require('express');
const router = express.Router();
const banners = require('../data/banners');

// GET /api/banners - 获取轮播图数据
router.get('/', (req, res) => {
  try {
    res.json({
      status: 'success',
      message: 'Banners retrieved successfully',
      data: banners,
      total: banners.length,
      timestamp: new Date().toISOString()
    });
  } catch (error) {
    res.status(500).json({
      status: 'error', 
      message: 'Failed to retrieve banners',
      error: error.message
    });
  }
});

// GET /api/banners/:id - 获取单个轮播图
router.get('/:id', (req, res) => {
  try {
    const { id } = req.params;
    const banner = banners.find(b => b.id === id);
    
    if (!banner) {
      return res.status(404).json({
        status: 'error',
        message: 'Banner not found'
      });
    }
    
    res.json({
      status: 'success',
      message: 'Banner retrieved successfully',
      data: banner,
      timestamp: new Date().toISOString()
    });
  } catch (error) {
    res.status(500).json({
      status: 'error',
      message: 'Failed to retrieve banner',
      error: error.message
    });
  }
});

module.exports = router;