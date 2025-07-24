# 📱 Flutter App 后端服务器使用指南

## 🚀 快速启动

### 1. 安装依赖
```bash
cd server
npm install
```

### 2. 启动服务器
```bash
# 开发模式（自动重启）
npm run dev

# 生产模式
npm start
```

### 3. 访问地址
- **本地访问**: http://localhost:3001
- **Flutter模拟器**: http://10.0.2.2:3001/api
- **健康检查**: http://localhost:3001/api/health

## 📡 API 接口列表

### 🏠 首页数据接口
- `GET /api/banners` - 获取轮播图数据
- `GET /api/banners/:id` - 获取单个轮播图
- `GET /api/services` - 获取服务分类数据
- `GET /api/services/:id` - 获取特定服务分类
- `GET /api/promotions` - 获取促销活动（支持筛选：?category=hotel&limit=6）
- `GET /api/promotions/:id` - 获取特定促销活动

### 📖 内容推荐接口
- `GET /api/content` - 获取推荐内容（支持分页）
  - 参数：`?page=1&limit=10&type=destination&sortBy=publishDate&order=desc`
- `GET /api/content/:id` - 获取内容详情
- `GET /api/content/type/:type` - 按类型获取内容

### 🏙️ 城市相关接口  
- `GET /api/cities` - 获取城市列表（支持筛选：?popular=true&search=北京&limit=8）
- `GET /api/cities/:id` - 获取特定城市信息
- `GET /api/cities/search/:term` - 搜索城市
- `GET /api/cities/popular/list` - 获取热门城市

### 👤 用户认证接口
- `POST /api/auth/login` - 用户登录
- `POST /api/auth/register` - 用户注册  
- `POST /api/auth/logout` - 用户登出
- `POST /api/auth/refresh` - 刷新token

### 👤 用户信息接口（需要认证）
- `GET /api/user/profile` - 获取用户资料
- `PUT /api/user/profile` - 更新用户资料
- `GET /api/user/stats` - 获取用户统计
- `POST /api/user/avatar` - 更新用户头像

## 🔧 测试账号
- **用户名**: demo
- **密码**: password
- **邮箱**: demo@example.com

## 💡 使用示例

### 获取首页数据
```bash
# 获取轮播图
curl http://localhost:3001/api/banners

# 获取服务分类
curl http://localhost:3001/api/services

# 获取促销活动（前6个）
curl "http://localhost:3001/api/promotions?limit=6"

# 获取推荐内容（第1页，每页10条）
curl "http://localhost:3001/api/content?page=1&limit=10"

# 获取热门城市
curl "http://localhost:3001/api/cities?popular=true"
```

### 用户认证
```bash
# 登录
curl -X POST http://localhost:3001/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"username":"demo","password":"password"}'

# 获取用户信息（需要token）
curl http://localhost:3001/api/user/profile \
  -H "Authorization: Bearer YOUR_TOKEN_HERE"
```

## 📊 数据格式

### 统一响应格式
```json
{
  "status": "success|error",
  "message": "操作描述",
  "data": "实际数据",
  "timestamp": "2024-01-01T00:00:00.000Z"
}
```

### 分页格式
```json
{
  "status": "success",
  "data": [...],
  "pagination": {
    "currentPage": 1,
    "totalPages": 5,
    "totalItems": 50,
    "itemsPerPage": 10,
    "hasNext": true,
    "hasPrev": false
  }
}
```

## 🛠️ 开发功能
- ✅ CORS跨域支持
- ✅ JWT身份验证
- ✅ 请求日志记录
- ✅ 全局错误处理
- ✅ 参数验证
- ✅ 搜索和筛选
- ✅ 分页支持

## 🔗 在Flutter中使用
将你的Flutter项目中的API地址改为：
```dart
const String baseUrl = 'http://10.0.2.2:3001/api';
```