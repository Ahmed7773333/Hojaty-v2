# Task 1: Hojaty AI Assistant — Remove Live Stream, Intent Routing & UI Polish

Inspect the existing AI Assistant feature (`domain`, `data`, `presentation`), tool-calling registry, and RAG pipeline first. Follow Hojaty's Clean Architecture, custom extensions, and DI conventions strictly.

## Requirements:
1. **Remove Live Stream Tool:**
   - Completely remove the Makkah/Madinah Live Stream tool definition, execution handler, prompt references, and any related UI trigger.

2. **Strict 3-Way Mutually Exclusive Intent Router:**
   - Ensure a single user query NEVER triggers both Tool Calling and RAG simultaneously, and random/gibberish inputs trigger neither.
   - Implement a pre-execution intent gate / router in the domain/data orchestration layer:
     - **`NO_OP / GIBBERISH / CHITCHAT`:** Random text (e.g., `"asdf"`, `"123"`, `"ههه"`), greetings, or casual off-topic chat -> Skip RAG retrieval and skip Tool Calling completely. Return a brief, helpful reply in the user's language.
     - **`ACTION_TOOL`:** Explicit app actions (e.g., setting reminders/alarms, navigating screens, toggling settings, Zakat calculation, checking next prayer) -> Invoke Tool Calling ONLY; skip RAG context injection.
     - **`KNOWLEDGE_RAG`:** Islamic questions (Tafsir, Hadith, Fiqh, rulings) -> Run RAG retrieval ONLY; disable/exclude tool definitions during generation.

3. **UI/UX Upgrades:**
   - Replace generic spinners with stage-aware status pills (*"جاري البحث في المصادر..."* for RAG, *"جاري تنفيذ الإجراء..."* for Tools, no loader delay for chitchat).
   - Render RAG sources as clean collapsible footnote chips at the bottom of assistant messages, and tool executions as compact confirmation cards with a relevant action/deep-link button.
   - Add 3–4 context-aware starter prompt chips on the empty chat state.

Output a brief file-by-file plan first, then implement cleanly and run `flutter analyze`.
