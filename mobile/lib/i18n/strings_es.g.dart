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
	@override late final _Translations$navigation$es navigation = _Translations$navigation$es._(_root);
	@override late final _Translations$comingSoon$es comingSoon = _Translations$comingSoon$es._(_root);
	@override late final _Translations$recipes$es recipes = _Translations$recipes$es._(_root);
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
	@override String get cancel => 'Cancelar';
	@override String get delete => 'Eliminar';
	@override String get dismiss => 'Cerrar';
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
	@override String get publishIncomplete => 'Añade al menos un ingrediente y un paso antes de publicar.';
	@override String get collectionNameTaken => 'Ya tienes una colección con ese nombre.';
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
	@override late final _Translations$home$library$es library = _Translations$home$library$es._(_root);
}

// Path: navigation
class _Translations$navigation$es extends Translations$navigation$en {
	_Translations$navigation$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get home => 'Inicio';
	@override String get discover => 'Descubrir';
	@override String get aiCook => 'Cocina IA';
	@override String get myRecipes => 'Mis recetas';
	@override String get profile => 'Perfil';
}

// Path: comingSoon
class _Translations$comingSoon$es extends Translations$comingSoon$en {
	_Translations$comingSoon$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get badge => 'PRÓXIMAMENTE';
	@override late final _Translations$comingSoon$discover$es discover = _Translations$comingSoon$discover$es._(_root);
	@override late final _Translations$comingSoon$aiCook$es aiCook = _Translations$comingSoon$aiCook$es._(_root);
	@override late final _Translations$comingSoon$profile$es profile = _Translations$comingSoon$profile$es._(_root);
}

// Path: recipes
class _Translations$recipes$es extends Translations$recipes$en {
	_Translations$recipes$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override late final _Translations$recipes$mealTypes$es mealTypes = _Translations$recipes$mealTypes$es._(_root);
	@override late final _Translations$recipes$difficulty$es difficulty = _Translations$recipes$difficulty$es._(_root);
	@override late final _Translations$recipes$library$es library = _Translations$recipes$library$es._(_root);
	@override late final _Translations$recipes$detail$es detail = _Translations$recipes$detail$es._(_root);
	@override late final _Translations$recipes$saveSheet$es saveSheet = _Translations$recipes$saveSheet$es._(_root);
	@override late final _Translations$recipes$collections$es collections = _Translations$recipes$collections$es._(_root);
	@override late final _Translations$recipes$editor$es editor = _Translations$recipes$editor$es._(_root);
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
	@override String get passwordHelper => '8+ caracteres con mayúsculas, minúsculas, un número y un símbolo.';
	@override String get submit => 'Crear cuenta';
	@override String get emailRequired => 'Escribe tu correo.';
	@override String get emailInvalid => 'Escribe un correo válido.';
	@override String get passwordRequired => 'Elige una contraseña.';
	@override String get passwordTooShort => 'Usa al menos 8 caracteres.';
	@override String get passwordTooWeak => 'Añade mayúsculas, minúsculas, un número y un símbolo.';
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

// Path: home.library
class _Translations$home$library$es extends Translations$home$library$en {
	_Translations$home$library$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get eyebrow => 'TUS RECETAS';
	@override String get title => 'Tu recetario.';
	@override String get body => 'Tus platos guardados, tus colecciones y tus propias recetas, listos cuando tú lo estés.';
	@override String get action => 'Abrir mis recetas';
}

// Path: comingSoon.discover
class _Translations$comingSoon$discover$es extends Translations$comingSoon$discover$en {
	_Translations$comingSoon$discover$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get eyebrow => 'DESCUBRIR';
	@override String get title => 'Una mesa más amplia.';
	@override String get body => 'La búsqueda, los filtros por cocina y las recetas de otras personas llegan en la próxima etapa. Tu recetario ya está listo.';
}

// Path: comingSoon.aiCook
class _Translations$comingSoon$aiCook$es extends Translations$comingSoon$aiCook$en {
	_Translations$comingSoon$aiCook$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get eyebrow => 'COCINA IA';
	@override String get title => 'Un sous-chef, pronto.';
	@override String get body => 'Pregunta por sustituciones, planifica con lo que hay en la despensa y adapta recetas. Las claves se quedan en el servidor, nunca en la app.';
}

// Path: comingSoon.profile
class _Translations$comingSoon$profile$es extends Translations$comingSoon$profile$en {
	_Translations$comingSoon$profile$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get eyebrow => 'PERFIL';
	@override String get title => 'Tu rincón.';
	@override String get body => 'Tus preferencias, recetas publicadas y ajustes de cuenta vivirán aquí. Por ahora, cerrar sesión y el idioma siguen en Inicio.';
}

// Path: recipes.mealTypes
class _Translations$recipes$mealTypes$es extends Translations$recipes$mealTypes$en {
	_Translations$recipes$mealTypes$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get unspecified => 'Cualquier momento';
	@override String get breakfast => 'Desayuno';
	@override String get lunch => 'Almuerzo';
	@override String get dinner => 'Cena';
	@override String get snack => 'Tentempié';
	@override String get dessert => 'Postre';
	@override String get drink => 'Bebida';
}

// Path: recipes.difficulty
class _Translations$recipes$difficulty$es extends Translations$recipes$difficulty$en {
	_Translations$recipes$difficulty$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get easy => 'Fácil';
	@override String get medium => 'Media';
	@override String get hard => 'Difícil';
}

// Path: recipes.library
class _Translations$recipes$library$es extends Translations$recipes$library$en {
	_Translations$recipes$library$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get eyebrow => 'TU COCINA';
	@override String get title => 'Mis recetas';
	@override String get subtitle => 'Lo que has escrito y lo que has guardado, en un mismo sitio.';
	@override String get newRecipe => 'Nueva receta';
	@override String get collections => 'Colecciones';
	@override String get mine => 'Mías';
	@override String get saved => 'Guardadas';
	@override String get loading => 'Abriendo tu recetario…';
	@override String get loadError => 'No pudimos cargar tus recetas.';
	@override String get loadMoreError => 'No pudimos cargar más recetas.';
	@override String get emptyOwnTitle => 'Tu primera receta empieza aquí.';
	@override String get emptyOwnBody => 'Apunta un plato que ya cocinas. Las fotos y los pasos pueden llegar después.';
	@override String get emptySavedTitle => 'Aún no has guardado nada.';
	@override String get emptySavedBody => 'Pulsa Guardar en cualquier receta y aparecerá aquí para otra noche.';
	@override String get draft => 'BORRADOR';
	@override String get ai => 'IA';
	@override String minutes({required Object count}) => '${count} min';
	@override String seconds({required Object count}) => '${count} s';
	@override String servings({required Object count}) => 'Para ${count}';
	@override String get servingsOne => 'Para 1';
}

// Path: recipes.detail
class _Translations$recipes$detail$es extends Translations$recipes$detail$en {
	_Translations$recipes$detail$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String by({required Object name}) => 'Por ${name}';
	@override String get ingredients => 'Ingredientes';
	@override String get method => 'Elaboración';
	@override String get media => 'Fotos y vídeo';
	@override String get tags => 'Etiquetas';
	@override String get save => 'Guardar receta';
	@override String get saved => 'Guardada';
	@override String get savedMessage => 'Guardada en tu biblioteca.';
	@override String get unsavedMessage => 'Quitada de tu biblioteca.';
	@override String get noIngredients => 'Todavía no hay ingredientes.';
	@override String get noSteps => 'Todavía no hay pasos escritos.';
	@override String get aiNote => 'Hecha con IA: léela antes de cocinar.';
	@override String get video => 'Vídeo';
	@override String get publishedBadge => 'PÚBLICA';
	@override String get edit => 'Editar receta';
	@override String get publish => 'Publicar receta';
	@override String get unpublish => 'Hacer privada';
	@override String get delete => 'Eliminar receta';
	@override String get more => 'Acciones de la receta';
	@override String get deleteTitle => '¿Eliminar esta receta?';
	@override String get deleteBody => 'Saldrá de tu biblioteca y de todas tus colecciones. No se puede deshacer.';
	@override String get loadError => 'No pudimos cargar esta receta.';
	@override String get notFoundTitle => 'Esta receta no está aquí.';
	@override String get notFoundBody => 'Puede que se haya eliminado o se haya hecho privada.';
	@override String get actionError => 'No funcionó. Inténtalo de nuevo.';
	@override String get published => 'Receta publicada.';
	@override String get unpublished => 'La receta vuelve a ser privada.';
}

// Path: recipes.saveSheet
class _Translations$recipes$saveSheet$es extends Translations$recipes$saveSheet$en {
	_Translations$recipes$saveSheet$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Guardar en una colección';
	@override String get favoritesBody => 'Al guardar, la receta siempre entra en Favoritos.';
	@override String get favorites => 'Guardar en favoritos';
	@override String get savedStatus => 'Guardada en tu biblioteca.';
	@override String get unsave => 'Quitar';
	@override String get collections => 'AÑADIR A UNA COLECCIÓN';
	@override String get collectionsError => 'No pudimos cargar tus colecciones.';
	@override String get noCollections => 'Aún no hay colecciones. Crea una abajo.';
	@override String get newCollection => 'Nueva colección';
	@override String get createTitle => 'Ponle nombre a la colección';
	@override String get nameLabel => 'Nombre de la colección';
	@override String get nameHint => 'Cenas de entre semana, domingo de horno…';
	@override String get nameRequired => 'Ponle nombre a la colección.';
	@override String get create => 'Crear';
	@override String get createError => 'No pudimos crear la colección. Inténtalo de nuevo.';
	@override String get saveError => 'No pudimos guardar la receta. Inténtalo de nuevo.';
}

// Path: recipes.collections
class _Translations$recipes$collections$es extends Translations$recipes$collections$en {
	_Translations$recipes$collections$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get eyebrow => 'TU COCINA';
	@override String get title => 'Colecciones';
	@override String get subtitle => 'Agrupa recetas para una noche, una temporada o una mesa.';
	@override String get newCollection => 'Nueva colección';
	@override String get loadError => 'No pudimos cargar tus colecciones.';
	@override String count({required Object count}) => '${count} recetas';
	@override String get countOne => '1 receta';
	@override String get favorites => 'Favoritos';
	@override String get emptyTitle => 'Aún no hay colecciones.';
	@override String get emptyBody => 'Agrupa recetas para una noche, una temporada o una cena con gente.';
	@override String get emptyCollection => 'Esta colección está vacía.';
	@override String get emptyCollectionBody => 'Guarda una receta en ella desde su página.';
	@override String get remove => 'Quitar';
	@override String get removeTitle => '¿Quitar esta receta?';
	@override String get removeBody => 'Sigue en tu biblioteca guardada.';
	@override String get removeError => 'No pudimos quitar la receta. Inténtalo de nuevo.';
	@override String get delete => 'Eliminar colección';
	@override String get deleteTitle => '¿Eliminar esta colección?';
	@override String get deleteBody => 'Las recetas siguen en tu biblioteca; solo desaparece la colección.';
	@override String get deleteError => 'No pudimos eliminar la colección. Inténtalo de nuevo.';
}

// Path: recipes.editor
class _Translations$recipes$editor$es extends Translations$recipes$editor$en {
	_Translations$recipes$editor$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get newEyebrow => 'UN PLATO NUEVO';
	@override String get newTitle => 'Ponlo por escrito.';
	@override String get newBody => 'Siete secciones cortas. Puedes guardar un borrador en cualquier momento: solo hace falta el nombre.';
	@override String get editEyebrow => 'EDITANDO';
	@override String get editTitle => 'Afina el plato.';
	@override String get editBody => 'Cambia lo que quieras. La publicación se queda como estaba salvo que publiques al guardar.';
	@override String get save => 'Guardar receta';
	@override String get saving => 'Guardando…';
	@override String get saveAndPublish => 'Guardar y publicar';
	@override String get saveError => 'No pudimos guardar la receta. Inténtalo de nuevo.';
	@override String get loadError => 'No pudimos cargar esta receta para editarla.';
	@override late final _Translations$recipes$editor$basics$es basics = _Translations$recipes$editor$basics$es._(_root);
	@override late final _Translations$recipes$editor$plate$es plate = _Translations$recipes$editor$plate$es._(_root);
	@override late final _Translations$recipes$editor$time$es time = _Translations$recipes$editor$time$es._(_root);
	@override late final _Translations$recipes$editor$photos$es photos = _Translations$recipes$editor$photos$es._(_root);
	@override late final _Translations$recipes$editor$ingredients$es ingredients = _Translations$recipes$editor$ingredients$es._(_root);
	@override late final _Translations$recipes$editor$steps$es steps = _Translations$recipes$editor$steps$es._(_root);
	@override late final _Translations$recipes$editor$tags$es tags = _Translations$recipes$editor$tags$es._(_root);
	@override late final _Translations$recipes$editor$publish$es publish = _Translations$recipes$editor$publish$es._(_root);
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

// Path: recipes.editor.basics
class _Translations$recipes$editor$basics$es extends Translations$recipes$editor$basics$en {
	_Translations$recipes$editor$basics$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get eyebrow => 'LO BÁSICO';
	@override String get title => 'Lo básico';
	@override String get name => 'Nombre de la receta';
	@override String get nameHint => 'Pollo asado con limón y tomillo';
	@override String get nameRequired => 'Ponle nombre a la receta.';
	@override String get description => 'Descripción';
	@override String get descriptionHint => 'Qué es y por qué lo cocinas.';
}

// Path: recipes.editor.plate
class _Translations$recipes$editor$plate$es extends Translations$recipes$editor$plate$en {
	_Translations$recipes$editor$plate$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get eyebrow => 'EL PLATO';
	@override String get title => 'Cómo se come';
	@override String get cuisine => 'Cocina';
	@override String get cuisineHint => 'Italiana, tailandesa, levantina…';
	@override String get meal => 'Comida';
}

// Path: recipes.editor.time
class _Translations$recipes$editor$time$es extends Translations$recipes$editor$time$en {
	_Translations$recipes$editor$time$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get eyebrow => 'TIEMPO';
	@override String get title => 'Tiempo al fuego';
	@override String get prep => 'Preparación (min)';
	@override String get cook => 'Cocción (min)';
	@override String get servings => 'Raciones';
	@override String get difficulty => 'Dificultad';
	@override String get invalid => 'Usa minutos enteros entre 0 y 1440.';
}

// Path: recipes.editor.photos
class _Translations$recipes$editor$photos$es extends Translations$recipes$editor$photos$en {
	_Translations$recipes$editor$photos$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get eyebrow => 'FOTOS';
	@override String get title => 'Muestra el plato';
	@override String get chooseCover => 'Elegir portada';
	@override String get changeCover => 'Cambiar portada';
	@override String get removeCover => 'Quitar portada';
	@override String get more => 'Más fotos y vídeo';
	@override String get addPhoto => 'Añadir foto';
	@override String get addVideo => 'Añadir vídeo';
	@override String get uploading => 'Subiendo…';
	@override String get uploadError => 'No se pudo subir. Inténtalo de nuevo.';
	@override String get tooLarge => 'El archivo es demasiado grande. Las fotos admiten 10 MB y el vídeo 24 MB.';
	@override String get tooMany => 'Una receta puede tener hasta 20 fotos y vídeos.';
	@override String get unsupported => 'Elige un archivo JPEG, PNG, WebP, GIF, MP4 o MOV.';
}

// Path: recipes.editor.ingredients
class _Translations$recipes$editor$ingredients$es extends Translations$recipes$editor$ingredients$en {
	_Translations$recipes$editor$ingredients$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get eyebrow => 'INGREDIENTES';
	@override String get title => 'Qué lleva';
	@override String get quantity => 'Cant.';
	@override String get unit => 'Unidad';
	@override String get name => 'Ingrediente';
	@override String get note => 'Nota (opcional)';
	@override String get add => 'Añadir ingrediente';
	@override String get remove => 'Quitar ingrediente';
	@override String get moveUp => 'Subir';
	@override String get moveDown => 'Bajar';
	@override String get nameRequired => 'Pon nombre a cada ingrediente que rellenes.';
	@override String get quantityInvalid => 'Las cantidades deben ser cero o más.';
}

// Path: recipes.editor.steps
class _Translations$recipes$editor$steps$es extends Translations$recipes$editor$steps$en {
	_Translations$recipes$editor$steps$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get eyebrow => 'ELABORACIÓN';
	@override String get title => 'Cómo se cocina';
	@override String get instruction => 'Paso';
	@override String get tip => 'Consejo (opcional)';
	@override String get timer => 'Temporizador (min, opcional)';
	@override String get add => 'Añadir paso';
	@override String get remove => 'Quitar paso';
	@override String get instructionRequired => 'Escribe cada paso que rellenes.';
	@override String get timerInvalid => 'El temporizador necesita minutos enteros entre 1 y 1440.';
}

// Path: recipes.editor.tags
class _Translations$recipes$editor$tags$es extends Translations$recipes$editor$tags$en {
	_Translations$recipes$editor$tags$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get eyebrow => 'DETALLES';
	@override String get title => 'Un poco más';
	@override String get body => 'Las etiquetas te ayudan a encontrar la receta después. Las dietéticas las ve cualquiera que pueda verla.';
	@override String get tags => 'Etiquetas';
	@override String get tagsHint => 'Entre semana, una sartén…';
	@override String get dietaryTags => 'Etiquetas dietéticas';
	@override String get dietaryHint => 'Vegetariano, sin gluten…';
	@override String get add => 'Añadir etiqueta';
}

// Path: recipes.editor.publish
class _Translations$recipes$editor$publish$es extends Translations$recipes$editor$publish$en {
	_Translations$recipes$editor$publish$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get label => 'Publicar al guardar';
	@override String get body => 'Las recetas publicadas pueden aparecer en Descubrir. Puedes hacerla privada cuando quieras.';
	@override String get incomplete => 'Añade al menos un ingrediente y un paso antes de publicar.';
	@override String get failed => 'La receta se guardó, pero no se pudo publicar. Inténtalo desde la página de la receta.';
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
			'common.cancel' => 'Cancelar',
			'common.delete' => 'Eliminar',
			'common.dismiss' => 'Cerrar',
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
			'errors.publishIncomplete' => 'Añade al menos un ingrediente y un paso antes de publicar.',
			'errors.collectionNameTaken' => 'Ya tienes una colección con ese nombre.',
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
			'auth.register.passwordHelper' => '8+ caracteres con mayúsculas, minúsculas, un número y un símbolo.',
			'auth.register.submit' => 'Crear cuenta',
			'auth.register.emailRequired' => 'Escribe tu correo.',
			'auth.register.emailInvalid' => 'Escribe un correo válido.',
			'auth.register.passwordRequired' => 'Elige una contraseña.',
			'auth.register.passwordTooShort' => 'Usa al menos 8 caracteres.',
			'auth.register.passwordTooWeak' => 'Añade mayúsculas, minúsculas, un número y un símbolo.',
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
			'home.library.eyebrow' => 'TUS RECETAS',
			'home.library.title' => 'Tu recetario.',
			'home.library.body' => 'Tus platos guardados, tus colecciones y tus propias recetas, listos cuando tú lo estés.',
			'home.library.action' => 'Abrir mis recetas',
			'navigation.home' => 'Inicio',
			'navigation.discover' => 'Descubrir',
			'navigation.aiCook' => 'Cocina IA',
			'navigation.myRecipes' => 'Mis recetas',
			'navigation.profile' => 'Perfil',
			'comingSoon.badge' => 'PRÓXIMAMENTE',
			'comingSoon.discover.eyebrow' => 'DESCUBRIR',
			'comingSoon.discover.title' => 'Una mesa más amplia.',
			'comingSoon.discover.body' => 'La búsqueda, los filtros por cocina y las recetas de otras personas llegan en la próxima etapa. Tu recetario ya está listo.',
			'comingSoon.aiCook.eyebrow' => 'COCINA IA',
			'comingSoon.aiCook.title' => 'Un sous-chef, pronto.',
			'comingSoon.aiCook.body' => 'Pregunta por sustituciones, planifica con lo que hay en la despensa y adapta recetas. Las claves se quedan en el servidor, nunca en la app.',
			'comingSoon.profile.eyebrow' => 'PERFIL',
			'comingSoon.profile.title' => 'Tu rincón.',
			'comingSoon.profile.body' => 'Tus preferencias, recetas publicadas y ajustes de cuenta vivirán aquí. Por ahora, cerrar sesión y el idioma siguen en Inicio.',
			'recipes.mealTypes.unspecified' => 'Cualquier momento',
			'recipes.mealTypes.breakfast' => 'Desayuno',
			'recipes.mealTypes.lunch' => 'Almuerzo',
			'recipes.mealTypes.dinner' => 'Cena',
			'recipes.mealTypes.snack' => 'Tentempié',
			'recipes.mealTypes.dessert' => 'Postre',
			'recipes.mealTypes.drink' => 'Bebida',
			'recipes.difficulty.easy' => 'Fácil',
			'recipes.difficulty.medium' => 'Media',
			'recipes.difficulty.hard' => 'Difícil',
			'recipes.library.eyebrow' => 'TU COCINA',
			'recipes.library.title' => 'Mis recetas',
			'recipes.library.subtitle' => 'Lo que has escrito y lo que has guardado, en un mismo sitio.',
			'recipes.library.newRecipe' => 'Nueva receta',
			'recipes.library.collections' => 'Colecciones',
			'recipes.library.mine' => 'Mías',
			'recipes.library.saved' => 'Guardadas',
			'recipes.library.loading' => 'Abriendo tu recetario…',
			'recipes.library.loadError' => 'No pudimos cargar tus recetas.',
			'recipes.library.loadMoreError' => 'No pudimos cargar más recetas.',
			'recipes.library.emptyOwnTitle' => 'Tu primera receta empieza aquí.',
			'recipes.library.emptyOwnBody' => 'Apunta un plato que ya cocinas. Las fotos y los pasos pueden llegar después.',
			'recipes.library.emptySavedTitle' => 'Aún no has guardado nada.',
			'recipes.library.emptySavedBody' => 'Pulsa Guardar en cualquier receta y aparecerá aquí para otra noche.',
			'recipes.library.draft' => 'BORRADOR',
			'recipes.library.ai' => 'IA',
			'recipes.library.minutes' => ({required Object count}) => '${count} min',
			'recipes.library.seconds' => ({required Object count}) => '${count} s',
			'recipes.library.servings' => ({required Object count}) => 'Para ${count}',
			'recipes.library.servingsOne' => 'Para 1',
			'recipes.detail.by' => ({required Object name}) => 'Por ${name}',
			'recipes.detail.ingredients' => 'Ingredientes',
			'recipes.detail.method' => 'Elaboración',
			'recipes.detail.media' => 'Fotos y vídeo',
			'recipes.detail.tags' => 'Etiquetas',
			'recipes.detail.save' => 'Guardar receta',
			'recipes.detail.saved' => 'Guardada',
			'recipes.detail.savedMessage' => 'Guardada en tu biblioteca.',
			'recipes.detail.unsavedMessage' => 'Quitada de tu biblioteca.',
			'recipes.detail.noIngredients' => 'Todavía no hay ingredientes.',
			'recipes.detail.noSteps' => 'Todavía no hay pasos escritos.',
			'recipes.detail.aiNote' => 'Hecha con IA: léela antes de cocinar.',
			'recipes.detail.video' => 'Vídeo',
			'recipes.detail.publishedBadge' => 'PÚBLICA',
			'recipes.detail.edit' => 'Editar receta',
			'recipes.detail.publish' => 'Publicar receta',
			'recipes.detail.unpublish' => 'Hacer privada',
			'recipes.detail.delete' => 'Eliminar receta',
			'recipes.detail.more' => 'Acciones de la receta',
			'recipes.detail.deleteTitle' => '¿Eliminar esta receta?',
			'recipes.detail.deleteBody' => 'Saldrá de tu biblioteca y de todas tus colecciones. No se puede deshacer.',
			'recipes.detail.loadError' => 'No pudimos cargar esta receta.',
			'recipes.detail.notFoundTitle' => 'Esta receta no está aquí.',
			'recipes.detail.notFoundBody' => 'Puede que se haya eliminado o se haya hecho privada.',
			'recipes.detail.actionError' => 'No funcionó. Inténtalo de nuevo.',
			'recipes.detail.published' => 'Receta publicada.',
			'recipes.detail.unpublished' => 'La receta vuelve a ser privada.',
			'recipes.saveSheet.title' => 'Guardar en una colección',
			'recipes.saveSheet.favoritesBody' => 'Al guardar, la receta siempre entra en Favoritos.',
			'recipes.saveSheet.favorites' => 'Guardar en favoritos',
			'recipes.saveSheet.savedStatus' => 'Guardada en tu biblioteca.',
			'recipes.saveSheet.unsave' => 'Quitar',
			'recipes.saveSheet.collections' => 'AÑADIR A UNA COLECCIÓN',
			'recipes.saveSheet.collectionsError' => 'No pudimos cargar tus colecciones.',
			'recipes.saveSheet.noCollections' => 'Aún no hay colecciones. Crea una abajo.',
			'recipes.saveSheet.newCollection' => 'Nueva colección',
			'recipes.saveSheet.createTitle' => 'Ponle nombre a la colección',
			'recipes.saveSheet.nameLabel' => 'Nombre de la colección',
			'recipes.saveSheet.nameHint' => 'Cenas de entre semana, domingo de horno…',
			'recipes.saveSheet.nameRequired' => 'Ponle nombre a la colección.',
			'recipes.saveSheet.create' => 'Crear',
			'recipes.saveSheet.createError' => 'No pudimos crear la colección. Inténtalo de nuevo.',
			'recipes.saveSheet.saveError' => 'No pudimos guardar la receta. Inténtalo de nuevo.',
			'recipes.collections.eyebrow' => 'TU COCINA',
			'recipes.collections.title' => 'Colecciones',
			'recipes.collections.subtitle' => 'Agrupa recetas para una noche, una temporada o una mesa.',
			'recipes.collections.newCollection' => 'Nueva colección',
			'recipes.collections.loadError' => 'No pudimos cargar tus colecciones.',
			'recipes.collections.count' => ({required Object count}) => '${count} recetas',
			'recipes.collections.countOne' => '1 receta',
			'recipes.collections.favorites' => 'Favoritos',
			'recipes.collections.emptyTitle' => 'Aún no hay colecciones.',
			'recipes.collections.emptyBody' => 'Agrupa recetas para una noche, una temporada o una cena con gente.',
			'recipes.collections.emptyCollection' => 'Esta colección está vacía.',
			'recipes.collections.emptyCollectionBody' => 'Guarda una receta en ella desde su página.',
			'recipes.collections.remove' => 'Quitar',
			'recipes.collections.removeTitle' => '¿Quitar esta receta?',
			'recipes.collections.removeBody' => 'Sigue en tu biblioteca guardada.',
			'recipes.collections.removeError' => 'No pudimos quitar la receta. Inténtalo de nuevo.',
			'recipes.collections.delete' => 'Eliminar colección',
			'recipes.collections.deleteTitle' => '¿Eliminar esta colección?',
			'recipes.collections.deleteBody' => 'Las recetas siguen en tu biblioteca; solo desaparece la colección.',
			'recipes.collections.deleteError' => 'No pudimos eliminar la colección. Inténtalo de nuevo.',
			'recipes.editor.newEyebrow' => 'UN PLATO NUEVO',
			'recipes.editor.newTitle' => 'Ponlo por escrito.',
			'recipes.editor.newBody' => 'Siete secciones cortas. Puedes guardar un borrador en cualquier momento: solo hace falta el nombre.',
			'recipes.editor.editEyebrow' => 'EDITANDO',
			'recipes.editor.editTitle' => 'Afina el plato.',
			'recipes.editor.editBody' => 'Cambia lo que quieras. La publicación se queda como estaba salvo que publiques al guardar.',
			'recipes.editor.save' => 'Guardar receta',
			'recipes.editor.saving' => 'Guardando…',
			'recipes.editor.saveAndPublish' => 'Guardar y publicar',
			'recipes.editor.saveError' => 'No pudimos guardar la receta. Inténtalo de nuevo.',
			'recipes.editor.loadError' => 'No pudimos cargar esta receta para editarla.',
			'recipes.editor.basics.eyebrow' => 'LO BÁSICO',
			'recipes.editor.basics.title' => 'Lo básico',
			'recipes.editor.basics.name' => 'Nombre de la receta',
			'recipes.editor.basics.nameHint' => 'Pollo asado con limón y tomillo',
			'recipes.editor.basics.nameRequired' => 'Ponle nombre a la receta.',
			'recipes.editor.basics.description' => 'Descripción',
			'recipes.editor.basics.descriptionHint' => 'Qué es y por qué lo cocinas.',
			'recipes.editor.plate.eyebrow' => 'EL PLATO',
			'recipes.editor.plate.title' => 'Cómo se come',
			'recipes.editor.plate.cuisine' => 'Cocina',
			'recipes.editor.plate.cuisineHint' => 'Italiana, tailandesa, levantina…',
			'recipes.editor.plate.meal' => 'Comida',
			'recipes.editor.time.eyebrow' => 'TIEMPO',
			'recipes.editor.time.title' => 'Tiempo al fuego',
			'recipes.editor.time.prep' => 'Preparación (min)',
			'recipes.editor.time.cook' => 'Cocción (min)',
			'recipes.editor.time.servings' => 'Raciones',
			'recipes.editor.time.difficulty' => 'Dificultad',
			'recipes.editor.time.invalid' => 'Usa minutos enteros entre 0 y 1440.',
			'recipes.editor.photos.eyebrow' => 'FOTOS',
			'recipes.editor.photos.title' => 'Muestra el plato',
			'recipes.editor.photos.chooseCover' => 'Elegir portada',
			'recipes.editor.photos.changeCover' => 'Cambiar portada',
			'recipes.editor.photos.removeCover' => 'Quitar portada',
			'recipes.editor.photos.more' => 'Más fotos y vídeo',
			'recipes.editor.photos.addPhoto' => 'Añadir foto',
			'recipes.editor.photos.addVideo' => 'Añadir vídeo',
			'recipes.editor.photos.uploading' => 'Subiendo…',
			'recipes.editor.photos.uploadError' => 'No se pudo subir. Inténtalo de nuevo.',
			'recipes.editor.photos.tooLarge' => 'El archivo es demasiado grande. Las fotos admiten 10 MB y el vídeo 24 MB.',
			'recipes.editor.photos.tooMany' => 'Una receta puede tener hasta 20 fotos y vídeos.',
			'recipes.editor.photos.unsupported' => 'Elige un archivo JPEG, PNG, WebP, GIF, MP4 o MOV.',
			'recipes.editor.ingredients.eyebrow' => 'INGREDIENTES',
			'recipes.editor.ingredients.title' => 'Qué lleva',
			'recipes.editor.ingredients.quantity' => 'Cant.',
			'recipes.editor.ingredients.unit' => 'Unidad',
			'recipes.editor.ingredients.name' => 'Ingrediente',
			'recipes.editor.ingredients.note' => 'Nota (opcional)',
			'recipes.editor.ingredients.add' => 'Añadir ingrediente',
			'recipes.editor.ingredients.remove' => 'Quitar ingrediente',
			'recipes.editor.ingredients.moveUp' => 'Subir',
			'recipes.editor.ingredients.moveDown' => 'Bajar',
			'recipes.editor.ingredients.nameRequired' => 'Pon nombre a cada ingrediente que rellenes.',
			'recipes.editor.ingredients.quantityInvalid' => 'Las cantidades deben ser cero o más.',
			'recipes.editor.steps.eyebrow' => 'ELABORACIÓN',
			'recipes.editor.steps.title' => 'Cómo se cocina',
			'recipes.editor.steps.instruction' => 'Paso',
			'recipes.editor.steps.tip' => 'Consejo (opcional)',
			'recipes.editor.steps.timer' => 'Temporizador (min, opcional)',
			'recipes.editor.steps.add' => 'Añadir paso',
			'recipes.editor.steps.remove' => 'Quitar paso',
			'recipes.editor.steps.instructionRequired' => 'Escribe cada paso que rellenes.',
			'recipes.editor.steps.timerInvalid' => 'El temporizador necesita minutos enteros entre 1 y 1440.',
			'recipes.editor.tags.eyebrow' => 'DETALLES',
			'recipes.editor.tags.title' => 'Un poco más',
			'recipes.editor.tags.body' => 'Las etiquetas te ayudan a encontrar la receta después. Las dietéticas las ve cualquiera que pueda verla.',
			'recipes.editor.tags.tags' => 'Etiquetas',
			'recipes.editor.tags.tagsHint' => 'Entre semana, una sartén…',
			'recipes.editor.tags.dietaryTags' => 'Etiquetas dietéticas',
			'recipes.editor.tags.dietaryHint' => 'Vegetariano, sin gluten…',
			'recipes.editor.tags.add' => 'Añadir etiqueta',
			'recipes.editor.publish.label' => 'Publicar al guardar',
			'recipes.editor.publish.body' => 'Las recetas publicadas pueden aparecer en Descubrir. Puedes hacerla privada cuando quieras.',
			'recipes.editor.publish.incomplete' => 'Añade al menos un ingrediente y un paso antes de publicar.',
			'recipes.editor.publish.failed' => 'La receta se guardó, pero no se pudo publicar. Inténtalo desde la página de la receta.',
			_ => null,
		};
	}
}
