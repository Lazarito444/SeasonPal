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
	@override late final _Translations$discovery$es discovery = _Translations$discovery$es._(_root);
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
	@override late final _Translations$auth$social$es social = _Translations$auth$social$es._(_root);
	@override late final _Translations$auth$login$es login = _Translations$auth$login$es._(_root);
	@override late final _Translations$auth$register$es register = _Translations$auth$register$es._(_root);
	@override late final _Translations$auth$forgot$es forgot = _Translations$auth$forgot$es._(_root);
	@override late final _Translations$auth$splash$es splash = _Translations$auth$splash$es._(_root);
}

// Path: onboarding
class _Translations$onboarding$es extends Translations$onboarding$en {
	_Translations$onboarding$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String stepIndicator({required Object current, required Object total}) => 'PASO ${current} DE ${total}';
	@override String eyebrowCuisines({required Object current, required Object total}) => 'PASO ${current} DE ${total} · PERSONALIZACIÓN';
	@override String eyebrowDiet({required Object current, required Object total}) => 'PASO ${current} DE ${total} · PREFERENCIAS';
	@override String eyebrowRhythm({required Object current, required Object total}) => 'PASO ${current} DE ${total} · TU RITMO';
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

// Path: discovery
class _Translations$discovery$es extends Translations$discovery$en {
	_Translations$discovery$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get eyebrow => 'DESCUBRIR';
	@override String get title => 'Encuentra tu próxima mesa.';
	@override String get subtitle => 'Busca recetas públicas y filtra por cocina, tiempo, comida y dieta.';
	@override String get searchHint => 'Busca recetas, ingredientes o cocinas';
	@override late final _Translations$discovery$filters$es filters = _Translations$discovery$filters$es._(_root);
	@override late final _Translations$discovery$time$es time = _Translations$discovery$time$es._(_root);
	@override late final _Translations$discovery$feed$es feed = _Translations$discovery$feed$es._(_root);
	@override late final _Translations$discovery$pantry$es pantry = _Translations$discovery$pantry$es._(_root);
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
	@override late final _Translations$home$pantry$es pantry = _Translations$home$pantry$es._(_root);
	@override late final _Translations$home$rails$es rails = _Translations$home$rails$es._(_root);
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

// Path: auth.social
class _Translations$auth$social$es extends Translations$auth$social$en {
	_Translations$auth$social$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get continueWith => 'O continúa con';
	@override String get apple => 'Apple';
	@override String get google => 'Google';
	@override String get planned => 'El acceso con redes sociales llegará más adelante.';
}

// Path: auth.login
class _Translations$auth$login$es extends Translations$auth$login$en {
	_Translations$auth$login$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Qué bueno';
	@override String get titleAccent => 'verte.';
	@override String get subtitle => 'Tus recetas guardadas, tus notas de cocina y tu despensa inteligente te esperan.';
	@override String get newHere => '¿Es tu primera vez en SeasonPal?';
	@override String get createAccount => 'Crear una cuenta';
	@override String get email => 'Correo electrónico';
	@override String get emailHint => 'chef@seasonpal.com';
	@override String get password => 'Contraseña';
	@override String get forgot => '¿Olvidaste tu contraseña?';
	@override String get remember => 'Mantener sesión iniciada';
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
	@override String get title => 'Comienza tu';
	@override String get titleAccent => 'viaje culinario.';
	@override String get subtitle => 'Únete a una comunidad de cocineros curiosos que exploran la cocina de temporada.';
	@override String get alreadyHere => '¿Ya cocinas con nosotros?';
	@override String get signIn => 'Iniciar sesión';
	@override String get name => 'Nombre completo';
	@override String get nameHint => 'Elena Rostova';
	@override String get nameTooLong => 'Mantén tu nombre en 80 caracteres.';
	@override String get email => 'Correo electrónico';
	@override String get emailHint => 'elena@seasonpal.com';
	@override String get password => 'Contraseña';
	@override String get required => 'Obligatorio';
	@override String get optional => 'Opcional';
	@override String get passwordHint => 'Mín. 8 caracteres';
	@override String get strengthLabel => 'Nivel de seguridad';
	@override String get strengthEmpty => 'Usa 8+ caracteres con mayúsculas, minúsculas, un número y un símbolo.';
	@override String get strengthWeak => 'Débil';
	@override String get strengthFair => 'Aceptable';
	@override String get strengthGood => 'Buena';
	@override String get strengthStrong => 'Fuerte';
	@override String get terms => 'Acepto las Condiciones de uso y la Política de privacidad.';
	@override String get termsRequired => 'Acepta las condiciones para crear tu cuenta.';
	@override String get submit => 'Crear mi cuenta SeasonPal';
	@override String get emailRequired => 'Escribe tu correo.';
	@override String get emailInvalid => 'Escribe un correo válido.';
	@override String get passwordRequired => 'Elige una contraseña.';
	@override String get passwordTooShort => 'Usa al menos 8 caracteres.';
	@override String get passwordTooWeak => 'Añade mayúsculas, minúsculas, un número y un símbolo.';
}

// Path: auth.forgot
class _Translations$auth$forgot$es extends Translations$auth$forgot$en {
	_Translations$auth$forgot$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get title => '¿Olvidaste tu contraseña?';
	@override String get body => 'Escribe el correo asociado a tu cuenta de SeasonPal. Te enviaremos un enlace seguro para volver a tus recetas de temporada.';
	@override String get email => 'Correo electrónico';
	@override String get emailHint => 'ejemplo@seasonpal.com';
	@override String get inboxHint => 'Asegúrate de poder abrir esta bandeja de entrada.';
	@override String get submit => 'Enviar enlace de recuperación';
	@override String get successTitle => 'Solicitud recibida.';
	@override String successBody({required Object email}) => 'Si ${email} pertenece a una cuenta de SeasonPal, enviaremos allí un enlace de recuperación. El envío de correos aún no está conectado, así que no llegará nada en esta versión.';
	@override String get dataTitle => 'Protección de datos SeasonPal';
	@override String get dataBody => 'Cuando el envío de correos esté activo, los enlaces caducarán a los 15 minutos y solo podrán usarse una vez.';
	@override String get remembered => '¿Recordaste tu contraseña?';
	@override String get signIn => 'Iniciar sesión';
	@override String get backToSignIn => 'Volver a iniciar sesión';
	@override String get emailRequired => 'Escribe tu correo.';
	@override String get emailInvalid => 'Escribe un correo válido.';
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
	@override String get title => 'Cocina al compás de la temporada.';
	@override String get body => 'Solo tomará un minuto afinar tu experiencia culinaria a la cocina que de verdad usas.';
	@override String get itineraryTitle => 'TU ITINERARIO CULINARIO';
	@override String get cuisineTitle => 'Tus cocinas favoritas';
	@override String get cuisineBody => 'Mediterránea, levantina, huerto andino o brasa nórdica. Define tus paladares de estación.';
	@override String get dietTitle => 'Dieta e intereses botánicos';
	@override String get dietBody => 'Preferencias vegetales, alimentos sin gluten, especias frescas y afinidades digestivas.';
	@override String get rhythmTitle => 'Tu ritmo en los fogones';
	@override String get rhythmBody => 'Cenas rápidas de 20 minutos o rituales pausados de fin de semana en cazuela de barro.';
	@override String get start => 'Comenzar personalización (1 min)';
	@override String get skip => 'Omitir por ahora';
}

// Path: onboarding.cuisines
class _Translations$onboarding$cuisines$es extends Translations$onboarding$cuisines$en {
	_Translations$onboarding$cuisines$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Elige tus cocinas favoritas.';
	@override String get body => 'Selecciona al menos tres para que tu primer feed no sea monótono.';
	@override String get sectionTitle => 'Curaduría de estación';
	@override String get sectionBody => 'Inspiración botánica y recetarios con huella de origen.';
	@override String get counterNone => 'Aún no hay cocinas seleccionadas';
	@override String get counterOne => '1 cocina seleccionada';
	@override String counterOther({required Object count}) => '${count} cocinas seleccionadas';
	@override String get remainingOne => 'Selecciona 1 más';
	@override String remainingOther({required Object count}) => 'Selecciona ${count} más';
	@override String get ready => '¡Todo listo!';
	@override String get next => 'Continuar a Dietas';
}

// Path: onboarding.diet
class _Translations$onboarding$diet$es extends Translations$onboarding$diet$en {
	_Translations$onboarding$diet$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Tu despensa, tus reglas.';
	@override String get body => 'Adaptamos las recetas a lo que necesitas y a lo que te da curiosidad.';
	@override String get restrictionsTitle => 'Restricciones dietarias';
	@override String get restrictionsBody => 'No te sugeriremos ingredientes que contengan estas restricciones.';
	@override String get interestsTitle => 'Intereses botánicos';
	@override String get interestsBody => 'Opcional: los temas que queremos priorizar.';
	@override String get next => 'Continuar a Tu Ritmo';
}

// Path: onboarding.rhythm
class _Translations$onboarding$rhythm$es extends Translations$onboarding$rhythm$en {
	_Translations$onboarding$rhythm$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get title => '¿Cómo vives tu cocina?';
	@override String get body => 'Alineamos la complejidad de las técnicas y el tiempo de preparación a tus hábitos reales.';
	@override String get skillTitle => 'Nivel de destreza culinaria';
	@override String get skillHint => 'Elige uno';
	@override String get timeTitle => 'Tiempo habitual para cocinar';
	@override String get timeHint => 'Elige tu ritmo preferido';
	@override String get next => 'Revisar resumen';
}

// Path: onboarding.done
class _Translations$onboarding$done$es extends Translations$onboarding$done$en {
	_Translations$onboarding$done$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get title => '¡Todo listo para encender los fogones!';
	@override String get body => 'Hemos diseñado un recetario inteligente a tu medida. Confirma tus selecciones antes de sincronizar tu despensa.';
	@override String cuisinesTitle({required Object count}) => 'Cocinas seleccionadas (${count})';
	@override String get dietTitle => 'Restricciones y pasiones';
	@override String get rhythmTitle => 'Ritmo culinario';
	@override String get dietLabel => 'DIETA';
	@override String get interestsLabel => 'INTERESES';
	@override String get editSection => 'Editar';
	@override String get emptyCuisines => 'Abierto a todo';
	@override String get emptyDiet => 'Sin restricciones';
	@override String get emptyInterests => 'Ninguno todavía';
	@override String get noTime => 'Sin tiempo fijo';
	@override String get footnote => 'Puedes modificar tus preferencias en cualquier momento desde Ajustes.';
	@override String get finish => 'Continuar a SeasonPal';
}

// Path: onboarding.footer
class _Translations$onboarding$footer$es extends Translations$onboarding$footer$en {
	_Translations$onboarding$footer$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get begin => 'Comenzar';
	@override String get next => 'Continuar';
	@override String get finish => 'Continuar';
	@override String get saving => 'Guardando…';
}

// Path: onboarding.time
class _Translations$onboarding$time$es extends Translations$onboarding$time$en {
	_Translations$onboarding$time$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get hour => '1 hora';
	@override String get minSuffix => 'min';
	@override late final _Translations$onboarding$time$buckets$es buckets = _Translations$onboarding$time$buckets$es._(_root);
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

// Path: discovery.filters
class _Translations$discovery$filters$es extends Translations$discovery$filters$en {
	_Translations$discovery$filters$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get cuisine => 'Cocina';
	@override String get meal => 'Comida';
	@override String get time => 'Tiempo';
	@override String get difficulty => 'Esfuerzo';
	@override String get diet => 'Dieta';
	@override String get any => 'Cualquiera';
	@override String get clearAll => 'Limpiar todo';
}

// Path: discovery.time
class _Translations$discovery$time$es extends Translations$discovery$time$en {
	_Translations$discovery$time$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String under({required Object count}) => 'Menos de ${count} min';
}

// Path: discovery.feed
class _Translations$discovery$feed$es extends Translations$discovery$feed$en {
	_Translations$discovery$feed$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get loading => 'Preparando la mesa.';
	@override String get loadError => 'No pudimos cargar el feed público.';
	@override String results({required Object count}) => '${count} recetas';
	@override String get resultsOne => '1 receta';
	@override String get newestFirst => 'Más recientes primero';
	@override String get bestMatch => 'Mejor coincidencia';
	@override String get loadMoreError => 'No pudimos cargar más recetas.';
	@override String get emptyTitle => 'Nada coincide con esa mesa.';
	@override String get emptyBody => 'Prueba con más tiempo, otra cocina o una búsqueda más corta.';
	@override String get emptyCommunityTitle => 'La mesa de la comunidad aún se está preparando.';
	@override String get emptyCommunityBody => 'Publica una receta y podrá aparecer aquí para otros cocineros.';
}

// Path: discovery.pantry
class _Translations$discovery$pantry$es extends Translations$discovery$pantry$en {
	_Translations$discovery$pantry$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get eyebrow => 'LA DESPENSA';
	@override String get title => 'Cocina con lo que tienes.';
	@override String get subtitle => 'Añade los ingredientes de tu despensa. Ordenaremos las recetas públicas según cuánto de cada una ya tienes.';
	@override String get body => 'Compara recetas públicas con tu despensa.';
	@override String get inputHint => 'Añade un ingrediente, o varios separados por comas';
	@override String get add => 'Añadir';
	@override String get clear => 'Vaciar despensa';
	@override String remove({required Object name}) => 'Quitar ${name}';
	@override String get loading => 'Revisando la despensa.';
	@override String get loadError => 'No pudimos comparar tu despensa.';
	@override String get loadMoreError => 'No pudimos cargar más coincidencias.';
	@override String get loadMore => 'Cargar más';
	@override String results({required Object count}) => '${count} coincidencias';
	@override String get resultsOne => '1 coincidencia';
	@override String get emptyTitle => 'Aún no hay coincidencias.';
	@override String get emptyBody => 'Prueba con menos ingredientes o más generales, como "tomate" en vez de "tomates cherry".';
	@override String get emptyPromptTitle => 'Empieza con lo que tienes.';
	@override String get emptyPromptBody => 'Añade algunos ingredientes arriba y buscaremos recetas públicas que necesiten menos compras.';
	@override String get canCook => 'Puedes cocinar';
	@override String match({required Object percent}) => '${percent}% de coincidencia';
	@override String have({required Object names}) => 'Tienes: ${names}';
	@override String missing({required Object names}) => 'Falta: ${names}';
	@override String get allIngredients => 'Tienes todo.';
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

// Path: home.pantry
class _Translations$home$pantry$es extends Translations$home$pantry$en {
	_Translations$home$pantry$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get eyebrow => 'DE TU DESPENSA';
	@override String get title => '¿Qué puedo cocinar ahora?';
	@override String get body => 'Escribe lo que tienes. Buscaremos recetas públicas que usen la mayor parte.';
	@override String get hint => 'Limón, orzo, espinaca';
	@override String get action => 'Buscar recetas';
	@override String get empty => 'Añade al menos un ingrediente.';
}

// Path: home.rails
class _Translations$home$rails$es extends Translations$home$rails$en {
	_Translations$home$rails$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get loading => 'Buscando qué se cocina cerca.';
	@override String get forYouEyebrow => 'PARA TU GUSTO';
	@override String get forYouTitle => 'Hecho con tus cocinas y dietas.';
	@override String get trendingEyebrow => 'TENDENCIA ESTA SEMANA';
	@override String get trendingTitle => 'Lo que otros cocineros guardan.';
	@override String get newestEyebrow => 'RECIÉN LLEGADO';
	@override String get newestTitle => 'Las últimas recetas públicas.';
	@override String get loadError => 'No pudimos cargar las recomendaciones de la comunidad.';
	@override String get emptyTitle => 'La mesa de la comunidad aún se está preparando.';
	@override String get emptyBody => 'Publica una receta y podrá aparecer aquí para otros cocineros.';
	@override String get action => 'Explorar Descubrir';
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
	@override String one({required Object cuisine}) => 'Tu cocina tira a ${cuisine}.';
	@override String two({required Object first, required Object second}) => 'Tu cocina tira a ${first} y ${second}.';
	@override String many({required Object first, required Object second}) => 'Tu cocina tira a ${first}, ${second} y más.';
	@override String get noRestrictions => 'No hay restricciones dietéticas guardadas.';
	@override String dietOne({required Object restriction}) => 'Dieta ${restriction}.';
	@override String dietMany({required Object leading, required Object last}) => 'Dieta ${leading} y ${last}.';
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

// Path: onboarding.time.buckets
class _Translations$onboarding$time$buckets$es extends Translations$onboarding$time$buckets$en {
	_Translations$onboarding$time$buckets$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override late final _Translations$onboarding$time$buckets$quick$es quick = _Translations$onboarding$time$buckets$quick$es._(_root);
	@override late final _Translations$onboarding$time$buckets$balanced$es balanced = _Translations$onboarding$time$buckets$balanced$es._(_root);
	@override late final _Translations$onboarding$time$buckets$long$es long = _Translations$onboarding$time$buckets$long$es._(_root);
	@override late final _Translations$onboarding$time$buckets$variable$es variable = _Translations$onboarding$time$buckets$variable$es._(_root);
}

// Path: onboarding.skill.beginner
class _Translations$onboarding$skill$beginner$es extends Translations$onboarding$skill$beginner$en {
	_Translations$onboarding$skill$beginner$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get label => 'Principiante entusiasta';
	@override String get description => 'Técnicas sencillas, paso a paso detallado e ingredientes accesibles.';
}

// Path: onboarding.skill.intermediate
class _Translations$onboarding$skill$intermediate$es extends Translations$onboarding$skill$intermediate$en {
	_Translations$onboarding$skill$intermediate$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get label => 'Cocinero casero frecuente';
	@override String get description => 'Confianza en cortes básicos, salsas y manejo del fuego.';
}

// Path: onboarding.skill.advanced
class _Translations$onboarding$skill$advanced$es extends Translations$onboarding$skill$advanced$en {
	_Translations$onboarding$skill$advanced$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get label => 'Artesano / avanzado';
	@override String get description => 'Fermentación, horneado complejo y emplatado de autor.';
}

// Path: onboarding.options.cuisines
class _Translations$onboarding$options$cuisines$es extends Translations$onboarding$options$cuisines$en {
	_Translations$onboarding$options$cuisines$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override late final _Translations$onboarding$options$cuisines$italian$es italian = _Translations$onboarding$options$cuisines$italian$es._(_root);
	@override late final _Translations$onboarding$options$cuisines$mediterranean$es mediterranean = _Translations$onboarding$options$cuisines$mediterranean$es._(_root);
	@override late final _Translations$onboarding$options$cuisines$middleEastern$es middleEastern = _Translations$onboarding$options$cuisines$middleEastern$es._(_root);
	@override late final _Translations$onboarding$options$cuisines$mexican$es mexican = _Translations$onboarding$options$cuisines$mexican$es._(_root);
	@override late final _Translations$onboarding$options$cuisines$indian$es indian = _Translations$onboarding$options$cuisines$indian$es._(_root);
	@override late final _Translations$onboarding$options$cuisines$japanese$es japanese = _Translations$onboarding$options$cuisines$japanese$es._(_root);
	@override late final _Translations$onboarding$options$cuisines$korean$es korean = _Translations$onboarding$options$cuisines$korean$es._(_root);
	@override late final _Translations$onboarding$options$cuisines$thai$es thai = _Translations$onboarding$options$cuisines$thai$es._(_root);
	@override late final _Translations$onboarding$options$cuisines$chinese$es chinese = _Translations$onboarding$options$cuisines$chinese$es._(_root);
	@override late final _Translations$onboarding$options$cuisines$french$es french = _Translations$onboarding$options$cuisines$french$es._(_root);
	@override late final _Translations$onboarding$options$cuisines$spanish$es spanish = _Translations$onboarding$options$cuisines$spanish$es._(_root);
	@override late final _Translations$onboarding$options$cuisines$greek$es greek = _Translations$onboarding$options$cuisines$greek$es._(_root);
	@override late final _Translations$onboarding$options$cuisines$turkish$es turkish = _Translations$onboarding$options$cuisines$turkish$es._(_root);
	@override late final _Translations$onboarding$options$cuisines$vietnamese$es vietnamese = _Translations$onboarding$options$cuisines$vietnamese$es._(_root);
	@override late final _Translations$onboarding$options$cuisines$american$es american = _Translations$onboarding$options$cuisines$american$es._(_root);
	@override late final _Translations$onboarding$options$cuisines$northAfrican$es northAfrican = _Translations$onboarding$options$cuisines$northAfrican$es._(_root);
	@override late final _Translations$onboarding$options$cuisines$latinAmerican$es latinAmerican = _Translations$onboarding$options$cuisines$latinAmerican$es._(_root);
	@override late final _Translations$onboarding$options$cuisines$nordic$es nordic = _Translations$onboarding$options$cuisines$nordic$es._(_root);
	@override late final _Translations$onboarding$options$cuisines$caribbean$es caribbean = _Translations$onboarding$options$cuisines$caribbean$es._(_root);
	@override late final _Translations$onboarding$options$cuisines$african$es african = _Translations$onboarding$options$cuisines$african$es._(_root);
}

// Path: onboarding.options.diets
class _Translations$onboarding$options$diets$es extends Translations$onboarding$options$diets$en {
	_Translations$onboarding$options$diets$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override late final _Translations$onboarding$options$diets$vegetarian$es vegetarian = _Translations$onboarding$options$diets$vegetarian$es._(_root);
	@override late final _Translations$onboarding$options$diets$vegan$es vegan = _Translations$onboarding$options$diets$vegan$es._(_root);
	@override late final _Translations$onboarding$options$diets$glutenFree$es glutenFree = _Translations$onboarding$options$diets$glutenFree$es._(_root);
	@override late final _Translations$onboarding$options$diets$dairyFree$es dairyFree = _Translations$onboarding$options$diets$dairyFree$es._(_root);
	@override late final _Translations$onboarding$options$diets$nutFree$es nutFree = _Translations$onboarding$options$diets$nutFree$es._(_root);
	@override late final _Translations$onboarding$options$diets$halal$es halal = _Translations$onboarding$options$diets$halal$es._(_root);
	@override late final _Translations$onboarding$options$diets$kosher$es kosher = _Translations$onboarding$options$diets$kosher$es._(_root);
	@override late final _Translations$onboarding$options$diets$pescatarian$es pescatarian = _Translations$onboarding$options$diets$pescatarian$es._(_root);
	@override late final _Translations$onboarding$options$diets$lowCarb$es lowCarb = _Translations$onboarding$options$diets$lowCarb$es._(_root);
	@override late final _Translations$onboarding$options$diets$lowSodium$es lowSodium = _Translations$onboarding$options$diets$lowSodium$es._(_root);
}

// Path: onboarding.options.interests
class _Translations$onboarding$options$interests$es extends Translations$onboarding$options$interests$en {
	_Translations$onboarding$options$interests$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get weeknightDinners => 'Cenas de entre semana';
	@override String get mealPrep => 'Meal prep';
	@override String get baking => 'Repostería';
	@override String get grilling => 'Parrilla';
	@override String get slowCooking => 'Cocción lenta';
	@override String get fermentation => 'Fermentación';
	@override String get plantForward => 'Cocina vegetal';
	@override String get comfortFood => 'Comida reconfortante';
	@override String get entertaining => 'Recibir en casa';
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

// Path: onboarding.time.buckets.quick
class _Translations$onboarding$time$buckets$quick$es extends Translations$onboarding$time$buckets$quick$en {
	_Translations$onboarding$time$buckets$quick$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get label => '15–20 min';
	@override String get description => 'Express entre semana';
}

// Path: onboarding.time.buckets.balanced
class _Translations$onboarding$time$buckets$balanced$es extends Translations$onboarding$time$buckets$balanced$en {
	_Translations$onboarding$time$buckets$balanced$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get label => '30–45 min';
	@override String get description => 'Equilibrio para elaborar';
}

// Path: onboarding.time.buckets.long
class _Translations$onboarding$time$buckets$long$es extends Translations$onboarding$time$buckets$long$en {
	_Translations$onboarding$time$buckets$long$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get label => '60+ min';
	@override String get description => 'Estofados y rituales de fin de semana';
}

// Path: onboarding.time.buckets.variable
class _Translations$onboarding$time$buckets$variable$es extends Translations$onboarding$time$buckets$variable$en {
	_Translations$onboarding$time$buckets$variable$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get label => 'Variable';
	@override String get description => 'Me adapto según el día';
}

// Path: onboarding.options.cuisines.italian
class _Translations$onboarding$options$cuisines$italian$es extends Translations$onboarding$options$cuisines$italian$en {
	_Translations$onboarding$options$cuisines$italian$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get label => 'Italiana rústica y pasta';
	@override String get description => 'Trigo antiguo, ragú, quesos curados';
	@override String get short => 'Italiana';
}

// Path: onboarding.options.cuisines.mediterranean
class _Translations$onboarding$options$cuisines$mediterranean$es extends Translations$onboarding$options$cuisines$mediterranean$en {
	_Translations$onboarding$options$cuisines$mediterranean$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get label => 'Mediterránea clásica';
	@override String get description => 'Aceites vivos, hierbas, pescado de mar';
	@override String get short => 'Mediterránea';
}

// Path: onboarding.options.cuisines.middleEastern
class _Translations$onboarding$options$cuisines$middleEastern$es extends Translations$onboarding$options$cuisines$middleEastern$en {
	_Translations$onboarding$options$cuisines$middleEastern$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get label => 'Levantina y Oriente Medio';
	@override String get description => 'Za\'atar, tahini, granadas';
	@override String get short => 'De Oriente Medio';
}

// Path: onboarding.options.cuisines.mexican
class _Translations$onboarding$options$cuisines$mexican$es extends Translations$onboarding$options$cuisines$mexican$en {
	_Translations$onboarding$options$cuisines$mexican$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get label => 'Oaxaqueña y tradicional';
	@override String get description => 'Moles negros, maíz criollo';
	@override String get short => 'Mexicana';
}

// Path: onboarding.options.cuisines.indian
class _Translations$onboarding$options$cuisines$indian$es extends Translations$onboarding$options$cuisines$indian$en {
	_Translations$onboarding$options$cuisines$indian$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get label => 'India especiada';
	@override String get description => 'Masalas tostados, legumbres, ghee';
	@override String get short => 'India';
}

// Path: onboarding.options.cuisines.japanese
class _Translations$onboarding$options$cuisines$japanese$es extends Translations$onboarding$options$cuisines$japanese$en {
	_Translations$onboarding$options$cuisines$japanese$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get label => 'Japonesa y ramen artesanal';
	@override String get description => 'Caldos dashi, umami, fermentos';
	@override String get short => 'Japonesa';
}

// Path: onboarding.options.cuisines.korean
class _Translations$onboarding$options$cuisines$korean$es extends Translations$onboarding$options$cuisines$korean$en {
	_Translations$onboarding$options$cuisines$korean$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get label => 'Coreana y kimchi';
	@override String get description => 'Gochujang, banchan, marinados';
	@override String get short => 'Coreana';
}

// Path: onboarding.options.cuisines.thai
class _Translations$onboarding$options$cuisines$thai$es extends Translations$onboarding$options$cuisines$thai$en {
	_Translations$onboarding$options$cuisines$thai$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get label => 'Tailandesa aromática';
	@override String get description => 'Hierba limón, lima kaffir, coco';
	@override String get short => 'Tailandesa';
}

// Path: onboarding.options.cuisines.chinese
class _Translations$onboarding$options$cuisines$chinese$es extends Translations$onboarding$options$cuisines$chinese$en {
	_Translations$onboarding$options$cuisines$chinese$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get label => 'Wok y dim sum';
	@override String get description => 'Fuego alto, vapor, soja y vinagre';
	@override String get short => 'China';
}

// Path: onboarding.options.cuisines.french
class _Translations$onboarding$options$cuisines$french$es extends Translations$onboarding$options$cuisines$french$en {
	_Translations$onboarding$options$cuisines$french$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get label => 'Francesa bistró';
	@override String get description => 'Mantequilla avellanada, fondos, vino';
	@override String get short => 'Francesa';
}

// Path: onboarding.options.cuisines.spanish
class _Translations$onboarding$options$cuisines$spanish$es extends Translations$onboarding$options$cuisines$spanish$en {
	_Translations$onboarding$options$cuisines$spanish$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get label => 'Ibérica y tapas';
	@override String get description => 'Pimentón, dehesa, conservas';
	@override String get short => 'Española';
}

// Path: onboarding.options.cuisines.greek
class _Translations$onboarding$options$cuisines$greek$es extends Translations$onboarding$options$cuisines$greek$en {
	_Translations$onboarding$options$cuisines$greek$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get label => 'Griega del Egeo';
	@override String get description => 'Feta de pastura, orégano salvaje';
	@override String get short => 'Griega';
}

// Path: onboarding.options.cuisines.turkish
class _Translations$onboarding$options$cuisines$turkish$es extends Translations$onboarding$options$cuisines$turkish$en {
	_Translations$onboarding$options$cuisines$turkish$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get label => 'Anatolia y brasa';
	@override String get description => 'Bulgur, berenjena ahumada, yogur';
	@override String get short => 'Turca';
}

// Path: onboarding.options.cuisines.vietnamese
class _Translations$onboarding$options$cuisines$vietnamese$es extends Translations$onboarding$options$cuisines$vietnamese$en {
	_Translations$onboarding$options$cuisines$vietnamese$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get label => 'Vietnamita fresca';
	@override String get description => 'Cilantro fino, rollos, phở';
	@override String get short => 'Vietnamita';
}

// Path: onboarding.options.cuisines.american
class _Translations$onboarding$options$cuisines$american$es extends Translations$onboarding$options$cuisines$american$en {
	_Translations$onboarding$options$cuisines$american$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get label => 'Californiana farm-to-table';
	@override String get description => 'Cosecha local, platos limpios';
	@override String get short => 'Estadounidense';
}

// Path: onboarding.options.cuisines.northAfrican
class _Translations$onboarding$options$cuisines$northAfrican$es extends Translations$onboarding$options$cuisines$northAfrican$en {
	_Translations$onboarding$options$cuisines$northAfrican$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get label => 'Marroquí y tagines';
	@override String get description => 'Ras el hanout, limón confitado';
	@override String get short => 'Del norte de África';
}

// Path: onboarding.options.cuisines.latinAmerican
class _Translations$onboarding$options$cuisines$latinAmerican$es extends Translations$onboarding$options$cuisines$latinAmerican$en {
	_Translations$onboarding$options$cuisines$latinAmerican$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get label => 'Peruana y nikkei';
	@override String get description => 'Ajíes nativos, ceviches, rocoto';
	@override String get short => 'Latinoamericana';
}

// Path: onboarding.options.cuisines.nordic
class _Translations$onboarding$options$cuisines$nordic$es extends Translations$onboarding$options$cuisines$nordic$en {
	_Translations$onboarding$options$cuisines$nordic$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get label => 'Nórdica y fermentos';
	@override String get description => 'Encurtidos, centeno, ahumados';
	@override String get short => 'Nórdica';
}

// Path: onboarding.options.cuisines.caribbean
class _Translations$onboarding$options$cuisines$caribbean$es extends Translations$onboarding$options$cuisines$caribbean$en {
	_Translations$onboarding$options$cuisines$caribbean$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get label => 'Caribeña de islas';
	@override String get description => 'Pimientos, coco, cítricos';
	@override String get short => 'Caribeña';
}

// Path: onboarding.options.cuisines.african
class _Translations$onboarding$options$cuisines$african$es extends Translations$onboarding$options$cuisines$african$en {
	_Translations$onboarding$options$cuisines$african$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get label => 'África de fuego lento';
	@override String get description => 'Guisos de una olla, tubérculos, especias';
	@override String get short => 'Africana';
}

// Path: onboarding.options.diets.vegetarian
class _Translations$onboarding$options$diets$vegetarian$es extends Translations$onboarding$options$diets$vegetarian$en {
	_Translations$onboarding$options$diets$vegetarian$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get label => 'Vegetariana';
	@override String get description => 'Sin carnes ni pescados';
}

// Path: onboarding.options.diets.vegan
class _Translations$onboarding$options$diets$vegan$es extends Translations$onboarding$options$diets$vegan$en {
	_Translations$onboarding$options$diets$vegan$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get label => 'Vegana';
	@override String get description => '100% de origen vegetal';
}

// Path: onboarding.options.diets.glutenFree
class _Translations$onboarding$options$diets$glutenFree$es extends Translations$onboarding$options$diets$glutenFree$en {
	_Translations$onboarding$options$diets$glutenFree$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get label => 'Sin gluten';
	@override String get description => 'Libre de trigo, cebada y centeno';
}

// Path: onboarding.options.diets.dairyFree
class _Translations$onboarding$options$diets$dairyFree$es extends Translations$onboarding$options$diets$dairyFree$en {
	_Translations$onboarding$options$diets$dairyFree$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get label => 'Sin lácteos';
	@override String get description => 'Sin leche, mantequilla ni queso';
}

// Path: onboarding.options.diets.nutFree
class _Translations$onboarding$options$diets$nutFree$es extends Translations$onboarding$options$diets$nutFree$en {
	_Translations$onboarding$options$diets$nutFree$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get label => 'Sin frutos secos';
	@override String get description => 'Sin nueces ni almendras';
}

// Path: onboarding.options.diets.halal
class _Translations$onboarding$options$diets$halal$es extends Translations$onboarding$options$diets$halal$en {
	_Translations$onboarding$options$diets$halal$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get label => 'Halal';
	@override String get description => 'Certificación y normas islámicas';
}

// Path: onboarding.options.diets.kosher
class _Translations$onboarding$options$diets$kosher$es extends Translations$onboarding$options$diets$kosher$en {
	_Translations$onboarding$options$diets$kosher$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get label => 'Kosher';
	@override String get description => 'Conforme a preceptos cashrut';
}

// Path: onboarding.options.diets.pescatarian
class _Translations$onboarding$options$diets$pescatarian$es extends Translations$onboarding$options$diets$pescatarian$en {
	_Translations$onboarding$options$diets$pescatarian$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get label => 'Pescatariana';
	@override String get description => 'Pescados, mariscos y vegetales';
}

// Path: onboarding.options.diets.lowCarb
class _Translations$onboarding$options$diets$lowCarb$es extends Translations$onboarding$options$diets$lowCarb$en {
	_Translations$onboarding$options$diets$lowCarb$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get label => 'Baja en carbohidratos';
	@override String get description => 'Menos hidratos, más proteína';
}

// Path: onboarding.options.diets.lowSodium
class _Translations$onboarding$options$diets$lowSodium$es extends Translations$onboarding$options$diets$lowSodium$en {
	_Translations$onboarding$options$diets$lowSodium$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get label => 'Baja en sodio';
	@override String get description => 'Para control cardiovascular';
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
			'auth.social.continueWith' => 'O continúa con',
			'auth.social.apple' => 'Apple',
			'auth.social.google' => 'Google',
			'auth.social.planned' => 'El acceso con redes sociales llegará más adelante.',
			'auth.login.title' => 'Qué bueno',
			'auth.login.titleAccent' => 'verte.',
			'auth.login.subtitle' => 'Tus recetas guardadas, tus notas de cocina y tu despensa inteligente te esperan.',
			'auth.login.newHere' => '¿Es tu primera vez en SeasonPal?',
			'auth.login.createAccount' => 'Crear una cuenta',
			'auth.login.email' => 'Correo electrónico',
			'auth.login.emailHint' => 'chef@seasonpal.com',
			'auth.login.password' => 'Contraseña',
			'auth.login.forgot' => '¿Olvidaste tu contraseña?',
			'auth.login.remember' => 'Mantener sesión iniciada',
			'auth.login.submit' => 'Iniciar sesión',
			'auth.login.emailRequired' => 'Escribe tu correo.',
			'auth.login.emailInvalid' => 'Escribe un correo válido.',
			'auth.login.passwordRequired' => 'Escribe tu contraseña.',
			'auth.register.title' => 'Comienza tu',
			'auth.register.titleAccent' => 'viaje culinario.',
			'auth.register.subtitle' => 'Únete a una comunidad de cocineros curiosos que exploran la cocina de temporada.',
			'auth.register.alreadyHere' => '¿Ya cocinas con nosotros?',
			'auth.register.signIn' => 'Iniciar sesión',
			'auth.register.name' => 'Nombre completo',
			'auth.register.nameHint' => 'Elena Rostova',
			'auth.register.nameTooLong' => 'Mantén tu nombre en 80 caracteres.',
			'auth.register.email' => 'Correo electrónico',
			'auth.register.emailHint' => 'elena@seasonpal.com',
			'auth.register.password' => 'Contraseña',
			'auth.register.required' => 'Obligatorio',
			'auth.register.optional' => 'Opcional',
			'auth.register.passwordHint' => 'Mín. 8 caracteres',
			'auth.register.strengthLabel' => 'Nivel de seguridad',
			'auth.register.strengthEmpty' => 'Usa 8+ caracteres con mayúsculas, minúsculas, un número y un símbolo.',
			'auth.register.strengthWeak' => 'Débil',
			'auth.register.strengthFair' => 'Aceptable',
			'auth.register.strengthGood' => 'Buena',
			'auth.register.strengthStrong' => 'Fuerte',
			'auth.register.terms' => 'Acepto las Condiciones de uso y la Política de privacidad.',
			'auth.register.termsRequired' => 'Acepta las condiciones para crear tu cuenta.',
			'auth.register.submit' => 'Crear mi cuenta SeasonPal',
			'auth.register.emailRequired' => 'Escribe tu correo.',
			'auth.register.emailInvalid' => 'Escribe un correo válido.',
			'auth.register.passwordRequired' => 'Elige una contraseña.',
			'auth.register.passwordTooShort' => 'Usa al menos 8 caracteres.',
			'auth.register.passwordTooWeak' => 'Añade mayúsculas, minúsculas, un número y un símbolo.',
			'auth.forgot.title' => '¿Olvidaste tu contraseña?',
			'auth.forgot.body' => 'Escribe el correo asociado a tu cuenta de SeasonPal. Te enviaremos un enlace seguro para volver a tus recetas de temporada.',
			'auth.forgot.email' => 'Correo electrónico',
			'auth.forgot.emailHint' => 'ejemplo@seasonpal.com',
			'auth.forgot.inboxHint' => 'Asegúrate de poder abrir esta bandeja de entrada.',
			'auth.forgot.submit' => 'Enviar enlace de recuperación',
			'auth.forgot.successTitle' => 'Solicitud recibida.',
			'auth.forgot.successBody' => ({required Object email}) => 'Si ${email} pertenece a una cuenta de SeasonPal, enviaremos allí un enlace de recuperación. El envío de correos aún no está conectado, así que no llegará nada en esta versión.',
			'auth.forgot.dataTitle' => 'Protección de datos SeasonPal',
			'auth.forgot.dataBody' => 'Cuando el envío de correos esté activo, los enlaces caducarán a los 15 minutos y solo podrán usarse una vez.',
			'auth.forgot.remembered' => '¿Recordaste tu contraseña?',
			'auth.forgot.signIn' => 'Iniciar sesión',
			'auth.forgot.backToSignIn' => 'Volver a iniciar sesión',
			'auth.forgot.emailRequired' => 'Escribe tu correo.',
			'auth.forgot.emailInvalid' => 'Escribe un correo válido.',
			'auth.splash.restoreFailed' => 'No pudimos restaurar tu sesión.',
			'auth.splash.loading' => 'Poniendo la mesa…',
			'onboarding.stepIndicator' => ({required Object current, required Object total}) => 'PASO ${current} DE ${total}',
			'onboarding.eyebrowCuisines' => ({required Object current, required Object total}) => 'PASO ${current} DE ${total} · PERSONALIZACIÓN',
			'onboarding.eyebrowDiet' => ({required Object current, required Object total}) => 'PASO ${current} DE ${total} · PREFERENCIAS',
			'onboarding.eyebrowRhythm' => ({required Object current, required Object total}) => 'PASO ${current} DE ${total} · TU RITMO',
			'onboarding.welcome.title' => 'Cocina al compás de la temporada.',
			'onboarding.welcome.body' => 'Solo tomará un minuto afinar tu experiencia culinaria a la cocina que de verdad usas.',
			'onboarding.welcome.itineraryTitle' => 'TU ITINERARIO CULINARIO',
			'onboarding.welcome.cuisineTitle' => 'Tus cocinas favoritas',
			'onboarding.welcome.cuisineBody' => 'Mediterránea, levantina, huerto andino o brasa nórdica. Define tus paladares de estación.',
			'onboarding.welcome.dietTitle' => 'Dieta e intereses botánicos',
			'onboarding.welcome.dietBody' => 'Preferencias vegetales, alimentos sin gluten, especias frescas y afinidades digestivas.',
			'onboarding.welcome.rhythmTitle' => 'Tu ritmo en los fogones',
			'onboarding.welcome.rhythmBody' => 'Cenas rápidas de 20 minutos o rituales pausados de fin de semana en cazuela de barro.',
			'onboarding.welcome.start' => 'Comenzar personalización (1 min)',
			'onboarding.welcome.skip' => 'Omitir por ahora',
			'onboarding.cuisines.title' => 'Elige tus cocinas favoritas.',
			'onboarding.cuisines.body' => 'Selecciona al menos tres para que tu primer feed no sea monótono.',
			'onboarding.cuisines.sectionTitle' => 'Curaduría de estación',
			'onboarding.cuisines.sectionBody' => 'Inspiración botánica y recetarios con huella de origen.',
			'onboarding.cuisines.counterNone' => 'Aún no hay cocinas seleccionadas',
			'onboarding.cuisines.counterOne' => '1 cocina seleccionada',
			'onboarding.cuisines.counterOther' => ({required Object count}) => '${count} cocinas seleccionadas',
			'onboarding.cuisines.remainingOne' => 'Selecciona 1 más',
			'onboarding.cuisines.remainingOther' => ({required Object count}) => 'Selecciona ${count} más',
			'onboarding.cuisines.ready' => '¡Todo listo!',
			'onboarding.cuisines.next' => 'Continuar a Dietas',
			'onboarding.diet.title' => 'Tu despensa, tus reglas.',
			'onboarding.diet.body' => 'Adaptamos las recetas a lo que necesitas y a lo que te da curiosidad.',
			'onboarding.diet.restrictionsTitle' => 'Restricciones dietarias',
			'onboarding.diet.restrictionsBody' => 'No te sugeriremos ingredientes que contengan estas restricciones.',
			'onboarding.diet.interestsTitle' => 'Intereses botánicos',
			'onboarding.diet.interestsBody' => 'Opcional: los temas que queremos priorizar.',
			'onboarding.diet.next' => 'Continuar a Tu Ritmo',
			'onboarding.rhythm.title' => '¿Cómo vives tu cocina?',
			'onboarding.rhythm.body' => 'Alineamos la complejidad de las técnicas y el tiempo de preparación a tus hábitos reales.',
			'onboarding.rhythm.skillTitle' => 'Nivel de destreza culinaria',
			'onboarding.rhythm.skillHint' => 'Elige uno',
			'onboarding.rhythm.timeTitle' => 'Tiempo habitual para cocinar',
			'onboarding.rhythm.timeHint' => 'Elige tu ritmo preferido',
			'onboarding.rhythm.next' => 'Revisar resumen',
			'onboarding.done.title' => '¡Todo listo para encender los fogones!',
			'onboarding.done.body' => 'Hemos diseñado un recetario inteligente a tu medida. Confirma tus selecciones antes de sincronizar tu despensa.',
			'onboarding.done.cuisinesTitle' => ({required Object count}) => 'Cocinas seleccionadas (${count})',
			'onboarding.done.dietTitle' => 'Restricciones y pasiones',
			'onboarding.done.rhythmTitle' => 'Ritmo culinario',
			'onboarding.done.dietLabel' => 'DIETA',
			'onboarding.done.interestsLabel' => 'INTERESES',
			'onboarding.done.editSection' => 'Editar',
			'onboarding.done.emptyCuisines' => 'Abierto a todo',
			'onboarding.done.emptyDiet' => 'Sin restricciones',
			'onboarding.done.emptyInterests' => 'Ninguno todavía',
			'onboarding.done.noTime' => 'Sin tiempo fijo',
			'onboarding.done.footnote' => 'Puedes modificar tus preferencias en cualquier momento desde Ajustes.',
			'onboarding.done.finish' => 'Continuar a SeasonPal',
			'onboarding.footer.begin' => 'Comenzar',
			'onboarding.footer.next' => 'Continuar',
			'onboarding.footer.finish' => 'Continuar',
			'onboarding.footer.saving' => 'Guardando…',
			'onboarding.saveError' => 'No pudimos guardar tus preferencias. Inténtalo de nuevo.',
			'onboarding.time.hour' => '1 hora',
			'onboarding.time.minSuffix' => 'min',
			'onboarding.time.buckets.quick.label' => '15–20 min',
			'onboarding.time.buckets.quick.description' => 'Express entre semana',
			'onboarding.time.buckets.balanced.label' => '30–45 min',
			'onboarding.time.buckets.balanced.description' => 'Equilibrio para elaborar',
			'onboarding.time.buckets.long.label' => '60+ min',
			'onboarding.time.buckets.long.description' => 'Estofados y rituales de fin de semana',
			'onboarding.time.buckets.variable.label' => 'Variable',
			'onboarding.time.buckets.variable.description' => 'Me adapto según el día',
			'onboarding.skill.beginner.label' => 'Principiante entusiasta',
			'onboarding.skill.beginner.description' => 'Técnicas sencillas, paso a paso detallado e ingredientes accesibles.',
			'onboarding.skill.intermediate.label' => 'Cocinero casero frecuente',
			'onboarding.skill.intermediate.description' => 'Confianza en cortes básicos, salsas y manejo del fuego.',
			'onboarding.skill.advanced.label' => 'Artesano / avanzado',
			'onboarding.skill.advanced.description' => 'Fermentación, horneado complejo y emplatado de autor.',
			'onboarding.options.cuisines.italian.label' => 'Italiana rústica y pasta',
			'onboarding.options.cuisines.italian.description' => 'Trigo antiguo, ragú, quesos curados',
			'onboarding.options.cuisines.italian.short' => 'Italiana',
			'onboarding.options.cuisines.mediterranean.label' => 'Mediterránea clásica',
			'onboarding.options.cuisines.mediterranean.description' => 'Aceites vivos, hierbas, pescado de mar',
			'onboarding.options.cuisines.mediterranean.short' => 'Mediterránea',
			'onboarding.options.cuisines.middleEastern.label' => 'Levantina y Oriente Medio',
			'onboarding.options.cuisines.middleEastern.description' => 'Za\'atar, tahini, granadas',
			'onboarding.options.cuisines.middleEastern.short' => 'De Oriente Medio',
			'onboarding.options.cuisines.mexican.label' => 'Oaxaqueña y tradicional',
			'onboarding.options.cuisines.mexican.description' => 'Moles negros, maíz criollo',
			'onboarding.options.cuisines.mexican.short' => 'Mexicana',
			'onboarding.options.cuisines.indian.label' => 'India especiada',
			'onboarding.options.cuisines.indian.description' => 'Masalas tostados, legumbres, ghee',
			'onboarding.options.cuisines.indian.short' => 'India',
			'onboarding.options.cuisines.japanese.label' => 'Japonesa y ramen artesanal',
			'onboarding.options.cuisines.japanese.description' => 'Caldos dashi, umami, fermentos',
			'onboarding.options.cuisines.japanese.short' => 'Japonesa',
			'onboarding.options.cuisines.korean.label' => 'Coreana y kimchi',
			'onboarding.options.cuisines.korean.description' => 'Gochujang, banchan, marinados',
			'onboarding.options.cuisines.korean.short' => 'Coreana',
			'onboarding.options.cuisines.thai.label' => 'Tailandesa aromática',
			'onboarding.options.cuisines.thai.description' => 'Hierba limón, lima kaffir, coco',
			'onboarding.options.cuisines.thai.short' => 'Tailandesa',
			'onboarding.options.cuisines.chinese.label' => 'Wok y dim sum',
			'onboarding.options.cuisines.chinese.description' => 'Fuego alto, vapor, soja y vinagre',
			'onboarding.options.cuisines.chinese.short' => 'China',
			'onboarding.options.cuisines.french.label' => 'Francesa bistró',
			'onboarding.options.cuisines.french.description' => 'Mantequilla avellanada, fondos, vino',
			'onboarding.options.cuisines.french.short' => 'Francesa',
			'onboarding.options.cuisines.spanish.label' => 'Ibérica y tapas',
			'onboarding.options.cuisines.spanish.description' => 'Pimentón, dehesa, conservas',
			'onboarding.options.cuisines.spanish.short' => 'Española',
			'onboarding.options.cuisines.greek.label' => 'Griega del Egeo',
			'onboarding.options.cuisines.greek.description' => 'Feta de pastura, orégano salvaje',
			'onboarding.options.cuisines.greek.short' => 'Griega',
			'onboarding.options.cuisines.turkish.label' => 'Anatolia y brasa',
			'onboarding.options.cuisines.turkish.description' => 'Bulgur, berenjena ahumada, yogur',
			'onboarding.options.cuisines.turkish.short' => 'Turca',
			'onboarding.options.cuisines.vietnamese.label' => 'Vietnamita fresca',
			'onboarding.options.cuisines.vietnamese.description' => 'Cilantro fino, rollos, phở',
			'onboarding.options.cuisines.vietnamese.short' => 'Vietnamita',
			'onboarding.options.cuisines.american.label' => 'Californiana farm-to-table',
			'onboarding.options.cuisines.american.description' => 'Cosecha local, platos limpios',
			'onboarding.options.cuisines.american.short' => 'Estadounidense',
			'onboarding.options.cuisines.northAfrican.label' => 'Marroquí y tagines',
			'onboarding.options.cuisines.northAfrican.description' => 'Ras el hanout, limón confitado',
			'onboarding.options.cuisines.northAfrican.short' => 'Del norte de África',
			'onboarding.options.cuisines.latinAmerican.label' => 'Peruana y nikkei',
			'onboarding.options.cuisines.latinAmerican.description' => 'Ajíes nativos, ceviches, rocoto',
			'onboarding.options.cuisines.latinAmerican.short' => 'Latinoamericana',
			'onboarding.options.cuisines.nordic.label' => 'Nórdica y fermentos',
			'onboarding.options.cuisines.nordic.description' => 'Encurtidos, centeno, ahumados',
			'onboarding.options.cuisines.nordic.short' => 'Nórdica',
			'onboarding.options.cuisines.caribbean.label' => 'Caribeña de islas',
			'onboarding.options.cuisines.caribbean.description' => 'Pimientos, coco, cítricos',
			'onboarding.options.cuisines.caribbean.short' => 'Caribeña',
			'onboarding.options.cuisines.african.label' => 'África de fuego lento',
			'onboarding.options.cuisines.african.description' => 'Guisos de una olla, tubérculos, especias',
			'onboarding.options.cuisines.african.short' => 'Africana',
			'onboarding.options.diets.vegetarian.label' => 'Vegetariana',
			'onboarding.options.diets.vegetarian.description' => 'Sin carnes ni pescados',
			'onboarding.options.diets.vegan.label' => 'Vegana',
			'onboarding.options.diets.vegan.description' => '100% de origen vegetal',
			'onboarding.options.diets.glutenFree.label' => 'Sin gluten',
			'onboarding.options.diets.glutenFree.description' => 'Libre de trigo, cebada y centeno',
			'onboarding.options.diets.dairyFree.label' => 'Sin lácteos',
			'onboarding.options.diets.dairyFree.description' => 'Sin leche, mantequilla ni queso',
			'onboarding.options.diets.nutFree.label' => 'Sin frutos secos',
			'onboarding.options.diets.nutFree.description' => 'Sin nueces ni almendras',
			'onboarding.options.diets.halal.label' => 'Halal',
			'onboarding.options.diets.halal.description' => 'Certificación y normas islámicas',
			'onboarding.options.diets.kosher.label' => 'Kosher',
			'onboarding.options.diets.kosher.description' => 'Conforme a preceptos cashrut',
			'onboarding.options.diets.pescatarian.label' => 'Pescatariana',
			'onboarding.options.diets.pescatarian.description' => 'Pescados, mariscos y vegetales',
			'onboarding.options.diets.lowCarb.label' => 'Baja en carbohidratos',
			'onboarding.options.diets.lowCarb.description' => 'Menos hidratos, más proteína',
			'onboarding.options.diets.lowSodium.label' => 'Baja en sodio',
			'onboarding.options.diets.lowSodium.description' => 'Para control cardiovascular',
			'onboarding.options.interests.weeknightDinners' => 'Cenas de entre semana',
			'onboarding.options.interests.mealPrep' => 'Meal prep',
			'onboarding.options.interests.baking' => 'Repostería',
			'onboarding.options.interests.grilling' => 'Parrilla',
			'onboarding.options.interests.slowCooking' => 'Cocción lenta',
			'onboarding.options.interests.fermentation' => 'Fermentación',
			'onboarding.options.interests.plantForward' => 'Cocina vegetal',
			'onboarding.options.interests.comfortFood' => 'Comida reconfortante',
			'onboarding.options.interests.entertaining' => 'Recibir en casa',
			'onboarding.options.interests.budgetCooking' => 'Cocina económica',
			'onboarding.options.interests.cookingWithKids' => 'Cocinar con niños',
			'onboarding.options.interests.spicesAndHeat' => 'Especias y picante',
			'discovery.eyebrow' => 'DESCUBRIR',
			'discovery.title' => 'Encuentra tu próxima mesa.',
			'discovery.subtitle' => 'Busca recetas públicas y filtra por cocina, tiempo, comida y dieta.',
			'discovery.searchHint' => 'Busca recetas, ingredientes o cocinas',
			'discovery.filters.cuisine' => 'Cocina',
			'discovery.filters.meal' => 'Comida',
			'discovery.filters.time' => 'Tiempo',
			'discovery.filters.difficulty' => 'Esfuerzo',
			'discovery.filters.diet' => 'Dieta',
			'discovery.filters.any' => 'Cualquiera',
			'discovery.filters.clearAll' => 'Limpiar todo',
			'discovery.time.under' => ({required Object count}) => 'Menos de ${count} min',
			'discovery.feed.loading' => 'Preparando la mesa.',
			'discovery.feed.loadError' => 'No pudimos cargar el feed público.',
			'discovery.feed.results' => ({required Object count}) => '${count} recetas',
			'discovery.feed.resultsOne' => '1 receta',
			'discovery.feed.newestFirst' => 'Más recientes primero',
			'discovery.feed.bestMatch' => 'Mejor coincidencia',
			'discovery.feed.loadMoreError' => 'No pudimos cargar más recetas.',
			'discovery.feed.emptyTitle' => 'Nada coincide con esa mesa.',
			'discovery.feed.emptyBody' => 'Prueba con más tiempo, otra cocina o una búsqueda más corta.',
			'discovery.feed.emptyCommunityTitle' => 'La mesa de la comunidad aún se está preparando.',
			'discovery.feed.emptyCommunityBody' => 'Publica una receta y podrá aparecer aquí para otros cocineros.',
			'discovery.pantry.eyebrow' => 'LA DESPENSA',
			'discovery.pantry.title' => 'Cocina con lo que tienes.',
			'discovery.pantry.subtitle' => 'Añade los ingredientes de tu despensa. Ordenaremos las recetas públicas según cuánto de cada una ya tienes.',
			'discovery.pantry.body' => 'Compara recetas públicas con tu despensa.',
			'discovery.pantry.inputHint' => 'Añade un ingrediente, o varios separados por comas',
			'discovery.pantry.add' => 'Añadir',
			'discovery.pantry.clear' => 'Vaciar despensa',
			'discovery.pantry.remove' => ({required Object name}) => 'Quitar ${name}',
			'discovery.pantry.loading' => 'Revisando la despensa.',
			'discovery.pantry.loadError' => 'No pudimos comparar tu despensa.',
			'discovery.pantry.loadMoreError' => 'No pudimos cargar más coincidencias.',
			'discovery.pantry.loadMore' => 'Cargar más',
			'discovery.pantry.results' => ({required Object count}) => '${count} coincidencias',
			'discovery.pantry.resultsOne' => '1 coincidencia',
			'discovery.pantry.emptyTitle' => 'Aún no hay coincidencias.',
			'discovery.pantry.emptyBody' => 'Prueba con menos ingredientes o más generales, como "tomate" en vez de "tomates cherry".',
			'discovery.pantry.emptyPromptTitle' => 'Empieza con lo que tienes.',
			'discovery.pantry.emptyPromptBody' => 'Añade algunos ingredientes arriba y buscaremos recetas públicas que necesiten menos compras.',
			'discovery.pantry.canCook' => 'Puedes cocinar',
			'discovery.pantry.match' => ({required Object percent}) => '${percent}% de coincidencia',
			'discovery.pantry.have' => ({required Object names}) => 'Tienes: ${names}',
			'discovery.pantry.missing' => ({required Object names}) => 'Falta: ${names}',
			'discovery.pantry.allIngredients' => 'Tienes todo.',
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
			'home.pantry.eyebrow' => 'DE TU DESPENSA',
			'home.pantry.title' => '¿Qué puedo cocinar ahora?',
			'home.pantry.body' => 'Escribe lo que tienes. Buscaremos recetas públicas que usen la mayor parte.',
			'home.pantry.hint' => 'Limón, orzo, espinaca',
			'home.pantry.action' => 'Buscar recetas',
			'home.pantry.empty' => 'Añade al menos un ingrediente.',
			'home.rails.loading' => 'Buscando qué se cocina cerca.',
			'home.rails.forYouEyebrow' => 'PARA TU GUSTO',
			'home.rails.forYouTitle' => 'Hecho con tus cocinas y dietas.',
			'home.rails.trendingEyebrow' => 'TENDENCIA ESTA SEMANA',
			'home.rails.trendingTitle' => 'Lo que otros cocineros guardan.',
			'home.rails.newestEyebrow' => 'RECIÉN LLEGADO',
			'home.rails.newestTitle' => 'Las últimas recetas públicas.',
			'home.rails.loadError' => 'No pudimos cargar las recomendaciones de la comunidad.',
			'home.rails.emptyTitle' => 'La mesa de la comunidad aún se está preparando.',
			'home.rails.emptyBody' => 'Publica una receta y podrá aparecer aquí para otros cocineros.',
			'home.rails.action' => 'Explorar Descubrir',
			'home.taste.eyebrow' => 'TU PALADAR',
			'home.taste.loading' => 'Leyendo tu perfil de sabor…',
			'home.taste.loadError' => 'No pudimos cargar tu perfil de sabor.',
			'home.taste.noTime' => 'Sin tiempo fijo',
			'home.taste.empty' => 'Tu cocina está abierta a todo.',
			'home.taste.one' => ({required Object cuisine}) => 'Tu cocina tira a ${cuisine}.',
			'home.taste.two' => ({required Object first, required Object second}) => 'Tu cocina tira a ${first} y ${second}.',
			'home.taste.many' => ({required Object first, required Object second}) => 'Tu cocina tira a ${first}, ${second} y más.',
			'home.taste.noRestrictions' => 'No hay restricciones dietéticas guardadas.',
			'home.taste.dietOne' => ({required Object restriction}) => 'Dieta ${restriction}.',
			'home.taste.dietMany' => ({required Object leading, required Object last}) => 'Dieta ${leading} y ${last}.',
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
			_ => null,
		} ?? switch (path) {
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
