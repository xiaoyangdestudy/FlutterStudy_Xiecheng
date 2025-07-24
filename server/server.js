const express = require('express');
const cors = require('cors');
const bodyParser = require('body-parser');
const morgan = require('morgan');

const app = express();
const PORT = process.env.PORT || 3002;

// 中间件配置
app.use(cors());
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));
app.use(morgan('combined'));

// 路由导入
const bannerRoutes = require('./routes/banners');
const serviceRoutes = require('./routes/services');
const promotionRoutes = require('./routes/promotions');
const contentRoutes = require('./routes/content');
const cityRoutes = require('./routes/cities');
const userRoutes = require('./routes/users');
const authRoutes = require('./routes/auth');
const searchRoutes = require('./routes/search');

// 路由配置
app.use('/api/banners', bannerRoutes);
app.use('/api/services', serviceRoutes);
app.use('/api/promotions', promotionRoutes);
app.use('/api/content', contentRoutes);
app.use('/api/cities', cityRoutes);
app.use('/api/user', userRoutes);
app.use('/api/auth', authRoutes);
app.use('/api/search', searchRoutes);

// 健康检查
app.get('/api/health', (req, res) => {
  res.json({
    status: 'success',
    message: 'Server is running',
    timestamp: new Date().toISOString()
  });
});

// 404处理
app.use('*', (req, res) => {
  res.status(404).json({
    status: 'error',
    message: 'Route not found'
  });
});

// 全局错误处理
app.use((err, req, res, next) => {
  console.error(err.stack);
  res.status(500).json({
    status: 'error',
    message: 'Internal server error'
  });
});

app.listen(PORT, () => {
  console.log(`🚀 Server running on http://localhost:${PORT}`);
  console.log(`📱 Flutter app can connect to: http://10.0.2.2:${PORT}/api`);
});

module.exports = app;