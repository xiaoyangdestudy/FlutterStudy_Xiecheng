const express = require('express');
const router = express.Router();
const cities = require('../data/cities');

// GET /api/cities - 获取城市列表
router.get('/', (req, res) => {
  try {
    const { popular, search, limit } = req.query;
    let filteredCities = [...cities];
    
    // 筛选热门城市
    if (popular === 'true') {
      filteredCities = filteredCities.filter(city => city.popular);
    }
    
    // 搜索功能
    if (search) {
      const searchTerm = search.toLowerCase();
      filteredCities = filteredCities.filter(city =>
        city.name.toLowerCase().includes(searchTerm) ||
        city.pinyin.toLowerCase().includes(searchTerm) ||
        city.code.toLowerCase().includes(searchTerm) ||
        city.province.toLowerCase().includes(searchTerm)
      );
    }
    
    // 限制返回数量
    if (limit) {
      const limitNum = parseInt(limit);
      filteredCities = filteredCities.slice(0, limitNum);
    }
    
    res.json({
      status: 'success',
      message: 'Cities retrieved successfully',
      data: filteredCities,
      total: filteredCities.length,
      filters: { popular, search, limit },
      timestamp: new Date().toISOString()
    });
  } catch (error) {
    res.status(500).json({
      status: 'error',
      message: 'Failed to retrieve cities',
      error: error.message
    });
  }
});

// GET /api/cities/:id - 获取特定城市信息
router.get('/:id', (req, res) => {
  try {
    const { id } = req.params;
    const city = cities.find(c => c.id === id || c.code === id.toUpperCase());
    
    if (!city) {
      return res.status(404).json({
        status: 'error',
        message: 'City not found'
      });
    }
    
    res.json({
      status: 'success',
      message: 'City retrieved successfully',
      data: city,
      timestamp: new Date().toISOString()
    });
  } catch (error) {
    res.status(500).json({
      status: 'error',
      message: 'Failed to retrieve city',
      error: error.message
    });
  }
});

// GET /api/cities/search/:term - 搜索城市
router.get('/search/:term', (req, res) => {
  try {
    const { term } = req.params;
    const { limit = 10 } = req.query;
    
    const searchTerm = term.toLowerCase();
    const searchResults = cities
      .filter(city =>
        city.name.toLowerCase().includes(searchTerm) ||
        city.pinyin.toLowerCase().includes(searchTerm) ||
        city.code.toLowerCase().includes(searchTerm) ||
        city.province.toLowerCase().includes(searchTerm) ||
        city.description.toLowerCase().includes(searchTerm)
      )
      .slice(0, parseInt(limit));
    
    res.json({
      status: 'success',
      message: `Search results for "${term}"`,
      data: searchResults,
      total: searchResults.length,
      searchTerm: term,
      timestamp: new Date().toISOString()
    });
  } catch (error) {
    res.status(500).json({
      status: 'error',
      message: 'Failed to search cities',
      error: error.message
    });
  }
});

// GET /api/cities/popular/list - 获取热门城市列表
router.get('/popular/list', (req, res) => {
  try {
    const popularCities = cities.filter(city => city.popular);
    
    res.json({
      status: 'success',
      message: 'Popular cities retrieved successfully',
      data: popularCities,
      total: popularCities.length,
      timestamp: new Date().toISOString()
    });
  } catch (error) {
    res.status(500).json({
      status: 'error',
      message: 'Failed to retrieve popular cities',
      error: error.message
    });
  }
});

module.exports = router;