const express = require('express');
const router = express.Router();
const searchResults = require('../data/search');

// GET /api/search - 综合搜索
router.get('/', (req, res) => {
  try {
    const {
      q: query,           // 搜索关键词
      type,               // 搜索类型：hotel, attraction, food, shopping, entertainment
      city,               // 城市筛选
      page = 1,           // 页码
      limit = 10,         // 每页数量
      sortBy = 'rating',  // 排序字段：rating, price, name
      order = 'desc'      // 排序方向：asc, desc
    } = req.query;

    let results = [...searchResults];

    // 1. 关键词搜索
    if (query) {
      const searchTerm = query.toLowerCase();
      results = results.filter(item => 
        item.word.toLowerCase().includes(searchTerm) ||
        item.zonename.toLowerCase().includes(searchTerm) ||
        item.districtname.toLowerCase().includes(searchTerm) ||
        (item.description && item.description.toLowerCase().includes(searchTerm))
      );
    }

    // 2. 类型筛选
    if (type && type !== 'all') {
      results = results.filter(item => item.type === type);
    }

    // 3. 城市筛选
    if (city) {
      results = results.filter(item => 
        item.districtname.toLowerCase().includes(city.toLowerCase())
      );
    }

    // 4. 排序
    results.sort((a, b) => {
      let compareValue = 0;
      
      switch (sortBy) {
        case 'rating':
          compareValue = (b.rating || 0) - (a.rating || 0);
          break;
        case 'price':
          // 简单的价格排序（基于字符串长度，实际应用中需要更复杂的价格解析）
          const aPrice = a.price.replace(/[^\d]/g, '') || '0';
          const bPrice = b.price.replace(/[^\d]/g, '') || '0';
          compareValue = parseInt(bPrice) - parseInt(aPrice);
          break;
        case 'name':
          compareValue = a.word.localeCompare(b.word);
          break;
        default:
          compareValue = 0;
      }

      return order === 'asc' ? -compareValue : compareValue;
    });

    // 5. 分页
    const totalCount = results.length;
    const totalPages = Math.ceil(totalCount / limit);
    const startIndex = (page - 1) * limit;
    const endIndex = startIndex + parseInt(limit);
    const paginatedResults = results.slice(startIndex, endIndex);

    // 6. 构建响应
    res.json({
      status: 'success',
      data: paginatedResults,
      pagination: {
        page: parseInt(page),
        limit: parseInt(limit),
        totalCount,
        totalPages,
        hasNext: page < totalPages,
        hasPrev: page > 1
      },
      filters: {
        query: query || '',
        type: type || 'all',
        city: city || '',
        sortBy,
        order
      },
      timestamp: new Date().toISOString()
    });

  } catch (error) {
    console.error('Search error:', error);
    res.status(500).json({
      status: 'error',
      message: 'Search failed',
      error: error.message
    });
  }
});

// GET /api/search/suggestions - 搜索建议
router.get('/suggestions', (req, res) => {
  try {
    const { q: query, limit = 5 } = req.query;

    if (!query) {
      return res.json({
        status: 'success',
        data: [],
        message: 'No query provided'
      });
    }

    const searchTerm = query.toLowerCase();
    const suggestions = [];

    // 从搜索结果中提取建议
    searchResults.forEach(item => {
      if (item.word.toLowerCase().includes(searchTerm)) {
        suggestions.push({
          text: item.word,
          type: item.type,
          icon: getTypeIcon(item.type)
        });
      }
    });

    // 去重并限制数量
    const uniqueSuggestions = suggestions
      .filter((item, index, self) => 
        index === self.findIndex(t => t.text === item.text)
      )
      .slice(0, parseInt(limit));

    res.json({
      status: 'success',
      data: uniqueSuggestions,
      timestamp: new Date().toISOString()
    });

  } catch (error) {
    console.error('Suggestions error:', error);
    res.status(500).json({
      status: 'error',
      message: 'Failed to get suggestions',
      error: error.message
    });
  }
});

// GET /api/search/hot - 热门搜索
router.get('/hot', (req, res) => {
  try {
    const { limit = 10 } = req.query;

    // 模拟热门搜索（实际应用中可能基于搜索频率）
    const hotSearches = [
      { text: '北京酒店', type: 'hotel', count: 1250 },
      { text: '故宫', type: 'attraction', count: 980 },
      { text: '烤鸭', type: 'food', count: 756 },
      { text: '上海迪士尼', type: 'attraction', count: 654 },
      { text: '王府井', type: 'shopping', count: 543 },
      { text: '小笼包', type: 'food', count: 432 },
      { text: '外滩', type: 'attraction', count: 321 },
      { text: '欢乐谷', type: 'entertainment', count: 210 }
    ];

    const limitedResults = hotSearches.slice(0, parseInt(limit));

    res.json({
      status: 'success',
      data: limitedResults,
      timestamp: new Date().toISOString()
    });

  } catch (error) {
    console.error('Hot search error:', error);
    res.status(500).json({
      status: 'error',
      message: 'Failed to get hot searches',
      error: error.message
    });
  }
});

// 辅助函数：获取类型图标
function getTypeIcon(type) {
  const icons = {
    'hotel': '🏨',
    'attraction': '🎯',
    'food': '🍴',
    'shopping': '🛍️',
    'entertainment': '🎪'
  };
  return icons[type] || '📍';
}

module.exports = router;