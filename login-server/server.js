const express = require('express');
const cors = require('cors');

const app = express();
const PORT = 3001;

// 中间件配置
app.use(cors()); // 允许跨域访问
app.use(express.json()); // 解析JSON请求体

// 模拟用户数据
const users = [
  { account: 'test', password: '123456', name: '测试用户', id: 1 },
  { account: 'admin', password: 'admin123', name: '管理员', id: 2 },
  { account: 'user1', password: 'password', name: '用户1', id: 3 }
];

// 登录接口
app.post('/api/login', (req, res) => {
  const { account, password } = req.body;
  
  console.log(`登录请求 - 账号: ${account}, 密码: ${password}`);
  
  // 参数验证
  if (!account || !password) {
    return res.status(400).json({
      success: false,
      message: '账号和密码不能为空'
    });
  }
  
  // 查找用户
  const user = users.find(u => u.account === account && u.password === password);
  
  if (user) {
    // 登录成功
    const token = `token_${user.id}_${Date.now()}`;
    res.json({
      success: true,
      message: '登录成功',
      token: token,
      user: {
        id: user.id,
        name: user.name,
        account: user.account
      }
    });
    console.log('登录成功');
  } else {
    // 登录失败
    res.status(401).json({
      success: false,
      message: '账号或密码错误'
    });
    console.log('登录失败');
  }
});

// 注册接口
app.post('/api/register', (req, res) => {
  const { account, password, name } = req.body;
  
  console.log(`注册请求 - 账号: ${account}, 姓名: ${name}`);
  
  if (!account || !password || !name) {
    return res.status(400).json({
      success: false,
      message: '所有字段都不能为空'
    });
  }
  
  // 检查账号是否已存在
  const existingUser = users.find(u => u.account === account);
  if (existingUser) {
    return res.status(409).json({
      success: false,
      message: '账号已存在'
    });
  }
  
  // 添加新用户
  const newUser = {
    id: users.length + 1,
    account,
    password,
    name
  };
  users.push(newUser);
  
  res.json({
    success: true,
    message: '注册成功',
    user: {
      id: newUser.id,
      name: newUser.name,
      account: newUser.account
    }
  });
  console.log('注册成功');
});

// 获取用户信息接口
app.get('/api/user/:id', (req, res) => {
  const userId = parseInt(req.params.id);
  const user = users.find(u => u.id === userId);
  
  if (user) {
    res.json({
      success: true,
      user: {
        id: user.id,
        name: user.name,
        account: user.account
      }
    });
  } else {
    res.status(404).json({
      success: false,
      message: '用户不存在'
    });
  }
});

// 健康检查接口
app.get('/api/health', (req, res) => {
  res.json({
    status: 'ok',
    message: '服务器运行正常',
    timestamp: new Date().toISOString()
  });
});

// 启动服务器
app.listen(PORT, () => {
  console.log(`🚀 登录服务器已启动!`);
  console.log(`📍 服务器地址: http://localhost:${PORT}`);
  console.log(`🔗 登录接口: POST http://localhost:${PORT}/api/login`);
  console.log(`🔗 注册接口: POST http://localhost:${PORT}/api/register`);
  console.log(`📝 测试账号: test / 123456`);
  console.log('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
});