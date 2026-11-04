# 📄 مواصفات واجهات برمجة التطبيقات (API Specifications)
## تطبيق "حچتي" — السياسات، الشروط، الإعلانات، وإعدادات التحكم (App Policies, Banners & Remote Config Endpoints)

تهدف هذه الوثيقة إلى توضيح متطلبات واجهات برمجة التطبيقات (RESTful API Endpoints) الخاصة بصفحتي **سياسة الخصوصية (Privacy Policy)** و**الشروط والأحكام (Terms & Conditions)** بالإضافة إلى **الإعلانات والبنرات (Banners)** و**إعدادات التحكم العامة للتطبيق (App Remote Configuration)** لتطبيق "حچتي" ليقوم الفريق البرمجي للـ Backend بتنفيذها.

---

## 📌 1. نظرة عامة (Overview)

| البند | التفاصيل |
| :--- | :--- |
| **بروتوكول الاتصال** | HTTPS |
| **تنسيق البيانات (Format)** | JSON (`application/json`) |
| **اللغات المدعومة** | العربية (`ar`)، الإنجليزية (`en`) |
| **طريقة تحديد اللغة** | عبر الـ Header: `Accept-Language` أو `app-lang` |
| **المصادقة (Authentication)** | Public Endpoint (لا تتطلب Bearer Token ولكن تقبله إذا وجد) |

---

## 🌐 2. المسارات (Endpoints)

### 1️⃣ سياسة الخصوصية (Privacy Policy)
- **المسار (URL)**: `GET /api/v1/app/privacy-policy`
- **الوصف**: جلب نص وبنود سياسة الخصوصية المحدثة للتطبيق حسب اللغة المطلوبة.

### 2️⃣ الشروط والأحكام (Terms & Conditions)
- **المسار (URL)**: `GET /api/v1/app/terms-and-conditions`
- **الوصف**: جلب بنود وشروط الاستخدام للتطبيق حسب اللغة المطلوبة.

### 3️⃣ الإعلانات / البنرات (Banners)
- **المسار (URL)**: `GET /api/v1/app/banners`
- **الوصف**: جلب قائمة البنرات الإعلانية الترويجية النشطة داخل التطبيق.

### 4️⃣ إعدادات التحكم العامة بالتطبيق (App Remote Configuration)
- **المسار (URL)**: `GET /api/v1/app/config`
- **الوصف**: جلب إعدادات التحكم العامة ومفاتيح تفعيل/تعطيل الميزات (Feature Flags)، وأرقام الإصدارات الإلزامية/الاختيارية للتحديث، وروابط التطبيق على المتاجر، ورسائل الصيانة.

---

## 📥 3. ترويسة الطلب (Request Headers)

```http
GET /api/v1/app/config HTTP/1.1
Host: api.anaosaly.com
Accept: application/json
Accept-Language: ar
app-lang: ar
```

---

## 📤 4. نموذج الاستجابة (Response Payload)

### ✅ أ. سياسة الخصوصية (HTTP 200 OK)

#### باللغة العربية (`Accept-Language: ar`):
```json
{
  "status": true,
  "message": "تم جلب البيانات بنجاح",
  "data": {
    "title": "سياسة الخصوصية",
    "content": "نحن نولي خصوصية بياناتك اهتماماً فائقاً في تطبيق حچتي. جميع بياناتك ومواقيت صلواتك وإعداداتك الشخصية يتم حفظها محلياً على جهازك لضمان أعلى معايير الأمان والسرية، ولا يتم بيع أو مشاركة أي بيانات مع أطراف خارجية.",
    "version": "1.2.0",
    "updated_at": "2026-08-25"
  }
}
```

#### باللغة الإنجليزية (`Accept-Language: en`):
```json
{
  "status": true,
  "message": "Data retrieved successfully",
  "data": {
    "title": "Privacy Policy",
    "content": "We take your privacy very seriously in the Hojaty application. All your prayer times, personal settings, and offline records are stored locally on your device ensuring maximum confidentiality. No personal information is sold or shared with any third party.",
    "version": "1.2.0",
    "updated_at": "2026-08-25"
  }
}
```

---

### ✅ ب. الإعلانات / البنرات (HTTP 200 OK)

```json
{
  "status": true,
  "message": "تم جلب البنرات بنجاح",
  "data": [
    {
      "id": "1",
      "link": "https://anaosaly.com/special-offer",
      "image_link": "https://api.anaosaly.com/storage/banners/banner_1.png"
    },
    {
      "id": "2",
      "link": "https://anaosaly.com/ramadan",
      "image_link": "https://api.anaosaly.com/storage/banners/banner_2.png"
    }
  ]
}
```

---

### ✅ ج. إعدادات التحكم العامة بالتطبيق (App Remote Configuration) (HTTP 200 OK)

```json
{
  "status": true,
  "message": "تم جلب إعدادات التطبيق بنجاح",
  "data": {
    "app_version": {
      "latest_version": "1.3.0",
      "min_supported_version": "1.0.0",
      "force_update": false,
      "android_store_url": "https://play.google.com/store/apps/details?id=com.wolfdev.hojaty",
      "ios_store_url": "https://apps.apple.com/app/id123456789",
      "update_message": {
        "ar": "يتوفر إصدار جديد من تطبيق حچتي يرجى التحديث للحصول على أحدث الميزات.",
        "en": "A new version of Hojaty is available. Please update to enjoy new features."
      }
    },
    "maintenance_mode": {
      "is_active": false,
      "message": {
        "ar": "التطبيق قيد الصيانة الدورية حالياً، سنعود قريباً إن شاء الله.",
        "en": "The application is currently under maintenance. We will be back shortly."
      }
    },
    "feature_flags": {
      "enable_banners": true,
      "enable_hojaty_sms": true,
      "enable_ramadan_counter": true,
      "enable_occasions_sync": true,
      "enable_advanced_adhan": true,
      "enable_contact_us": true
    },
    "support_contact": {
      "support_email": "support@anaosaly.com",
      "support_phone": "+201000000000",
      "support_whatsapp": "+201000000000",
      "website_url": "https://anaosaly.com"
    },
    "social_links": {
      "facebook": "https://facebook.com/anaosaly",
      "twitter": "https://twitter.com/anaosaly",
      "instagram": "https://instagram.com/anaosaly",
      "telegram": "https://t.me/anaosaly"
    }
  }
}
```

---

## 📊 5. تفاصيل الحقول (Fields Definition)

### 1. حقول السياسات والشروط:
| الحقل | النوع | إلزامي؟ | الوصف |
| :--- | :--- | :--- | :--- |
| `status` | `boolean` | نعم | حالة نجاح العملية (`true` / `false`) |
| `message` | `string` | نعم | رسالة توضيحية للعملية |
| `data` | `object` | نعم | الكائن الذي يحتوي على بيانات المحتوى |
| `data.title` | `string` | نعم | عنوان الصفحة (مثال: "سياسة الخصوصية" أو "الشروط والأحكام") |
| `data.content` | `string` | نعم | النص الكامل للسياسة أو الشروط (يدعم فواصل الأسطر `\n` لتنسيق الفقرات) |
| `data.version` | `string` | اختياري | رقم إصدار السياسة (مثال: `"1.2.0"`) |
| `data.updated_at` | `string` | اختياري | تاريخ آخر تحديث للسياسة (مثال: `"2026-08-25"`) |

### 2. حقول كائن البنر (Banner Object):
| الحقل | النوع | إلزامي؟ | الوصف |
| :--- | :--- | :--- | :--- |
| `id` | `string` / `integer` | نعم | المعرف الفريد للبنر الإعلاني |
| `link` | `string` | نعم | الرابط التوجيهي عند النقر على البنر (External URL أو Deep link) |
| `image_link` | `string` | نعم | رابط صورة البنر لعرضه في التطبيق |

### 3. حقول إعدادات التحكم (Remote Config Object):
| الحقل | النوع | إلزامي؟ | الوصف |
| :--- | :--- | :--- | :--- |
| `app_version.latest_version` | `string` | نعم | أحدث رقم إصدار متوفر للتطبيق على المتاجر |
| `app_version.min_supported_version` | `string` | نعم | أقل إصدار مسموح به للاستمرار بتشغيل التطبيق |
| `app_version.force_update` | `boolean` | نعم | تفعيل نافذة التحديث الإجباري للمستخدم |
| `app_version.android_store_url` | `string` | نعم | رابط صفحة التطبيق على Google Play Store |
| `app_version.ios_store_url` | `string` | نعم | رابط صفحة التطبيق على Apple App Store |
| `maintenance_mode.is_active` | `boolean` | نعم | تفعيل شاشة وضع الصيانة وإيقاف التطبيق مؤقتاً |
| `maintenance_mode.message` | `object` | نعم | نص رسالة الصيانة بالعربية والإنجليزية |
| `feature_flags` | `object` | نعم | مفاتيح تشغيل وإيقاف الميزات الحصرية والديناميكية عن بُعد |
| `support_contact` | `object` | اختياري | قنوات الدعم الفني والتواصل (إيميل، هاتف، واتساب) |
| `social_links` | `object` | اختياري | روابط حسابات التواصل الاجتماعي الرسمية للتطبيق |

---

## ⚠️ 6. معالجة الأخطاء (Error Handling)

### خطأ في الخادم (HTTP 500 Internal Server Error):
```json
{
  "status": false,
  "message": "حدث خطأ غير متوقع في الخادم، يرجى المحاولة لاحقاً.",
  "data": null
}
```

---

## 💡 7. ملاحظات وتوصيات للمطورين (Backend Developer Notes)

1. **الفقرات وفواصل الأسطر**: يُرجى إرجاع نص `content` مع فواصل الأسطر الطبيعية (`\n\n`) لتقسيم البنود إلى فقرات مريحة للقراءة في واجهة الموبايل.
2. **التخزين المؤقت (Caching Headers)**: يُفضل إرسال ترويسة Caching (مثل `Cache-Control: public, max-age=86400`) لنصوص السياسات والشروط لأنها نادراً ما تتغير يومياً، بينما يُفضل مدة كاش أقصر لـ `/app/config` (مثلاً 5-15 دقيقة) لسرعة تطبيق التغييرات.
3. **أبعاد وتحسين صور البنرات**: يُستحسن ضغط صور البنرات بصيغ خفيفة (WebP أو PNG مضغوطة) لسرعة التحميل وتوفير استهلاك البيانات.
4. **التطبيق مجهز بالكامل**: بنية تطبيق الفلاتر مهيأة مع هذه المواصفات وتحتوي على نظام Fallback ذكي للعرض في حالة عدم توفر اتصال بالإنترنت أو أثناء قيامكم بإنشاء الـ Endpoints.

