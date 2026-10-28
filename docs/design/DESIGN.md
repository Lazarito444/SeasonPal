---
name: Botanical Culinary Editorial
colors:
  surface: '#f5efe1'
  surface-dim: '#ded3bd'
  surface-bright: '#f5efe1'
  surface-container-lowest: '#ffffff'
  surface-container-low: '#fdf9ef'
  surface-container: '#edf1e4'
  surface-container-high: '#e6ebdc'
  surface-container-highest: '#ded3bd'
  on-surface: '#26261f'
  on-surface-variant: '#6e6c5e'
  inverse-surface: '#1e3a2a'
  inverse-on-surface: '#f5efe1'
  outline: '#6e6c5e'
  outline-variant: '#ded3bd'
  surface-tint: '#1e3a2a'
  primary: '#1e3a2a'
  on-primary: '#ffffff'
  primary-container: '#1e3a2a'
  on-primary-container: '#e6ebdc'
  inverse-primary: '#9baf86'
  secondary: '#b45a36'
  on-secondary: '#ffffff'
  secondary-container: '#cf7f5c'
  on-secondary-container: '#7d3920'
  tertiary: '#5f7250'
  on-tertiary: '#ffffff'
  tertiary-container: '#7f9370'
  on-tertiary-container: '#e6ebdc'
  error: '#a44832'
  on-error: '#ffffff'
  error-container: '#f3d9d2'
  on-error-container: '#7d2b1c'
  primary-fixed: '#e6ebdc'
  primary-fixed-dim: '#9baf86'
  on-primary-fixed: '#13251a'
  on-primary-fixed-variant: '#1e3a2a'
  secondary-fixed: '#f7e3d9'
  secondary-fixed-dim: '#e0a58f'
  on-secondary-fixed: '#4a1f12'
  on-secondary-fixed-variant: '#8c3f26'
  tertiary-fixed: '#eef1e5'
  tertiary-fixed-dim: '#bccfae'
  on-tertiary-fixed: '#26301f'
  on-tertiary-fixed-variant: '#5f7250'
  background: '#f5efe1'
  on-background: '#26261f'
  surface-variant: '#ded3bd'
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
  sm: 0.375rem
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
  margin-mobile: 1.25rem
  margin-desktop: 2.5rem
  space-xs: 0.25rem
  space-sm: 0.5rem
  space-md: 1rem
  space-lg: 1.5rem
  space-xl: 2.25rem
---

> Implementation: the Flutter tokens live in `mobile/lib/core/theme/app_colors.dart`
> (palette), `app_theme.dart` (type scale, radii, shadows, component themes) and
> `mobile/assets/fonts/` (Playfair Display roman + italic and Plus Jakarta Sans,
> self-hosted variable TTFs). The hex values above are the shipped ones; keep this file
> and those tokens in step when either changes.

## Brand & Style

The design system is rooted in the warmth of home cooking, natural seasonal produce, and refined editorial food journalism. It balances the tactile charm of an artisanal cookbook with the frictionless utility of an intelligent digital culinary companion.

### Personality & Tone
- **Organic & Nourishing:** Earthy sage and spice tones evoke garden herbs, roasted vegetables, and sun-dried spices.
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
- **Primary (`#1e3a2a`, Deep Forest):** Used for primary buttons, selected navigation states, progress meters, and confirmation accents. An alternate bright leaf shade (`#2c4e38`) is designated for hover and active micro-states.
- **Secondary (`#b45a36`, Spice):** Directs the eye toward urgent kitchen actions, AI assistant suggestions, recipe bookmarks, cook-time highlights, and dynamic call-to-actions.
- **Tertiary (`#9baf86`, Sage):** Acts as a soft supporting accent for nutritional metric callouts, star ratings, and subtle highlight pills.
- **Neutral Surface & Text (`#26261f`, Charcoal):** Delivers WCAG AAA contrast against cream foundations, avoiding digital sterility.
- **Backgrounds:** Canvas sits on `#f5efe1` (Soft Cream), secondary layered surfaces on `#edf1e4` (Washed Linen), and elevated recipe cards on `#FFFFFF` (Stoneware Crisp).
- **Dividers & Borders:** `#ded3bd` (Parchment Line) establishes structural containment without visual heaviness.

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
- **Level 0 (Canvas Base):** Flat `#f5efe1` background.
- **Level 1 (Cards & Modules):** Pure `#FFFFFF` surface accompanied by a soft, warm ambient drop shadow: `0 4px 20px -2px rgba(38, 38, 31, 0.06)`, encased by a delicate border in `#ded3bd`.
- **Level 2 (Floating Action Buttons & Dynamic AI Sheets):** Soft floating elevated surfaces: `0 8px 30px -4px rgba(30, 58, 42, 0.12)`, combining an organic sage-tinted cast shadow for contextual feedback.
- **Level 3 (Modal Cooking Overlay & Tooltips):** Deep protective elevation: `0 16px 40px -6px rgba(19, 37, 26, 0.18)` over a blurred frosted backdrop (`backdrop-filter: blur(8px); background-color: rgba(245, 239, 225, 0.85)`).

## Shapes

The interface embraces organic curvature to reinforce comfort, domestic warmth, and tactile friendliness.

### Shape Scale Rules
- **Micro Radii (`rounded-sm` / 6px):** Checkbox indicators and minor inline micro-tags.
- **Standard Radii (`rounded-md` / 8px):** Form input fields, step counter indicators, and inner ingredient selection zones.
- **Card Radii (`rounded-xl` / 16px & `rounded-2xl` / 24px):** Primary recipe cards, collection covers, and bottom sheet containers.
- **Container Curvature (`rounded-3xl` / 32px):** Modal surfaces, full-bleed hero image corners, and floating assistant panels.
- **Full Pill (`rounded-full` / 9999px):** All actionable buttons, filter tags, cuisine badges, cooking timers, and tab indicators.

## Components

### Buttons
- **Primary Action (Cook Now, Generate Recipe):** Pill-shaped (`rounded-full`), filled with `#1e3a2a` (Deep Forest), label in bold white Plus Jakarta Sans (`label-lg`), with a subtle inner top highlight. Hover/active scales slightly (`scale-98`) with background shifting to `#2c4e38`.
- **Secondary Action (Bookmark, Share, Swap):** Washed linen fill (`#edf1e4`) with `#1e3a2a` typography, or transparent with a 1.5px `#1e3a2a` stroke.
- **Spice Accent (Start Timer, AI Kitchen Prompt):** Pill-shaped with `#b45a36` background, white text, and a spice-tinted ambient glow.

### Chips & Pill Badges
- **Metadata Badges (Cuisine, Cook Time, Calorie):** `rounded-full` pill structure with `space-xs` vertical and `space-sm` horizontal padding. Neutral background `#edf1e4`, border `#ded3bd`, text `#26261f` in `label-sm`.
- **Appliance Badges (Air Fryer, Instant Pot, Slow Cooker):** Soft Sage tint (`rgba(30, 58, 42, 0.08)`) with `#1e3a2a` text and a mini iconography glyph prefix.
- **Active Filter Chips:** Filled with `#1e3a2a`, text in white, with a smooth spring transition on tap.

### Recipe Cards
- Base surface in `#FFFFFF`, with `rounded-2xl` corners, a 1px border in `#ded3bd`, and Level 1 elevation.
- 16:10 or 4:3 image header with subtle bottom vignette, housing floating top-right bookmark buttons and bottom-left dietary badges.
- Card body features title in Playfair Display (`headline-sm`), followed by a row of metadata chips (time, difficulty rating, rating stars).

### Step Badges & Cooking Instructions
- Numerical step circles: 32px diameter circles in `#edf1e4` with `#1e3a2a` text in `title-md`. Upon completion, fills with `#1e3a2a` showing a white checkmark icon.
- Step item text in `body-lg` Plus Jakarta Sans with generous line height (24px) for reading at counter distance.

### Ingredient Checklists
- Custom circular checkbox: 22px diameter, 1.5px border in `#ded3bd`. Upon check, fills with `#1e3a2a` with an energetic scale bounce animation. Checked ingredient labels transition to `#26261f` at 40% opacity with a clean strikethrough.

### Input Fields & Search Bars
- Background in `#FFFFFF` or `#edf1e4`, border 1px solid `#ded3bd`, radius `rounded-xl`.
- Focus state reveals a 2px `#1e3a2a` ring with zero layout shift. Placeholder text styled in muted slate.
- AI Search Input features a spice sparkle icon button positioned within the trailing edge.

### Mobile Navigation Bar
- Fixed bottom dock featuring a frosted glass background (`rgba(245, 239, 225, 0.9)` with 12px blur) and top border in `#ded3bd`.
- Active tab indicator: Pill badge in `#1e3a2a` with white active glyph and micro-label, or an organic dot indicator nestled below the icon with subtle scale and spring physics.
- Central Floating Action Item: Dedicated "AI Kitchen Assistant" entry point styled in `#b45a36` (Spice) breaking the top waterline of the bar.