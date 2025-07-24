// 生成推荐内容数据
const generateContent = () => {
  const contentTypes = ['destination', 'hotel', 'experience', 'food', 'culture'];
  const destinations = ['巴厘岛', '马尔代夫', '普吉岛', '长白山', '九寨沟', '张家界', '厦门', '三亚', '青岛', '大理'];
  const content = [];

  for (let i = 1; i <= 50; i++) {
    const type = contentTypes[Math.floor(Math.random() * contentTypes.length)];
    const destination = destinations[Math.floor(Math.random() * destinations.length)];
    
    content.push({
      id: i.toString(),
      title: `${destination}${getTypeTitle(type)}推荐`,
      subtitle: getSubtitle(type, destination),
      imageUrl: `https://images.unsplash.com/photo-${1500000000000 + i}?w=400&h=300&fit=crop`,
      type: type,
      destination: destination,
      rating: (4.0 + Math.random() * 1.0).toFixed(1),
      price: Math.floor(Math.random() * 5000) + 500,
      tags: generateTags(type),
      description: `探索${destination}的美丽景色，享受独特的${getTypeTitle(type)}体验。`,
      publishDate: new Date(Date.now() - Math.random() * 30 * 24 * 60 * 60 * 1000).toISOString(),
      views: Math.floor(Math.random() * 10000) + 100,
      likes: Math.floor(Math.random() * 1000) + 10
    });
  }
  
  return content.sort((a, b) => new Date(b.publishDate) - new Date(a.publishDate));
};

function getTypeTitle(type) {
  const titles = {
    'destination': '景点',
    'hotel': '酒店',
    'experience': '体验',
    'food': '美食',
    'culture': '文化'
  };
  return titles[type] || '推荐';
}

function getSubtitle(type, destination) {
  const subtitles = {
    'destination': `${destination}必去景点指南`,
    'hotel': `${destination}精选酒店住宿`,
    'experience': `${destination}独特体验活动`,
    'food': `${destination}地道美食推荐`,
    'culture': `${destination}文化深度游`
  };
  return subtitles[type] || `${destination}旅游推荐`;
}

function generateTags(type) {
  const tagOptions = {
    'destination': ['自然风光', '人文景观', '网红打卡', '亲子游'],
    'hotel': ['豪华酒店', '性价比', '海景房', '度假村'],
    'experience': ['户外运动', '文化体验', '美食之旅', '购物天堂'],
    'food': ['当地特色', '米其林', '街头小吃', '海鲜大餐'],
    'culture': ['历史古迹', '传统文化', '艺术展览', '节庆活动']
  };
  
  const tags = tagOptions[type] || ['推荐'];
  return tags.slice(0, Math.floor(Math.random() * 3) + 1);
}

const content = generateContent();

module.exports = content;