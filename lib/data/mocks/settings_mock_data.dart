import '../../features/homelayout/data/models/adhan_sound_model.dart';
import '../../features/homelayout/data/models/calculation_method_model.dart';
import '../../features/homelayout/data/models/font_type_model.dart';
import '../../features/homelayout/data/models/prayers_helper.dart';

class SettingsMockData {
  static List<FontTypeModel> get fontTypes => const [
        FontTypeModel(
          id: 'naskh',
          title: 'نسخ',
          subtitle: 'خط واضح ومريح للقراءة',
        ),
        FontTypeModel(
          id: 'uthmani',
          title: 'عثماني',
          subtitle: 'الرسم العثماني المعتمد للمصحف',
        ),
        FontTypeModel(
          id: 'amiri',
          title: 'أميري',
          subtitle: 'خط عربي كلاسيكي أصيل',
        ),
      ];

  static List<CalculationMethodModel> get calculationMethods => const [
        CalculationMethodModel(
          id: 'mwl',
          title: 'رابطة العالم الإسلامي',
          subtitle: 'الأكثر شيوعًا في مصر والدول العربية',
        ),
        CalculationMethodModel(
          id: 'isna',
          title: 'الجمعية الإسلامية لأمريكا الشمالية',
          subtitle: 'ISNA',
        ),
        CalculationMethodModel(
          id: 'egypt',
          title: 'الهيئة المصرية العامة للمساحة',
          subtitle: 'موصى بها في مصر',
        ),
        CalculationMethodModel(
          id: 'umm_al_qura',
          title: 'أم القرى، مكة المكرمة',
          subtitle: 'المملكة العربية السعودية',
        ),
        CalculationMethodModel(
          id: 'karachi',
          title: 'جامعة العلوم الإسلامية، كراتشي',
          subtitle: 'باكستان وأفغانستان والهند',
        ),
      ];

  static List<AdhanSoundModel> get adhanSounds => const [
        AdhanSoundModel(
          id: 'makkah',
          title: 'أذان مكة المكرمة',
          iconType: AdhanSoundIconType.makkah,
          audioAsset: 'assets/audio/makka azan.mp3',
          rawResource: 'makka_azan',
        ),
        AdhanSoundModel(
          id: 'madinah',
          title: 'أذان المدينة المنورة',
          iconType: AdhanSoundIconType.madinah,
          audioAsset: 'assets/audio/madina azan.mp3',
          rawResource: 'madina_azan',
        ),
        AdhanSoundModel(
          id: 'azan',
          title: 'الأذان التقليدي',
          iconType: AdhanSoundIconType.mic,
          audioAsset: 'assets/audio/azan.mp3',
          rawResource: 'azan',
        ),
      ];

  static List<String> get cities => const [
        'القاهرة، مصر',
        'الجيزة، مصر',
        'الإسكندرية، مصر',
        'مكة المكرمة، السعودية',
        'المدينة المنورة، السعودية',
        'الرياض، السعودية',
        'دبي، الإمارات',
        'عمان، الأردن',
        'الدوحة، قطر',
      ];

   static GeoCoordinates getCityCoordinates(String cityName) {
    final fullNormalized = _normalizeText(cityName);
    final key = _extractCityKey(cityName);

    // 1. معالجة المدن المتشابهة في الاسم بين دولتين
    if (key == 'طرابلس' || key == 'tripoli') {
      if (fullNormalized.contains('لبنان') || fullNormalized.contains('lebanon')) {
        return const GeoCoordinates(34.4367, 35.8497, utcOffsetHours: 2.0);
      }
      return const GeoCoordinates(32.8872, 13.1913, utcOffsetHours: 2.0);
    }

    // 2. معالجة التمييز بين عَمّان (الأردن) وسلطنة عُمان (مسقط)
    if (key == 'عمان' || key == 'amman' || key == 'oman') {
      if (fullNormalized.contains('سلطنه') || fullNormalized.contains('مسقط') || fullNormalized.contains('oman')) {
        return const GeoCoordinates(23.5880, 58.3829, utcOffsetHours: 4.0);
      }
      return const GeoCoordinates(31.9454, 35.9284, utcOffsetHours: 3.0);
    }

    // 3. Modern Dart 3 Switch Expression مع دعم البدائل اللغوية والإنجليزية
    return switch (key) {
      // =======================================================================
      // 🇪🇬 مصر (جميع المحافظات والمدن الرئيسية - UTC+2)
      // =======================================================================
      'قاهره' || 'قاهره كبري' || 'حلوان' || 'قاهره جديده' || 'تجمع خامس' || 'عاصمه اداريه' || 'cairo' || 'مصر' || 'egypt' =>
        GeoCoordinates.cairo,
      'جيزه' || 'سادس من اكتوبر' || '6 اكتوبر' || 'اكتوبر' || 'شيخ زايد' || 'giza' =>
        GeoCoordinates.giza,
      'اسكندريه' || 'برج عرب' || 'alexandria' || 'alex' =>
        GeoCoordinates.alexandria,
      'بورسعيد' || 'بور سعيد' || 'port said' || 'portsaid' =>
        const GeoCoordinates(31.2653, 32.3019, utcOffsetHours: 2.0),
      'سويس' || 'suez' =>
        const GeoCoordinates(29.9668, 32.5498, utcOffsetHours: 2.0),
      'اسماعيليه' || 'ismailia' =>
        const GeoCoordinates(30.5965, 32.2715, utcOffsetHours: 2.0),
      'منصوره' || 'دقهليه' || 'mansoura' || 'dakahlia' =>
        const GeoCoordinates(31.0409, 31.3785, utcOffsetHours: 2.0),
      'طنطا' || 'غربيه' || 'tanta' || 'gharbia' =>
        const GeoCoordinates(30.7865, 31.0004, utcOffsetHours: 2.0),
      'محله كبري' || 'محله' || 'mahalla' =>
        const GeoCoordinates(30.9706, 31.1669, utcOffsetHours: 2.0),
      'زقازيق' || 'شرقيه' || 'zagazig' || 'sharqia' =>
        const GeoCoordinates(30.5877, 31.5020, utcOffsetHours: 2.0),
      'عاشر من رمضان' || 'عاشر' || '10th of ramadan' =>
        const GeoCoordinates(30.2969, 31.7418, utcOffsetHours: 2.0),
      'دمنهور' || 'بحيره' || 'damanhur' || 'beheira' =>
        const GeoCoordinates(31.0411, 30.4735, utcOffsetHours: 2.0),
      'كفر شيخ' || 'kafr el sheikh' =>
        const GeoCoordinates(31.1107, 30.9388, utcOffsetHours: 2.0),
      'دمياط' || 'دمياط جديده' || 'damietta' =>
        const GeoCoordinates(31.4175, 31.8144, utcOffsetHours: 2.0),
      'شبين كوم' || 'منوفيه' || 'سادات' || 'shebin el kom' || 'monufia' =>
        const GeoCoordinates(30.5503, 31.0106, utcOffsetHours: 2.0),
      'بنها' || 'قليوبيه' || 'شبرا خيمه' || 'banha' || 'qalyubia' =>
        const GeoCoordinates(30.4660, 31.1848, utcOffsetHours: 2.0),
      'فيوم' || 'fayoum' || 'faiyum' =>
        const GeoCoordinates(29.3084, 30.8428, utcOffsetHours: 2.0),
      'بني سويف' || 'بنى سويف' || 'beni suef' =>
        const GeoCoordinates(29.0661, 31.0994, utcOffsetHours: 2.0),
      'منيا' || 'minya' =>
        const GeoCoordinates(28.1099, 30.7503, utcOffsetHours: 2.0),
      'اسيوط' || 'asyut' || 'assiut' =>
        const GeoCoordinates(27.1810, 31.1837, utcOffsetHours: 2.0),
      'سوهاج' || 'sohag' =>
        const GeoCoordinates(26.5591, 31.6957, utcOffsetHours: 2.0),
      'قنا' || 'نجع حمادي' || 'qena' =>
        const GeoCoordinates(26.1551, 32.7160, utcOffsetHours: 2.0),
      'اقصر' || 'luxor' =>
        const GeoCoordinates(25.6872, 32.6396, utcOffsetHours: 2.0),
      'اسوان' || 'ادفو' || 'كوم امبو' || 'aswan' =>
        const GeoCoordinates(24.0889, 32.8998, utcOffsetHours: 2.0),
      'غردقه' || 'بحر احمر' || 'سفاجا' || 'قصير' || 'مرسي علم' || 'hurghada' || 'red sea' =>
        const GeoCoordinates(27.2579, 33.8116, utcOffsetHours: 2.0),
      'شرم شيخ' || 'جنوب سيناء' || 'طور' || 'دهب' || 'sharm el sheikh' || 'south sinai' =>
        const GeoCoordinates(27.9158, 34.3300, utcOffsetHours: 2.0),
      'عريش' || 'شمال سيناء' || 'arish' || 'north sinai' =>
        const GeoCoordinates(31.1321, 33.8033, utcOffsetHours: 2.0),
      'مرسي مطروح' || 'مطروح' || 'علمين' || 'سيوه' || 'marsa matrouh' || 'matrouh' =>
        const GeoCoordinates(31.3543, 27.2373, utcOffsetHours: 2.0),
      'خارجه' || 'وادي جديد' || 'داخله' || 'new valley' || 'kharga' =>
        const GeoCoordinates(25.4390, 30.5586, utcOffsetHours: 2.0),

      // =======================================================================
      // 🇸🇦 المملكة العربية السعودية (UTC+3)
      // =======================================================================
      'مكه مكرمه' || 'مكه' || 'makkah' || 'mecca' =>
        GeoCoordinates.makkah,
      'مدينه منوره' || 'مدينه' || 'madinah' || 'medina' =>
        GeoCoordinates.madinah,
      'رياض' || 'درعيه' || 'خرج' || 'riyadh' || 'سعوديه' || 'saudi' || 'saudi arabia' || 'ksa' =>
        GeoCoordinates.riyadh,
      'جده' || 'jeddah' || 'jiddah' =>
        const GeoCoordinates(21.4858, 39.1925, utcOffsetHours: 3.0),
      'دمام' || 'dammam' =>
        const GeoCoordinates(26.4207, 50.0888, utcOffsetHours: 3.0),
      'خبر' || 'khobar' || 'al khobar' =>
        const GeoCoordinates(26.2172, 50.1971, utcOffsetHours: 3.0),
      'ظهران' || 'dhahran' =>
        const GeoCoordinates(26.2361, 50.0393, utcOffsetHours: 3.0),
      'طايف' || 'taif' =>
        const GeoCoordinates(21.2703, 40.4158, utcOffsetHours: 3.0),
      'تبوك' || 'نيوم' || 'tabuk' =>
        const GeoCoordinates(28.3835, 36.5662, utcOffsetHours: 3.0),
      'بريده' || 'قصيم' || 'buraidah' || 'qassim' =>
        const GeoCoordinates(26.3260, 43.9750, utcOffsetHours: 3.0),
      'عنيزه' || 'unayzah' =>
        const GeoCoordinates(26.0840, 43.9936, utcOffsetHours: 3.0),
      'ابها' || 'عسير' || 'abha' || 'asir' =>
        const GeoCoordinates(18.2164, 42.5053, utcOffsetHours: 3.0),
      'خميس مشيط' || 'khamis mushait' =>
        const GeoCoordinates(18.3093, 42.7662, utcOffsetHours: 3.0),
      'حايل' || 'hail' =>
        const GeoCoordinates(27.5114, 41.7208, utcOffsetHours: 3.0),
      'جازان' || 'جيزان' || 'jazan' || 'jizan' =>
        const GeoCoordinates(16.8894, 42.5706, utcOffsetHours: 3.0),
      'نجران' || 'najran' =>
        const GeoCoordinates(17.4924, 44.1277, utcOffsetHours: 3.0),
      'جبيل' || 'jubail' =>
        const GeoCoordinates(27.0046, 49.6460, utcOffsetHours: 3.0),
      'ينبع' || 'yanbu' =>
        const GeoCoordinates(24.0895, 38.0618, utcOffsetHours: 3.0),
      'احساء' || 'هفوف' || 'مبرز' || 'al ahsa' || 'hofuf' =>
        const GeoCoordinates(25.3800, 49.5888, utcOffsetHours: 3.0),
      'باحه' || 'al bahah' || 'baha' =>
        const GeoCoordinates(20.0129, 41.4677, utcOffsetHours: 3.0),
      'سكاكا' || 'جوف' || 'sakaka' || 'al jawf' =>
        const GeoCoordinates(29.9697, 40.2064, utcOffsetHours: 3.0),
      'عرعر' || 'حدود شماليه' || 'arar' =>
        const GeoCoordinates(30.9753, 41.0381, utcOffsetHours: 3.0),
      'حفر باطن' || 'hafar al batin' =>
        const GeoCoordinates(28.4328, 45.9708, utcOffsetHours: 3.0),

      // =======================================================================
      // 🇦🇪 الإمارات ودول الخليج العربي
      // =======================================================================
      'دبي' || 'دبى' || 'dubai' =>
        const GeoCoordinates(25.2048, 55.2708, utcOffsetHours: 4.0),
      'ابوظبي' || 'ابو ظبي' || 'abu dhabi' || 'abudhabi' || 'امارات' || 'uae' || 'united arab emirates' =>
        const GeoCoordinates(24.4539, 54.3773, utcOffsetHours: 4.0),
      'شارقه' || 'sharjah' =>
        const GeoCoordinates(25.3463, 55.4209, utcOffsetHours: 4.0),
      'عجمان' || 'ajman' =>
        const GeoCoordinates(25.4052, 55.5136, utcOffsetHours: 4.0),
      'عين' || 'al ain' =>
        const GeoCoordinates(24.1302, 55.8023, utcOffsetHours: 4.0),
      'راس خيمه' || 'ras al khaimah' || 'rak' =>
        const GeoCoordinates(25.7895, 55.9432, utcOffsetHours: 4.0),
      'فجيره' || 'fujairah' =>
        const GeoCoordinates(25.1288, 56.3265, utcOffsetHours: 4.0),
      'ام قيوين' || 'umm al quwain' =>
        const GeoCoordinates(25.5647, 55.5552, utcOffsetHours: 4.0),
      'دوحه' || 'قطر' || 'ريان' || 'وكره' || 'doha' || 'qatar' =>
        const GeoCoordinates(25.2854, 51.5310, utcOffsetHours: 3.0),
      'كويت' || 'حولي' || 'سالميه' || 'فروانيه' || 'احمدي' || 'جهراء' || 'kuwait' || 'kuwait city' =>
        const GeoCoordinates(29.3759, 47.9774, utcOffsetHours: 3.0),
      'منامه' || 'بحرين' || 'محرق' || 'رفاع' || 'manama' || 'bahrain' =>
        const GeoCoordinates(26.2285, 50.5860, utcOffsetHours: 3.0),
      'مسقط' || 'سلطنه عمان' || 'muscat' =>
        const GeoCoordinates(23.5880, 58.3829, utcOffsetHours: 4.0),
      'صلاله' || 'salalah' =>
        const GeoCoordinates(17.0151, 54.0924, utcOffsetHours: 4.0),
      'صحار' || 'sohar' =>
        const GeoCoordinates(24.3461, 56.7075, utcOffsetHours: 4.0),

      // =======================================================================
      // 🇯🇴🇵🇸🇸🇾🇱🇧🇮🇶🇾🇪 الشام والعراق واليمن
      // =======================================================================
      'عمان' || 'زرقاء' || 'سلط' || 'amman' || 'اردن' || 'jordan' =>
        const GeoCoordinates(31.9454, 35.9284, utcOffsetHours: 3.0),
      'اربد' || 'irbid' =>
        const GeoCoordinates(32.5568, 35.8469, utcOffsetHours: 3.0),
      'عقبه' || 'aqaba' =>
        const GeoCoordinates(29.5321, 35.0063, utcOffsetHours: 3.0),
      'قدس' || 'رام الله' || 'خليل' || 'نابلس' || 'جنين' || 'فلسطين' || 'jerusalem' || 'ramallah' || 'palestine' =>
        const GeoCoordinates(31.7683, 35.2137, utcOffsetHours: 2.0),
      'غزه' || 'خان يونس' || 'رفح' || 'gaza' =>
        const GeoCoordinates(31.5017, 34.4668, utcOffsetHours: 2.0),
      'بيروت' || 'صيدا' || 'صور' || 'beirut' || 'لبنان' || 'lebanon' =>
        const GeoCoordinates(33.8938, 35.5018, utcOffsetHours: 2.0),
      'دمشق' || 'شام' || 'damascus' || 'سوريا' || 'syria' =>
        const GeoCoordinates(33.5138, 36.2765, utcOffsetHours: 3.0),
      'حلب' || 'aleppo' =>
        const GeoCoordinates(36.2021, 37.1343, utcOffsetHours: 3.0),
      'حمص' || 'حماه' || 'homs' =>
        const GeoCoordinates(34.7324, 36.7137, utcOffsetHours: 3.0),
      'لاذقيه' || 'طرطوس' || 'latakia' =>
        const GeoCoordinates(35.5317, 35.7918, utcOffsetHours: 3.0),
      'بغداد' || 'عراق' || 'iraq' || 'baghdad' =>
        const GeoCoordinates(33.3152, 44.3661, utcOffsetHours: 3.0),
      'بصره' || 'basra' =>
        const GeoCoordinates(30.5081, 47.7835, utcOffsetHours: 3.0),
      'اربيل' || 'سليمانيه' || 'erbil' =>
        const GeoCoordinates(36.1901, 44.0091, utcOffsetHours: 3.0),
      'موصل' || 'نينوي' || 'mosul' =>
        const GeoCoordinates(36.3350, 43.1189, utcOffsetHours: 3.0),
      'نجف' || 'كربلاء' || 'najaf' || 'karbala' =>
        const GeoCoordinates(32.0000, 44.3333, utcOffsetHours: 3.0),
      'صنعاء' || 'ذمار' || 'اب' || 'sanaa' || 'يمن' || 'yemen' =>
        const GeoCoordinates(15.3694, 44.1910, utcOffsetHours: 3.0),
      'عدن' || 'تعز' || 'aden' || 'taiz' =>
        const GeoCoordinates(12.7855, 45.0187, utcOffsetHours: 3.0),
      'مكلا' || 'حضرموت' || 'mukalla' =>
        const GeoCoordinates(14.5425, 49.1242, utcOffsetHours: 3.0),

      // =======================================================================
      // 🇸🇩🇱🇾🇹🇳🇩🇿🇲🇦🇲🇷 وادي النيل والمغرب العربي
      // =======================================================================
      'خرطوم' || 'ام درمان' || 'بحري' || 'khartoum' || 'سودان' || 'sudan' =>
        const GeoCoordinates(15.5007, 32.5599, utcOffsetHours: 2.0),
      'بورتسودان' || 'بور سودان' || 'port sudan' =>
        const GeoCoordinates(19.6158, 37.2164, utcOffsetHours: 2.0),
      'بنغازي' || 'بيضاء' || 'طبرق' || 'benghazi' || 'ليبيا' || 'libya' =>
        const GeoCoordinates(32.1194, 20.0868, utcOffsetHours: 2.0),
      'مصراته' || 'misrata' =>
        const GeoCoordinates(32.3754, 15.0925, utcOffsetHours: 2.0),
      'تونس' || 'صفاقس' || 'سوسه' || 'قيروان' || 'tunis' || 'tunisia' =>
        const GeoCoordinates(36.8065, 10.1815, utcOffsetHours: 1.0),
      'جزاير' || 'بليده' || 'algiers' || 'algeria' =>
        const GeoCoordinates(36.7538, 3.0588, utcOffsetHours: 1.0),
      'وهران' || 'oran' =>
        const GeoCoordinates(35.6971, -0.6308, utcOffsetHours: 1.0),
      'قسنطينه' || 'عنابه' || 'سطيف' || 'constantine' =>
        const GeoCoordinates(36.3650, 6.6147, utcOffsetHours: 1.0),
      'رباط' || 'سلا' || 'قنيطره' || 'rabat' || 'مغرب' || 'morocco' =>
        const GeoCoordinates(34.0209, -6.8416, utcOffsetHours: 1.0),
      'دار بيضاء' || 'كازابلانكا' || 'كازا' || 'casablanca' =>
        const GeoCoordinates(33.5731, -7.5898, utcOffsetHours: 1.0),
      'مراكش' || 'اكادير' || 'أغادير' || 'marrakech' || 'agadir' =>
        const GeoCoordinates(31.6295, -7.9811, utcOffsetHours: 1.0),
      'فاس' || 'مكناس' || 'fes' || 'fez' =>
        const GeoCoordinates(34.0181, -5.0078, utcOffsetHours: 1.0),
      'طنجه' || 'تطوان' || 'tangier' =>
        const GeoCoordinates(35.7595, -5.8340, utcOffsetHours: 1.0),
      'نواكشوط' || 'موريتانيا' || 'nouakchott' || 'mauritania' =>
        const GeoCoordinates(18.0735, -15.9582, utcOffsetHours: 0.0),
      'مقديشو' || 'صومال' || 'mogadishu' || 'somalia' =>
        const GeoCoordinates(2.0469, 45.3182, utcOffsetHours: 3.0),

      // =======================================================================
      // 🌍 عواصم ومدن إسلامية وعالمية كبرى
      // =======================================================================
      'اسطنبول' || 'بورصه' || 'istanbul' || 'bursa' || 'تركيا' || 'turkey' =>
        const GeoCoordinates(41.0082, 28.9784, utcOffsetHours: 3.0),
      'انقره' || 'قونيه' || 'ankara' || 'konya' =>
        const GeoCoordinates(39.9334, 32.8597, utcOffsetHours: 3.0),
      'كوالالمبور' || 'ماليزيا' || 'kuala lumpur' || 'malaysia' =>
        const GeoCoordinates(3.1390, 101.6869, utcOffsetHours: 8.0),
      'جاكرتا' || 'اندونيسيا' || 'jakarta' || 'indonesia' =>
        const GeoCoordinates(-6.2088, 106.8456, utcOffsetHours: 7.0),
      'اسلام اباد' || 'اسلاماباد' || 'لاهور' || 'كراتشي' || 'باكستان' || 'pakistan' || 'islamabad' || 'karachi' || 'lahore' =>
        const GeoCoordinates(33.6844, 73.0479, utcOffsetHours: 5.0),
      'لندن' || 'مانشستر' || 'برمنغهام' || 'london' || 'manchester' || 'بريطانيا' || 'انجلترا' || 'uk' =>
        const GeoCoordinates(51.5074, -0.1278, utcOffsetHours: 0.0),
      'باريس' || 'مارسيليا' || 'ليون' || 'paris' || 'فرنسا' || 'france' =>
        const GeoCoordinates(48.8566, 2.3522, utcOffsetHours: 1.0),
      'برلين' || 'فرانكفورت' || 'ميونخ' || 'berlin' || 'frankfurt' || 'munich' || 'المانيا' || 'germany' =>
        const GeoCoordinates(52.5200, 13.4050, utcOffsetHours: 1.0),
      'مدريد' || 'برشلونه' || 'غرناطه' || 'قرطبه' || 'madrid' || 'barcelona' || 'اسبانيا' || 'spain' =>
        const GeoCoordinates(40.4168, -3.7038, utcOffsetHours: 1.0),
      'روما' || 'ميلانو' || 'rome' || 'milan' || 'ايطاليا' || 'italy' =>
        const GeoCoordinates(41.9028, 12.4964, utcOffsetHours: 1.0),
      'امستردام' || 'روتردام' || 'amsterdam' || 'هولندا' || 'netherlands' =>
        const GeoCoordinates(52.3676, 4.9041, utcOffsetHours: 1.0),
      'فيينا' || 'vienna' || 'النمسا' || 'austria' =>
        const GeoCoordinates(48.2082, 16.3738, utcOffsetHours: 1.0),
      'موسكو' || 'moscow' || 'روسيا' || 'russia' =>
        const GeoCoordinates(55.7558, 37.6173, utcOffsetHours: 3.0),
      'نيويورك' || 'واشنطن' || 'new york' || 'washington' || 'امريكا' || 'usa' =>
        const GeoCoordinates(40.7128, -74.0060, utcOffsetHours: -5.0),
      'تورنتو' || 'مونتريال' || 'اوتاوا' || 'toronto' || 'montreal' || 'كندا' || 'canada' =>
        const GeoCoordinates(43.6532, -79.3832, utcOffsetHours: -5.0),
      'شيكاغو' || 'chicago' =>
        const GeoCoordinates(41.8781, -87.6298, utcOffsetHours: -6.0),
      'لوس انجلوس' || 'سان فرانسيسكو' || 'los angeles' =>
        const GeoCoordinates(34.0522, -118.2437, utcOffsetHours: -8.0),
      'سيدني' || 'ملبورن' || 'sydney' || 'melbourne' || 'استراليا' || 'australia' =>
        const GeoCoordinates(-33.8688, 151.2093, utcOffsetHours: 10.0),

      // 4. مسار احتياطي ذكي يفحص التطابق الجزئي قبل العودة للقاهرة
      _ => _matchBySubstring(fullNormalized) ?? GeoCoordinates.cairo,
    };
  }

  /// استخراج اسم المدينة الأساسي وتجريده من الزوائد و"ال" التعريف وحروف الجر
  static String _extractCityKey(String raw) {
    // أخذ الجزء الأول قبل أي فاصلة لتجاهل اسم الدولة (مثل: "الإسكندرية، مصر")
    final firstPart = raw.split(RegExp(r'[،,]')).first;
    var normalized = _normalizeText(firstPart);

    // إزالة الكلمات والبادئات الوصفية
    normalized = normalized
        .replaceFirst(RegExp(r'^(محافظه|مدينه|ولايه|اماره|منطقه|سلطنه|حي|مركز|قريه|دوله|مملكه|جمهوريه|في|ب)\s+'), '')
        .replaceFirst(RegExp(r'^(city of|governorate of|province of|state of|district of)\s+'), '')
        .trim();

    // إزالة اللواحق الوصفية في النهاية إن وجدت
    normalized = normalized
        .replaceFirst(RegExp(r'\s+(governorate|province|state|city|district|airport|intl airport)$'), '')
        .trim();

    // تجريد "ال" و "بال" و "لل" و "بـ" المتصلة من بداية الكلمات
    normalized = normalized
        .split(' ')
        .map((w) {
          if (w.startsWith('بال') && w.length > 4) {
            return w.substring(3);
          } else if (w.startsWith('لل') && w.length > 3) {
            return w.substring(2);
          } else if (w.startsWith('ال') && w.length > 3) {
            return w.substring(2);
          } else if (w.startsWith('ب') && w.length > 3 && !w.startsWith('بور') && !w.startsWith('بر')) {
            // تجريد حرف الجر "بـ" مثل (بدبي -> دبي، بجدة -> جدة) مع الحفاظ على مدن مثل بورسعيد أو بريدة
            return w.substring(1);
          }
          return w;
        })
        .join(' ');

    return normalized.trim();
  }

  /// توحيد الحروف العربية والإنجليزية وإزالة التشكيل والفراغات والرموز الزائدة
  static String _normalizeText(String input) {
    return input
        .toLowerCase()
        // إزالة التشكيل والمد (التطويل)
        .replaceAll(RegExp(r'[\u064B-\u065F\u0670\u0640]'), '')
        // توحيد الهمزات
        .replaceAll(RegExp(r'[أإآٱ]'), 'ا')
        .replaceAll('ؤ', 'و')
        .replaceAll('ئ', 'ي')
        // توحيد التاء المربوطة والياء
        .replaceAll('ة', 'ه')
        .replaceAll('ى', 'ي')
        // توحيد الفواصل والرموز
        .replaceAll(RegExp(r'[\-_/\\()\[\]+.]'), ' ')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
  }

  /// فحص جزئي احتياطي إذا أرسل المستخدم أو الجيوليكيشن جملة مركبة
  static GeoCoordinates? _matchBySubstring(String t) {
    // الأماكن المقدسة والمدن الكبرى
    if (t.contains('مكه') || t.contains('makkah') || t.contains('mecca')) return GeoCoordinates.makkah;
    if (t.contains('مدينه منوره') || t.contains('madinah') || t.contains('medina')) return GeoCoordinates.madinah;
    if (t.contains('رياض') || t.contains('riyadh')) return GeoCoordinates.riyadh;
    if (t.contains('جده') || t.contains('jeddah')) return const GeoCoordinates(21.4858, 39.1925, utcOffsetHours: 3.0);
    if (t.contains('دمام') || t.contains('dammam')) return const GeoCoordinates(26.4207, 50.0888, utcOffsetHours: 3.0);

    // الخليج العربي
    if (t.contains('دبي') || t.contains('dubai')) return const GeoCoordinates(25.2048, 55.2708, utcOffsetHours: 4.0);
    if (t.contains('ابوظبي') || t.contains('abu dhabi')) return const GeoCoordinates(24.4539, 54.3773, utcOffsetHours: 4.0);
    if (t.contains('شارقه') || t.contains('sharjah')) return const GeoCoordinates(25.3463, 55.4209, utcOffsetHours: 4.0);
    if (t.contains('دوحه') || t.contains('قطر') || t.contains('doha') || t.contains('qatar')) return const GeoCoordinates(25.2854, 51.5310, utcOffsetHours: 3.0);
    if (t.contains('كويت') || t.contains('kuwait')) return const GeoCoordinates(29.3759, 47.9774, utcOffsetHours: 3.0);
    if (t.contains('منامه') || t.contains('بحرين') || t.contains('bahrain')) return const GeoCoordinates(26.2285, 50.5860, utcOffsetHours: 3.0);
    if (t.contains('مسقط') || t.contains('muscat') || t.contains('سلطنه عمان') || t.contains('oman')) return const GeoCoordinates(23.5880, 58.3829, utcOffsetHours: 4.0);

    // الشام واليمن والعراق
    if (t.contains('عمان') || t.contains('amman') || t.contains('اردن') || t.contains('jordan')) return const GeoCoordinates(31.9454, 35.9284, utcOffsetHours: 3.0);
    if (t.contains('قدس') || t.contains('فلسطين') || t.contains('jerusalem')) return const GeoCoordinates(31.7683, 35.2137, utcOffsetHours: 2.0);
    if (t.contains('غزه') || t.contains('gaza')) return const GeoCoordinates(31.5017, 34.4668, utcOffsetHours: 2.0);
    if (t.contains('بيروت') || t.contains('لبنان') || t.contains('beirut')) return const GeoCoordinates(33.8938, 35.5018, utcOffsetHours: 2.0);
    if (t.contains('دمشق') || t.contains('سوريا') || t.contains('damascus')) return const GeoCoordinates(33.5138, 36.2765, utcOffsetHours: 3.0);
    if (t.contains('بغداد') || t.contains('عراق') || t.contains('baghdad')) return const GeoCoordinates(33.3152, 44.3661, utcOffsetHours: 3.0);
    if (t.contains('صنعاء') || t.contains('يمن') || t.contains('sanaa')) return const GeoCoordinates(15.3694, 44.1910, utcOffsetHours: 3.0);

    // شمال إفريقيا
    if (t.contains('خرطوم') || t.contains('سودان') || t.contains('khartoum')) return const GeoCoordinates(15.5007, 32.5599, utcOffsetHours: 2.0);
    if (t.contains('تونس') || t.contains('tunis')) return const GeoCoordinates(36.8065, 10.1815, utcOffsetHours: 1.0);
    if (t.contains('جزاير') || t.contains('algiers')) return const GeoCoordinates(36.7538, 3.0588, utcOffsetHours: 1.0);
    if (t.contains('رباط') || t.contains('كازابلانكا') || t.contains('دار بيضاء') || t.contains('مغرب') || t.contains('casablanca')) return const GeoCoordinates(34.0209, -6.8416, utcOffsetHours: 1.0);

    // العالم
    if (t.contains('اسطنبول') || t.contains('تركيا') || t.contains('istanbul')) return const GeoCoordinates(41.0082, 28.9784, utcOffsetHours: 3.0);
    if (t.contains('لندن') || t.contains('london')) return const GeoCoordinates(51.5074, -0.1278, utcOffsetHours: 0.0);
    if (t.contains('باريس') || t.contains('paris')) return const GeoCoordinates(48.8566, 2.3522, utcOffsetHours: 1.0);
    if (t.contains('نيويورك') || t.contains('new york')) return const GeoCoordinates(40.7128, -74.0060, utcOffsetHours: -5.0);

    // محافظات مصر الكبرى
    if (t.contains('اسكندريه') || t.contains('alex')) return GeoCoordinates.alexandria;
    if (t.contains('جيزه') || t.contains('اكتوبر') || t.contains('زايد')) return GeoCoordinates.giza;
    if (t.contains('قاهره') || t.contains('cairo')) return GeoCoordinates.cairo;

    return null;
  }

}
