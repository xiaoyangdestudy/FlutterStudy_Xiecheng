// 搜索结果模拟数据
const searchResults = [
  // 酒店数据
  {
    code: "hotel_385114",
    word: "北京千禧大酒店",
    type: "hotel",
    price: "¥580起",
    zonename: "国贸",
    star: "五星级",
    districtname: "北京",
    url: "http://m.ctrip.com/webapp/hotel/hoteldetail/385114.html",
    imageUrl: "https://images.unsplash.com/photo-1566073771259-6a8506099945?w=300&h=200&fit=crop",
    description: "位于北京CBD核心区域，交通便利，设施豪华",
    rating: 4.5
  },
  {
    code: "hotel_123456",
    word: "北京王府井大饭店",
    type: "hotel", 
    price: "¥420起",
    zonename: "王府井",
    star: "四星级",
    districtname: "北京",
    url: "http://m.ctrip.com/webapp/hotel/hoteldetail/123456.html",
    imageUrl: "https://images.unsplash.com/photo-1551882547-ff40c63fe5fa?w=300&h=200&fit=crop",
    description: "王府井步行街核心位置，购物出行便利",
    rating: 4.2
  },
  {
    code: "hotel_789012",
    word: "上海外滩茂悦大酒店",
    type: "hotel",
    price: "¥1200起", 
    zonename: "外滩",
    star: "五星级",
    districtname: "上海",
    url: "http://m.ctrip.com/webapp/hotel/hoteldetail/789012.html",
    imageUrl: "https://images.unsplash.com/photo-1520250497591-112f2f40a3f4?w=300&h=200&fit=crop",
    description: "黄浦江畔豪华酒店，尽享外滩美景",
    rating: 4.8
  },

  // 景点数据
  {
    code: "attraction_001",
    word: "故宫博物院",
    type: "attraction",
    price: "¥60",
    zonename: "东城区",
    districtname: "北京",
    url: "http://m.ctrip.com/webapp/attraction/detail/001.html",
    imageUrl: "https://images.unsplash.com/photo-1508804185872-d7badad00f7d?w=300&h=200&fit=crop",
    description: "中国明清两代的皇家宫殿，世界文化遗产",
    rating: 4.9
  },
  {
    code: "attraction_002", 
    word: "天安门广场",
    type: "attraction",
    price: "免费",
    zonename: "东城区",
    districtname: "北京",
    url: "http://m.ctrip.com/webapp/attraction/detail/002.html",
    imageUrl: "https://images.unsplash.com/photo-1545239705-1564e58b9e4e?w=300&h=200&fit=crop",
    description: "世界最大的城市广场之一，中国的象征",
    rating: 4.7
  },
  {
    code: "attraction_003",
    word: "上海迪士尼乐园", 
    type: "attraction",
    price: "¥399起",
    zonename: "浦东新区",
    districtname: "上海",
    url: "http://m.ctrip.com/webapp/attraction/detail/003.html",
    imageUrl: "https://images.unsplash.com/photo-1613521721493-6c4bf2b3c825?w=300&h=200&fit=crop",
    description: "充满奇幻与冒险的神奇王国",
    rating: 4.6
  },

  // 美食数据
  {
    code: "food_001",
    word: "全聚德烤鸭店",
    type: "food",
    price: "¥200-400",
    zonename: "前门",
    districtname: "北京",
    url: "http://m.ctrip.com/webapp/food/detail/001.html",
    imageUrl: "https://images.unsplash.com/photo-1598515214211-89d3c73ae83b?w=300&h=200&fit=crop",
    description: "百年老字号，正宗北京烤鸭",
    rating: 4.3
  },
  {
    code: "food_002",
    word: "老北京炸酱面",
    type: "food", 
    price: "¥30-60",
    zonename: "胡同",
    districtname: "北京",
    url: "http://m.ctrip.com/webapp/food/detail/002.html",
    imageUrl: "https://images.unsplash.com/photo-1612929633738-8fe44f7ec841?w=300&h=200&fit=crop",
    description: "地道北京风味面条，传统工艺制作",
    rating: 4.1
  },
  {
    code: "food_003",
    word: "小笼包",
    type: "food",
    price: "¥25-50",
    zonename: "豫园",
    districtname: "上海", 
    url: "http://m.ctrip.com/webapp/food/detail/003.html",
    imageUrl: "https://images.unsplash.com/photo-1561651188-d207bbec2fab?w=300&h=200&fit=crop",
    description: "上海特色点心，皮薄汁多",
    rating: 4.4
  },

  // 购物数据
  {
    code: "shopping_001",
    word: "王府井大街",
    type: "shopping",
    price: "实时计价",
    zonename: "王府井",
    districtname: "北京",
    url: "http://m.ctrip.com/webapp/shopping/detail/001.html",
    imageUrl: "https://images.unsplash.com/photo-1441986300917-64674bd600d8?w=300&h=200&fit=crop",
    description: "北京最著名的商业街之一",
    rating: 4.2
  },
  {
    code: "shopping_002",
    word: "南京路步行街",
    type: "shopping",
    price: "实时计价", 
    zonename: "黄浦区",
    districtname: "上海",
    url: "http://m.ctrip.com/webapp/shopping/detail/002.html",
    imageUrl: "https://images.unsplash.com/photo-1519832041-e64b7ba2cf9e?w=300&h=200&fit=crop",
    description: "中华商业第一街，购物天堂",
    rating: 4.5
  },

  // 娱乐数据
  {
    code: "entertainment_001",
    word: "北京欢乐谷",
    type: "entertainment",
    price: "¥299起",
    zonename: "朝阳区",
    districtname: "北京",
    url: "http://m.ctrip.com/webapp/entertainment/detail/001.html",
    imageUrl: "https://images.unsplash.com/photo-1594736797933-d0a9ba7a7e50?w=300&h=200&fit=crop",
    description: "大型主题公园，刺激好玩的游乐设施",
    rating: 4.3
  },
  {
    code: "entertainment_002",
    word: "上海海昌海洋公园",
    type: "entertainment",
    price: "¥399起",
    zonename: "浦东新区", 
    districtname: "上海",
    url: "http://m.ctrip.com/webapp/entertainment/detail/002.html",
    imageUrl: "https://images.unsplash.com/photo-1559827260-dc66d52bef19?w=300&h=200&fit=crop",
    description: "海洋主题公园，近距离接触海洋动物",
    rating: 4.4
  }
];

module.exports = searchResults;