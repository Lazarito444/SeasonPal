///
/// Generated file. Do not edit.
///
// coverage:ignore-file
// ignore_for_file: type=lint, unused_import
// dart format off

import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:slang/generated.dart';
import 'strings.g.dart';

// Path: <root>
class TranslationsEs extends Translations with BaseTranslations<AppLocale, Translations> {
	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	TranslationsEs({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver, TranslationMetadata<AppLocale, Translations>? meta})
		: assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
		  _meta = meta ?? TranslationMetadata(
		    locale: AppLocale.es,
		    overrides: overrides ?? {},
		    cardinalResolver: cardinalResolver,
		    ordinalResolver: ordinalResolver,
		  ),
		  super(cardinalResolver: cardinalResolver, ordinalResolver: ordinalResolver) {
		_meta.setFlatMapFunction(_flatMapFunction);
	}

	/// Metadata for the translations of <es>.
	final TranslationMetadata<AppLocale, Translations> _meta;
	@override TranslationMetadata<AppLocale, Translations> get $meta => _meta;

	/// Access flat map
	@override dynamic operator[](String key) => _meta.getTranslation(key) ?? super[key];

	late final TranslationsEs _root = this; // ignore: unused_field

	@override 
	TranslationsEs $copyWith({TranslationMetadata<AppLocale, Translations>? meta}) => TranslationsEs(meta: meta ?? this.$meta);

	// Translations
	@override late final _Translations$app$es app = _Translations$app$es._(_root);
	@override late final _Translations$common$es common = _Translations$common$es._(_root);
	@override late final _Translations$errors$es errors = _Translations$errors$es._(_root);
	@override late final _Translations$auth$es auth = _Translations$auth$es._(_root);
	@override late final _Translations$onboarding$es onboarding = _Translations$onboarding$es._(_root);
	@override late final _Translations$home$es home = _Translations$home$es._(_root);
}

// Path: app
class _Translations$app$es extends Translations$app$en {
	_Translations$app$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get tagline => 'Cocina con la temporada, guarda lo que amas.';
	@override String get privacyNote => 'Tus recetas siguen siendo tuyas.';
}

// Path: common
class _Translations$common$es extends Translations$common$en {
	_Translations$common$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get back => 'Atrás';
	@override String get tryAgain => 'Intentar de nuevo';
	@override String get showPassword => 'Mostrar contraseña';
	@override String get hidePassword => 'Ocultar contraseña';
}

// Path: errors
class _Translations$errors$es extends Translations$errors$en {
	_Translations$errors$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get generic => 'Algo salió mal. Inténtalo de nuevo.';
	@override String get connection => 'No pudimos conectar con SeasonPal. Revisa tu conexión e inténtalo de nuevo.';
	@override String get timeout => 'La cocina está tardando demasiado en responder. Inténtalo de nuevo.';
	@override String get sessionExpired => 'Tu sesión ha caducado. Inicia sesión de nuevo.';
	@override String get conflict => 'Esa acción entra en conflicto con los datos existentes.';
	@override String get rateLimited => 'Demasiados intentos. Espera un momento e inténtalo de nuevo.';
	@override String get server => 'Algo falló de nuestro lado. Inténtalo de nuevo.';
	@override String get invalidCredentials => 'El correo o la contraseña no son correctos.';
	@override String get emailTaken => 'Ya existe una cuenta con ese correo.';
}

// Path: auth
class _Translations$auth$es extends Translations$auth$en {
	_Translations$auth$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override late final _Translations$auth$login$es login = _Translations$auth$login$es._(_root);
	@override late final _Translations$auth$register$es register = _Translations$auth$register$es._(_root);
	@override late final _Translations$auth$splash$es splash = _Translations$auth$splash$es._(_root);
}

// Path: onboarding
class _Translations$onboarding$es extends Translations$onboarding$en {
	_Translations$onboarding$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String stepIndicator({required Object current, required Object total}) => 'PASO ${current} DE ${total}';
	@override late final _Translations$onboarding$welcome$es welcome = _Translations$onboarding$welcome$es._(_root);
	@override late final _Translations$onboarding$cuisines$es cuisines = _Translations$onboarding$cuisines$es._(_root);
	@override late final _Translations$onboarding$diet$es diet = _Translations$onboarding$diet$es._(_root);
	@override late final _Translations$onboarding$rhythm$es rhythm = _Translations$onboarding$rhythm$es._(_root);
	@override late final _Translations$onboarding$done$es done = _Translations$onboarding$done$es._(_root);
	@override late final _Translations$onboarding$footer$es footer = _Translations$onboarding$footer$es._(_root);
	@override String get saveError => 'No pudimos guardar tus preferencias. Inténtalo de nuevo.';
	@override late final _Translations$onboarding$time$es time = _Translations$onboarding$time$es._(_root);
	@override late final _Translations$onboarding$skill$es skill = _Translations$onboarding$skill$es._(_root);
	@override late final _Translations$onboarding$options$es options = _Translations$onboarding$options$es._(_root);
}

// Path: home
class _Translations$home$es extends Translations$home$en {
	_Translations$home$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get signOut => 'Cerrar sesión';
	@override late final _Translations$home$language$es language = _Translations$home$language$es._(_root);
	@override late final _Translations$home$greetings$es greetings = _Translations$home$greetings$es._(_root);
	@override String get whatCooking => '¿Qué cocinamos hoy?';
	@override late final _Translations$home$taste$es taste = _Translations$home$taste$es._(_root);
	@override late final _Translations$home$comingNext$es comingNext = _Translations$home$comingNext$es._(_root);
}

// Path: auth.login
class _Translations$auth$login$es extends Translations$auth$login$en {
	_Translations$auth$login$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Qué bueno verte.';
	@override String get subtitle => 'Inicia sesión y retoma la cocina donde la dejaste.';
	@override String get newHere => '¿Es tu primera vez en SeasonPal?';
	@override String get createAccount => 'Crear una cuenta';
	@override String get email => 'Correo electrónico';
	@override String get password => 'Contraseña';
	@override String get submit => 'Iniciar sesión';
	@override String get emailRequired => 'Escribe tu correo.';
	@override String get emailInvalid => 'Escribe un correo válido.';
	@override String get passwordRequired => 'Escribe tu contraseña.';
}

// Path: auth.register
class _Translations$auth$register$es extends Translations$auth$register$en {
	_Translations$auth$register$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Toma asiento.';
	@override String get subtitle => 'Crea tu cuenta y cuéntanos cómo te gusta cocinar para que las sugerencias encajen contigo.';
	@override String get alreadyHere => '¿Ya cocinas con nosotros?';
	@override String get signIn => 'Iniciar sesión';
	@override String get name => 'Nombre';
	@override String get nameHelper => 'Opcional: ¿cómo quieres que te llamemos?';
	@override String get nameTooLong => 'Mantén tu nombre en 80 caracteres.';
	@override String get email => 'Correo electrónico';
	@override String get password => 'Contraseña';
	@override String get passwordHelper => 'Al menos 8 caracteres.';
	@override String get submit => 'Crear cuenta';
	@override String get emailRequired => 'Escribe tu correo.';
	@override String get emailInvalid => 'Escribe un correo válido.';
	@override String get passwordRequired => 'Elige una contraseña.';
	@override String get passwordTooShort => 'Usa al menos 8 caracteres.';
}

// Path: auth.splash
class _Translations$auth$splash$es extends Translations$auth$splash$en {
	_Translations$auth$splash$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get restoreFailed => 'No pudimos restaurar tu sesión.';
	@override String get loading => 'Poniendo la mesa…';
}

// Path: onboarding.welcome
class _Translations$onboarding$welcome$es extends Translations$onboarding$welcome$en {
	_Translations$onboarding$welcome$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get eyebrow => 'UN POCO DE TI';
	@override String get title => 'Vamos a poner la mesa.';
	@override String get body => 'Unas preguntas para que SeasonPal sugiera platos que encajen con tu cocina, no con la de otra persona.';
	@override String get cuisineTitle => 'Cocinas que te gustan';
	@override String get cuisineBody => 'Los sabores que buscas en una semana normal.';
	@override String get dietTitle => 'Lo que evitas';
	@override String get dietBody => 'Alergias y dietas que siempre respetaremos.';
	@override String get timeTitle => 'El tiempo que tienes';
	@override String get timeBody => 'Una cena de martes no es lo mismo que un proyecto de domingo.';
	@override String get duration => 'Alrededor de un minuto, de principio a fin.';
}

// Path: onboarding.cuisines
class _Translations$onboarding$cuisines$es extends Translations$onboarding$cuisines$en {
	_Translations$onboarding$cuisines$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get eyebrow => 'Tu paladar';
	@override String get title => '¿Qué te apetece?';
	@override String get body => 'Elige las cocinas que más te llaman. Puedes escoger todas las que quieras.';
}

// Path: onboarding.diet
class _Translations$onboarding$diet$es extends Translations$onboarding$diet$en {
	_Translations$onboarding$diet$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get eyebrow => 'Tu mesa';
	@override String get title => '¿Algo fuera del menú?';
	@override String get body => 'Alergias, dietas o ingredientes que prefieres evitar. Elige todo lo que aplique.';
	@override String get interestsTitle => '¿Qué te interesa?';
	@override String get interestsBody => 'Opcional: nos ayuda a afinar las sugerencias.';
}

// Path: onboarding.rhythm
class _Translations$onboarding$rhythm$es extends Translations$onboarding$rhythm$en {
	_Translations$onboarding$rhythm$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get eyebrow => 'Tu ritmo';
	@override String get title => '¿Cómo te gusta cocinar?';
	@override String get body => 'Lo usamos para elegir técnicas y recetas que encajen contigo.';
	@override String get timeTitle => 'Tiempo en una noche normal';
	@override String get timeBody => 'Déjalo sin elegir si cambia de un día a otro.';
}

// Path: onboarding.done
class _Translations$onboarding$done$es extends Translations$onboarding$done$en {
	_Translations$onboarding$done$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Tu cocina está lista.';
	@override String get body => 'Esto es lo que usaremos para cocinar. Puedes cambiarlo más adelante.';
	@override String get openToAnything => 'Abierto a todo';
	@override String get noRestrictions => 'Sin restricciones';
	@override String get noTime => 'Sin tiempo fijo';
	@override String get summaryCuisines => 'Cocinas';
	@override String get summaryDiet => 'Dieta';
	@override String get summarySkill => 'Nivel';
	@override String get summaryTime => 'Tiempo habitual';
	@override String get alsoInto => 'También te gusta';
}

// Path: onboarding.footer
class _Translations$onboarding$footer$es extends Translations$onboarding$footer$en {
	_Translations$onboarding$footer$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get begin => 'Empezar';
	@override String get next => 'Continuar';
	@override String get finish => 'Terminar';
	@override String get saving => 'Guardando…';
}

// Path: onboarding.time
class _Translations$onboarding$time$es extends Translations$onboarding$time$en {
	_Translations$onboarding$time$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get hour => '1 hora';
	@override String get minSuffix => 'min';
}

// Path: onboarding.skill
class _Translations$onboarding$skill$es extends Translations$onboarding$skill$en {
	_Translations$onboarding$skill$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override late final _Translations$onboarding$skill$beginner$es beginner = _Translations$onboarding$skill$beginner$es._(_root);
	@override late final _Translations$onboarding$skill$intermediate$es intermediate = _Translations$onboarding$skill$intermediate$es._(_root);
	@override late final _Translations$onboarding$skill$advanced$es advanced = _Translations$onboarding$skill$advanced$es._(_root);
}

// Path: onboarding.options
class _Translations$onboarding$options$es extends Translations$onboarding$options$en {
	_Translations$onboarding$options$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override late final _Translations$onboarding$options$cuisines$es cuisines = _Translations$onboarding$options$cuisines$es._(_root);
	@override late final _Translations$onboarding$options$diets$es diets = _Translations$onboarding$options$diets$es._(_root);
	@override late final _Translations$onboarding$options$interests$es interests = _Translations$onboarding$options$interests$es._(_root);
}

// Path: home.language
class _Translations$home$language$es extends Translations$home$language$en {
	_Translations$home$language$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get tooltip => 'Idioma';
	@override String get english => 'English';
	@override String get spanish => 'Español';
}

// Path: home.greetings
class _Translations$home$greetings$es extends Translations$home$greetings$en {
	_Translations$home$greetings$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get morning => 'Buenos días';
	@override String get afternoon => 'Buenas tardes';
	@override String get evening => 'Buenas noches';
	@override String line({required Object greeting, required Object name}) => '${greeting}, ${name}.';
	@override String get friend => 'chef';
}

// Path: home.taste
class _Translations$home$taste$es extends Translations$home$taste$en {
	_Translations$home$taste$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get eyebrow => 'TU PALADAR';
	@override String get loading => 'Leyendo tu perfil de sabor…';
	@override String get loadError => 'No pudimos cargar tu perfil de sabor.';
	@override String get noTime => 'Sin tiempo fijo';
	@override String get empty => 'Tu cocina está abierta a todo.';
	@override String one({required Object cuisine}) => 'Tu cocina se inclina por la ${cuisine}.';
	@override String two({required Object first, required Object second}) => 'Tu cocina se inclina por la ${first} y la ${second}.';
	@override String many({required Object first, required Object second}) => 'Tu cocina se inclina por la ${first}, la ${second} y más.';
	@override String get noRestrictions => 'No hay restricciones dietéticas guardadas.';
	@override String dietOne({required Object restriction}) => 'Cocinando con una dieta ${restriction}.';
	@override String dietMany({required Object leading, required Object last}) => 'Cocinando con una dieta ${leading} y ${last}.';
}

// Path: home.comingNext
class _Translations$home$comingNext$es extends Translations$home$comingNext$en {
	_Translations$home$comingNext$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get eyebrow => 'LO QUE VIENE';
	@override String get title => 'Tu biblioteca de recetas.';
	@override String get body => 'Las recetas guardadas, las colecciones y el modo cocina están en camino.';
}

// Path: onboarding.skill.beginner
class _Translations$onboarding$skill$beginner$es extends Translations$onboarding$skill$beginner$en {
	_Translations$onboarding$skill$beginner$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get label => 'Principiante';
	@override String get description => 'Recetas sencillas y técnicas conocidas.';
}

// Path: onboarding.skill.intermediate
class _Translations$onboarding$skill$intermediate$es extends Translations$onboarding$skill$intermediate$en {
	_Translations$onboarding$skill$intermediate$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get label => 'Intermedio';
	@override String get description => 'Con ganas de probar métodos nuevos.';
}

// Path: onboarding.skill.advanced
class _Translations$onboarding$skill$advanced$es extends Translations$onboarding$skill$advanced$en {
	_Translations$onboarding$skill$advanced$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get label => 'Avanzado';
	@override String get description => 'Un buen desafío por delante.';
}

// Path: onboarding.options.cuisines
class _Translations$onboarding$options$cuisines$es extends Translations$onboarding$options$cuisines$en {
	_Translations$onboarding$options$cuisines$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get italian => 'italiana';
	@override String get mediterranean => 'mediterránea';
	@override String get middleEastern => 'medioriental';
	@override String get mexican => 'mexicana';
	@override String get indian => 'india';
	@override String get japanese => 'japonesa';
	@override String get korean => 'coreana';
	@override String get thai => 'tailandesa';
	@override String get chinese => 'china';
	@override String get french => 'francesa';
	@override String get spanish => 'española';
	@override String get greek => 'griega';
	@override String get turkish => 'turca';
	@override String get vietnamese => 'vietnamita';
	@override String get american => 'estadounidense';
	@override String get northAfrican => 'norteafricana';
	@override String get latinAmerican => 'latinoamericana';
	@override String get nordic => 'nórdica';
	@override String get caribbean => 'caribeña';
	@override String get african => 'africana';
}

// Path: onboarding.options.diets
class _Translations$onboarding$options$diets$es extends Translations$onboarding$options$diets$en {
	_Translations$onboarding$options$diets$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get vegetarian => 'vegetariana';
	@override String get vegan => 'vegana';
	@override String get glutenFree => 'sin gluten';
	@override String get dairyFree => 'sin lactosa';
	@override String get nutFree => 'sin frutos secos';
	@override String get halal => 'halal';
	@override String get kosher => 'kosher';
	@override String get pescatarian => 'pescetariana';
	@override String get lowCarb => 'baja en carbohidratos';
	@override String get lowSodium => 'baja en sodio';
}

// Path: onboarding.options.interests
class _Translations$onboarding$options$interests$es extends Translations$onboarding$options$interests$en {
	_Translations$onboarding$options$interests$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get weeknightDinners => 'Cenas entre semana';
	@override String get mealPrep => 'Preparar comidas';
	@override String get baking => 'Repostería';
	@override String get grilling => 'A la parrilla';
	@override String get slowCooking => 'Cocción lenta';
	@override String get fermentation => 'Fermentación';
	@override String get plantForward => 'Cocina vegetal';
	@override String get comfortFood => 'Comida reconfortante';
	@override String get entertaining => 'Recibir invitados';
	@override String get budgetCooking => 'Cocina económica';
	@override String get cookingWithKids => 'Cocinar con niños';
	@override String get spicesAndHeat => 'Especias y picante';
}

/// The flat map containing all translations for locale <es>.
/// Only for edge cases! For simple maps, use the map function of this library.
///
/// The Dart AOT compiler has issues with very large switch statements,
/// so the map is split into smaller functions (512 entries each).
extension on TranslationsEs {
	dynamic _flatMapFunction(String path) {
		return switch (path) {
			'app.tagline' => 'Cocina con la temporada, guarda lo que amas.',
			'app.privacyNote' => 'Tus recetas siguen siendo tuyas.',
			'common.back' => 'Atrás',
			'common.tryAgain' => 'Intentar de nuevo',
			'common.showPassword' => 'Mostrar contraseña',
			'common.hidePassword' => 'Ocultar contraseña',
			'errors.generic' => 'Algo salió mal. Inténtalo de nuevo.',
			'errors.connection' => 'No pudimos conectar con SeasonPal. Revisa tu conexión e inténtalo de nuevo.',
			'errors.timeout' => 'La cocina está tardando demasiado en responder. Inténtalo de nuevo.',
			'errors.sessionExpired' => 'Tu sesión ha caducado. Inicia sesión de nuevo.',
			'errors.conflict' => 'Esa acción entra en conflicto con los datos existentes.',
			'errors.rateLimited' => 'Demasiados intentos. Espera un momento e inténtalo de nuevo.',
			'errors.server' => 'Algo falló de nuestro lado. Inténtalo de nuevo.',
			'errors.invalidCredentials' => 'El correo o la contraseña no son correctos.',
			'errors.emailTaken' => 'Ya existe una cuenta con ese correo.',
			'auth.login.title' => 'Qué bueno verte.',
			'auth.login.subtitle' => 'Inicia sesión y retoma la cocina donde la dejaste.',
			'auth.login.newHere' => '¿Es tu primera vez en SeasonPal?',
			'auth.login.createAccount' => 'Crear una cuenta',
			'auth.login.email' => 'Correo electrónico',
			'auth.login.password' => 'Contraseña',
			'auth.login.submit' => 'Iniciar sesión',
			'auth.login.emailRequired' => 'Escribe tu correo.',
			'auth.login.emailInvalid' => 'Escribe un correo válido.',
			'auth.login.passwordRequired' => 'Escribe tu contraseña.',
			'auth.register.title' => 'Toma asiento.',
			'auth.register.subtitle' => 'Crea tu cuenta y cuéntanos cómo te gusta cocinar para que las sugerencias encajen contigo.',
			'auth.register.alreadyHere' => '¿Ya cocinas con nosotros?',
			'auth.register.signIn' => 'Iniciar sesión',
			'auth.register.name' => 'Nombre',
			'auth.register.nameHelper' => 'Opcional: ¿cómo quieres que te llamemos?',
			'auth.register.nameTooLong' => 'Mantén tu nombre en 80 caracteres.',
			'auth.register.email' => 'Correo electrónico',
			'auth.register.password' => 'Contraseña',
			'auth.register.passwordHelper' => 'Al menos 8 caracteres.',
			'auth.register.submit' => 'Crear cuenta',
			'auth.register.emailRequired' => 'Escribe tu correo.',
			'auth.register.emailInvalid' => 'Escribe un correo válido.',
			'auth.register.passwordRequired' => 'Elige una contraseña.',
			'auth.register.passwordTooShort' => 'Usa al menos 8 caracteres.',
			'auth.splash.restoreFailed' => 'No pudimos restaurar tu sesión.',
			'auth.splash.loading' => 'Poniendo la mesa…',
			'onboarding.stepIndicator' => ({required Object current, required Object total}) => 'PASO ${current} DE ${total}',
			'onboarding.welcome.eyebrow' => 'UN POCO DE TI',
			'onboarding.welcome.title' => 'Vamos a poner la mesa.',
			'onboarding.welcome.body' => 'Unas preguntas para que SeasonPal sugiera platos que encajen con tu cocina, no con la de otra persona.',
			'onboarding.welcome.cuisineTitle' => 'Cocinas que te gustan',
			'onboarding.welcome.cuisineBody' => 'Los sabores que buscas en una semana normal.',
			'onboarding.welcome.dietTitle' => 'Lo que evitas',
			'onboarding.welcome.dietBody' => 'Alergias y dietas que siempre respetaremos.',
			'onboarding.welcome.timeTitle' => 'El tiempo que tienes',
			'onboarding.welcome.timeBody' => 'Una cena de martes no es lo mismo que un proyecto de domingo.',
			'onboarding.welcome.duration' => 'Alrededor de un minuto, de principio a fin.',
			'onboarding.cuisines.eyebrow' => 'Tu paladar',
			'onboarding.cuisines.title' => '¿Qué te apetece?',
			'onboarding.cuisines.body' => 'Elige las cocinas que más te llaman. Puedes escoger todas las que quieras.',
			'onboarding.diet.eyebrow' => 'Tu mesa',
			'onboarding.diet.title' => '¿Algo fuera del menú?',
			'onboarding.diet.body' => 'Alergias, dietas o ingredientes que prefieres evitar. Elige todo lo que aplique.',
			'onboarding.diet.interestsTitle' => '¿Qué te interesa?',
			'onboarding.diet.interestsBody' => 'Opcional: nos ayuda a afinar las sugerencias.',
			'onboarding.rhythm.eyebrow' => 'Tu ritmo',
			'onboarding.rhythm.title' => '¿Cómo te gusta cocinar?',
			'onboarding.rhythm.body' => 'Lo usamos para elegir técnicas y recetas que encajen contigo.',
			'onboarding.rhythm.timeTitle' => 'Tiempo en una noche normal',
			'onboarding.rhythm.timeBody' => 'Déjalo sin elegir si cambia de un día a otro.',
			'onboarding.done.title' => 'Tu cocina está lista.',
			'onboarding.done.body' => 'Esto es lo que usaremos para cocinar. Puedes cambiarlo más adelante.',
			'onboarding.done.openToAnything' => 'Abierto a todo',
			'onboarding.done.noRestrictions' => 'Sin restricciones',
			'onboarding.done.noTime' => 'Sin tiempo fijo',
			'onboarding.done.summaryCuisines' => 'Cocinas',
			'onboarding.done.summaryDiet' => 'Dieta',
			'onboarding.done.summarySkill' => 'Nivel',
			'onboarding.done.summaryTime' => 'Tiempo habitual',
			'onboarding.done.alsoInto' => 'También te gusta',
			'onboarding.footer.begin' => 'Empezar',
			'onboarding.footer.next' => 'Continuar',
			'onboarding.footer.finish' => 'Terminar',
			'onboarding.footer.saving' => 'Guardando…',
			'onboarding.saveError' => 'No pudimos guardar tus preferencias. Inténtalo de nuevo.',
			'onboarding.time.hour' => '1 hora',
			'onboarding.time.minSuffix' => 'min',
			'onboarding.skill.beginner.label' => 'Principiante',
			'onboarding.skill.beginner.description' => 'Recetas sencillas y técnicas conocidas.',
			'onboarding.skill.intermediate.label' => 'Intermedio',
			'onboarding.skill.intermediate.description' => 'Con ganas de probar métodos nuevos.',
			'onboarding.skill.advanced.label' => 'Avanzado',
			'onboarding.skill.advanced.description' => 'Un buen desafío por delante.',
			'onboarding.options.cuisines.italian' => 'italiana',
			'onboarding.options.cuisines.mediterranean' => 'mediterránea',
			'onboarding.options.cuisines.middleEastern' => 'medioriental',
			'onboarding.options.cuisines.mexican' => 'mexicana',
			'onboarding.options.cuisines.indian' => 'india',
			'onboarding.options.cuisines.japanese' => 'japonesa',
			'onboarding.options.cuisines.korean' => 'coreana',
			'onboarding.options.cuisines.thai' => 'tailandesa',
			'onboarding.options.cuisines.chinese' => 'china',
			'onboarding.options.cuisines.french' => 'francesa',
			'onboarding.options.cuisines.spanish' => 'española',
			'onboarding.options.cuisines.greek' => 'griega',
			'onboarding.options.cuisines.turkish' => 'turca',
			'onboarding.options.cuisines.vietnamese' => 'vietnamita',
			'onboarding.options.cuisines.american' => 'estadounidense',
			'onboarding.options.cuisines.northAfrican' => 'norteafricana',
			'onboarding.options.cuisines.latinAmerican' => 'latinoamericana',
			'onboarding.options.cuisines.nordic' => 'nórdica',
			'onboarding.options.cuisines.caribbean' => 'caribeña',
			'onboarding.options.cuisines.african' => 'africana',
			'onboarding.options.diets.vegetarian' => 'vegetariana',
			'onboarding.options.diets.vegan' => 'vegana',
			'onboarding.options.diets.glutenFree' => 'sin gluten',
			'onboarding.options.diets.dairyFree' => 'sin lactosa',
			'onboarding.options.diets.nutFree' => 'sin frutos secos',
			'onboarding.options.diets.halal' => 'halal',
			'onboarding.options.diets.kosher' => 'kosher',
			'onboarding.options.diets.pescatarian' => 'pescetariana',
			'onboarding.options.diets.lowCarb' => 'baja en carbohidratos',
			'onboarding.options.diets.lowSodium' => 'baja en sodio',
			'onboarding.options.interests.weeknightDinners' => 'Cenas entre semana',
			'onboarding.options.interests.mealPrep' => 'Preparar comidas',
			'onboarding.options.interests.baking' => 'Repostería',
			'onboarding.options.interests.grilling' => 'A la parrilla',
			'onboarding.options.interests.slowCooking' => 'Cocción lenta',
			'onboarding.options.interests.fermentation' => 'Fermentación',
			'onboarding.options.interests.plantForward' => 'Cocina vegetal',
			'onboarding.options.interests.comfortFood' => 'Comida reconfortante',
			'onboarding.options.interests.entertaining' => 'Recibir invitados',
			'onboarding.options.interests.budgetCooking' => 'Cocina económica',
			'onboarding.options.interests.cookingWithKids' => 'Cocinar con niños',
			'onboarding.options.interests.spicesAndHeat' => 'Especias y picante',
			'home.signOut' => 'Cerrar sesión',
			'home.language.tooltip' => 'Idioma',
			'home.language.english' => 'English',
			'home.language.spanish' => 'Español',
			'home.greetings.morning' => 'Buenos días',
			'home.greetings.afternoon' => 'Buenas tardes',
			'home.greetings.evening' => 'Buenas noches',
			'home.greetings.line' => ({required Object greeting, required Object name}) => '${greeting}, ${name}.',
			'home.greetings.friend' => 'chef',
			'home.whatCooking' => '¿Qué cocinamos hoy?',
			'home.taste.eyebrow' => 'TU PALADAR',
			'home.taste.loading' => 'Leyendo tu perfil de sabor…',
			'home.taste.loadError' => 'No pudimos cargar tu perfil de sabor.',
			'home.taste.noTime' => 'Sin tiempo fijo',
			'home.taste.empty' => 'Tu cocina está abierta a todo.',
			'home.taste.one' => ({required Object cuisine}) => 'Tu cocina se inclina por la ${cuisine}.',
			'home.taste.two' => ({required Object first, required Object second}) => 'Tu cocina se inclina por la ${first} y la ${second}.',
			'home.taste.many' => ({required Object first, required Object second}) => 'Tu cocina se inclina por la ${first}, la ${second} y más.',
			'home.taste.noRestrictions' => 'No hay restricciones dietéticas guardadas.',
			'home.taste.dietOne' => ({required Object restriction}) => 'Cocinando con una dieta ${restriction}.',
			'home.taste.dietMany' => ({required Object leading, required Object last}) => 'Cocinando con una dieta ${leading} y ${last}.',
			'home.comingNext.eyebrow' => 'LO QUE VIENE',
			'home.comingNext.title' => 'Tu biblioteca de recetas.',
			'home.comingNext.body' => 'Las recetas guardadas, las colecciones y el modo cocina están en camino.',
			_ => null,
		};
	}
}
