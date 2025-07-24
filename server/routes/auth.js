const express = require('express');
const router = express.Router();
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');

// 模拟用户数据库
const users = [
  {
    id: "1",
    username: "demo",
    password: "$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi", // password
    email: "demo@example.com",
    phone: "13800138000",
    nickname: "演示用户",
    avatar: "https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=200&h=200&fit=crop&crop=face",
    createdAt: "2023-01-01T00:00:00.000Z"
  }
];

// JWT密钥
const JWT_SECRET = process.env.JWT_SECRET || 'your-secret-key';

// POST /api/auth/login - 用户登录
router.post('/login', async (req, res) => {
  try {
    const { username, password } = req.body;
    
    if (!username || !password) {
      return res.status(400).json({
        status: 'error',
        message: 'Username and password are required'
      });
    }
    
    // 查找用户
    const user = users.find(u => u.username === username || u.email === username || u.phone === username);
    
    if (!user) {
      return res.status(401).json({
        status: 'error',
        message: 'Invalid credentials'
      });
    }
    
    // 验证密码
    const isValidPassword = await bcrypt.compare(password, user.password);
    
    if (!isValidPassword) {
      return res.status(401).json({
        status: 'error',
        message: 'Invalid credentials'
      });
    }
    
    // 生成JWT token
    const token = jwt.sign(
      { 
        id: user.id, 
        username: user.username,
        email: user.email 
      },
      JWT_SECRET,
      { expiresIn: '7d' }
    );
    
    // 返回用户信息（不包含密码）
    const { password: _, ...userInfo } = user;
    
    res.json({
      status: 'success',
      message: 'Login successful',
      data: {
        user: userInfo,
        token: token,
        tokenType: 'Bearer',
        expiresIn: '7d'
      },
      timestamp: new Date().toISOString()
    });
  } catch (error) {
    res.status(500).json({
      status: 'error',
      message: 'Login failed',
      error: error.message
    });
  }
});

// POST /api/auth/register - 用户注册
router.post('/register', async (req, res) => {
  try {
    const { username, password, email, phone, nickname } = req.body;
    
    // 验证必填字段
    if (!username || !password || !email) {
      return res.status(400).json({
        status: 'error',
        message: 'Username, password and email are required'
      });
    }
    
    // 检查用户是否已存在
    const existingUser = users.find(u => 
      u.username === username || 
      u.email === email || 
      (phone && u.phone === phone)
    );
    
    if (existingUser) {
      return res.status(409).json({
        status: 'error',
        message: 'User already exists'
      });
    }
    
    // 密码加密
    const hashedPassword = await bcrypt.hash(password, 10);
    
    // 创建新用户
    const newUser = {
      id: (users.length + 1).toString(),
      username,
      password: hashedPassword,
      email,
      phone: phone || null,
      nickname: nickname || username,
      avatar: `https://images.unsplash.com/photo-${Date.now()}?w=200&h=200&fit=crop&crop=face`,
      createdAt: new Date().toISOString()
    };
    
    users.push(newUser);
    
    // 生成JWT token
    const token = jwt.sign(
      { 
        id: newUser.id, 
        username: newUser.username,
        email: newUser.email 
      },
      JWT_SECRET,
      { expiresIn: '7d' }
    );
    
    // 返回用户信息（不包含密码）
    const { password: _, ...userInfo } = newUser;
    
    res.status(201).json({
      status: 'success',
      message: 'Registration successful',
      data: {
        user: userInfo,
        token: token,
        tokenType: 'Bearer',
        expiresIn: '7d'
      },
      timestamp: new Date().toISOString()
    });
  } catch (error) {
    res.status(500).json({
      status: 'error',
      message: 'Registration failed',
      error: error.message
    });
  }
});

// POST /api/auth/logout - 用户登出
router.post('/logout', (req, res) => {
  try {
    // 在实际应用中，这里应该将token加入黑名单
    res.json({
      status: 'success',
      message: 'Logout successful',
      timestamp: new Date().toISOString()
    });
  } catch (error) {
    res.status(500).json({
      status: 'error',
      message: 'Logout failed',
      error: error.message
    });
  }
});

// POST /api/auth/refresh - 刷新token
router.post('/refresh', (req, res) => {
  try {
    const { token } = req.body;
    
    if (!token) {
      return res.status(400).json({
        status: 'error',
        message: 'Token is required'
      });
    }
    
    // 验证旧token
    jwt.verify(token, JWT_SECRET, (err, decoded) => {
      if (err) {
        return res.status(403).json({
          status: 'error',
          message: 'Invalid token'
        });
      }
      
      // 生成新token
      const newToken = jwt.sign(
        { 
          id: decoded.id, 
          username: decoded.username,
          email: decoded.email 
        },
        JWT_SECRET,
        { expiresIn: '7d' }
      );
      
      res.json({
        status: 'success',
        message: 'Token refreshed successfully',
        data: {
          token: newToken,
          tokenType: 'Bearer',
          expiresIn: '7d'
        },
        timestamp: new Date().toISOString()
      });
    });
  } catch (error) {
    res.status(500).json({
      status: 'error',
      message: 'Token refresh failed',
      error: error.message
    });
  }
});

module.exports = router;