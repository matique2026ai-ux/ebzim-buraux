const http = require('http');

const data = JSON.stringify({
  title: {
    ar: "دليل المواقع الأثرية في سطيف",
    en: "Archaeological Sites Guide in Setif",
    fr: "Guide des sites archéologiques de Sétif"
  },
  author: {
    ar: "د. جمال الدين دباش",
    en: "Dr. Djamel Eddine Debache",
    fr: "Dr. Djamel Eddine Debache"
  },
  summary: {
    ar: "دراسة شاملة للمواقع الرومانية والبيزنطية في ولاية سطيف مع خرائط تفصيلية.",
    en: "A comprehensive study of Roman and Byzantine sites in Setif with detailed maps.",
    fr: "Une étude complète des sites romains et byzantins à Sétif avec des cartes détaillées."
  },
  thumbnailUrl: "https://images.unsplash.com/photo-1544006659-f0b21f04cb1d?q=80&w=800",
  pdfUrl: "https://www.unesco.org/en/articles/algeria-heritage-guide-example.pdf",
  category: "HERITAGE"
});

const options = {
  hostname: '127.0.0.1',
  port: 3000,
  path: '/api/v1/publications',
  method: 'POST',
  headers: {
    'Content-Type': 'application/json',
    'Content-Length': data.length
  }
};

const req = http.request(options, res => {
  console.log(`Status: ${res.statusCode}`);
  let responseData = '';
  res.on('data', d => {
    responseData += d;
  });
  res.on('end', () => {
    console.log('Response:', responseData);
  });
});

req.on('error', error => {
  console.error(error);
});

req.write(data);
req.end();
