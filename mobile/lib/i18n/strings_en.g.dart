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
	late final Translations$home$en home = Translations$home$en.internal(_root);
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

	late final Translations$home$taste$en taste = Translations$home$taste$en.internal(_root);
	late final Translations$home$comingNext$en comingNext = Translations$home$comingNext$en.internal(_root);
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

	/// en: 'At least 8 characters.'
	String get passwordHelper => 'At least 8 characters.';

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

	/// en: 'A QUICK TASTE OF YOU'
	String get eyebrow => 'A QUICK TASTE OF YOU';

	/// en: 'Let's set the table.'
	String get title => 'Let\'s set the table.';

	/// en: 'A few questions so SeasonPal can suggest dishes that fit your kitchen — not someone else's.'
	String get body => 'A few questions so SeasonPal can suggest dishes that fit your kitchen — not someone else\'s.';

	/// en: 'Cuisines you love'
	String get cuisineTitle => 'Cuisines you love';

	/// en: 'The flavours you reach for on a normal week.'
	String get cuisineBody => 'The flavours you reach for on a normal week.';

	/// en: 'Anything you avoid'
	String get dietTitle => 'Anything you avoid';

	/// en: 'Allergies and diets we should always respect.'
	String get dietBody => 'Allergies and diets we should always respect.';

	/// en: 'The time you have'
	String get timeTitle => 'The time you have';

	/// en: 'Tuesday dinner looks different from a Sunday project.'
	String get timeBody => 'Tuesday dinner looks different from a Sunday project.';

	/// en: 'About a minute, start to finish.'
	String get duration => 'About a minute, start to finish.';
}

// Path: onboarding.cuisines
class Translations$onboarding$cuisines$en {
	Translations$onboarding$cuisines$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Your taste'
	String get eyebrow => 'Your taste';

	/// en: 'What do you crave?'
	String get title => 'What do you crave?';

	/// en: 'Pick the cuisines you reach for most. Choose as many as you like.'
	String get body => 'Pick the cuisines you reach for most. Choose as many as you like.';
}

// Path: onboarding.diet
class Translations$onboarding$diet$en {
	Translations$onboarding$diet$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Your table'
	String get eyebrow => 'Your table';

	/// en: 'Anything off the menu?'
	String get title => 'Anything off the menu?';

	/// en: 'Allergies, diets, or ingredients you'd rather skip. Pick everything that applies.'
	String get body => 'Allergies, diets, or ingredients you\'d rather skip. Pick everything that applies.';

	/// en: 'What are you into?'
	String get interestsTitle => 'What are you into?';

	/// en: 'Optional — it helps us tune the suggestions.'
	String get interestsBody => 'Optional — it helps us tune the suggestions.';
}

// Path: onboarding.rhythm
class Translations$onboarding$rhythm$en {
	Translations$onboarding$rhythm$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Your rhythm'
	String get eyebrow => 'Your rhythm';

	/// en: 'How do you like to cook?'
	String get title => 'How do you like to cook?';

	/// en: 'We use this to choose techniques and recipes that feel right for you.'
	String get body => 'We use this to choose techniques and recipes that feel right for you.';

	/// en: 'Time on a usual night'
	String get timeTitle => 'Time on a usual night';

	/// en: 'Leave it unset if it changes day to day.'
	String get timeBody => 'Leave it unset if it changes day to day.';
}

// Path: onboarding.done
class Translations$onboarding$done$en {
	Translations$onboarding$done$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Your kitchen is ready.'
	String get title => 'Your kitchen is ready.';

	/// en: 'Here's what we'll cook with. You can change any of it later.'
	String get body => 'Here\'s what we\'ll cook with. You can change any of it later.';

	/// en: 'Open to anything'
	String get openToAnything => 'Open to anything';

	/// en: 'No restrictions'
	String get noRestrictions => 'No restrictions';

	/// en: 'No set time'
	String get noTime => 'No set time';

	/// en: 'Cuisines'
	String get summaryCuisines => 'Cuisines';

	/// en: 'Diet'
	String get summaryDiet => 'Diet';

	/// en: 'Skill'
	String get summarySkill => 'Skill';

	/// en: 'Usual time'
	String get summaryTime => 'Usual time';

	/// en: 'Also into'
	String get alsoInto => 'Also into';
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

	/// en: 'Finish setup'
	String get finish => 'Finish setup';

	/// en: 'Saving…'
	String get saving => 'Saving…';
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

// Path: home.comingNext
class Translations$home$comingNext$en {
	Translations$home$comingNext$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'COMING NEXT'
	String get eyebrow => 'COMING NEXT';

	/// en: 'Your recipe library.'
	String get title => 'Your recipe library.';

	/// en: 'Saved recipes, collections, and a cooking view are on the way.'
	String get body => 'Saved recipes, collections, and a cooking view are on the way.';
}

// Path: onboarding.skill.beginner
class Translations$onboarding$skill$beginner$en {
	Translations$onboarding$skill$beginner$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Beginner'
	String get label => 'Beginner';

	/// en: 'Simple recipes and familiar techniques.'
	String get description => 'Simple recipes and familiar techniques.';
}

// Path: onboarding.skill.intermediate
class Translations$onboarding$skill$intermediate$en {
	Translations$onboarding$skill$intermediate$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Intermediate'
	String get label => 'Intermediate';

	/// en: 'Comfortable trying new methods.'
	String get description => 'Comfortable trying new methods.';
}

// Path: onboarding.skill.advanced
class Translations$onboarding$skill$advanced$en {
	Translations$onboarding$skill$advanced$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Advanced'
	String get label => 'Advanced';

	/// en: 'Ready for a proper challenge.'
	String get description => 'Ready for a proper challenge.';
}

// Path: onboarding.options.cuisines
class Translations$onboarding$options$cuisines$en {
	Translations$onboarding$options$cuisines$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Italian'
	String get italian => 'Italian';

	/// en: 'Mediterranean'
	String get mediterranean => 'Mediterranean';

	/// en: 'Middle Eastern'
	String get middleEastern => 'Middle Eastern';

	/// en: 'Mexican'
	String get mexican => 'Mexican';

	/// en: 'Indian'
	String get indian => 'Indian';

	/// en: 'Japanese'
	String get japanese => 'Japanese';

	/// en: 'Korean'
	String get korean => 'Korean';

	/// en: 'Thai'
	String get thai => 'Thai';

	/// en: 'Chinese'
	String get chinese => 'Chinese';

	/// en: 'French'
	String get french => 'French';

	/// en: 'Spanish'
	String get spanish => 'Spanish';

	/// en: 'Greek'
	String get greek => 'Greek';

	/// en: 'Turkish'
	String get turkish => 'Turkish';

	/// en: 'Vietnamese'
	String get vietnamese => 'Vietnamese';

	/// en: 'American'
	String get american => 'American';

	/// en: 'North African'
	String get northAfrican => 'North African';

	/// en: 'Latin American'
	String get latinAmerican => 'Latin American';

	/// en: 'Nordic'
	String get nordic => 'Nordic';

	/// en: 'Caribbean'
	String get caribbean => 'Caribbean';

	/// en: 'African'
	String get african => 'African';
}

// Path: onboarding.options.diets
class Translations$onboarding$options$diets$en {
	Translations$onboarding$options$diets$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Vegetarian'
	String get vegetarian => 'Vegetarian';

	/// en: 'Vegan'
	String get vegan => 'Vegan';

	/// en: 'Gluten-free'
	String get glutenFree => 'Gluten-free';

	/// en: 'Dairy-free'
	String get dairyFree => 'Dairy-free';

	/// en: 'Nut-free'
	String get nutFree => 'Nut-free';

	/// en: 'Halal'
	String get halal => 'Halal';

	/// en: 'Kosher'
	String get kosher => 'Kosher';

	/// en: 'Pescatarian'
	String get pescatarian => 'Pescatarian';

	/// en: 'Low-carb'
	String get lowCarb => 'Low-carb';

	/// en: 'Low-sodium'
	String get lowSodium => 'Low-sodium';
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
			'auth.register.passwordHelper' => 'At least 8 characters.',
			'auth.register.submit' => 'Create account',
			'auth.register.emailRequired' => 'Enter your email.',
			'auth.register.emailInvalid' => 'Enter a valid email address.',
			'auth.register.passwordRequired' => 'Choose a password.',
			'auth.register.passwordTooShort' => 'Use at least 8 characters.',
			'auth.splash.restoreFailed' => 'Could not restore your session.',
			'auth.splash.loading' => 'Setting the table…',
			'onboarding.stepIndicator' => ({required Object current, required Object total}) => 'STEP ${current} OF ${total}',
			'onboarding.welcome.eyebrow' => 'A QUICK TASTE OF YOU',
			'onboarding.welcome.title' => 'Let\'s set the table.',
			'onboarding.welcome.body' => 'A few questions so SeasonPal can suggest dishes that fit your kitchen — not someone else\'s.',
			'onboarding.welcome.cuisineTitle' => 'Cuisines you love',
			'onboarding.welcome.cuisineBody' => 'The flavours you reach for on a normal week.',
			'onboarding.welcome.dietTitle' => 'Anything you avoid',
			'onboarding.welcome.dietBody' => 'Allergies and diets we should always respect.',
			'onboarding.welcome.timeTitle' => 'The time you have',
			'onboarding.welcome.timeBody' => 'Tuesday dinner looks different from a Sunday project.',
			'onboarding.welcome.duration' => 'About a minute, start to finish.',
			'onboarding.cuisines.eyebrow' => 'Your taste',
			'onboarding.cuisines.title' => 'What do you crave?',
			'onboarding.cuisines.body' => 'Pick the cuisines you reach for most. Choose as many as you like.',
			'onboarding.diet.eyebrow' => 'Your table',
			'onboarding.diet.title' => 'Anything off the menu?',
			'onboarding.diet.body' => 'Allergies, diets, or ingredients you\'d rather skip. Pick everything that applies.',
			'onboarding.diet.interestsTitle' => 'What are you into?',
			'onboarding.diet.interestsBody' => 'Optional — it helps us tune the suggestions.',
			'onboarding.rhythm.eyebrow' => 'Your rhythm',
			'onboarding.rhythm.title' => 'How do you like to cook?',
			'onboarding.rhythm.body' => 'We use this to choose techniques and recipes that feel right for you.',
			'onboarding.rhythm.timeTitle' => 'Time on a usual night',
			'onboarding.rhythm.timeBody' => 'Leave it unset if it changes day to day.',
			'onboarding.done.title' => 'Your kitchen is ready.',
			'onboarding.done.body' => 'Here\'s what we\'ll cook with. You can change any of it later.',
			'onboarding.done.openToAnything' => 'Open to anything',
			'onboarding.done.noRestrictions' => 'No restrictions',
			'onboarding.done.noTime' => 'No set time',
			'onboarding.done.summaryCuisines' => 'Cuisines',
			'onboarding.done.summaryDiet' => 'Diet',
			'onboarding.done.summarySkill' => 'Skill',
			'onboarding.done.summaryTime' => 'Usual time',
			'onboarding.done.alsoInto' => 'Also into',
			'onboarding.footer.begin' => 'Begin',
			'onboarding.footer.next' => 'Continue',
			'onboarding.footer.finish' => 'Finish setup',
			'onboarding.footer.saving' => 'Saving…',
			'onboarding.saveError' => 'Could not save your preferences. Try again.',
			'onboarding.time.hour' => '1 hour',
			'onboarding.time.minSuffix' => 'min',
			'onboarding.skill.beginner.label' => 'Beginner',
			'onboarding.skill.beginner.description' => 'Simple recipes and familiar techniques.',
			'onboarding.skill.intermediate.label' => 'Intermediate',
			'onboarding.skill.intermediate.description' => 'Comfortable trying new methods.',
			'onboarding.skill.advanced.label' => 'Advanced',
			'onboarding.skill.advanced.description' => 'Ready for a proper challenge.',
			'onboarding.options.cuisines.italian' => 'Italian',
			'onboarding.options.cuisines.mediterranean' => 'Mediterranean',
			'onboarding.options.cuisines.middleEastern' => 'Middle Eastern',
			'onboarding.options.cuisines.mexican' => 'Mexican',
			'onboarding.options.cuisines.indian' => 'Indian',
			'onboarding.options.cuisines.japanese' => 'Japanese',
			'onboarding.options.cuisines.korean' => 'Korean',
			'onboarding.options.cuisines.thai' => 'Thai',
			'onboarding.options.cuisines.chinese' => 'Chinese',
			'onboarding.options.cuisines.french' => 'French',
			'onboarding.options.cuisines.spanish' => 'Spanish',
			'onboarding.options.cuisines.greek' => 'Greek',
			'onboarding.options.cuisines.turkish' => 'Turkish',
			'onboarding.options.cuisines.vietnamese' => 'Vietnamese',
			'onboarding.options.cuisines.american' => 'American',
			'onboarding.options.cuisines.northAfrican' => 'North African',
			'onboarding.options.cuisines.latinAmerican' => 'Latin American',
			'onboarding.options.cuisines.nordic' => 'Nordic',
			'onboarding.options.cuisines.caribbean' => 'Caribbean',
			'onboarding.options.cuisines.african' => 'African',
			'onboarding.options.diets.vegetarian' => 'Vegetarian',
			'onboarding.options.diets.vegan' => 'Vegan',
			'onboarding.options.diets.glutenFree' => 'Gluten-free',
			'onboarding.options.diets.dairyFree' => 'Dairy-free',
			'onboarding.options.diets.nutFree' => 'Nut-free',
			'onboarding.options.diets.halal' => 'Halal',
			'onboarding.options.diets.kosher' => 'Kosher',
			'onboarding.options.diets.pescatarian' => 'Pescatarian',
			'onboarding.options.diets.lowCarb' => 'Low-carb',
			'onboarding.options.diets.lowSodium' => 'Low-sodium',
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
			'home.comingNext.eyebrow' => 'COMING NEXT',
			'home.comingNext.title' => 'Your recipe library.',
			'home.comingNext.body' => 'Saved recipes, collections, and a cooking view are on the way.',
			_ => null,
		};
	}
}
