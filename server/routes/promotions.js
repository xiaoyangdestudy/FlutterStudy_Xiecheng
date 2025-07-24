const express = require('express');
const router = express.Router();
const promotions = require('../data/promotions');

// GET /api/promotions - 获取所有促销活动
router.get('/', (req, res) => {
  try {
    const { category, limit } = req.query;
    let filteredPromotions = promotions;
    
    // 按分类筛选
    if (category) {
      filteredPromotions = promotions.filter(p => p.category === category);
    }
    
    // 限制返回数量
    if (limit) {
      const limitNum = parseInt(limit);
      filteredPromotions = filteredPromotions.slice(0, limitNum);
    }
    
    res.json({
      status: 'success',
      message: 'Promotions retrieved successfully',
      data: filteredPromotions,
      total: filteredPromotions.length,
      filters: { category, limit },
      timestamp: new Date().toISOString()
    });
  } catch (error) {
    res.status(500).json({
      status: 'error',
      message: 'Failed to retrieve promotions',
      error: error.message
    });
  }
});

// GET /api/promotions/:id - 获取特定促销活动
router.get('/:id', (req, res) => {
  try {
    const { id } = req.params;
    const promotion = promotions.find(p => p.id === id);
    
    if (!promotion) {
      return res.status(404).json({
        status: 'error',
        message: 'Promotion not found'
      });
    }
    
    res.json({
      status: 'success',
      message: 'Promotion retrieved successfully',
      data: promotion,
      timestamp: new Date().toISOString()
    });
  } catch (error) {
    res.status(500).json({
      status: 'error',
      message: 'Failed to retrieve promotion',
      error: error.message
    });
  }
});

// GET /api/promotions/category/:category - 按分类获取促销活动
router.get('/category/:category', (req, res) => {
  try {
    const { category } = req.params;
    const categoryPromotions = promotions.filter(p => p.category === category);
    
    res.json({
      status: 'success',
      message: `Promotions for category ${category} retrieved successfully`,
      data: categoryPromotions,
      total: categoryPromotions.length,
      category: category,
      timestamp: new Date().toISOString()
    });
  } catch (error) {
    res.status(500).json({
      status: 'error',
      message: 'Failed to retrieve category promotions',
      error: error.message
    });
  }
});

module.exports = router;