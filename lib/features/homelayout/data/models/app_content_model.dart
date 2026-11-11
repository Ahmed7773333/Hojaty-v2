class AppContentModel {
  final String title;
  final String content;
  final String? version;
  final String? updatedAt;

  const AppContentModel({
    required this.title,
    required this.content,
    this.version,
    this.updatedAt,
  });

  factory AppContentModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] is Map<String, dynamic>
        ? json['data'] as Map<String, dynamic>
        : json;

    return AppContentModel(
      title: data['title'] as String? ?? '',
      content: data['content'] as String? ?? '',
      version: data['version'] as String?,
      updatedAt: (data['updated_at'] ?? data['updatedAt']) as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'content': content,
      'version': version,
      'updated_at': updatedAt,
    };
  }

  factory AppContentModel.fallbackPrivacyPolicy({String language = 'ar'}) {
    final isAr = language == 'ar';
    return AppContentModel(
      title: isAr ? 'سياسة الخصوصية' : 'Privacy Policy',
      content: isAr
          ? 'نحن نولي خصوصية بياناتك اهتماماً فائقاً. تطبيق حچتي مصمم لحفظ جميع معلوماتك الشخصية وسجل محادثاتك مع المساعد الذكي (AI) وإعداداتك في قاعدة البيانات المحلية (Local Database) على جهازك فقط لضمان أعلى مستويات الأمان والسرية دون مشاركة أي معلومات شخصية مع أطراف خارجية.'
          : 'We value your privacy immensely. Hojaty is designed to store all your personal information, AI Assistant chat history, and preferences inside the local database on your device only to ensure maximum security and privacy without sharing any personal data with third parties.',
    );
  }

  factory AppContentModel.fallbackTermsAndConditions({String language = 'ar'}) {
    final isAr = language == 'ar';
    return AppContentModel(
      title: isAr ? 'الشروط والأحكام' : 'Terms and Conditions',
      content: isAr
          ? 'باستخدامك لتطبيق حچتي، فإنك توافق على الالتزام بجميع الشروط والأحكام الخاصة بالاستخدام الشخصي غير التجاري. نهدف من خلال هذا التطبيق إلى تقديم تجربة إسلامية متميزة لمساعدتك على أداء صلاتك وعباداتك.\n\nتنويه حول المساعد الذكي (AI): المساعد الذكي داخل التطبيق ليس مفتياً ولا يُصدر فتاوى شرعية، وإنما يقتصر دوره على مساعدتك في البحث عن الأدلة والنصوص من المصادر الإسلامية الصحيحة والمعتمدة مثل القرآن الكريم وصحيح البخاري وصحيح مسلم وغيرها من كتب السنة الموثوقة.'
          : 'By using Hojaty, you agree to comply with all terms and conditions for personal, non-commercial use. We aim to provide an exceptional Islamic experience to help you perform your prayers and worship.\n\nAI Assistant Disclaimer: The AI Assistant in this app is not a Mufti and does not issue Fatwas (religious rulings). Its role is solely to help you find evidence and references from authentic Islamic sources such as the Holy Quran, Sahih al-Bukhari, Sahih Muslim, and other trusted books of Sunnah.',
    );
  }
}
