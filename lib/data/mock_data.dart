import 'package:flutter/foundation.dart';

import 'models.dart';

/// Sample data so every screen opens in a realistic state.
/// Replace with real data when the backend is connected.
const technicians = <Technician>[
  Technician(
    id: 1,
    name: 'بشار تيّم',
    trade: Trade.tiling,
    city: 'عمّان',
    district: 'طبربور',
    distanceKm: 2.4,
    rating: 4.8,
    reviewsCount: 124,
    years: 9,
    certLevel: 3,
    certReviewed: true,
    bio: 'بليط بخبرة 9 سنين. بشتغل بورسلان وسيراميك وحجر، وبسلّم الشغل نظيف وعلى الموعد.',
    works: [
      Work('تبليط واجهة منزل ريفي', 350, 500, 1),
      Work('حمام 6 متر سيراميك', 90, 140, 2),
      Work('أرضية صالون بورسلان', 200, 320, 3),
    ],
    reviews: [
      Review('أم خالد', 5, 'شغل مرتب وخلّص قبل الموعد بيوم.', 'قبل أسبوع'),
      Review('معتز', 4, 'السعر طلع قريب من اللي حكاه بالأول.', 'قبل شهر'),
    ],
  ),
  Technician(
    id: 2,
    name: 'أحمد النجار',
    trade: Trade.carpentry,
    city: 'عمّان',
    district: 'ماركا',
    distanceKm: 4.1,
    rating: 4.6,
    reviewsCount: 87,
    years: 8,
    certLevel: 4,
    certReviewed: true,
    bio: 'خبرة أكثر من 8 سنوات في أعمال النجارة والتأثيث. مطابخ، خزائن، وأبواب تفصيل.',
    works: [
      Work('خزانة حائط 3 متر', 280, 400, 4),
      Work('مطبخ خشب لاتيه', 900, 1300, 5),
    ],
    reviews: [Review('رنا', 5, 'دقيق بالقياسات والتشطيب ممتاز.', 'قبل 3 أيام')],
  ),
  Technician(
    id: 3,
    name: 'محمود الخطيب',
    trade: Trade.electric,
    city: 'عمّان',
    district: 'جبل الحسين',
    distanceKm: 1.2,
    rating: 4.9,
    reviewsCount: 203,
    years: 12,
    certLevel: 4,
    certReviewed: true,
    bio: 'كهربائي منازل ومحلات. تمديدات، لوحات، وإنارة. بشتغل طوارئ.',
    works: [
      Work('تمديد كهرباء شقة 120 متر', 400, 600, 6),
      Work('تركيب لوحة توزيع', 60, 90, 7),
    ],
    reviews: [
      Review('أبو يوسف', 5, 'إجا بنص ساعة وحل المشكلة.', 'أمس'),
      Review('سلمى', 5, 'شرحلي المشكلة قبل ما يبلّش.', 'قبل أسبوعين'),
    ],
  ),
  Technician(
    id: 4,
    name: 'سامر عودة',
    trade: Trade.plumbing,
    city: 'الزرقاء',
    district: 'الزرقاء الجديدة',
    distanceKm: 18.5,
    rating: 4.4,
    reviewsCount: 56,
    years: 6,
    certLevel: 2,
    bio: 'سبّاك. تسليك، تمديدات، وتركيب أطقم حمامات.',
    works: [
      Work('تمديد مواسير حمام', 120, 180, 8),
      Work('تركيب سخان شمسي', 70, 110, 9),
    ],
    reviews: [Review('هاني', 4, 'شغله منيح بس تأخر شوي عن الموعد.', 'قبل شهر')],
  ),
  Technician(
    id: 5,
    name: 'خالد حداد',
    trade: Trade.painting,
    city: 'إربد',
    district: 'الحي الشرقي',
    distanceKm: 72,
    rating: 4.7,
    reviewsCount: 98,
    years: 10,
    bio: 'دهّان. دهان داخلي وخارجي، ديكورات، وورق جدران.',
    works: [
      Work('دهان شقة 3 غرف', 220, 300, 10),
      Work('ديكور جدار صالون', 80, 130, 11),
    ],
    reviews: [
      Review('لينا', 5, 'الألوان طلعت متل ما بدي بالزبط.', 'قبل أسبوع'),
    ],
  ),
  Technician(
    id: 6,
    name: 'يزن العبادي',
    trade: Trade.ac,
    city: 'عمّان',
    district: 'خلدا',
    distanceKm: 6.8,
    rating: 4.5,
    reviewsCount: 41,
    years: 5,
    certLevel: 3,
    bio: 'فني تكييف وتبريد. تركيب، صيانة، وتعبئة غاز.',
    works: [
      Work('تركيب مكيف سبليت', 35, 50, 12),
      Work('صيانة وتنظيف مكيفين', 25, 40, 13),
    ],
    reviews: [Review('فراس', 4, 'سريع وسعره معقول.', 'قبل أسبوعين')],
  ),
];

final posts = <Post>[
  Post(
    technicians[0],
    'الحمدلله، اليوم أنهينا تبليط واجهة منزل ريفي.',
    technicians[0].works[0],
    'قبل ساعتين',
  ),
  Post(
    technicians[2],
    'تمديد كهرباء كامل لشقة جديدة، جاهزة للتسليم.',
    technicians[2].works[0],
    'قبل 5 ساعات',
  ),
  Post(
    technicians[1],
    'خزانة حائط تفصيل، خشب لاتيه مع تشطيب مات.',
    technicians[1].works[0],
    'أمس',
  ),
  Post(
    technicians[4],
    'دهان شقة 3 غرف خلال 4 أيام.',
    technicians[4].works[0],
    'قبل يومين',
  ),
];

const cities = ['عمّان', 'الزرقاء', 'إربد'];

/// Two ready-made demo accounts for testers. Fake people, fake credentials.
const demoCustomer = Account(
  name: 'ليث حداد',
  email: 'zaboon@fanni.demo',
  password: 'fanni2026',
  isTech: false,
);
const demoTech = Account(
  name: 'يوسف عيسى',
  email: 'fanni@fanni.demo',
  password: 'fanni2026',
  isTech: true,
);

/// The signed-in user's own technician profile, used in technician mode.
const myTech = Technician(
  id: 99,
  name: 'يوسف عيسى',
  trade: Trade.electric,
  city: 'عمّان',
  district: 'طبربور',
  distanceKm: 0.5,
  rating: 4.7,
  reviewsCount: 2,
  years: 4,
  certLevel: 3,
  bio: 'كهربائي منازل. تمديدات وإنارة وصيانة.',
  works: [],
  reviews: [
    Review('سوسن', 5, 'شغل نظيف وإجا على الموعد.', 'قبل 4 أيام'),
    Review('عمر', 4, 'منيح، والسعر كان واضح من الأول.', 'قبل 3 أسابيع'),
  ],
);

/// In-memory store for the user's requests. Lives until the app restarts.
class AppState extends ChangeNotifier {
  AppState._();

  static final instance = AppState._();

  final List<JobRequest> requests = [
    JobRequest(
      tech: technicians[3],
      title: 'تسريب تحت المغسلة',
      area: 'الزرقاء الجديدة',
      when: 'اليوم',
      status: RequestStatus.quoted,
      quoteFrom: 15,
      quoteTo: 25,
    ),
    JobRequest(
      tech: technicians[5],
      title: 'صيانة مكيف غرفة النوم',
      area: 'خلدا',
      when: 'هالأسبوع',
      status: RequestStatus.done,
      quoteFrom: 25,
      quoteTo: 40,
    ),
  ];

  /// False: browsing as a customer. True: browsing as a technician.
  bool isTech = false;

  final List<ProblemPost> problems = [
    ProblemPost(
      title: 'فيش الصالون ما بيشتغل',
      trade: Trade.electric,
      area: 'جبل الحسين، عمّان',
      when: 'بكرا',
      details: 'فيشين جنب التلفزيون وقفوا مرة وحدة.',
      interested: [technicians[2]],
    ),
    ProblemPost(
      title: 'تسريب مي من سقف الحمام',
      trade: Trade.plumbing,
      area: 'طبربور، عمّان',
      when: 'اليوم',
      details: 'في بقعة مي بالسقف صارلها يومين وبتكبر.',
      mine: false,
      author: 'أم خالد',
    ),
    ProblemPost(
      title: 'بلاط مكسور بالمطبخ',
      trade: Trade.tiling,
      area: 'خلدا، عمّان',
      when: 'هالأسبوع',
      details: '4 بلاطات مكسورات جنب المجلى.',
      mine: false,
      author: 'معتز',
      interested: [technicians[0]],
    ),
  ];

  /// Works the signed-in technician added to their own profile.
  final List<Work> myWorks = [
    const Work('تركيب إنارة مخفية لصالون', 60, 90, 31),
  ];

  /// Accounts that can sign in: the two demo ones, plus any created
  /// through the sign-up screen during this run.
  final List<Account> accounts = [demoCustomer, demoTech];

  /// The signed-in account, or null before sign-in.
  Account? user;

  Account? findAccount(String email) {
    final key = email.trim().toLowerCase();
    for (final a in accounts) {
      if (a.email.toLowerCase() == key) return a;
    }
    return null;
  }

  void signIn(Account account) {
    user = account;
    isTech = account.isTech;
    notifyListeners();
  }

  void register(Account account) {
    accounts.add(account);
    signIn(account);
  }

  void signOut() {
    user = null;
    isTech = false;
    notifyListeners();
  }

  void setTechMode(bool value) {
    isTech = value;
    notifyListeners();
  }

  void addProblem(ProblemPost post) {
    problems.insert(0, post);
    notifyListeners();
  }

  void addMyWork(Work work) {
    myWorks.insert(0, work);
    notifyListeners();
  }

  void add(JobRequest request) {
    requests.insert(0, request);
    notifyListeners();
  }

  /// Call after changing a request so listening screens rebuild.
  void touch() => notifyListeners();
}
