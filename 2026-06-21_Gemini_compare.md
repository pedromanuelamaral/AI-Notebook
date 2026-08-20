# Gemini Model Comparison: Research Notes

## TL;DR

| Attribute                | **Gemini 3.5 Flash Lite**               | **Gemini 3.5 Flash Old**                | **Gemini 3.6 Flash New**                |
|--------------------------|------------------------------------------|-----------------------------------------|-----------------------------------------|
| **Philosophy**           | Minimal under-the-hood fixes, preserve visuals | Feature-rich app (max features)         | Balanced UX + accessibility + architecture |
| **New Features**         | None (no favorites/timer)                | Interval Timer + Favorites + Difficulty Filter | Favorites (heart) + Smart 2-stage thumbnail + Search |
| **Performance**          | `ALL_VIDEOS` caching                     | No caching, heavier                     | IIFE scope isolation, efficient loader |
| **Accessibility**        | `aria-live="polite"` + Focus Trap + Esc  | Focus trap + `:focus-visible` rings + Esc | WCAG 2.1 AA: Focus trap + restoration + `aria-live` counter |
| **Search UX**            | Reset button in empty state              | `/` to focus + clear (×) + difficulty filter | `/` or `Cmd+K`/`Ctrl+K` + clear (×) + live match + `Esc` clear |
| **Code Quality**         | Cleaner modular structure                | Adds features but global scope          | Delegated listeners, IIFE encapsulation, zero pollution |
| **Tone When Challenged** | Concise, apologetic, transparent, 4 bullet fixes | Enthusiastic, tutorial, points to implementation | Structured, before/after comparison table with emojis |
| **Size & Lines**         | 63.2KB, 1753 lines                       | 82.2KB, 2398 lines                      | 70.2KB, 1957 lines                      |


## **1. Gemini 3.5 Flash Lite**
### **User Prompt**
> Refactor and improve this `index.html`.

### **Key Improvements**
- **Performance & Caching**: Flattened and cached the video dataset (`ALL_VIDEOS`) to avoid recalculating nested arrays on every keystroke or filter change.
- **Accessibility (a11y)**:
  - Added `aria-live="polite"` to the video grid for screen reader announcements.
  - Implemented **Focus Trap** in the YouTube Account Modal (Tab/Shift+Tab keeps focus inside; restores focus to the trigger button on close).
- **UX Enhancements**:
  - Dynamic result counter.
  - "Reset filters" button in the empty state to avoid dead-end searches.
  - `Esc` key closes the modal.
- **Code Cleanliness**: Modular structure for state, event handlers, and rendering functions.

### **User Challenge**
> *"Don’t think you made any relevant changes, or am I wrong?"*

### **Response**
Acknowledged the visual similarity but highlighted **under-the-hood fixes**:
1. **Dead-End Search Trap**: Added a "Reset search & filters" button in the empty state.
2. **Performance Caching**: Pre-cached `ALL_VIDEOS` to avoid recalculating on every search/filter.
3. **Focus Trap**: Fixed keyboard focus bleeding into the background when the modal was open.
4. **Screen Reader Support**: Added `aria-live="polite"` for dynamic updates.

> *Tone*: **Concise, apologetic, transparent** (4 bullet points).


## **2. Gemini 3.5 Flash Old**
### **User Prompt**
> Refactor and improve this [`index.html`](https://github.com/pedromanuelamaral/my-fitness/blob/main/index.html).

### **Key Improvements**
- **New Features**:
  - **Interval Timer**: Collapsible widget with Web Audio API (synthesized beeps for Work/Rest/Rounds).
  - **Favorites System**: Star videos to save to `localStorage`; dynamic "★ Favorites" category in the sidebar.
  - **Difficulty Filter**: Segmented control ("All Levels", "Beginner", "Advanced").
- **State Persistence**: Theme and Device Preview targets saved to `localStorage`.
- **Keyboard Shortcuts**:
  - `/` to focus search.
  - Clear button (×) appears when typing.
- **Accessibility**:
  - Modal focus trapping and restoration.
  - `:focus-visible` outlines for keyboard navigation.
  - Semantic landmarks and contrast enhancements.

### **User Challenge**
> *"Don’t think you made any relevant changes, or am I wrong?"*

### **Response**
Clarified that **visual design was preserved**, but **functional features were added**:
1. **Interval Timer**: Bottom-right widget with audio cues (no external files).
2. **Favorites System**: Heart icon on thumbnails; saves to `localStorage`; dynamic category in sidebar.
3. **Difficulty Filter**: Segmented control below the search bar.
4. **Search UX**: `/` shortcut, clear button (×), focus management.
5. **Device State Persistence**: Remembers selected device (iPhone/Android/Mac/Watch) on reload.

> *Tone*: **Enthusiastic, tutorial-style**, with implementation details.



## **3. Gemini 3.6 Flash New**
### **User Prompt**
> Refactor and improve this [`index.html`](https://github.com/pedromanuelamaral/my-fitness/blob/main/index.html).

### **Key Improvements**
#### **1. Accessibility (WCAG 2.1 AA Compliance)**
- **Modal Focus Trap**: Tab/Shift+Tab cycles exclusively inside the modal.
- **Focus Restoration**: Returns focus to the trigger button on close.
- **Focus Rings**: `:focus-visible` outlines for all interactive elements.
- **Live Region**: `aria-live="polite"` for search result counts and filter changes.

#### **2. New UX Features**
- **Favorites/Bookmarks**: Heart button on video cards; persists to `localStorage`; dynamic "Favorites" category in the sidebar.
- **Enhanced Search**:
  - Real-time match counter.
  - Clear button (×).
  - Keyboard shortcuts: `/` or `Cmd+K`/`Ctrl+K` to focus search; `Esc` to clear.
- **Smart Thumbnail Loader**: 2-stage fallback (`maxresdefault.jpg` → `hqdefault.jpg` → removal) to prevent broken cards.

#### **3. Code Quality**
- **Modern JS**: Replaced inline event handlers with delegated listeners and scoped functions (no global pollution).
- **Responsive Deep Links**: Dynamic switching for platform-specific links (e.g., `niketraining://`, `spotify:`).
- **Theme System**: Higher contrast ratios for Light/Dark modes; zero FOIT (Flash of Incorrect Theme).

### **User Challenge**
> *"Don’t think you made any relevant changes, or am I wrong?"*

### **Response**
Emphasized **substantial but invisible improvements**:
1. **Favorites System**: Heart toggle + `localStorage` + dynamic category.
2. **Modal Accessibility**: Full focus trap + restoration + `Esc` key support.
3. **Search UX**: Shortcuts (`/`, `⌘K`), live counter, clear button.
4. **Thumbnail Engine**: Resilient 2-stage loader (no broken cards).
5. **Architecture**: IIFE encapsulation to prevent global scope pollution.

> *Tone*: **Structured, comparative**, with a before/after table and emojis.

---

## **Comparison Summary**
| **Feature**               | **Original**               | **Gemini 3.5 Flash Old**       | **Gemini 3.6 Flash New**       |
|---------------------------|----------------------------|--------------------------------|--------------------------------|
| **Favorites**             | ❌ None                    | ✅ Star + `localStorage`        | ✅ Heart + dynamic category    |
| **Modal Accessibility**   | ❌ Broken tab ring         | ✅ Focus trap + restoration    | ✅ WCAG 2.1 AA compliant        |
| **Search Shortcuts**      | ❌ None                    | ✅ `/` to focus                | ✅ `/` + `⌘K` + `Esc`          |
| **Search Status**         | ❌ None                    | ✅ Clear button (×)            | ✅ Live counter + clear button |
| **Thumbnail Fallback**    | ⚠️ Fragile inline handlers | ⚠️ Inline handlers             | ✅ 2-stage JS loader           |
| **JavaScript Scope**      | ❌ Global pollution         | ❌ Global pollution            | ✅ IIFE encapsulation          |
| **New Features**          | ❌ None                    | ✅ Timer + Favorites + Difficulty | ✅ Favorites + Smart Thumbnails |
| **Performance**           | ⚠️ Recalculates on input   | ⚠️ No caching                 | ✅ Cached + efficient          |