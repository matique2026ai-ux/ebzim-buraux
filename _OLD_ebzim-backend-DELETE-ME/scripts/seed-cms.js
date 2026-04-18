import axios from 'axios';

const API_URL = 'http://localhost:3000/api';

async function seed() {
  try {
    // 1. Seed Hero Slides
    console.log('Seeding Hero Slides...');
    const slides = [
      {
        title: {
          ar: 'جمعية إبزيم للثقافة والمواطنة',
          en: 'Ebzim Association for Culture',
          fr: 'Association Ebzim Culture'
        },
        subtitle: {
          ar: 'نحو حفظ الذاكرة الجماعية وصون الهوية الثقافية في ولاية سطيف',
          en: 'Preserving collective memory and cultural identity in Sétif',
          fr: 'Préservation de la mémoire collective et de l\'identité à Sétif'
        },
        imageUrl: 'https://images.unsplash.com/photo-1518709268805-4e9042af9f23?q=80&w=2000&auto=format&fit=crop',
        order: 1
      },
      {
        title: {
          ar: 'الموروث الثقافي السطايفي',
          en: 'Sétif Cultural Heritage',
          fr: 'Patrimoine Culturel de Sétif'
        },
        subtitle: {
          ar: 'اكتشف المعالم التاريخية والكنوز الأثرية التي تزخر بها المنطقة',
          en: 'Discover historical monuments and archaeological treasures',
          fr: 'Découvrez les monuments historiques et les trésors archéologiques'
        },
        imageUrl: 'https://images.unsplash.com/photo-1548013146-72479768bbaa?q=80&w=2000&auto=format&fit=crop',
        order: 2
      }
    ];

    for (const slide of slides) {
      await axios.post(`${API_URL}/hero-slides`, slide);
    }

    // 2. Seed Partners
    console.log('Seeding Partners...');
    const partners = [
      {
        name: {
          ar: 'المتحف العمومي الوطني بسطيف',
          en: 'National Public Museum of Sétif',
          fr: 'Musée Public National de Sétif'
        },
        logoUrl: 'https://ebzim.dz/assets/partners/museum.png',
        goalsSummary: {
          ar: 'تهدف الاتفاقية إلى تنظيم ورشات عمل مشتركة لترميم القطع الأثرية وتعريف الشباب بالموروث المادي.',
          en: 'The agreement aims to organize joint workshops to restore artifacts and introduce youth to tangible heritage.',
          fr: 'La convention vise à organiser des ateliers conjoints pour restaurer l\'artisanat et initier les jeunes.'
        },
        color: '#8E2424',
        order: 1
      },
      {
        name: {
          ar: 'جامعة فرحات عباس - سطيف 1',
          en: 'University of Sétif 1',
          fr: 'Université de Sétif 1'
        },
        logoUrl: 'https://ebzim.dz/assets/partners/univ.png',
        goalsSummary: {
          ar: 'تعزيز البحث العلمي في مجال التراث اللامادي وتأطير الطلبة في مشاريع التخرج الميدانية.',
          en: 'Promoting scientific research in intangible heritage and supervising students in field projects.',
          fr: 'Promouvoir la recherche scientifique dans le patrimoine immatériel et encadrer les étudiants.'
        },
        color: '#F7C04A',
        order: 2
      }
    ];

    for (const partner of partners) {
      await axios.post(`${API_URL}/partners`, partner);
    }

    console.log('Seeding completed successfully!');
  } catch (error) {
    console.error('Seeding failed:', error.response?.data || error.message);
  }
}

seed();
