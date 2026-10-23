---
name: Botanical Culinary Editorial
colors:
  surface: '#f9f9ff'
  surface-dim: '#cfdaf2'
  surface-bright: '#f9f9ff'
  surface-container-lowest: '#ffffff'
  surface-container-low: '#f0f3ff'
  surface-container: '#e7eeff'
  surface-container-high: '#dee8ff'
  surface-container-highest: '#d8e3fb'
  on-surface: '#111c2d'
  on-surface-variant: '#404943'
  inverse-surface: '#263143'
  inverse-on-surface: '#ecf1ff'
  outline: '#707973'
  outline-variant: '#bfc9c1'
  surface-tint: '#2c694d'
  primary: '#115238'
  on-primary: '#ffffff'
  primary-container: '#2e6b4f'
  on-primary-container: '#a9e9c6'
  inverse-primary: '#95d4b2'
  secondary: '#9a442d'
  on-secondary: '#ffffff'
  secondary-container: '#fc9174'
  on-secondary-container: '#742814'
  tertiary: '#723a00'
  on-tertiary: '#ffffff'
  tertiary-container: '#905015'
  on-tertiary-container: '#ffd3b4'
  error: '#ba1a1a'
  on-error: '#ffffff'
  error-container: '#ffdad6'
  on-error-container: '#93000a'
  primary-fixed: '#b0f1cd'
  primary-fixed-dim: '#95d4b2'
  on-primary-fixed: '#002113'
  on-primary-fixed-variant: '#0e5137'
  secondary-fixed: '#ffdbd2'
  secondary-fixed-dim: '#ffb4a1'
  on-secondary-fixed: '#3c0800'
  on-secondary-fixed-variant: '#7c2e19'
  tertiary-fixed: '#ffdcc4'
  tertiary-fixed-dim: '#ffb780'
  on-tertiary-fixed: '#2f1400'
  on-tertiary-fixed-variant: '#6f3800'
  background: '#f9f9ff'
  on-background: '#111c2d'
  surface-variant: '#d8e3fb'
typography:
  display-lg:
    fontFamily: Playfair Display
    fontSize: 40px
    fontWeight: '600'
    lineHeight: 48px
  display-lg-mobile:
    fontFamily: Playfair Display
    fontSize: 32px
    fontWeight: '600'
    lineHeight: 40px
  headline-lg:
    fontFamily: Playfair Display
    fontSize: 28px
    fontWeight: '600'
    lineHeight: 36px
  headline-md:
    fontFamily: Playfair Display
    fontSize: 24px
    fontWeight: '500'
    lineHeight: 32px
  headline-sm:
    fontFamily: Playfair Display
    fontSize: 20px
    fontWeight: '600'
    lineHeight: 28px
  title-lg:
    fontFamily: Plus Jakarta Sans
    fontSize: 18px
    fontWeight: '700'
    lineHeight: 26px
  title-md:
    fontFamily: Plus Jakarta Sans
    fontSize: 16px
    fontWeight: '600'
    lineHeight: 24px
  body-lg:
    fontFamily: Plus Jakarta Sans
    fontSize: 16px
    fontWeight: '400'
    lineHeight: 24px
  body-md:
    fontFamily: Plus Jakarta Sans
    fontSize: 14px
    fontWeight: '400'
    lineHeight: 22px
  body-sm:
    fontFamily: Plus Jakarta Sans
    fontSize: 13px
    fontWeight: '400'
    lineHeight: 18px
  label-lg:
    fontFamily: Plus Jakarta Sans
    fontSize: 14px
    fontWeight: '600'
    lineHeight: 20px
  label-md:
    fontFamily: Plus Jakarta Sans
    fontSize: 12px
    fontWeight: '600'
    lineHeight: 16px
    letterSpacing: 0.02em
  label-sm:
    fontFamily: Plus Jakarta Sans
    fontSize: 11px
    fontWeight: '700'
    lineHeight: 14px
    letterSpacing: 0.04em
rounded:
  sm: 0.25rem
  DEFAULT: 0.5rem
  md: 0.75rem
  lg: 1rem
  xl: 1.5rem
  full: 9999px
spacing:
  gutter: 1rem
  gutter-mobile: 0.75rem
  gutter-desktop: 1.5rem
  margin: 1.25rem
  margin-mobile: 1rem
  margin-desktop: 2.5rem
  space-xs: 0.25rem
  space-sm: 0.5rem
  space-md: 1rem
  space-lg: 1.5rem
  space-xl: 2.25rem
---

## Brand & Style

The design system is rooted in the warmth of home cooking, natural seasonal produce, and refined editorial food journalism. It balances the tactile charm of an artisanal cookbook with the frictionless utility of an intelligent digital culinary companion.

### Personality & Tone
- **Organic & Nourishing:** Earthy sage and terracotta tones evoke garden herbs, roasted vegetables, and sun-dried spices.
- **Warm & Sophisticated:** Crisp cream foundations and deliberate editorial serif typography provide a curated, magazine-grade feel without feeling sterile or intimidating.
- **Supportive & Intuitive:** Kitchen settings demand high scannability, clear feedback loops, and rapid visual orientation for messy-hands usage.

### Design Movement: Modern Tactile Editorial
The interface combines warm minimalism with organic tactile surfaces:
- Cream and parchment backgrounds paired with crisp elevated white containers.
- Editorial typographic hierarchy blending literary serifs for recipe identity and clean geometric sans for operational precision.
- Pill badges, rounded nested surfaces, and warm ambient undertone shadows that soften visual friction.

## Colors

The palette derives from seasonal ingredients, glazed stoneware, and botanical kitchen greens. It avoids harsh digital blues and pure blacks in favor of grounded, organic tones.

### Palette Roles
- **Primary (`#2E6B4F`, Herb Sage):** Used for primary buttons, selected navigation states, progress meters, and confirmation accents. An alternate bright leaf shade (`#3D8361`) is designated for hover and active micro-states.
- **Secondary (`#E07A5F`, Warm Terracotta):** Directs the eye toward urgent kitchen actions, AI assistant suggestions, recipe bookmarks, cook-time highlights, and dynamic call-to-actions.
- **Tertiary (`#F4A261`, Apricot Glaze):** Acts as a soft supporting accent for nutritional metric callouts, star ratings, and subtle highlight pills.
- **Neutral Surface & Text (`#1E293B`, Deep Slate):** Delivers WCAG AAA contrast against cream foundations, avoiding digital sterility.
- **Backgrounds:** Canvas sits on `#FBF9F5` (Soft Cream), secondary layered surfaces on `#F4F1EA` (Washed Linen), and elevated recipe cards on `#FFFFFF` (Stoneware Crisp).
- **Dividers & Borders:** `#E7E2D9` (Parchment Line) establishes structural containment without visual heaviness.

## Typography

The type system pairs **Playfair Display** (a modern, high-contrast serif) with **Plus Jakarta Sans** (a friendly, geometric, highly legible humanist grotesque).

### Typographic Intent
- **Playfair Display** commands recipe titles, magazine-style editorial hero banners, culinary collection headers, and celebratory step completions.
- **Plus Jakarta Sans** powers all operational, step-by-step cooking flows, ingredient quantities, timers, nutritional breakdowns, and AI assistant dialogs to guarantee rapid comprehension at arm's length.

### Kitchen-Specific Rules
- **Timers and Metric Tokens:** Ingredient quantities (e.g., `250g`, `2 tbsp`) must always render in `title-md` or `label-lg` with tabular numeric alignment.
- **Uppercase Restraint:** Restrict all-caps tracking solely to `label-sm` for culinary appliance tags, preparation phases, and diet markers.

## Layout & Spacing

The interface centers on a fluid mobile-first grid built to support thumb reach zones and single-hand navigation while cooking.

### Layout Mechanics
- **Mobile (<640px):** 4-column fluid system with `1rem` edge margins and `0.75rem` column gutters. Horizontal scrolling carousels break out to negative margin boundaries (`-1rem`) with bleeding card edges.
- **Tablet (640px–1024px):** 8-column layout with `1.5rem` edge margins. Recipe preparation steps and ingredient lists snap into a dual-pane master-detail arrangement.
- **Desktop (>1024px):** 12-column layout max-width constrained to `1200px` centered, with `2.5rem` outer canvas padding.

### Spacing Scale
- Use `space-xs` (4px) and `space-sm` (8px) for badge padding, ingredient check item gaps, and inline icons.
- Use `space-md` (16px) for card body padding, stack gaps between cooking steps, and list item separators.
- Use `space-lg` (24px) between distinct card groups, kitchen timer modules, and AI assistant prompt panels.
- Use `space-xl` (36px) for section-level separation on scrollable recipe viewports.

## Elevation & Depth

Visual depth relies on tonal warmth and diffused organic shadows rather than industrial gray drop shadows. This creates the illusion of stacked parchment, linen, and glazed ceramic plates.

### Elevation Hierarchy
- **Level 0 (Canvas Base):** Flat `#FBF9F5` background.
- **Level 1 (Cards & Modules):** Pure `#FFFFFF` surface accompanied by a soft, warm ambient drop shadow: `0 4px 20px -2px rgba(30, 41, 59, 0.05)`, encased by a delicate border in `#E7E2D9`.
- **Level 2 (Floating Action Buttons & Dynamic AI Sheets):** Soft floating elevated surfaces: `0 8px 30px -4px rgba(46, 107, 79, 0.12)`, combining an organic sage-tinted cast shadow for contextual feedback.
- **Level 3 (Modal Cooking Overlay & Tooltips):** Deep protective elevation: `0 16px 40px -6px rgba(30, 41, 59, 0.18)` over a blurred frosted backdrop (`backdrop-filter: blur(8px); background-color: rgba(251, 249, 245, 0.85)`).

## Shapes

The interface embraces organic curvature to reinforce comfort, domestic warmth, and tactile friendliness.

### Shape Scale Rules
- **Micro Radii (`rounded-sm` / 4px):** Checkbox indicators and minor inline micro-tags.
- **Standard Radii (`rounded-md` / 8px):** Form input fields, step counter indicators, and inner ingredient selection zones.
- **Card Radii (`rounded-xl` / 16px & `rounded-2xl` / 24px):** Primary recipe cards, collection covers, and bottom sheet containers.
- **Container Curvature (`rounded-3xl` / 32px):** Modal surfaces, full-bleed hero image corners, and floating assistant panels.
- **Full Pill (`rounded-full` / 9999px):** All actionable buttons, filter tags, cuisine badges, cooking timers, and tab indicators.

## Components

### Buttons
- **Primary Action (Cook Now, Generate Recipe):** Pill-shaped (`rounded-full`), filled with `#2E6B4F` (Sage Green), label in bold white Plus Jakarta Sans (`label-lg`), with a subtle inner top highlight. Hover/active scales slightly (`scale-98`) with background shifting to `#3D8361`.
- **Secondary Action (Bookmark, Share, Swap):** Warm parchment fill (`#F4F1EA`) with `#2E6B4F` typography, or transparent with a 1.5px `#2E6B4F` stroke.
- **Terracotta Accent (Start Timer, AI Kitchen Prompt):** Pill-shaped with `#E07A5F` background, white text, and a terracotta-tinted ambient glow.

### Chips & Pill Badges
- **Metadata Badges (Cuisine, Cook Time, Calorie):** `rounded-full` pill structure with `space-xs` vertical and `space-sm` horizontal padding. Neutral background `#F4F1EA`, border `#E7E2D9`, text `#1E293B` in `label-sm`.
- **Appliance Badges (Air Fryer, Instant Pot, Slow Cooker):** Soft Sage tint (`rgba(46, 107, 79, 0.08)`) with `#2E6B4F` text and a mini iconography glyph prefix.
- **Active Filter Chips:** Filled with `#2E6B4F`, text in white, with a smooth spring transition on tap.

### Recipe Cards
- Base surface in `#FFFFFF`, with `rounded-2xl` corners, a 1px border in `#E7E2D9`, and Level 1 elevation.
- 16:10 or 4:3 image header with subtle bottom vignette, housing floating top-right bookmark buttons and bottom-left dietary badges.
- Card body features title in Playfair Display (`headline-sm`), followed by a row of metadata chips (time, difficulty rating, rating stars).

### Step Badges & Cooking Instructions
- Numerical step circles: 32px diameter circles in `#F4F1EA` with `#2E6B4F` text in `title-md`. Upon completion, fills with `#2E6B4F` showing a white checkmark icon.
- Step item text in `body-lg` Plus Jakarta Sans with generous line height (24px) for reading at counter distance.

### Ingredient Checklists
- Custom circular checkbox: 22px diameter, 1.5px border in `#E7E2D9`. Upon check, fills with `#2E6B4F` with an energetic scale bounce animation. Checked ingredient labels transition to `#1E293B` at 40% opacity with a clean strikethrough.

### Input Fields & Search Bars
- Background in `#FFFFFF` or `#F4F1EA`, border 1px solid `#E7E2D9`, radius `rounded-xl`.
- Focus state reveals a 2px `#2E6B4F` ring with zero layout shift. Placeholder text styled in muted slate.
- AI Search Input features a terracotta sparkle icon button positioned within the trailing edge.

### Mobile Navigation Bar
- Fixed bottom dock featuring a frosted glass background (`rgba(251, 249, 245, 0.9)` with 12px blur) and top border in `#E7E2D9`.
- Active tab indicator: Pill badge in `#2E6B4F` with white active glyph and micro-label, or an organic dot indicator nestled below the icon with subtle scale and spring physics.
- Central Floating Action Item: Dedicated "AI Kitchen Assistant" entry point styled in `#E07A5F` (Terracotta) breaking the top waterline of the bar.