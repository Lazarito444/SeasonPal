///
/// Generated file. Do not edit.
///
// coverage:ignore-file
// ignore_for_file: type=lint, unused_import
// dart format off

part of 'strings.g.dart';

// Path: <root>
typedef TranslationsEn = Translations; // ignore: unused_element
class Translations with BaseTranslations<AppLocale, Translations> {
	/// Returns the current translations of the given [context].
	///
	/// Usage:
	/// final t = Translations.of(context);
	static Translations of(BuildContext context) => InheritedLocaleData.of<AppLocale, Translations>(context).translations;

	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	Translations({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver, TranslationMetadata<AppLocale, Translations>? meta})
		: assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
		  _meta = meta ?? TranslationMetadata(
		    locale: AppLocale.en,
		    overrides: overrides ?? {},
		    cardinalResolver: cardinalResolver,
		    ordinalResolver: ordinalResolver,
		  ) {
		_meta.setFlatMapFunction(_flatMapFunction);
	}

	/// Metadata for the translations of <en>.
	final TranslationMetadata<AppLocale, Translations> _meta;
	@override TranslationMetadata<AppLocale, Translations> get $meta => _meta;

	/// Access flat map
	dynamic operator[](String key) => _meta.getTranslation(key);

	late final Translations _root = this; // ignore: unused_field

	Translations $copyWith({TranslationMetadata<AppLocale, Translations>? meta}) => Translations(meta: meta ?? this.$meta);

	// Translations
	late final Translations$app$en app = Translations$app$en.internal(_root);
	late final Translations$common$en common = Translations$common$en.internal(_root);
	late final Translations$errors$en errors = Translations$errors$en.internal(_root);
	late final Translations$auth$en auth = Translations$auth$en.internal(_root);
	late final Translations$onboarding$en onboarding = Translations$onboarding$en.internal(_root);
	late final Translations$discovery$en discovery = Translations$discovery$en.internal(_root);
	late final Translations$home$en home = Translations$home$en.internal(_root);
	late final Translations$navigation$en navigation = Translations$navigation$en.internal(_root);
	late final Translations$comingSoon$en comingSoon = Translations$comingSoon$en.internal(_root);
	late final Translations$recipes$en recipes = Translations$recipes$en.internal(_root);
}

// Path: app
class Translations$app$en {
	Translations$app$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Cook with the season, keep what you love.'
	String get tagline => 'Cook with the season, keep what you love.';

	/// en: 'Your recipes stay yours.'
	String get privacyNote => 'Your recipes stay yours.';
}

// Path: common
class Translations$common$en {
	Translations$common$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Back'
	String get back => 'Back';

	/// en: 'Cancel'
	String get cancel => 'Cancel';

	/// en: 'Delete'
	String get delete => 'Delete';

	/// en: 'Dismiss'
	String get dismiss => 'Dismiss';

	/// en: 'Try again'
	String get tryAgain => 'Try again';

	/// en: 'Show password'
	String get showPassword => 'Show password';

	/// en: 'Hide password'
	String get hidePassword => 'Hide password';
}

// Path: errors
class Translations$errors$en {
	Translations$errors$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Something went wrong. Try again.'
	String get generic => 'Something went wrong. Try again.';

	/// en: 'Could not reach SeasonPal. Check your connection and try again.'
	String get connection => 'Could not reach SeasonPal. Check your connection and try again.';

	/// en: 'The kitchen is taking too long to answer. Try again.'
	String get timeout => 'The kitchen is taking too long to answer. Try again.';

	/// en: 'Your session has expired. Sign in again.'
	String get sessionExpired => 'Your session has expired. Sign in again.';

	/// en: 'That action conflicts with existing data.'
	String get conflict => 'That action conflicts with existing data.';

	/// en: 'Too many attempts. Wait a moment and try again.'
	String get rateLimited => 'Too many attempts. Wait a moment and try again.';

	/// en: 'Something went wrong on our side. Try again.'
	String get server => 'Something went wrong on our side. Try again.';

	/// en: 'Email or password is incorrect.'
	String get invalidCredentials => 'Email or password is incorrect.';

	/// en: 'That account already exists.'
	String get emailTaken => 'That account already exists.';

	/// en: 'Add at least one ingredient and one step before publishing.'
	String get publishIncomplete => 'Add at least one ingredient and one step before publishing.';

	/// en: 'You already have a collection with that name.'
	String get collectionNameTaken => 'You already have a collection with that name.';
}

// Path: auth
class Translations$auth$en {
	Translations$auth$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	late final Translations$auth$login$en login = Translations$auth$login$en.internal(_root);
	late final Translations$auth$register$en register = Translations$auth$register$en.internal(_root);
	late final Translations$auth$splash$en splash = Translations$auth$splash$en.internal(_root);
}

// Path: onboarding
class Translations$onboarding$en {
	Translations$onboarding$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'STEP {current} OF {total}'
	String stepIndicator({required Object current, required Object total}) => 'STEP ${current} OF ${total}';

	/// en: 'STEP {current} OF {total} · PERSONALIZATION'
	String eyebrowCuisines({required Object current, required Object total}) => 'STEP ${current} OF ${total} · PERSONALIZATION';

	/// en: 'STEP {current} OF {total} · PREFERENCES'
	String eyebrowDiet({required Object current, required Object total}) => 'STEP ${current} OF ${total} · PREFERENCES';

	/// en: 'STEP {current} OF {total} · YOUR RHYTHM'
	String eyebrowRhythm({required Object current, required Object total}) => 'STEP ${current} OF ${total} · YOUR RHYTHM';

	late final Translations$onboarding$welcome$en welcome = Translations$onboarding$welcome$en.internal(_root);
	late final Translations$onboarding$cuisines$en cuisines = Translations$onboarding$cuisines$en.internal(_root);
	late final Translations$onboarding$diet$en diet = Translations$onboarding$diet$en.internal(_root);
	late final Translations$onboarding$rhythm$en rhythm = Translations$onboarding$rhythm$en.internal(_root);
	late final Translations$onboarding$done$en done = Translations$onboarding$done$en.internal(_root);
	late final Translations$onboarding$footer$en footer = Translations$onboarding$footer$en.internal(_root);

	/// en: 'Could not save your preferences. Try again.'
	String get saveError => 'Could not save your preferences. Try again.';

	late final Translations$onboarding$time$en time = Translations$onboarding$time$en.internal(_root);
	late final Translations$onboarding$skill$en skill = Translations$onboarding$skill$en.internal(_root);
	late final Translations$onboarding$options$en options = Translations$onboarding$options$en.internal(_root);
}

// Path: discovery
class Translations$discovery$en {
	Translations$discovery$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'DISCOVER'
	String get eyebrow => 'DISCOVER';

	/// en: 'Find your next table.'
	String get title => 'Find your next table.';

	/// en: 'Search public recipes, then narrow by cuisine, time, meal and diet.'
	String get subtitle => 'Search public recipes, then narrow by cuisine, time, meal and diet.';

	/// en: 'Search recipes, ingredients, cuisines'
	String get searchHint => 'Search recipes, ingredients, cuisines';

	late final Translations$discovery$filters$en filters = Translations$discovery$filters$en.internal(_root);
	late final Translations$discovery$time$en time = Translations$discovery$time$en.internal(_root);
	late final Translations$discovery$feed$en feed = Translations$discovery$feed$en.internal(_root);
	late final Translations$discovery$pantry$en pantry = Translations$discovery$pantry$en.internal(_root);
}

// Path: home
class Translations$home$en {
	Translations$home$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Sign out'
	String get signOut => 'Sign out';

	late final Translations$home$language$en language = Translations$home$language$en.internal(_root);
	late final Translations$home$greetings$en greetings = Translations$home$greetings$en.internal(_root);

	/// en: 'What are we cooking today?'
	String get whatCooking => 'What are we cooking today?';

	late final Translations$home$pantry$en pantry = Translations$home$pantry$en.internal(_root);
	late final Translations$home$rails$en rails = Translations$home$rails$en.internal(_root);
	late final Translations$home$taste$en taste = Translations$home$taste$en.internal(_root);
	late final Translations$home$library$en library = Translations$home$library$en.internal(_root);
}

// Path: navigation
class Translations$navigation$en {
	Translations$navigation$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Home'
	String get home => 'Home';

	/// en: 'Discover'
	String get discover => 'Discover';

	/// en: 'AI Cook'
	String get aiCook => 'AI Cook';

	/// en: 'My Recipes'
	String get myRecipes => 'My Recipes';

	/// en: 'Profile'
	String get profile => 'Profile';
}

// Path: comingSoon
class Translations$comingSoon$en {
	Translations$comingSoon$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'PLANNED'
	String get badge => 'PLANNED';

	late final Translations$comingSoon$aiCook$en aiCook = Translations$comingSoon$aiCook$en.internal(_root);
	late final Translations$comingSoon$profile$en profile = Translations$comingSoon$profile$en.internal(_root);
}

// Path: recipes
class Translations$recipes$en {
	Translations$recipes$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	late final Translations$recipes$mealTypes$en mealTypes = Translations$recipes$mealTypes$en.internal(_root);
	late final Translations$recipes$difficulty$en difficulty = Translations$recipes$difficulty$en.internal(_root);
	late final Translations$recipes$library$en library = Translations$recipes$library$en.internal(_root);
	late final Translations$recipes$detail$en detail = Translations$recipes$detail$en.internal(_root);
	late final Translations$recipes$saveSheet$en saveSheet = Translations$recipes$saveSheet$en.internal(_root);
	late final Translations$recipes$collections$en collections = Translations$recipes$collections$en.internal(_root);
	late final Translations$recipes$editor$en editor = Translations$recipes$editor$en.internal(_root);
}

// Path: auth.login
class Translations$auth$login$en {
	Translations$auth$login$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Welcome back.'
	String get title => 'Welcome back.';

	/// en: 'Sign in and pick up where you left off in the kitchen.'
	String get subtitle => 'Sign in and pick up where you left off in the kitchen.';

	/// en: 'New to SeasonPal?'
	String get newHere => 'New to SeasonPal?';

	/// en: 'Create an account'
	String get createAccount => 'Create an account';

	/// en: 'Email'
	String get email => 'Email';

	/// en: 'Password'
	String get password => 'Password';

	/// en: 'Sign in'
	String get submit => 'Sign in';

	/// en: 'Enter your email.'
	String get emailRequired => 'Enter your email.';

	/// en: 'Enter a valid email address.'
	String get emailInvalid => 'Enter a valid email address.';

	/// en: 'Enter your password.'
	String get passwordRequired => 'Enter your password.';
}

// Path: auth.register
class Translations$auth$register$en {
	Translations$auth$register$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Pull up a chair.'
	String get title => 'Pull up a chair.';

	/// en: 'Create your account, then tell us how you like to cook so the suggestions fit.'
	String get subtitle => 'Create your account, then tell us how you like to cook so the suggestions fit.';

	/// en: 'Already cooking with us?'
	String get alreadyHere => 'Already cooking with us?';

	/// en: 'Sign in'
	String get signIn => 'Sign in';

	/// en: 'Name'
	String get name => 'Name';

	/// en: 'Optional — what should we call you?'
	String get nameHelper => 'Optional — what should we call you?';

	/// en: 'Keep your name to 80 characters.'
	String get nameTooLong => 'Keep your name to 80 characters.';

	/// en: 'Email'
	String get email => 'Email';

	/// en: 'Password'
	String get password => 'Password';

	/// en: '8+ characters with upper and lower case, a number, and a symbol.'
	String get passwordHelper => '8+ characters with upper and lower case, a number, and a symbol.';

	/// en: 'Create account'
	String get submit => 'Create account';

	/// en: 'Enter your email.'
	String get emailRequired => 'Enter your email.';

	/// en: 'Enter a valid email address.'
	String get emailInvalid => 'Enter a valid email address.';

	/// en: 'Choose a password.'
	String get passwordRequired => 'Choose a password.';

	/// en: 'Use at least 8 characters.'
	String get passwordTooShort => 'Use at least 8 characters.';

	/// en: 'Add upper and lower case, a number, and a symbol.'
	String get passwordTooWeak => 'Add upper and lower case, a number, and a symbol.';
}

// Path: auth.splash
class Translations$auth$splash$en {
	Translations$auth$splash$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Could not restore your session.'
	String get restoreFailed => 'Could not restore your session.';

	/// en: 'Setting the table…'
	String get loading => 'Setting the table…';
}

// Path: onboarding.welcome
class Translations$onboarding$welcome$en {
	Translations$onboarding$welcome$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Cook to the season.'
	String get title => 'Cook to the season.';

	/// en: 'One minute now, and every suggestion fits the kitchen you actually cook in.'
	String get body => 'One minute now, and every suggestion fits the kitchen you actually cook in.';

	/// en: 'YOUR COOKING ITINERARY'
	String get itineraryTitle => 'YOUR COOKING ITINERARY';

	/// en: 'The cuisines you love'
	String get cuisineTitle => 'The cuisines you love';

	/// en: 'Mediterranean, Levantine, Andean garden or Nordic smoke. Where your palate lives.'
	String get cuisineBody => 'Mediterranean, Levantine, Andean garden or Nordic smoke. Where your palate lives.';

	/// en: 'Diet and botanical interests'
	String get dietTitle => 'Diet and botanical interests';

	/// en: 'Plant preferences, gluten-free staples, fresh spice and what you cook for pleasure.'
	String get dietBody => 'Plant preferences, gluten-free staples, fresh spice and what you cook for pleasure.';

	/// en: 'Your pace at the stove'
	String get rhythmTitle => 'Your pace at the stove';

	/// en: 'Twenty-minute weeknights, or slow weekend braises in clay.'
	String get rhythmBody => 'Twenty-minute weeknights, or slow weekend braises in clay.';

	/// en: 'Start personalizing (1 min)'
	String get start => 'Start personalizing (1 min)';

	/// en: 'Skip for now'
	String get skip => 'Skip for now';
}

// Path: onboarding.cuisines
class Translations$onboarding$cuisines$en {
	Translations$onboarding$cuisines$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Pick your favourite kitchens.'
	String get title => 'Pick your favourite kitchens.';

	/// en: 'Choose at least three so your first feed is never one note.'
	String get body => 'Choose at least three so your first feed is never one note.';

	/// en: 'Seasonal curation'
	String get sectionTitle => 'Seasonal curation';

	/// en: 'Botanical inspiration and recipes with a sense of origin.'
	String get sectionBody => 'Botanical inspiration and recipes with a sense of origin.';

	/// en: 'No cuisines selected yet'
	String get counterNone => 'No cuisines selected yet';

	/// en: '1 cuisine selected'
	String get counterOne => '1 cuisine selected';

	/// en: '{count} cuisines selected'
	String counterOther({required Object count}) => '${count} cuisines selected';

	/// en: 'Choose 1 more'
	String get remainingOne => 'Choose 1 more';

	/// en: 'Choose {count} more'
	String remainingOther({required Object count}) => 'Choose ${count} more';

	/// en: 'All set'
	String get ready => 'All set';

	/// en: 'Continue to diet'
	String get next => 'Continue to diet';
}

// Path: onboarding.diet
class Translations$onboarding$diet$en {
	Translations$onboarding$diet$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Your pantry, your rules.'
	String get title => 'Your pantry, your rules.';

	/// en: 'We shape recipes around what you need and what you are curious about.'
	String get body => 'We shape recipes around what you need and what you are curious about.';

	/// en: 'Dietary restrictions'
	String get restrictionsTitle => 'Dietary restrictions';

	/// en: 'We never suggest an ingredient that breaks these.'
	String get restrictionsBody => 'We never suggest an ingredient that breaks these.';

	/// en: 'Botanical interests'
	String get interestsTitle => 'Botanical interests';

	/// en: 'Optional — the themes we should lean into.'
	String get interestsBody => 'Optional — the themes we should lean into.';

	/// en: 'Continue to your rhythm'
	String get next => 'Continue to your rhythm';
}

// Path: onboarding.rhythm
class Translations$onboarding$rhythm$en {
	Translations$onboarding$rhythm$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'How do you cook?'
	String get title => 'How do you cook?';

	/// en: 'We match technique and prep time to the habits you actually keep.'
	String get body => 'We match technique and prep time to the habits you actually keep.';

	/// en: 'Culinary skill level'
	String get skillTitle => 'Culinary skill level';

	/// en: 'Choose one'
	String get skillHint => 'Choose one';

	/// en: 'Time you usually cook'
	String get timeTitle => 'Time you usually cook';

	/// en: 'Pick your pace'
	String get timeHint => 'Pick your pace';

	/// en: 'Review summary'
	String get next => 'Review summary';
}

// Path: onboarding.done
class Translations$onboarding$done$en {
	Translations$onboarding$done$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'The stove is warm.'
	String get title => 'The stove is warm.';

	/// en: 'Your recipe box is shaped around this. Check it before we sync your pantry.'
	String get body => 'Your recipe box is shaped around this. Check it before we sync your pantry.';

	/// en: 'Selected cuisines ({count})'
	String cuisinesTitle({required Object count}) => 'Selected cuisines (${count})';

	/// en: 'Restrictions and passions'
	String get dietTitle => 'Restrictions and passions';

	/// en: 'Cooking rhythm'
	String get rhythmTitle => 'Cooking rhythm';

	/// en: 'DIET'
	String get dietLabel => 'DIET';

	/// en: 'INTERESTS'
	String get interestsLabel => 'INTERESTS';

	/// en: 'Edit'
	String get editSection => 'Edit';

	/// en: 'Open to anything'
	String get emptyCuisines => 'Open to anything';

	/// en: 'No restrictions'
	String get emptyDiet => 'No restrictions';

	/// en: 'None yet'
	String get emptyInterests => 'None yet';

	/// en: 'No set time'
	String get noTime => 'No set time';

	/// en: 'You can change any of this later in Settings.'
	String get footnote => 'You can change any of this later in Settings.';

	/// en: 'Continue to SeasonPal'
	String get finish => 'Continue to SeasonPal';
}

// Path: onboarding.footer
class Translations$onboarding$footer$en {
	Translations$onboarding$footer$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Begin'
	String get begin => 'Begin';

	/// en: 'Continue'
	String get next => 'Continue';

	/// en: 'Continue'
	String get finish => 'Continue';

	/// en: 'Saving...'
	String get saving => 'Saving...';
}

// Path: onboarding.time
class Translations$onboarding$time$en {
	Translations$onboarding$time$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: '1 hour'
	String get hour => '1 hour';

	/// en: 'min'
	String get minSuffix => 'min';

	late final Translations$onboarding$time$buckets$en buckets = Translations$onboarding$time$buckets$en.internal(_root);
}

// Path: onboarding.skill
class Translations$onboarding$skill$en {
	Translations$onboarding$skill$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	late final Translations$onboarding$skill$beginner$en beginner = Translations$onboarding$skill$beginner$en.internal(_root);
	late final Translations$onboarding$skill$intermediate$en intermediate = Translations$onboarding$skill$intermediate$en.internal(_root);
	late final Translations$onboarding$skill$advanced$en advanced = Translations$onboarding$skill$advanced$en.internal(_root);
}

// Path: onboarding.options
class Translations$onboarding$options$en {
	Translations$onboarding$options$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	late final Translations$onboarding$options$cuisines$en cuisines = Translations$onboarding$options$cuisines$en.internal(_root);
	late final Translations$onboarding$options$diets$en diets = Translations$onboarding$options$diets$en.internal(_root);
	late final Translations$onboarding$options$interests$en interests = Translations$onboarding$options$interests$en.internal(_root);
}

// Path: discovery.filters
class Translations$discovery$filters$en {
	Translations$discovery$filters$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Cuisine'
	String get cuisine => 'Cuisine';

	/// en: 'Meal'
	String get meal => 'Meal';

	/// en: 'Time'
	String get time => 'Time';

	/// en: 'Effort'
	String get difficulty => 'Effort';

	/// en: 'Diet'
	String get diet => 'Diet';

	/// en: 'Any'
	String get any => 'Any';

	/// en: 'Clear all'
	String get clearAll => 'Clear all';
}

// Path: discovery.time
class Translations$discovery$time$en {
	Translations$discovery$time$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Under {count} min'
	String under({required Object count}) => 'Under ${count} min';
}

// Path: discovery.feed
class Translations$discovery$feed$en {
	Translations$discovery$feed$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Setting the table.'
	String get loading => 'Setting the table.';

	/// en: 'We couldn't load the public feed.'
	String get loadError => 'We couldn\'t load the public feed.';

	/// en: '{count} recipes'
	String results({required Object count}) => '${count} recipes';

	/// en: '1 recipe'
	String get resultsOne => '1 recipe';

	/// en: 'Newest first'
	String get newestFirst => 'Newest first';

	/// en: 'Best match'
	String get bestMatch => 'Best match';

	/// en: 'Couldn't load more recipes.'
	String get loadMoreError => 'Couldn\'t load more recipes.';

	/// en: 'Nothing matches that table.'
	String get emptyTitle => 'Nothing matches that table.';

	/// en: 'Try a wider time, another cuisine, or a shorter search.'
	String get emptyBody => 'Try a wider time, another cuisine, or a shorter search.';

	/// en: 'The community table is still being set.'
	String get emptyCommunityTitle => 'The community table is still being set.';

	/// en: 'Publish a recipe and it can appear here for other cooks.'
	String get emptyCommunityBody => 'Publish a recipe and it can appear here for other cooks.';
}

// Path: discovery.pantry
class Translations$discovery$pantry$en {
	Translations$discovery$pantry$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'THE PANTRY'
	String get eyebrow => 'THE PANTRY';

	/// en: 'Cook from what you have.'
	String get title => 'Cook from what you have.';

	/// en: 'Add the ingredients on your shelf. We'll rank public recipes by how much of each one you already cover.'
	String get subtitle => 'Add the ingredients on your shelf. We\'ll rank public recipes by how much of each one you already cover.';

	/// en: 'Match public recipes against your shelf.'
	String get body => 'Match public recipes against your shelf.';

	/// en: 'Add an ingredient, or a few with commas'
	String get inputHint => 'Add an ingredient, or a few with commas';

	/// en: 'Add'
	String get add => 'Add';

	/// en: 'Clear pantry'
	String get clear => 'Clear pantry';

	/// en: 'Remove {name}'
	String remove({required Object name}) => 'Remove ${name}';

	/// en: 'Looking through the pantry.'
	String get loading => 'Looking through the pantry.';

	/// en: 'We couldn't match your pantry.'
	String get loadError => 'We couldn\'t match your pantry.';

	/// en: 'Couldn't load more matches.'
	String get loadMoreError => 'Couldn\'t load more matches.';

	/// en: 'Load more'
	String get loadMore => 'Load more';

	/// en: '{count} matches'
	String results({required Object count}) => '${count} matches';

	/// en: '1 match'
	String get resultsOne => '1 match';

	/// en: 'No matches yet.'
	String get emptyTitle => 'No matches yet.';

	/// en: 'Try fewer or more general ingredients, like "tomato" instead of "cherry tomatoes".'
	String get emptyBody => 'Try fewer or more general ingredients, like "tomato" instead of "cherry tomatoes".';

	/// en: 'Start with what you have.'
	String get emptyPromptTitle => 'Start with what you have.';

	/// en: 'Add a few ingredients above and we'll find public recipes that need the least extra shopping.'
	String get emptyPromptBody => 'Add a few ingredients above and we\'ll find public recipes that need the least extra shopping.';

	/// en: 'Can cook'
	String get canCook => 'Can cook';

	/// en: '{percent}% match'
	String match({required Object percent}) => '${percent}% match';

	/// en: 'You have: {names}'
	String have({required Object names}) => 'You have: ${names}';

	/// en: 'Missing: {names}'
	String missing({required Object names}) => 'Missing: ${names}';

	/// en: 'You have everything.'
	String get allIngredients => 'You have everything.';
}

// Path: home.language
class Translations$home$language$en {
	Translations$home$language$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Language'
	String get tooltip => 'Language';

	/// en: 'English'
	String get english => 'English';

	/// en: 'Español'
	String get spanish => 'Español';
}

// Path: home.greetings
class Translations$home$greetings$en {
	Translations$home$greetings$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Good morning'
	String get morning => 'Good morning';

	/// en: 'Good afternoon'
	String get afternoon => 'Good afternoon';

	/// en: 'Good evening'
	String get evening => 'Good evening';

	/// en: '{greeting}, {name}.'
	String line({required Object greeting, required Object name}) => '${greeting}, ${name}.';

	/// en: 'friend'
	String get friend => 'friend';
}

// Path: home.pantry
class Translations$home$pantry$en {
	Translations$home$pantry$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'FROM YOUR PANTRY'
	String get eyebrow => 'FROM YOUR PANTRY';

	/// en: 'What can I cook right now?'
	String get title => 'What can I cook right now?';

	/// en: 'Type what you have. We'll find public recipes that use the most of it.'
	String get body => 'Type what you have. We\'ll find public recipes that use the most of it.';

	/// en: 'Lemon, orzo, spinach'
	String get hint => 'Lemon, orzo, spinach';

	/// en: 'Find recipes'
	String get action => 'Find recipes';

	/// en: 'Add at least one ingredient first.'
	String get empty => 'Add at least one ingredient first.';
}

// Path: home.rails
class Translations$home$rails$en {
	Translations$home$rails$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Looking for what's cooking nearby.'
	String get loading => 'Looking for what\'s cooking nearby.';

	/// en: 'FOR YOUR TASTE'
	String get forYouEyebrow => 'FOR YOUR TASTE';

	/// en: 'Built from your cuisines and diets.'
	String get forYouTitle => 'Built from your cuisines and diets.';

	/// en: 'TRENDING THIS WEEK'
	String get trendingEyebrow => 'TRENDING THIS WEEK';

	/// en: 'What other cooks are saving.'
	String get trendingTitle => 'What other cooks are saving.';

	/// en: 'NEW FROM THE KITCHEN'
	String get newestEyebrow => 'NEW FROM THE KITCHEN';

	/// en: 'The latest public recipes.'
	String get newestTitle => 'The latest public recipes.';

	/// en: 'We couldn't load the community rails.'
	String get loadError => 'We couldn\'t load the community rails.';

	/// en: 'The community table is still being set.'
	String get emptyTitle => 'The community table is still being set.';

	/// en: 'Publish a recipe and it can appear here for other cooks.'
	String get emptyBody => 'Publish a recipe and it can appear here for other cooks.';

	/// en: 'Browse Discover'
	String get action => 'Browse Discover';
}

// Path: home.taste
class Translations$home$taste$en {
	Translations$home$taste$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'YOUR TASTE'
	String get eyebrow => 'YOUR TASTE';

	/// en: 'Reading your taste profile…'
	String get loading => 'Reading your taste profile…';

	/// en: 'We couldn't load your taste profile.'
	String get loadError => 'We couldn\'t load your taste profile.';

	/// en: 'No set time'
	String get noTime => 'No set time';

	/// en: 'Your kitchen is open to anything.'
	String get empty => 'Your kitchen is open to anything.';

	/// en: 'Your kitchen leans {cuisine}.'
	String one({required Object cuisine}) => 'Your kitchen leans ${cuisine}.';

	/// en: 'Your kitchen leans {first} and {second}.'
	String two({required Object first, required Object second}) => 'Your kitchen leans ${first} and ${second}.';

	/// en: 'Your kitchen leans {first}, {second}, and more.'
	String many({required Object first, required Object second}) => 'Your kitchen leans ${first}, ${second}, and more.';

	/// en: 'No dietary restrictions saved.'
	String get noRestrictions => 'No dietary restrictions saved.';

	/// en: 'Cooking around {restriction}.'
	String dietOne({required Object restriction}) => 'Cooking around ${restriction}.';

	/// en: 'Cooking around {leading} and {last}.'
	String dietMany({required Object leading, required Object last}) => 'Cooking around ${leading} and ${last}.';
}

// Path: home.library
class Translations$home$library$en {
	Translations$home$library$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'YOUR RECIPES'
	String get eyebrow => 'YOUR RECIPES';

	/// en: 'Your recipe library.'
	String get title => 'Your recipe library.';

	/// en: 'Saved dishes, collections, and your own recipes are ready when you are.'
	String get body => 'Saved dishes, collections, and your own recipes are ready when you are.';

	/// en: 'Open my recipes'
	String get action => 'Open my recipes';
}

// Path: comingSoon.aiCook
class Translations$comingSoon$aiCook$en {
	Translations$comingSoon$aiCook$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'AI COOK'
	String get eyebrow => 'AI COOK';

	/// en: 'A sous-chef, soon.'
	String get title => 'A sous-chef, soon.';

	/// en: 'Ask about substitutions, plan from what is in the pantry, and adapt recipes. Keys stay on the server, never in the app.'
	String get body => 'Ask about substitutions, plan from what is in the pantry, and adapt recipes. Keys stay on the server, never in the app.';
}

// Path: comingSoon.profile
class Translations$comingSoon$profile$en {
	Translations$comingSoon$profile$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'PROFILE'
	String get eyebrow => 'PROFILE';

	/// en: 'Your corner.'
	String get title => 'Your corner.';

	/// en: 'Preferences, published recipes, and account settings will live here. Sign-out and language stay on Home for now.'
	String get body => 'Preferences, published recipes, and account settings will live here. Sign-out and language stay on Home for now.';
}

// Path: recipes.mealTypes
class Translations$recipes$mealTypes$en {
	Translations$recipes$mealTypes$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Any time'
	String get unspecified => 'Any time';

	/// en: 'Breakfast'
	String get breakfast => 'Breakfast';

	/// en: 'Lunch'
	String get lunch => 'Lunch';

	/// en: 'Dinner'
	String get dinner => 'Dinner';

	/// en: 'Snack'
	String get snack => 'Snack';

	/// en: 'Dessert'
	String get dessert => 'Dessert';

	/// en: 'Drink'
	String get drink => 'Drink';
}

// Path: recipes.difficulty
class Translations$recipes$difficulty$en {
	Translations$recipes$difficulty$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Easy'
	String get easy => 'Easy';

	/// en: 'Medium'
	String get medium => 'Medium';

	/// en: 'Hard'
	String get hard => 'Hard';
}

// Path: recipes.library
class Translations$recipes$library$en {
	Translations$recipes$library$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'YOUR KITCHEN'
	String get eyebrow => 'YOUR KITCHEN';

	/// en: 'My recipes'
	String get title => 'My recipes';

	/// en: 'What you have written and what you have saved, in one place.'
	String get subtitle => 'What you have written and what you have saved, in one place.';

	/// en: 'New recipe'
	String get newRecipe => 'New recipe';

	/// en: 'Collections'
	String get collections => 'Collections';

	/// en: 'Mine'
	String get mine => 'Mine';

	/// en: 'Saved'
	String get saved => 'Saved';

	/// en: 'Opening your library…'
	String get loading => 'Opening your library…';

	/// en: 'We couldn't load your recipes.'
	String get loadError => 'We couldn\'t load your recipes.';

	/// en: 'Couldn't load more recipes.'
	String get loadMoreError => 'Couldn\'t load more recipes.';

	/// en: 'Your first recipe starts here.'
	String get emptyOwnTitle => 'Your first recipe starts here.';

	/// en: 'Write down a dish you already cook. Photos and steps can come as you go.'
	String get emptyOwnBody => 'Write down a dish you already cook. Photos and steps can come as you go.';

	/// en: 'Nothing saved yet.'
	String get emptySavedTitle => 'Nothing saved yet.';

	/// en: 'Tap Save on any recipe and it lands here, ready for another night.'
	String get emptySavedBody => 'Tap Save on any recipe and it lands here, ready for another night.';

	/// en: 'DRAFT'
	String get draft => 'DRAFT';

	/// en: 'AI'
	String get ai => 'AI';

	/// en: '{count} min'
	String minutes({required Object count}) => '${count} min';

	/// en: '{count}s'
	String seconds({required Object count}) => '${count}s';

	/// en: 'Serves {count}'
	String servings({required Object count}) => 'Serves ${count}';

	/// en: 'Serves 1'
	String get servingsOne => 'Serves 1';
}

// Path: recipes.detail
class Translations$recipes$detail$en {
	Translations$recipes$detail$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'By {name}'
	String by({required Object name}) => 'By ${name}';

	/// en: 'Ingredients'
	String get ingredients => 'Ingredients';

	/// en: 'Method'
	String get method => 'Method';

	/// en: 'Photos & video'
	String get media => 'Photos & video';

	/// en: 'Tags'
	String get tags => 'Tags';

	/// en: 'Save recipe'
	String get save => 'Save recipe';

	/// en: 'Saved'
	String get saved => 'Saved';

	/// en: 'Saved to your library.'
	String get savedMessage => 'Saved to your library.';

	/// en: 'Removed from your library.'
	String get unsavedMessage => 'Removed from your library.';

	/// en: 'No ingredients listed yet.'
	String get noIngredients => 'No ingredients listed yet.';

	/// en: 'No steps written yet.'
	String get noSteps => 'No steps written yet.';

	/// en: 'Made with AI — read it through before you cook.'
	String get aiNote => 'Made with AI — read it through before you cook.';

	/// en: 'Video'
	String get video => 'Video';

	/// en: 'PUBLIC'
	String get publishedBadge => 'PUBLIC';

	/// en: 'Edit recipe'
	String get edit => 'Edit recipe';

	/// en: 'Publish recipe'
	String get publish => 'Publish recipe';

	/// en: 'Make private'
	String get unpublish => 'Make private';

	/// en: 'Delete recipe'
	String get delete => 'Delete recipe';

	/// en: 'Recipe actions'
	String get more => 'Recipe actions';

	/// en: 'Delete this recipe?'
	String get deleteTitle => 'Delete this recipe?';

	/// en: 'It leaves your library and any collections. This can't be undone.'
	String get deleteBody => 'It leaves your library and any collections. This can\'t be undone.';

	/// en: 'We couldn't load this recipe.'
	String get loadError => 'We couldn\'t load this recipe.';

	/// en: 'This recipe isn't here.'
	String get notFoundTitle => 'This recipe isn\'t here.';

	/// en: 'It may have been deleted or kept private.'
	String get notFoundBody => 'It may have been deleted or kept private.';

	/// en: 'That didn't work. Try again.'
	String get actionError => 'That didn\'t work. Try again.';

	/// en: 'Recipe published.'
	String get published => 'Recipe published.';

	/// en: 'Recipe is private again.'
	String get unpublished => 'Recipe is private again.';
}

// Path: recipes.saveSheet
class Translations$recipes$saveSheet$en {
	Translations$recipes$saveSheet$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Save to a collection'
	String get title => 'Save to a collection';

	/// en: 'Saving always adds the recipe to Favorites.'
	String get favoritesBody => 'Saving always adds the recipe to Favorites.';

	/// en: 'Save to favorites'
	String get favorites => 'Save to favorites';

	/// en: 'Saved to your library.'
	String get savedStatus => 'Saved to your library.';

	/// en: 'Remove'
	String get unsave => 'Remove';

	/// en: 'ADD TO A COLLECTION'
	String get collections => 'ADD TO A COLLECTION';

	/// en: 'We couldn't load your collections.'
	String get collectionsError => 'We couldn\'t load your collections.';

	/// en: 'No collections yet. Create one below.'
	String get noCollections => 'No collections yet. Create one below.';

	/// en: 'New collection'
	String get newCollection => 'New collection';

	/// en: 'Name the collection'
	String get createTitle => 'Name the collection';

	/// en: 'Collection name'
	String get nameLabel => 'Collection name';

	/// en: 'Weeknight dinners, Sunday baking…'
	String get nameHint => 'Weeknight dinners, Sunday baking…';

	/// en: 'Give the collection a name.'
	String get nameRequired => 'Give the collection a name.';

	/// en: 'Create'
	String get create => 'Create';

	/// en: 'Could not create the collection. Try again.'
	String get createError => 'Could not create the collection. Try again.';

	/// en: 'Could not save the recipe. Try again.'
	String get saveError => 'Could not save the recipe. Try again.';
}

// Path: recipes.collections
class Translations$recipes$collections$en {
	Translations$recipes$collections$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'YOUR KITCHEN'
	String get eyebrow => 'YOUR KITCHEN';

	/// en: 'Collections'
	String get title => 'Collections';

	/// en: 'Group recipes for a weeknight, a season, or a table.'
	String get subtitle => 'Group recipes for a weeknight, a season, or a table.';

	/// en: 'New collection'
	String get newCollection => 'New collection';

	/// en: 'We couldn't load your collections.'
	String get loadError => 'We couldn\'t load your collections.';

	/// en: '{count} recipes'
	String count({required Object count}) => '${count} recipes';

	/// en: '1 recipe'
	String get countOne => '1 recipe';

	/// en: 'Favorites'
	String get favorites => 'Favorites';

	/// en: 'No collections yet.'
	String get emptyTitle => 'No collections yet.';

	/// en: 'Group recipes for a weeknight, a season, or a dinner party.'
	String get emptyBody => 'Group recipes for a weeknight, a season, or a dinner party.';

	/// en: 'This collection is empty.'
	String get emptyCollection => 'This collection is empty.';

	/// en: 'Save a recipe to this collection from its page.'
	String get emptyCollectionBody => 'Save a recipe to this collection from its page.';

	/// en: 'Remove'
	String get remove => 'Remove';

	/// en: 'Remove this recipe?'
	String get removeTitle => 'Remove this recipe?';

	/// en: 'It stays in your saved library.'
	String get removeBody => 'It stays in your saved library.';

	/// en: 'Could not remove the recipe. Try again.'
	String get removeError => 'Could not remove the recipe. Try again.';

	/// en: 'Delete collection'
	String get delete => 'Delete collection';

	/// en: 'Delete this collection?'
	String get deleteTitle => 'Delete this collection?';

	/// en: 'The recipes stay in your library; only the collection goes away.'
	String get deleteBody => 'The recipes stay in your library; only the collection goes away.';

	/// en: 'Could not delete the collection. Try again.'
	String get deleteError => 'Could not delete the collection. Try again.';
}

// Path: recipes.editor
class Translations$recipes$editor$en {
	Translations$recipes$editor$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'A NEW DISH'
	String get newEyebrow => 'A NEW DISH';

	/// en: 'Write it down.'
	String get newTitle => 'Write it down.';

	/// en: 'Seven short sections. Save a draft at any point — only the name is required.'
	String get newBody => 'Seven short sections. Save a draft at any point — only the name is required.';

	/// en: 'EDITING'
	String get editEyebrow => 'EDITING';

	/// en: 'Refine the dish.'
	String get editTitle => 'Refine the dish.';

	/// en: 'Change what you like. Publication stays as it was unless you publish after saving.'
	String get editBody => 'Change what you like. Publication stays as it was unless you publish after saving.';

	/// en: 'Save recipe'
	String get save => 'Save recipe';

	/// en: 'Saving…'
	String get saving => 'Saving…';

	/// en: 'Save & publish'
	String get saveAndPublish => 'Save & publish';

	/// en: 'Could not save the recipe. Try again.'
	String get saveError => 'Could not save the recipe. Try again.';

	/// en: 'We couldn't load this recipe for editing.'
	String get loadError => 'We couldn\'t load this recipe for editing.';

	late final Translations$recipes$editor$basics$en basics = Translations$recipes$editor$basics$en.internal(_root);
	late final Translations$recipes$editor$plate$en plate = Translations$recipes$editor$plate$en.internal(_root);
	late final Translations$recipes$editor$time$en time = Translations$recipes$editor$time$en.internal(_root);
	late final Translations$recipes$editor$photos$en photos = Translations$recipes$editor$photos$en.internal(_root);
	late final Translations$recipes$editor$ingredients$en ingredients = Translations$recipes$editor$ingredients$en.internal(_root);
	late final Translations$recipes$editor$steps$en steps = Translations$recipes$editor$steps$en.internal(_root);
	late final Translations$recipes$editor$tags$en tags = Translations$recipes$editor$tags$en.internal(_root);
	late final Translations$recipes$editor$publish$en publish = Translations$recipes$editor$publish$en.internal(_root);
}

// Path: onboarding.time.buckets
class Translations$onboarding$time$buckets$en {
	Translations$onboarding$time$buckets$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	late final Translations$onboarding$time$buckets$quick$en quick = Translations$onboarding$time$buckets$quick$en.internal(_root);
	late final Translations$onboarding$time$buckets$balanced$en balanced = Translations$onboarding$time$buckets$balanced$en.internal(_root);
	late final Translations$onboarding$time$buckets$long$en long = Translations$onboarding$time$buckets$long$en.internal(_root);
	late final Translations$onboarding$time$buckets$variable$en variable = Translations$onboarding$time$buckets$variable$en.internal(_root);
}

// Path: onboarding.skill.beginner
class Translations$onboarding$skill$beginner$en {
	Translations$onboarding$skill$beginner$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Enthusiastic beginner'
	String get label => 'Enthusiastic beginner';

	/// en: 'Simple techniques, detailed steps, ingredients to hand.'
	String get description => 'Simple techniques, detailed steps, ingredients to hand.';
}

// Path: onboarding.skill.intermediate
class Translations$onboarding$skill$intermediate$en {
	Translations$onboarding$skill$intermediate$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Confident home cook'
	String get label => 'Confident home cook';

	/// en: 'Knife basics, pan sauces and heat control.'
	String get description => 'Knife basics, pan sauces and heat control.';
}

// Path: onboarding.skill.advanced
class Translations$onboarding$skill$advanced$en {
	Translations$onboarding$skill$advanced$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Artisan cook'
	String get label => 'Artisan cook';

	/// en: 'Fermentation, layered baking, plated cooking.'
	String get description => 'Fermentation, layered baking, plated cooking.';
}

// Path: onboarding.options.cuisines
class Translations$onboarding$options$cuisines$en {
	Translations$onboarding$options$cuisines$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	late final Translations$onboarding$options$cuisines$italian$en italian = Translations$onboarding$options$cuisines$italian$en.internal(_root);
	late final Translations$onboarding$options$cuisines$mediterranean$en mediterranean = Translations$onboarding$options$cuisines$mediterranean$en.internal(_root);
	late final Translations$onboarding$options$cuisines$middleEastern$en middleEastern = Translations$onboarding$options$cuisines$middleEastern$en.internal(_root);
	late final Translations$onboarding$options$cuisines$mexican$en mexican = Translations$onboarding$options$cuisines$mexican$en.internal(_root);
	late final Translations$onboarding$options$cuisines$indian$en indian = Translations$onboarding$options$cuisines$indian$en.internal(_root);
	late final Translations$onboarding$options$cuisines$japanese$en japanese = Translations$onboarding$options$cuisines$japanese$en.internal(_root);
	late final Translations$onboarding$options$cuisines$korean$en korean = Translations$onboarding$options$cuisines$korean$en.internal(_root);
	late final Translations$onboarding$options$cuisines$thai$en thai = Translations$onboarding$options$cuisines$thai$en.internal(_root);
	late final Translations$onboarding$options$cuisines$chinese$en chinese = Translations$onboarding$options$cuisines$chinese$en.internal(_root);
	late final Translations$onboarding$options$cuisines$french$en french = Translations$onboarding$options$cuisines$french$en.internal(_root);
	late final Translations$onboarding$options$cuisines$spanish$en spanish = Translations$onboarding$options$cuisines$spanish$en.internal(_root);
	late final Translations$onboarding$options$cuisines$greek$en greek = Translations$onboarding$options$cuisines$greek$en.internal(_root);
	late final Translations$onboarding$options$cuisines$turkish$en turkish = Translations$onboarding$options$cuisines$turkish$en.internal(_root);
	late final Translations$onboarding$options$cuisines$vietnamese$en vietnamese = Translations$onboarding$options$cuisines$vietnamese$en.internal(_root);
	late final Translations$onboarding$options$cuisines$american$en american = Translations$onboarding$options$cuisines$american$en.internal(_root);
	late final Translations$onboarding$options$cuisines$northAfrican$en northAfrican = Translations$onboarding$options$cuisines$northAfrican$en.internal(_root);
	late final Translations$onboarding$options$cuisines$latinAmerican$en latinAmerican = Translations$onboarding$options$cuisines$latinAmerican$en.internal(_root);
	late final Translations$onboarding$options$cuisines$nordic$en nordic = Translations$onboarding$options$cuisines$nordic$en.internal(_root);
	late final Translations$onboarding$options$cuisines$caribbean$en caribbean = Translations$onboarding$options$cuisines$caribbean$en.internal(_root);
	late final Translations$onboarding$options$cuisines$african$en african = Translations$onboarding$options$cuisines$african$en.internal(_root);
}

// Path: onboarding.options.diets
class Translations$onboarding$options$diets$en {
	Translations$onboarding$options$diets$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	late final Translations$onboarding$options$diets$vegetarian$en vegetarian = Translations$onboarding$options$diets$vegetarian$en.internal(_root);
	late final Translations$onboarding$options$diets$vegan$en vegan = Translations$onboarding$options$diets$vegan$en.internal(_root);
	late final Translations$onboarding$options$diets$glutenFree$en glutenFree = Translations$onboarding$options$diets$glutenFree$en.internal(_root);
	late final Translations$onboarding$options$diets$dairyFree$en dairyFree = Translations$onboarding$options$diets$dairyFree$en.internal(_root);
	late final Translations$onboarding$options$diets$nutFree$en nutFree = Translations$onboarding$options$diets$nutFree$en.internal(_root);
	late final Translations$onboarding$options$diets$halal$en halal = Translations$onboarding$options$diets$halal$en.internal(_root);
	late final Translations$onboarding$options$diets$kosher$en kosher = Translations$onboarding$options$diets$kosher$en.internal(_root);
	late final Translations$onboarding$options$diets$pescatarian$en pescatarian = Translations$onboarding$options$diets$pescatarian$en.internal(_root);
	late final Translations$onboarding$options$diets$lowCarb$en lowCarb = Translations$onboarding$options$diets$lowCarb$en.internal(_root);
	late final Translations$onboarding$options$diets$lowSodium$en lowSodium = Translations$onboarding$options$diets$lowSodium$en.internal(_root);
}

// Path: onboarding.options.interests
class Translations$onboarding$options$interests$en {
	Translations$onboarding$options$interests$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Weeknight dinners'
	String get weeknightDinners => 'Weeknight dinners';

	/// en: 'Meal prep'
	String get mealPrep => 'Meal prep';

	/// en: 'Baking'
	String get baking => 'Baking';

	/// en: 'Grilling'
	String get grilling => 'Grilling';

	/// en: 'Slow cooking'
	String get slowCooking => 'Slow cooking';

	/// en: 'Fermentation'
	String get fermentation => 'Fermentation';

	/// en: 'Plant-forward'
	String get plantForward => 'Plant-forward';

	/// en: 'Comfort food'
	String get comfortFood => 'Comfort food';

	/// en: 'Entertaining'
	String get entertaining => 'Entertaining';

	/// en: 'Budget cooking'
	String get budgetCooking => 'Budget cooking';

	/// en: 'Cooking with kids'
	String get cookingWithKids => 'Cooking with kids';

	/// en: 'Spices & heat'
	String get spicesAndHeat => 'Spices & heat';
}

// Path: recipes.editor.basics
class Translations$recipes$editor$basics$en {
	Translations$recipes$editor$basics$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'BASICS'
	String get eyebrow => 'BASICS';

	/// en: 'The basics'
	String get title => 'The basics';

	/// en: 'Recipe name'
	String get name => 'Recipe name';

	/// en: 'Lemon and thyme roast chicken'
	String get nameHint => 'Lemon and thyme roast chicken';

	/// en: 'Give the recipe a name.'
	String get nameRequired => 'Give the recipe a name.';

	/// en: 'Description'
	String get description => 'Description';

	/// en: 'What it is, and why you make it.'
	String get descriptionHint => 'What it is, and why you make it.';
}

// Path: recipes.editor.plate
class Translations$recipes$editor$plate$en {
	Translations$recipes$editor$plate$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'THE PLATE'
	String get eyebrow => 'THE PLATE';

	/// en: 'How it eats'
	String get title => 'How it eats';

	/// en: 'Cuisine'
	String get cuisine => 'Cuisine';

	/// en: 'Italian, Thai, Levantine…'
	String get cuisineHint => 'Italian, Thai, Levantine…';

	/// en: 'Meal'
	String get meal => 'Meal';
}

// Path: recipes.editor.time
class Translations$recipes$editor$time$en {
	Translations$recipes$editor$time$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'TIME'
	String get eyebrow => 'TIME';

	/// en: 'Time at the stove'
	String get title => 'Time at the stove';

	/// en: 'Prep (min)'
	String get prep => 'Prep (min)';

	/// en: 'Cook (min)'
	String get cook => 'Cook (min)';

	/// en: 'Servings'
	String get servings => 'Servings';

	/// en: 'Difficulty'
	String get difficulty => 'Difficulty';

	/// en: 'Use whole minutes between 0 and 1440.'
	String get invalid => 'Use whole minutes between 0 and 1440.';
}

// Path: recipes.editor.photos
class Translations$recipes$editor$photos$en {
	Translations$recipes$editor$photos$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'PHOTOS'
	String get eyebrow => 'PHOTOS';

	/// en: 'Show the dish'
	String get title => 'Show the dish';

	/// en: 'Choose cover'
	String get chooseCover => 'Choose cover';

	/// en: 'Change cover'
	String get changeCover => 'Change cover';

	/// en: 'Remove cover'
	String get removeCover => 'Remove cover';

	/// en: 'More photos and video'
	String get more => 'More photos and video';

	/// en: 'Add photo'
	String get addPhoto => 'Add photo';

	/// en: 'Add video'
	String get addVideo => 'Add video';

	/// en: 'Uploading…'
	String get uploading => 'Uploading…';

	/// en: 'Upload failed. Try again.'
	String get uploadError => 'Upload failed. Try again.';

	/// en: 'That file is too large. Photos max out at 10 MB, video at 24 MB.'
	String get tooLarge => 'That file is too large. Photos max out at 10 MB, video at 24 MB.';

	/// en: 'A recipe can hold up to 20 photos and videos.'
	String get tooMany => 'A recipe can hold up to 20 photos and videos.';

	/// en: 'Choose a JPEG, PNG, WebP, GIF, MP4 or MOV file.'
	String get unsupported => 'Choose a JPEG, PNG, WebP, GIF, MP4 or MOV file.';
}

// Path: recipes.editor.ingredients
class Translations$recipes$editor$ingredients$en {
	Translations$recipes$editor$ingredients$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'INGREDIENTS'
	String get eyebrow => 'INGREDIENTS';

	/// en: 'What goes in'
	String get title => 'What goes in';

	/// en: 'Qty'
	String get quantity => 'Qty';

	/// en: 'Unit'
	String get unit => 'Unit';

	/// en: 'Ingredient'
	String get name => 'Ingredient';

	/// en: 'Note (optional)'
	String get note => 'Note (optional)';

	/// en: 'Add ingredient'
	String get add => 'Add ingredient';

	/// en: 'Remove ingredient'
	String get remove => 'Remove ingredient';

	/// en: 'Move up'
	String get moveUp => 'Move up';

	/// en: 'Move down'
	String get moveDown => 'Move down';

	/// en: 'Name every ingredient you fill in.'
	String get nameRequired => 'Name every ingredient you fill in.';

	/// en: 'Quantities need to be zero or more.'
	String get quantityInvalid => 'Quantities need to be zero or more.';
}

// Path: recipes.editor.steps
class Translations$recipes$editor$steps$en {
	Translations$recipes$editor$steps$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'METHOD'
	String get eyebrow => 'METHOD';

	/// en: 'How it cooks'
	String get title => 'How it cooks';

	/// en: 'Step'
	String get instruction => 'Step';

	/// en: 'Tip (optional)'
	String get tip => 'Tip (optional)';

	/// en: 'Timer (min, optional)'
	String get timer => 'Timer (min, optional)';

	/// en: 'Add step'
	String get add => 'Add step';

	/// en: 'Remove step'
	String get remove => 'Remove step';

	/// en: 'Write every step you fill in.'
	String get instructionRequired => 'Write every step you fill in.';

	/// en: 'Timers need whole minutes between 1 and 1440.'
	String get timerInvalid => 'Timers need whole minutes between 1 and 1440.';
}

// Path: recipes.editor.tags
class Translations$recipes$editor$tags$en {
	Translations$recipes$editor$tags$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'DETAILS'
	String get eyebrow => 'DETAILS';

	/// en: 'A little more detail'
	String get title => 'A little more detail';

	/// en: 'Tags help you find the recipe later. Dietary tags are shown to anyone who can see it.'
	String get body => 'Tags help you find the recipe later. Dietary tags are shown to anyone who can see it.';

	/// en: 'Tags'
	String get tags => 'Tags';

	/// en: 'Weeknight, one-pan…'
	String get tagsHint => 'Weeknight, one-pan…';

	/// en: 'Dietary tags'
	String get dietaryTags => 'Dietary tags';

	/// en: 'Vegetarian, gluten-free…'
	String get dietaryHint => 'Vegetarian, gluten-free…';

	/// en: 'Add tag'
	String get add => 'Add tag';
}

// Path: recipes.editor.publish
class Translations$recipes$editor$publish$en {
	Translations$recipes$editor$publish$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Publish after saving'
	String get label => 'Publish after saving';

	/// en: 'Published recipes can appear in Discover. You can make it private again at any time.'
	String get body => 'Published recipes can appear in Discover. You can make it private again at any time.';

	/// en: 'Add at least one ingredient and one step before publishing.'
	String get incomplete => 'Add at least one ingredient and one step before publishing.';

	/// en: 'The recipe was saved, but publishing failed. Try again from the recipe page.'
	String get failed => 'The recipe was saved, but publishing failed. Try again from the recipe page.';
}

// Path: onboarding.time.buckets.quick
class Translations$onboarding$time$buckets$quick$en {
	Translations$onboarding$time$buckets$quick$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: '15–20 min'
	String get label => '15–20 min';

	/// en: 'An express weeknight'
	String get description => 'An express weeknight';
}

// Path: onboarding.time.buckets.balanced
class Translations$onboarding$time$buckets$balanced$en {
	Translations$onboarding$time$buckets$balanced$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: '30–45 min'
	String get label => '30–45 min';

	/// en: 'Room to build a proper plate'
	String get description => 'Room to build a proper plate';
}

// Path: onboarding.time.buckets.long
class Translations$onboarding$time$buckets$long$en {
	Translations$onboarding$time$buckets$long$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: '60+ min'
	String get label => '60+ min';

	/// en: 'Braises and weekend rituals'
	String get description => 'Braises and weekend rituals';
}

// Path: onboarding.time.buckets.variable
class Translations$onboarding$time$buckets$variable$en {
	Translations$onboarding$time$buckets$variable$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'It varies'
	String get label => 'It varies';

	/// en: 'I fit it to the day'
	String get description => 'I fit it to the day';
}

// Path: onboarding.options.cuisines.italian
class Translations$onboarding$options$cuisines$italian$en {
	Translations$onboarding$options$cuisines$italian$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Rustic Italian & pasta'
	String get label => 'Rustic Italian & pasta';

	/// en: 'Ancient wheat, ragu, aged cheese'
	String get description => 'Ancient wheat, ragu, aged cheese';

	/// en: 'Italian'
	String get short => 'Italian';
}

// Path: onboarding.options.cuisines.mediterranean
class Translations$onboarding$options$cuisines$mediterranean$en {
	Translations$onboarding$options$cuisines$mediterranean$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Classic Mediterranean'
	String get label => 'Classic Mediterranean';

	/// en: 'Live oils, herbs, fish from the sea'
	String get description => 'Live oils, herbs, fish from the sea';

	/// en: 'Mediterranean'
	String get short => 'Mediterranean';
}

// Path: onboarding.options.cuisines.middleEastern
class Translations$onboarding$options$cuisines$middleEastern$en {
	Translations$onboarding$options$cuisines$middleEastern$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Levantine & Middle Eastern'
	String get label => 'Levantine & Middle Eastern';

	/// en: 'Za'atar, tahini, pomegranate'
	String get description => 'Za\'atar, tahini, pomegranate';

	/// en: 'Middle Eastern'
	String get short => 'Middle Eastern';
}

// Path: onboarding.options.cuisines.mexican
class Translations$onboarding$options$cuisines$mexican$en {
	Translations$onboarding$options$cuisines$mexican$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Oaxacan & traditional'
	String get label => 'Oaxacan & traditional';

	/// en: 'Black mole, native corn'
	String get description => 'Black mole, native corn';

	/// en: 'Mexican'
	String get short => 'Mexican';
}

// Path: onboarding.options.cuisines.indian
class Translations$onboarding$options$cuisines$indian$en {
	Translations$onboarding$options$cuisines$indian$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Spiced Indian'
	String get label => 'Spiced Indian';

	/// en: 'Toasted masalas, pulses, ghee'
	String get description => 'Toasted masalas, pulses, ghee';

	/// en: 'Indian'
	String get short => 'Indian';
}

// Path: onboarding.options.cuisines.japanese
class Translations$onboarding$options$cuisines$japanese$en {
	Translations$onboarding$options$cuisines$japanese$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Japanese & craft ramen'
	String get label => 'Japanese & craft ramen';

	/// en: 'Dashi broths, umami, ferments'
	String get description => 'Dashi broths, umami, ferments';

	/// en: 'Japanese'
	String get short => 'Japanese';
}

// Path: onboarding.options.cuisines.korean
class Translations$onboarding$options$cuisines$korean$en {
	Translations$onboarding$options$cuisines$korean$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Korean & kimchi'
	String get label => 'Korean & kimchi';

	/// en: 'Gochujang, banchan, marinades'
	String get description => 'Gochujang, banchan, marinades';

	/// en: 'Korean'
	String get short => 'Korean';
}

// Path: onboarding.options.cuisines.thai
class Translations$onboarding$options$cuisines$thai$en {
	Translations$onboarding$options$cuisines$thai$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Aromatic Thai'
	String get label => 'Aromatic Thai';

	/// en: 'Lemongrass, kaffir lime, coconut'
	String get description => 'Lemongrass, kaffir lime, coconut';

	/// en: 'Thai'
	String get short => 'Thai';
}

// Path: onboarding.options.cuisines.chinese
class Translations$onboarding$options$cuisines$chinese$en {
	Translations$onboarding$options$cuisines$chinese$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Wok & dim sum'
	String get label => 'Wok & dim sum';

	/// en: 'High heat, steam, soy and vinegar'
	String get description => 'High heat, steam, soy and vinegar';

	/// en: 'Chinese'
	String get short => 'Chinese';
}

// Path: onboarding.options.cuisines.french
class Translations$onboarding$options$cuisines$french$en {
	Translations$onboarding$options$cuisines$french$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'French bistro'
	String get label => 'French bistro';

	/// en: 'Brown butter, long stocks, wine'
	String get description => 'Brown butter, long stocks, wine';

	/// en: 'French'
	String get short => 'French';
}

// Path: onboarding.options.cuisines.spanish
class Translations$onboarding$options$cuisines$spanish$en {
	Translations$onboarding$options$cuisines$spanish$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Iberian & tapas'
	String get label => 'Iberian & tapas';

	/// en: 'Paprika, acorn-fed pork, tinned fish'
	String get description => 'Paprika, acorn-fed pork, tinned fish';

	/// en: 'Spanish'
	String get short => 'Spanish';
}

// Path: onboarding.options.cuisines.greek
class Translations$onboarding$options$cuisines$greek$en {
	Translations$onboarding$options$cuisines$greek$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Aegean Greek'
	String get label => 'Aegean Greek';

	/// en: 'Pastured feta, wild oregano'
	String get description => 'Pastured feta, wild oregano';

	/// en: 'Greek'
	String get short => 'Greek';
}

// Path: onboarding.options.cuisines.turkish
class Translations$onboarding$options$cuisines$turkish$en {
	Translations$onboarding$options$cuisines$turkish$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Anatolian & charcoal'
	String get label => 'Anatolian & charcoal';

	/// en: 'Bulgur, smoked aubergine, yoghurt'
	String get description => 'Bulgur, smoked aubergine, yoghurt';

	/// en: 'Turkish'
	String get short => 'Turkish';
}

// Path: onboarding.options.cuisines.vietnamese
class Translations$onboarding$options$cuisines$vietnamese$en {
	Translations$onboarding$options$cuisines$vietnamese$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Fresh Vietnamese'
	String get label => 'Fresh Vietnamese';

	/// en: 'Fine herbs, rice rolls, pho'
	String get description => 'Fine herbs, rice rolls, pho';

	/// en: 'Vietnamese'
	String get short => 'Vietnamese';
}

// Path: onboarding.options.cuisines.american
class Translations$onboarding$options$cuisines$american$en {
	Translations$onboarding$options$cuisines$american$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Californian farm-to-table'
	String get label => 'Californian farm-to-table';

	/// en: 'Local harvest, clean plates'
	String get description => 'Local harvest, clean plates';

	/// en: 'American'
	String get short => 'American';
}

// Path: onboarding.options.cuisines.northAfrican
class Translations$onboarding$options$cuisines$northAfrican$en {
	Translations$onboarding$options$cuisines$northAfrican$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Moroccan & tagines'
	String get label => 'Moroccan & tagines';

	/// en: 'Ras el hanout, preserved lemon'
	String get description => 'Ras el hanout, preserved lemon';

	/// en: 'North African'
	String get short => 'North African';
}

// Path: onboarding.options.cuisines.latinAmerican
class Translations$onboarding$options$cuisines$latinAmerican$en {
	Translations$onboarding$options$cuisines$latinAmerican$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Peruvian & Nikkei'
	String get label => 'Peruvian & Nikkei';

	/// en: 'Native chillies, ceviche, rocoto'
	String get description => 'Native chillies, ceviche, rocoto';

	/// en: 'Latin American'
	String get short => 'Latin American';
}

// Path: onboarding.options.cuisines.nordic
class Translations$onboarding$options$cuisines$nordic$en {
	Translations$onboarding$options$cuisines$nordic$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Nordic ferments'
	String get label => 'Nordic ferments';

	/// en: 'Pickles, rye, smoke'
	String get description => 'Pickles, rye, smoke';

	/// en: 'Nordic'
	String get short => 'Nordic';
}

// Path: onboarding.options.cuisines.caribbean
class Translations$onboarding$options$cuisines$caribbean$en {
	Translations$onboarding$options$cuisines$caribbean$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Caribbean islands'
	String get label => 'Caribbean islands';

	/// en: 'Peppers, coconut, citrus'
	String get description => 'Peppers, coconut, citrus';

	/// en: 'Caribbean'
	String get short => 'Caribbean';
}

// Path: onboarding.options.cuisines.african
class Translations$onboarding$options$cuisines$african$en {
	Translations$onboarding$options$cuisines$african$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Slow-fire African'
	String get label => 'Slow-fire African';

	/// en: 'One-pot stews, roots, spice'
	String get description => 'One-pot stews, roots, spice';

	/// en: 'African'
	String get short => 'African';
}

// Path: onboarding.options.diets.vegetarian
class Translations$onboarding$options$diets$vegetarian$en {
	Translations$onboarding$options$diets$vegetarian$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Vegetarian'
	String get label => 'Vegetarian';

	/// en: 'No meat, no fish'
	String get description => 'No meat, no fish';
}

// Path: onboarding.options.diets.vegan
class Translations$onboarding$options$diets$vegan$en {
	Translations$onboarding$options$diets$vegan$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Vegan'
	String get label => 'Vegan';

	/// en: '100% plant-based'
	String get description => '100% plant-based';
}

// Path: onboarding.options.diets.glutenFree
class Translations$onboarding$options$diets$glutenFree$en {
	Translations$onboarding$options$diets$glutenFree$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Gluten-free'
	String get label => 'Gluten-free';

	/// en: 'No wheat, barley or rye'
	String get description => 'No wheat, barley or rye';
}

// Path: onboarding.options.diets.dairyFree
class Translations$onboarding$options$diets$dairyFree$en {
	Translations$onboarding$options$diets$dairyFree$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Dairy-free'
	String get label => 'Dairy-free';

	/// en: 'No milk, butter or cheese'
	String get description => 'No milk, butter or cheese';
}

// Path: onboarding.options.diets.nutFree
class Translations$onboarding$options$diets$nutFree$en {
	Translations$onboarding$options$diets$nutFree$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Nut-free'
	String get label => 'Nut-free';

	/// en: 'No tree nuts or almonds'
	String get description => 'No tree nuts or almonds';
}

// Path: onboarding.options.diets.halal
class Translations$onboarding$options$diets$halal$en {
	Translations$onboarding$options$diets$halal$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Halal'
	String get label => 'Halal';

	/// en: 'Certification and Islamic rules'
	String get description => 'Certification and Islamic rules';
}

// Path: onboarding.options.diets.kosher
class Translations$onboarding$options$diets$kosher$en {
	Translations$onboarding$options$diets$kosher$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Kosher'
	String get label => 'Kosher';

	/// en: 'Follows kosher precepts'
	String get description => 'Follows kosher precepts';
}

// Path: onboarding.options.diets.pescatarian
class Translations$onboarding$options$diets$pescatarian$en {
	Translations$onboarding$options$diets$pescatarian$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Pescatarian'
	String get label => 'Pescatarian';

	/// en: 'Fish, seafood and vegetables'
	String get description => 'Fish, seafood and vegetables';
}

// Path: onboarding.options.diets.lowCarb
class Translations$onboarding$options$diets$lowCarb$en {
	Translations$onboarding$options$diets$lowCarb$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Low-carb'
	String get label => 'Low-carb';

	/// en: 'Fewer carbs, more protein'
	String get description => 'Fewer carbs, more protein';
}

// Path: onboarding.options.diets.lowSodium
class Translations$onboarding$options$diets$lowSodium$en {
	Translations$onboarding$options$diets$lowSodium$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Low-sodium'
	String get label => 'Low-sodium';

	/// en: 'Gentle on the heart'
	String get description => 'Gentle on the heart';
}

/// The flat map containing all translations for locale <en>.
/// Only for edge cases! For simple maps, use the map function of this library.
///
/// The Dart AOT compiler has issues with very large switch statements,
/// so the map is split into smaller functions (512 entries each).
extension on Translations {
	dynamic _flatMapFunction(String path) {
		return switch (path) {
			'app.tagline' => 'Cook with the season, keep what you love.',
			'app.privacyNote' => 'Your recipes stay yours.',
			'common.back' => 'Back',
			'common.cancel' => 'Cancel',
			'common.delete' => 'Delete',
			'common.dismiss' => 'Dismiss',
			'common.tryAgain' => 'Try again',
			'common.showPassword' => 'Show password',
			'common.hidePassword' => 'Hide password',
			'errors.generic' => 'Something went wrong. Try again.',
			'errors.connection' => 'Could not reach SeasonPal. Check your connection and try again.',
			'errors.timeout' => 'The kitchen is taking too long to answer. Try again.',
			'errors.sessionExpired' => 'Your session has expired. Sign in again.',
			'errors.conflict' => 'That action conflicts with existing data.',
			'errors.rateLimited' => 'Too many attempts. Wait a moment and try again.',
			'errors.server' => 'Something went wrong on our side. Try again.',
			'errors.invalidCredentials' => 'Email or password is incorrect.',
			'errors.emailTaken' => 'That account already exists.',
			'errors.publishIncomplete' => 'Add at least one ingredient and one step before publishing.',
			'errors.collectionNameTaken' => 'You already have a collection with that name.',
			'auth.login.title' => 'Welcome back.',
			'auth.login.subtitle' => 'Sign in and pick up where you left off in the kitchen.',
			'auth.login.newHere' => 'New to SeasonPal?',
			'auth.login.createAccount' => 'Create an account',
			'auth.login.email' => 'Email',
			'auth.login.password' => 'Password',
			'auth.login.submit' => 'Sign in',
			'auth.login.emailRequired' => 'Enter your email.',
			'auth.login.emailInvalid' => 'Enter a valid email address.',
			'auth.login.passwordRequired' => 'Enter your password.',
			'auth.register.title' => 'Pull up a chair.',
			'auth.register.subtitle' => 'Create your account, then tell us how you like to cook so the suggestions fit.',
			'auth.register.alreadyHere' => 'Already cooking with us?',
			'auth.register.signIn' => 'Sign in',
			'auth.register.name' => 'Name',
			'auth.register.nameHelper' => 'Optional — what should we call you?',
			'auth.register.nameTooLong' => 'Keep your name to 80 characters.',
			'auth.register.email' => 'Email',
			'auth.register.password' => 'Password',
			'auth.register.passwordHelper' => '8+ characters with upper and lower case, a number, and a symbol.',
			'auth.register.submit' => 'Create account',
			'auth.register.emailRequired' => 'Enter your email.',
			'auth.register.emailInvalid' => 'Enter a valid email address.',
			'auth.register.passwordRequired' => 'Choose a password.',
			'auth.register.passwordTooShort' => 'Use at least 8 characters.',
			'auth.register.passwordTooWeak' => 'Add upper and lower case, a number, and a symbol.',
			'auth.splash.restoreFailed' => 'Could not restore your session.',
			'auth.splash.loading' => 'Setting the table…',
			'onboarding.stepIndicator' => ({required Object current, required Object total}) => 'STEP ${current} OF ${total}',
			'onboarding.eyebrowCuisines' => ({required Object current, required Object total}) => 'STEP ${current} OF ${total} · PERSONALIZATION',
			'onboarding.eyebrowDiet' => ({required Object current, required Object total}) => 'STEP ${current} OF ${total} · PREFERENCES',
			'onboarding.eyebrowRhythm' => ({required Object current, required Object total}) => 'STEP ${current} OF ${total} · YOUR RHYTHM',
			'onboarding.welcome.title' => 'Cook to the season.',
			'onboarding.welcome.body' => 'One minute now, and every suggestion fits the kitchen you actually cook in.',
			'onboarding.welcome.itineraryTitle' => 'YOUR COOKING ITINERARY',
			'onboarding.welcome.cuisineTitle' => 'The cuisines you love',
			'onboarding.welcome.cuisineBody' => 'Mediterranean, Levantine, Andean garden or Nordic smoke. Where your palate lives.',
			'onboarding.welcome.dietTitle' => 'Diet and botanical interests',
			'onboarding.welcome.dietBody' => 'Plant preferences, gluten-free staples, fresh spice and what you cook for pleasure.',
			'onboarding.welcome.rhythmTitle' => 'Your pace at the stove',
			'onboarding.welcome.rhythmBody' => 'Twenty-minute weeknights, or slow weekend braises in clay.',
			'onboarding.welcome.start' => 'Start personalizing (1 min)',
			'onboarding.welcome.skip' => 'Skip for now',
			'onboarding.cuisines.title' => 'Pick your favourite kitchens.',
			'onboarding.cuisines.body' => 'Choose at least three so your first feed is never one note.',
			'onboarding.cuisines.sectionTitle' => 'Seasonal curation',
			'onboarding.cuisines.sectionBody' => 'Botanical inspiration and recipes with a sense of origin.',
			'onboarding.cuisines.counterNone' => 'No cuisines selected yet',
			'onboarding.cuisines.counterOne' => '1 cuisine selected',
			'onboarding.cuisines.counterOther' => ({required Object count}) => '${count} cuisines selected',
			'onboarding.cuisines.remainingOne' => 'Choose 1 more',
			'onboarding.cuisines.remainingOther' => ({required Object count}) => 'Choose ${count} more',
			'onboarding.cuisines.ready' => 'All set',
			'onboarding.cuisines.next' => 'Continue to diet',
			'onboarding.diet.title' => 'Your pantry, your rules.',
			'onboarding.diet.body' => 'We shape recipes around what you need and what you are curious about.',
			'onboarding.diet.restrictionsTitle' => 'Dietary restrictions',
			'onboarding.diet.restrictionsBody' => 'We never suggest an ingredient that breaks these.',
			'onboarding.diet.interestsTitle' => 'Botanical interests',
			'onboarding.diet.interestsBody' => 'Optional — the themes we should lean into.',
			'onboarding.diet.next' => 'Continue to your rhythm',
			'onboarding.rhythm.title' => 'How do you cook?',
			'onboarding.rhythm.body' => 'We match technique and prep time to the habits you actually keep.',
			'onboarding.rhythm.skillTitle' => 'Culinary skill level',
			'onboarding.rhythm.skillHint' => 'Choose one',
			'onboarding.rhythm.timeTitle' => 'Time you usually cook',
			'onboarding.rhythm.timeHint' => 'Pick your pace',
			'onboarding.rhythm.next' => 'Review summary',
			'onboarding.done.title' => 'The stove is warm.',
			'onboarding.done.body' => 'Your recipe box is shaped around this. Check it before we sync your pantry.',
			'onboarding.done.cuisinesTitle' => ({required Object count}) => 'Selected cuisines (${count})',
			'onboarding.done.dietTitle' => 'Restrictions and passions',
			'onboarding.done.rhythmTitle' => 'Cooking rhythm',
			'onboarding.done.dietLabel' => 'DIET',
			'onboarding.done.interestsLabel' => 'INTERESTS',
			'onboarding.done.editSection' => 'Edit',
			'onboarding.done.emptyCuisines' => 'Open to anything',
			'onboarding.done.emptyDiet' => 'No restrictions',
			'onboarding.done.emptyInterests' => 'None yet',
			'onboarding.done.noTime' => 'No set time',
			'onboarding.done.footnote' => 'You can change any of this later in Settings.',
			'onboarding.done.finish' => 'Continue to SeasonPal',
			'onboarding.footer.begin' => 'Begin',
			'onboarding.footer.next' => 'Continue',
			'onboarding.footer.finish' => 'Continue',
			'onboarding.footer.saving' => 'Saving...',
			'onboarding.saveError' => 'Could not save your preferences. Try again.',
			'onboarding.time.hour' => '1 hour',
			'onboarding.time.minSuffix' => 'min',
			'onboarding.time.buckets.quick.label' => '15–20 min',
			'onboarding.time.buckets.quick.description' => 'An express weeknight',
			'onboarding.time.buckets.balanced.label' => '30–45 min',
			'onboarding.time.buckets.balanced.description' => 'Room to build a proper plate',
			'onboarding.time.buckets.long.label' => '60+ min',
			'onboarding.time.buckets.long.description' => 'Braises and weekend rituals',
			'onboarding.time.buckets.variable.label' => 'It varies',
			'onboarding.time.buckets.variable.description' => 'I fit it to the day',
			'onboarding.skill.beginner.label' => 'Enthusiastic beginner',
			'onboarding.skill.beginner.description' => 'Simple techniques, detailed steps, ingredients to hand.',
			'onboarding.skill.intermediate.label' => 'Confident home cook',
			'onboarding.skill.intermediate.description' => 'Knife basics, pan sauces and heat control.',
			'onboarding.skill.advanced.label' => 'Artisan cook',
			'onboarding.skill.advanced.description' => 'Fermentation, layered baking, plated cooking.',
			'onboarding.options.cuisines.italian.label' => 'Rustic Italian & pasta',
			'onboarding.options.cuisines.italian.description' => 'Ancient wheat, ragu, aged cheese',
			'onboarding.options.cuisines.italian.short' => 'Italian',
			'onboarding.options.cuisines.mediterranean.label' => 'Classic Mediterranean',
			'onboarding.options.cuisines.mediterranean.description' => 'Live oils, herbs, fish from the sea',
			'onboarding.options.cuisines.mediterranean.short' => 'Mediterranean',
			'onboarding.options.cuisines.middleEastern.label' => 'Levantine & Middle Eastern',
			'onboarding.options.cuisines.middleEastern.description' => 'Za\'atar, tahini, pomegranate',
			'onboarding.options.cuisines.middleEastern.short' => 'Middle Eastern',
			'onboarding.options.cuisines.mexican.label' => 'Oaxacan & traditional',
			'onboarding.options.cuisines.mexican.description' => 'Black mole, native corn',
			'onboarding.options.cuisines.mexican.short' => 'Mexican',
			'onboarding.options.cuisines.indian.label' => 'Spiced Indian',
			'onboarding.options.cuisines.indian.description' => 'Toasted masalas, pulses, ghee',
			'onboarding.options.cuisines.indian.short' => 'Indian',
			'onboarding.options.cuisines.japanese.label' => 'Japanese & craft ramen',
			'onboarding.options.cuisines.japanese.description' => 'Dashi broths, umami, ferments',
			'onboarding.options.cuisines.japanese.short' => 'Japanese',
			'onboarding.options.cuisines.korean.label' => 'Korean & kimchi',
			'onboarding.options.cuisines.korean.description' => 'Gochujang, banchan, marinades',
			'onboarding.options.cuisines.korean.short' => 'Korean',
			'onboarding.options.cuisines.thai.label' => 'Aromatic Thai',
			'onboarding.options.cuisines.thai.description' => 'Lemongrass, kaffir lime, coconut',
			'onboarding.options.cuisines.thai.short' => 'Thai',
			'onboarding.options.cuisines.chinese.label' => 'Wok & dim sum',
			'onboarding.options.cuisines.chinese.description' => 'High heat, steam, soy and vinegar',
			'onboarding.options.cuisines.chinese.short' => 'Chinese',
			'onboarding.options.cuisines.french.label' => 'French bistro',
			'onboarding.options.cuisines.french.description' => 'Brown butter, long stocks, wine',
			'onboarding.options.cuisines.french.short' => 'French',
			'onboarding.options.cuisines.spanish.label' => 'Iberian & tapas',
			'onboarding.options.cuisines.spanish.description' => 'Paprika, acorn-fed pork, tinned fish',
			'onboarding.options.cuisines.spanish.short' => 'Spanish',
			'onboarding.options.cuisines.greek.label' => 'Aegean Greek',
			'onboarding.options.cuisines.greek.description' => 'Pastured feta, wild oregano',
			'onboarding.options.cuisines.greek.short' => 'Greek',
			'onboarding.options.cuisines.turkish.label' => 'Anatolian & charcoal',
			'onboarding.options.cuisines.turkish.description' => 'Bulgur, smoked aubergine, yoghurt',
			'onboarding.options.cuisines.turkish.short' => 'Turkish',
			'onboarding.options.cuisines.vietnamese.label' => 'Fresh Vietnamese',
			'onboarding.options.cuisines.vietnamese.description' => 'Fine herbs, rice rolls, pho',
			'onboarding.options.cuisines.vietnamese.short' => 'Vietnamese',
			'onboarding.options.cuisines.american.label' => 'Californian farm-to-table',
			'onboarding.options.cuisines.american.description' => 'Local harvest, clean plates',
			'onboarding.options.cuisines.american.short' => 'American',
			'onboarding.options.cuisines.northAfrican.label' => 'Moroccan & tagines',
			'onboarding.options.cuisines.northAfrican.description' => 'Ras el hanout, preserved lemon',
			'onboarding.options.cuisines.northAfrican.short' => 'North African',
			'onboarding.options.cuisines.latinAmerican.label' => 'Peruvian & Nikkei',
			'onboarding.options.cuisines.latinAmerican.description' => 'Native chillies, ceviche, rocoto',
			'onboarding.options.cuisines.latinAmerican.short' => 'Latin American',
			'onboarding.options.cuisines.nordic.label' => 'Nordic ferments',
			'onboarding.options.cuisines.nordic.description' => 'Pickles, rye, smoke',
			'onboarding.options.cuisines.nordic.short' => 'Nordic',
			'onboarding.options.cuisines.caribbean.label' => 'Caribbean islands',
			'onboarding.options.cuisines.caribbean.description' => 'Peppers, coconut, citrus',
			'onboarding.options.cuisines.caribbean.short' => 'Caribbean',
			'onboarding.options.cuisines.african.label' => 'Slow-fire African',
			'onboarding.options.cuisines.african.description' => 'One-pot stews, roots, spice',
			'onboarding.options.cuisines.african.short' => 'African',
			'onboarding.options.diets.vegetarian.label' => 'Vegetarian',
			'onboarding.options.diets.vegetarian.description' => 'No meat, no fish',
			'onboarding.options.diets.vegan.label' => 'Vegan',
			'onboarding.options.diets.vegan.description' => '100% plant-based',
			'onboarding.options.diets.glutenFree.label' => 'Gluten-free',
			'onboarding.options.diets.glutenFree.description' => 'No wheat, barley or rye',
			'onboarding.options.diets.dairyFree.label' => 'Dairy-free',
			'onboarding.options.diets.dairyFree.description' => 'No milk, butter or cheese',
			'onboarding.options.diets.nutFree.label' => 'Nut-free',
			'onboarding.options.diets.nutFree.description' => 'No tree nuts or almonds',
			'onboarding.options.diets.halal.label' => 'Halal',
			'onboarding.options.diets.halal.description' => 'Certification and Islamic rules',
			'onboarding.options.diets.kosher.label' => 'Kosher',
			'onboarding.options.diets.kosher.description' => 'Follows kosher precepts',
			'onboarding.options.diets.pescatarian.label' => 'Pescatarian',
			'onboarding.options.diets.pescatarian.description' => 'Fish, seafood and vegetables',
			'onboarding.options.diets.lowCarb.label' => 'Low-carb',
			'onboarding.options.diets.lowCarb.description' => 'Fewer carbs, more protein',
			'onboarding.options.diets.lowSodium.label' => 'Low-sodium',
			'onboarding.options.diets.lowSodium.description' => 'Gentle on the heart',
			'onboarding.options.interests.weeknightDinners' => 'Weeknight dinners',
			'onboarding.options.interests.mealPrep' => 'Meal prep',
			'onboarding.options.interests.baking' => 'Baking',
			'onboarding.options.interests.grilling' => 'Grilling',
			'onboarding.options.interests.slowCooking' => 'Slow cooking',
			'onboarding.options.interests.fermentation' => 'Fermentation',
			'onboarding.options.interests.plantForward' => 'Plant-forward',
			'onboarding.options.interests.comfortFood' => 'Comfort food',
			'onboarding.options.interests.entertaining' => 'Entertaining',
			'onboarding.options.interests.budgetCooking' => 'Budget cooking',
			'onboarding.options.interests.cookingWithKids' => 'Cooking with kids',
			'onboarding.options.interests.spicesAndHeat' => 'Spices & heat',
			'discovery.eyebrow' => 'DISCOVER',
			'discovery.title' => 'Find your next table.',
			'discovery.subtitle' => 'Search public recipes, then narrow by cuisine, time, meal and diet.',
			'discovery.searchHint' => 'Search recipes, ingredients, cuisines',
			'discovery.filters.cuisine' => 'Cuisine',
			'discovery.filters.meal' => 'Meal',
			'discovery.filters.time' => 'Time',
			'discovery.filters.difficulty' => 'Effort',
			'discovery.filters.diet' => 'Diet',
			'discovery.filters.any' => 'Any',
			'discovery.filters.clearAll' => 'Clear all',
			'discovery.time.under' => ({required Object count}) => 'Under ${count} min',
			'discovery.feed.loading' => 'Setting the table.',
			'discovery.feed.loadError' => 'We couldn\'t load the public feed.',
			'discovery.feed.results' => ({required Object count}) => '${count} recipes',
			'discovery.feed.resultsOne' => '1 recipe',
			'discovery.feed.newestFirst' => 'Newest first',
			'discovery.feed.bestMatch' => 'Best match',
			'discovery.feed.loadMoreError' => 'Couldn\'t load more recipes.',
			'discovery.feed.emptyTitle' => 'Nothing matches that table.',
			'discovery.feed.emptyBody' => 'Try a wider time, another cuisine, or a shorter search.',
			'discovery.feed.emptyCommunityTitle' => 'The community table is still being set.',
			'discovery.feed.emptyCommunityBody' => 'Publish a recipe and it can appear here for other cooks.',
			'discovery.pantry.eyebrow' => 'THE PANTRY',
			'discovery.pantry.title' => 'Cook from what you have.',
			'discovery.pantry.subtitle' => 'Add the ingredients on your shelf. We\'ll rank public recipes by how much of each one you already cover.',
			'discovery.pantry.body' => 'Match public recipes against your shelf.',
			'discovery.pantry.inputHint' => 'Add an ingredient, or a few with commas',
			'discovery.pantry.add' => 'Add',
			'discovery.pantry.clear' => 'Clear pantry',
			'discovery.pantry.remove' => ({required Object name}) => 'Remove ${name}',
			'discovery.pantry.loading' => 'Looking through the pantry.',
			'discovery.pantry.loadError' => 'We couldn\'t match your pantry.',
			'discovery.pantry.loadMoreError' => 'Couldn\'t load more matches.',
			'discovery.pantry.loadMore' => 'Load more',
			'discovery.pantry.results' => ({required Object count}) => '${count} matches',
			'discovery.pantry.resultsOne' => '1 match',
			'discovery.pantry.emptyTitle' => 'No matches yet.',
			'discovery.pantry.emptyBody' => 'Try fewer or more general ingredients, like "tomato" instead of "cherry tomatoes".',
			'discovery.pantry.emptyPromptTitle' => 'Start with what you have.',
			'discovery.pantry.emptyPromptBody' => 'Add a few ingredients above and we\'ll find public recipes that need the least extra shopping.',
			'discovery.pantry.canCook' => 'Can cook',
			'discovery.pantry.match' => ({required Object percent}) => '${percent}% match',
			'discovery.pantry.have' => ({required Object names}) => 'You have: ${names}',
			'discovery.pantry.missing' => ({required Object names}) => 'Missing: ${names}',
			'discovery.pantry.allIngredients' => 'You have everything.',
			'home.signOut' => 'Sign out',
			'home.language.tooltip' => 'Language',
			'home.language.english' => 'English',
			'home.language.spanish' => 'Español',
			'home.greetings.morning' => 'Good morning',
			'home.greetings.afternoon' => 'Good afternoon',
			'home.greetings.evening' => 'Good evening',
			'home.greetings.line' => ({required Object greeting, required Object name}) => '${greeting}, ${name}.',
			'home.greetings.friend' => 'friend',
			'home.whatCooking' => 'What are we cooking today?',
			'home.pantry.eyebrow' => 'FROM YOUR PANTRY',
			'home.pantry.title' => 'What can I cook right now?',
			'home.pantry.body' => 'Type what you have. We\'ll find public recipes that use the most of it.',
			'home.pantry.hint' => 'Lemon, orzo, spinach',
			'home.pantry.action' => 'Find recipes',
			'home.pantry.empty' => 'Add at least one ingredient first.',
			'home.rails.loading' => 'Looking for what\'s cooking nearby.',
			'home.rails.forYouEyebrow' => 'FOR YOUR TASTE',
			'home.rails.forYouTitle' => 'Built from your cuisines and diets.',
			'home.rails.trendingEyebrow' => 'TRENDING THIS WEEK',
			'home.rails.trendingTitle' => 'What other cooks are saving.',
			'home.rails.newestEyebrow' => 'NEW FROM THE KITCHEN',
			'home.rails.newestTitle' => 'The latest public recipes.',
			'home.rails.loadError' => 'We couldn\'t load the community rails.',
			'home.rails.emptyTitle' => 'The community table is still being set.',
			'home.rails.emptyBody' => 'Publish a recipe and it can appear here for other cooks.',
			'home.rails.action' => 'Browse Discover',
			'home.taste.eyebrow' => 'YOUR TASTE',
			'home.taste.loading' => 'Reading your taste profile…',
			'home.taste.loadError' => 'We couldn\'t load your taste profile.',
			'home.taste.noTime' => 'No set time',
			'home.taste.empty' => 'Your kitchen is open to anything.',
			'home.taste.one' => ({required Object cuisine}) => 'Your kitchen leans ${cuisine}.',
			'home.taste.two' => ({required Object first, required Object second}) => 'Your kitchen leans ${first} and ${second}.',
			'home.taste.many' => ({required Object first, required Object second}) => 'Your kitchen leans ${first}, ${second}, and more.',
			'home.taste.noRestrictions' => 'No dietary restrictions saved.',
			'home.taste.dietOne' => ({required Object restriction}) => 'Cooking around ${restriction}.',
			'home.taste.dietMany' => ({required Object leading, required Object last}) => 'Cooking around ${leading} and ${last}.',
			'home.library.eyebrow' => 'YOUR RECIPES',
			'home.library.title' => 'Your recipe library.',
			'home.library.body' => 'Saved dishes, collections, and your own recipes are ready when you are.',
			'home.library.action' => 'Open my recipes',
			'navigation.home' => 'Home',
			'navigation.discover' => 'Discover',
			'navigation.aiCook' => 'AI Cook',
			'navigation.myRecipes' => 'My Recipes',
			'navigation.profile' => 'Profile',
			'comingSoon.badge' => 'PLANNED',
			'comingSoon.aiCook.eyebrow' => 'AI COOK',
			'comingSoon.aiCook.title' => 'A sous-chef, soon.',
			'comingSoon.aiCook.body' => 'Ask about substitutions, plan from what is in the pantry, and adapt recipes. Keys stay on the server, never in the app.',
			'comingSoon.profile.eyebrow' => 'PROFILE',
			'comingSoon.profile.title' => 'Your corner.',
			'comingSoon.profile.body' => 'Preferences, published recipes, and account settings will live here. Sign-out and language stay on Home for now.',
			'recipes.mealTypes.unspecified' => 'Any time',
			'recipes.mealTypes.breakfast' => 'Breakfast',
			'recipes.mealTypes.lunch' => 'Lunch',
			'recipes.mealTypes.dinner' => 'Dinner',
			'recipes.mealTypes.snack' => 'Snack',
			'recipes.mealTypes.dessert' => 'Dessert',
			'recipes.mealTypes.drink' => 'Drink',
			'recipes.difficulty.easy' => 'Easy',
			'recipes.difficulty.medium' => 'Medium',
			'recipes.difficulty.hard' => 'Hard',
			'recipes.library.eyebrow' => 'YOUR KITCHEN',
			'recipes.library.title' => 'My recipes',
			'recipes.library.subtitle' => 'What you have written and what you have saved, in one place.',
			'recipes.library.newRecipe' => 'New recipe',
			'recipes.library.collections' => 'Collections',
			'recipes.library.mine' => 'Mine',
			'recipes.library.saved' => 'Saved',
			'recipes.library.loading' => 'Opening your library…',
			'recipes.library.loadError' => 'We couldn\'t load your recipes.',
			'recipes.library.loadMoreError' => 'Couldn\'t load more recipes.',
			'recipes.library.emptyOwnTitle' => 'Your first recipe starts here.',
			'recipes.library.emptyOwnBody' => 'Write down a dish you already cook. Photos and steps can come as you go.',
			'recipes.library.emptySavedTitle' => 'Nothing saved yet.',
			'recipes.library.emptySavedBody' => 'Tap Save on any recipe and it lands here, ready for another night.',
			'recipes.library.draft' => 'DRAFT',
			'recipes.library.ai' => 'AI',
			'recipes.library.minutes' => ({required Object count}) => '${count} min',
			'recipes.library.seconds' => ({required Object count}) => '${count}s',
			'recipes.library.servings' => ({required Object count}) => 'Serves ${count}',
			'recipes.library.servingsOne' => 'Serves 1',
			'recipes.detail.by' => ({required Object name}) => 'By ${name}',
			'recipes.detail.ingredients' => 'Ingredients',
			'recipes.detail.method' => 'Method',
			'recipes.detail.media' => 'Photos & video',
			'recipes.detail.tags' => 'Tags',
			'recipes.detail.save' => 'Save recipe',
			'recipes.detail.saved' => 'Saved',
			'recipes.detail.savedMessage' => 'Saved to your library.',
			'recipes.detail.unsavedMessage' => 'Removed from your library.',
			'recipes.detail.noIngredients' => 'No ingredients listed yet.',
			'recipes.detail.noSteps' => 'No steps written yet.',
			'recipes.detail.aiNote' => 'Made with AI — read it through before you cook.',
			'recipes.detail.video' => 'Video',
			'recipes.detail.publishedBadge' => 'PUBLIC',
			'recipes.detail.edit' => 'Edit recipe',
			'recipes.detail.publish' => 'Publish recipe',
			'recipes.detail.unpublish' => 'Make private',
			'recipes.detail.delete' => 'Delete recipe',
			'recipes.detail.more' => 'Recipe actions',
			'recipes.detail.deleteTitle' => 'Delete this recipe?',
			'recipes.detail.deleteBody' => 'It leaves your library and any collections. This can\'t be undone.',
			'recipes.detail.loadError' => 'We couldn\'t load this recipe.',
			'recipes.detail.notFoundTitle' => 'This recipe isn\'t here.',
			'recipes.detail.notFoundBody' => 'It may have been deleted or kept private.',
			'recipes.detail.actionError' => 'That didn\'t work. Try again.',
			'recipes.detail.published' => 'Recipe published.',
			'recipes.detail.unpublished' => 'Recipe is private again.',
			'recipes.saveSheet.title' => 'Save to a collection',
			'recipes.saveSheet.favoritesBody' => 'Saving always adds the recipe to Favorites.',
			'recipes.saveSheet.favorites' => 'Save to favorites',
			'recipes.saveSheet.savedStatus' => 'Saved to your library.',
			'recipes.saveSheet.unsave' => 'Remove',
			'recipes.saveSheet.collections' => 'ADD TO A COLLECTION',
			'recipes.saveSheet.collectionsError' => 'We couldn\'t load your collections.',
			'recipes.saveSheet.noCollections' => 'No collections yet. Create one below.',
			'recipes.saveSheet.newCollection' => 'New collection',
			'recipes.saveSheet.createTitle' => 'Name the collection',
			'recipes.saveSheet.nameLabel' => 'Collection name',
			'recipes.saveSheet.nameHint' => 'Weeknight dinners, Sunday baking…',
			'recipes.saveSheet.nameRequired' => 'Give the collection a name.',
			'recipes.saveSheet.create' => 'Create',
			'recipes.saveSheet.createError' => 'Could not create the collection. Try again.',
			'recipes.saveSheet.saveError' => 'Could not save the recipe. Try again.',
			'recipes.collections.eyebrow' => 'YOUR KITCHEN',
			'recipes.collections.title' => 'Collections',
			'recipes.collections.subtitle' => 'Group recipes for a weeknight, a season, or a table.',
			'recipes.collections.newCollection' => 'New collection',
			'recipes.collections.loadError' => 'We couldn\'t load your collections.',
			'recipes.collections.count' => ({required Object count}) => '${count} recipes',
			'recipes.collections.countOne' => '1 recipe',
			'recipes.collections.favorites' => 'Favorites',
			'recipes.collections.emptyTitle' => 'No collections yet.',
			'recipes.collections.emptyBody' => 'Group recipes for a weeknight, a season, or a dinner party.',
			'recipes.collections.emptyCollection' => 'This collection is empty.',
			'recipes.collections.emptyCollectionBody' => 'Save a recipe to this collection from its page.',
			'recipes.collections.remove' => 'Remove',
			'recipes.collections.removeTitle' => 'Remove this recipe?',
			'recipes.collections.removeBody' => 'It stays in your saved library.',
			'recipes.collections.removeError' => 'Could not remove the recipe. Try again.',
			'recipes.collections.delete' => 'Delete collection',
			'recipes.collections.deleteTitle' => 'Delete this collection?',
			'recipes.collections.deleteBody' => 'The recipes stay in your library; only the collection goes away.',
			'recipes.collections.deleteError' => 'Could not delete the collection. Try again.',
			'recipes.editor.newEyebrow' => 'A NEW DISH',
			'recipes.editor.newTitle' => 'Write it down.',
			'recipes.editor.newBody' => 'Seven short sections. Save a draft at any point — only the name is required.',
			'recipes.editor.editEyebrow' => 'EDITING',
			'recipes.editor.editTitle' => 'Refine the dish.',
			'recipes.editor.editBody' => 'Change what you like. Publication stays as it was unless you publish after saving.',
			'recipes.editor.save' => 'Save recipe',
			'recipes.editor.saving' => 'Saving…',
			'recipes.editor.saveAndPublish' => 'Save & publish',
			'recipes.editor.saveError' => 'Could not save the recipe. Try again.',
			'recipes.editor.loadError' => 'We couldn\'t load this recipe for editing.',
			'recipes.editor.basics.eyebrow' => 'BASICS',
			'recipes.editor.basics.title' => 'The basics',
			'recipes.editor.basics.name' => 'Recipe name',
			'recipes.editor.basics.nameHint' => 'Lemon and thyme roast chicken',
			'recipes.editor.basics.nameRequired' => 'Give the recipe a name.',
			'recipes.editor.basics.description' => 'Description',
			'recipes.editor.basics.descriptionHint' => 'What it is, and why you make it.',
			'recipes.editor.plate.eyebrow' => 'THE PLATE',
			'recipes.editor.plate.title' => 'How it eats',
			'recipes.editor.plate.cuisine' => 'Cuisine',
			'recipes.editor.plate.cuisineHint' => 'Italian, Thai, Levantine…',
			'recipes.editor.plate.meal' => 'Meal',
			'recipes.editor.time.eyebrow' => 'TIME',
			'recipes.editor.time.title' => 'Time at the stove',
			'recipes.editor.time.prep' => 'Prep (min)',
			'recipes.editor.time.cook' => 'Cook (min)',
			'recipes.editor.time.servings' => 'Servings',
			'recipes.editor.time.difficulty' => 'Difficulty',
			'recipes.editor.time.invalid' => 'Use whole minutes between 0 and 1440.',
			'recipes.editor.photos.eyebrow' => 'PHOTOS',
			'recipes.editor.photos.title' => 'Show the dish',
			'recipes.editor.photos.chooseCover' => 'Choose cover',
			'recipes.editor.photos.changeCover' => 'Change cover',
			'recipes.editor.photos.removeCover' => 'Remove cover',
			'recipes.editor.photos.more' => 'More photos and video',
			'recipes.editor.photos.addPhoto' => 'Add photo',
			'recipes.editor.photos.addVideo' => 'Add video',
			'recipes.editor.photos.uploading' => 'Uploading…',
			'recipes.editor.photos.uploadError' => 'Upload failed. Try again.',
			'recipes.editor.photos.tooLarge' => 'That file is too large. Photos max out at 10 MB, video at 24 MB.',
			'recipes.editor.photos.tooMany' => 'A recipe can hold up to 20 photos and videos.',
			'recipes.editor.photos.unsupported' => 'Choose a JPEG, PNG, WebP, GIF, MP4 or MOV file.',
			'recipes.editor.ingredients.eyebrow' => 'INGREDIENTS',
			'recipes.editor.ingredients.title' => 'What goes in',
			'recipes.editor.ingredients.quantity' => 'Qty',
			'recipes.editor.ingredients.unit' => 'Unit',
			'recipes.editor.ingredients.name' => 'Ingredient',
			'recipes.editor.ingredients.note' => 'Note (optional)',
			'recipes.editor.ingredients.add' => 'Add ingredient',
			'recipes.editor.ingredients.remove' => 'Remove ingredient',
			'recipes.editor.ingredients.moveUp' => 'Move up',
			'recipes.editor.ingredients.moveDown' => 'Move down',
			'recipes.editor.ingredients.nameRequired' => 'Name every ingredient you fill in.',
			'recipes.editor.ingredients.quantityInvalid' => 'Quantities need to be zero or more.',
			'recipes.editor.steps.eyebrow' => 'METHOD',
			'recipes.editor.steps.title' => 'How it cooks',
			'recipes.editor.steps.instruction' => 'Step',
			'recipes.editor.steps.tip' => 'Tip (optional)',
			'recipes.editor.steps.timer' => 'Timer (min, optional)',
			'recipes.editor.steps.add' => 'Add step',
			'recipes.editor.steps.remove' => 'Remove step',
			'recipes.editor.steps.instructionRequired' => 'Write every step you fill in.',
			'recipes.editor.steps.timerInvalid' => 'Timers need whole minutes between 1 and 1440.',
			'recipes.editor.tags.eyebrow' => 'DETAILS',
			'recipes.editor.tags.title' => 'A little more detail',
			'recipes.editor.tags.body' => 'Tags help you find the recipe later. Dietary tags are shown to anyone who can see it.',
			'recipes.editor.tags.tags' => 'Tags',
			'recipes.editor.tags.tagsHint' => 'Weeknight, one-pan…',
			'recipes.editor.tags.dietaryTags' => 'Dietary tags',
			'recipes.editor.tags.dietaryHint' => 'Vegetarian, gluten-free…',
			'recipes.editor.tags.add' => 'Add tag',
			'recipes.editor.publish.label' => 'Publish after saving',
			'recipes.editor.publish.body' => 'Published recipes can appear in Discover. You can make it private again at any time.',
			'recipes.editor.publish.incomplete' => 'Add at least one ingredient and one step before publishing.',
			'recipes.editor.publish.failed' => 'The recipe was saved, but publishing failed. Try again from the recipe page.',
			_ => null,
		};
	}
}
