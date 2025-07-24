const express = require('express');
const router = express.Router();
const content = require('../data/content');

// GET /api/content - 获取推荐内容（支持分页和筛选）
router.get('/', (req, res) => {
  try {
    const { 
      page = 1, 
      limit = 10, 
      type, 
      destination, 
      sortBy = 'publishDate',
      order = 'desc'
    } = req.query;
    
    let filteredContent = [...content];
    
    // 按类型筛选
    if (type) {
      filteredContent = filteredContent.filter(item => item.type === type);
    }
    
    // 按目的地筛选
    if (destination) {
      filteredContent = filteredContent.filter(item => 
        item.destination.includes(destination)
      );
    }
    
    // 排序
    filteredContent.sort((a, b) => {
      let aValue = a[sortBy];
      let bValue = b[sortBy];
      
      if (sortBy === 'publishDate') {
        aValue = new Date(aValue);
        bValue = new Date(bValue);
      } else if (sortBy === 'rating' || sortBy === 'price' || sortBy === 'views' || sortBy === 'likes') {
        aValue = parseFloat(aValue);
        bValue = parseFloat(bValue);
      }
      
      if (order === 'desc') {
        return bValue > aValue ? 1 : -1;
      } else {
        return aValue > bValue ? 1 : -1;
      }
    });
    
    // 分页
    const pageNum = parseInt(page);
    const limitNum = parseInt(limit);
    const startIndex = (pageNum - 1) * limitNum;
    const endIndex = startIndex + limitNum;
    
    const paginatedContent = filteredContent.slice(startIndex, endIndex);
    const totalPages = Math.ceil(filteredContent.length / limitNum);
    
    res.json({
      status: 'success',
      message: 'Content retrieved successfully',
      data: paginatedContent,
      pagination: {
        currentPage: pageNum,
        totalPages: totalPages,
        totalItems: filteredContent.length,
        itemsPerPage: limitNum,
        hasNext: pageNum < totalPages,
        hasPrev: pageNum > 1
      },
      filters: { type, destination, sortBy, order },
      timestamp: new Date().toISOString()
    });
  } catch (error) {
    res.status(500).json({
      status: 'error',
      message: 'Failed to retrieve content',
      error: error.message
    });
  }
});

// GET /api/content/:id - 获取特定内容详情
router.get('/:id', (req, res) => {
  try {
    const { id } = req.params;
    const contentItem = content.find(item => item.id === id);
    
    if (!contentItem) {
      return res.status(404).json({
        status: 'error',
        message: 'Content not found'
      });
    }
    
    res.json({
      status: 'success',
      message: 'Content retrieved successfully',
      data: contentItem,
      timestamp: new Date().toISOString()
    });
  } catch (error) {
    res.status(500).json({
      status: 'error',
      message: 'Failed to retrieve content',
      error: error.message
    });
  }
});

// GET /api/content/type/:type - 按类型获取内容
router.get('/type/:type', (req, res) => {
  try {
    const { type } = req.params;
    const { limit = 10 } = req.query;
    
    const typeContent = content
      .filter(item => item.type === type)
      .slice(0, parseInt(limit));
    
    res.json({
      status: 'success',
      message: `Content for type ${type} retrieved successfully`,
      data: typeContent,
      total: typeContent.length,
      type: type,
      timestamp: new Date().toISOString()
    });
  } catch (error) {
    res.status(500).json({
      status: 'error',
      message: 'Failed to retrieve content by type',
      error: error.message
    });
  }
});

module.exports = router;