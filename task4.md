Task 5: New Quick Action — Daily Random WhatsApp Story Card Generator
5.1 Generate Curated Local Dataset (assets/data/daily_stories.json)
Generate a rich, high-quality local JSON file (assets/data/daily_stories.json) containing 60 curated entries tailored to what users love sharing on WhatsApp Status, with accurate Arabic Tashkeel and concise, visually balanced lengths:
ayah (20 entries): Short, comforting Quranic verses (hope, relief, patience, reliance on Allah) paired with a 1-sentence simplified meaning (sub_text) and Surah/Ayah reference.
salawat (15 entries): Varied authentic formulas of Salawat upon the Prophet ﷺ (الصلاة على النبي ﷺ) paired with a short virtue/hadith reference.
dhikr (15 entries): High-reward short Adhkar & Istighfar (e.g., Hawqalah, Al-Baqiyat As-Salihat, Yunus's supplication, Syed Al-Istighfar) with a 1-line reward summary.
dua (10 entries): Short, relatable Prophetic supplications (جوامع الدعاء) for peace of mind, guidance, and provision.
{
  "id": "story_001",
  "category": "ayah | salawat | dhikr | dua",
  "category_label_ar": "آية وتدبر | صلاة على النبي ﷺ | ذكر اليوم | دعاء مختار",
  "main_text": "...",
  "sub_text": "...",
  "reference": "..."
}

(Ensure assets/data/daily_stories.json is registered in pubspec.yaml.)
5.2 Home Quick Action & Category Filter
Add a "حالة اليوم" (Daily Story) Quick Action on the Home screen opening DailyStoryPreviewPage.
Select today's default card using a date-seeded PRNG (year * 10000 + month * 100 + day) while tracking recently displayed IDs in local preferences to prevent consecutive repeats.
Inside DailyStoryPreviewPage, include:
A horizontal Category Filter Chip row (الكل، آيات، صلاة على النبي، أذكار، أدعية) so users can filter cards by mood/occasion (e.g., Salawat on Fridays).
A "تغيير البطاقة" (Shuffle) button to cycle through cards within the active filter.
5.3 9:16 Story Preview & Direct WhatsApp Status Sharing
Render a high-aesthetic 9:16 vertical Story card (1080x1920 aspect ratio) using Hojaty's Arabic display/Quran typography, subtle Islamic geometric accents, and a clean minimal Hojaty footer.
Let users switch between 3 curated visual palettes (e.g., Emerald Dawn, Midnight Gold, Warm Parchment).
Capture the card via RepaintBoundary (pixelRatio: 3.0), write to temporary storage (getTemporaryDirectory()), and trigger Share.shareXFiles for immediate WhatsApp Status sharing, automatically cleaning up old temporary images.
Final Verification
Run flutter pub get and flutter analyze to confirm zero warnings or errors.
Verify RTL alignment, proper resource disposal, and Clean Architecture boundaries across all 5 tasks.