const services = [
  {
    id: "hotels",
    title: "酒店",
    icon: "🏨",
    gradient: ["#FF6B6B", "#FFE66D"],
    services: [
      { name: "国内酒店", icon: "🏨" },
      { name: "海外酒店", icon: "🌍" },
      { name: "民宿客栈", icon: "🏠" },
      { name: "公寓式酒店", icon: "🏢" }
    ]
  },
  {
    id: "flights", 
    title: "机票",
    icon: "✈️",
    gradient: ["#4ECDC4", "#44A08D"],
    services: [
      { name: "国内机票", icon: "🛫" },
      { name: "国际机票", icon: "🌏" },
      { name: "特价机票", icon: "💰" },
      { name: "机票+酒店", icon: "🎫" }
    ]
  },
  {
    id: "travel",
    title: "旅游",
    icon: "🧳", 
    gradient: ["#667eea", "#764ba2"],
    services: [
      { name: "跟团游", icon: "👥" },
      { name: "自由行", icon: "🚶" },
      { name: "邮轮", icon: "🚢" },
      { name: "签证", icon: "📋" }
    ]
  }
];

module.exports = services;