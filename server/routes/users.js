const express = require('express');
const router = express.Router();
const jwt = require('jsonwebtoken');

// 模拟用户数据
const users = [
  {
    id: "1",
    username: "demo_user",
    email: "demo@example.com",
    phone: "13800138000",
    nickname: "演示用户", 
    avatar: "https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=200&h=200&fit=crop&crop=face",
    gender: "male",
    birthday: "1990-01-01",
    location: "北京市",
    vipLevel: "gold",
    points: 2580,
    totalOrders: 15,
    totalSpent: 25800,
    joinDate: "2023-01-01T00:00:00.000Z",
    lastLogin: new Date().toISOString(),
    preferences: {
      currency: "CNY",
      language: "zh-CN",
      notifications: {
        promotions: true,
        orderUpdates: true,
        systemMessages: false
      }
    }
  }
];

// JWT密钥
const JWT_SECRET = process.env.JWT_SECRET || 'your-secret-key';

// 中间件：验证JWT token
const authenticateToken = (req, res, next) => {
  const authHeader = req.headers['authorization'];
  const token = authHeader && authHeader.split(' ')[1];

  if (!token) {
    return res.status(401).json({
      status: 'error',
      message: 'Access token required'
    });
  }

  jwt.verify(token, JWT_SECRET, (err, user) => {
    if (err) {
      return res.status(403).json({
        status: 'error',
        message: 'Invalid or expired token'
      });
    }
    req.user = user;
    next();
  });
};

// GET /api/user/profile - 获取用户信息
router.get('/profile', authenticateToken, (req, res) => {
  try {
    const user = users.find(u => u.id === req.user.id);
    
    if (!user) {
      return res.status(404).json({
        status: 'error',
        message: 'User not found'
      });
    }
    
    // 不返回敏感信息
    const { password, ...userProfile } = user;
    
    res.json({
      status: 'success',
      message: 'User profile retrieved successfully',
      data: userProfile,
      timestamp: new Date().toISOString()
    });
  } catch (error) {
    res.status(500).json({
      status: 'error',
      message: 'Failed to retrieve user profile',
      error: error.message
    });
  }
});

// PUT /api/user/profile - 更新用户信息
router.put('/profile', authenticateToken, (req, res) => {
  try {
    const userIndex = users.findIndex(u => u.id === req.user.id);
    
    if (userIndex === -1) {
      return res.status(404).json({
        status: 'error',
        message: 'User not found'
      });
    }
    
    const allowedUpdates = ['nickname', 'avatar', 'gender', 'birthday', 'location', 'phone', 'preferences'];
    const updates = {};
    
    // 只允许更新特定字段
    Object.keys(req.body).forEach(key => {
      if (allowedUpdates.includes(key)) {
        updates[key] = req.body[key];
      }
    });
    
    // 更新用户信息
    users[userIndex] = { ...users[userIndex], ...updates };
    
    const { password, ...updatedProfile } = users[userIndex];
    
    res.json({
      status: 'success',
      message: 'User profile updated successfully',
      data: updatedProfile,
      timestamp: new Date().toISOString()
    });
  } catch (error) {
    res.status(500).json({
      status: 'error',
      message: 'Failed to update user profile',
      error: error.message
    });
  }
});

// GET /api/user/stats - 获取用户统计信息
router.get('/stats', authenticateToken, (req, res) => {
  try {
    const user = users.find(u => u.id === req.user.id);
    
    if (!user) {
      return res.status(404).json({
        status: 'error',
        message: 'User not found'
      });
    }
    
    const stats = {
      totalOrders: user.totalOrders,
      totalSpent: user.totalSpent,
      points: user.points,
      vipLevel: user.vipLevel,
      joinDate: user.joinDate,
      lastLogin: user.lastLogin,
      membershipDays: Math.floor((new Date() - new Date(user.joinDate)) / (1000 * 60 * 60 * 24))
    };
    
    res.json({
      status: 'success',
      message: 'User statistics retrieved successfully',
      data: stats,
      timestamp: new Date().toISOString()
    });
  } catch (error) {
    res.status(500).json({
      status: 'error',
      message: 'Failed to retrieve user statistics',
      error: error.message
    });
  }
});

// POST /api/user/avatar - 更新用户头像
router.post('/avatar', authenticateToken, (req, res) => {
  try {
    const { avatar } = req.body;
    
    if (!avatar) {
      return res.status(400).json({
        status: 'error',
        message: 'Avatar URL is required'
      });
    }
    
    const userIndex = users.findIndex(u => u.id === req.user.id);
    
    if (userIndex === -1) {
      return res.status(404).json({
        status: 'error',
        message: 'User not found'
      });
    }
    
    users[userIndex].avatar = avatar;
    
    res.json({
      status: 'success',
      message: 'Avatar updated successfully',
      data: { avatar: users[userIndex].avatar },
      timestamp: new Date().toISOString()
    });
  } catch (error) {
    res.status(500).json({
      status: 'error',
      message: 'Failed to update avatar',
      error: error.message
    });
  }
});

module.exports = router;