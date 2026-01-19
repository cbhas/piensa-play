/**
 * Firebase Seed Script for PiensaPlay - Unified Question Format
 * 
 * This script populates Firestore with UnifiedQuestion format.
 * 
 * Usage:
 *   1. Download your Firebase service account key from Firebase Console
 *   2. Save it as 'serviceAccountKey.json' in this folder
 *   3. Run: npm install
 *   4. Run: npm run seed:questions
 */

import { initializeApp, cert } from 'firebase-admin/app';
import { getFirestore } from 'firebase-admin/firestore';
import { readFileSync, existsSync } from 'fs';

// ============================================================================
// CONFIGURATION
// ============================================================================

const DRY_RUN = process.argv.includes('--dry-run');
const SERVICE_ACCOUNT_PATH = './serviceAccountKey.json';

if (!existsSync(SERVICE_ACCOUNT_PATH)) {
    console.error('❌ Error: serviceAccountKey.json not found!');
    process.exit(1);
}

const serviceAccount = JSON.parse(readFileSync(SERVICE_ACCOUNT_PATH, 'utf8'));

initializeApp({
    credential: cert(serviceAccount)
});

const db = getFirestore();

// ============================================================================
// UNIFIED QUESTIONS - New Format with feedback per option
// ============================================================================

const unifiedQuestions = [
    // =========================================================================
    // VERACIDADVILLE - Quiz Questions (fake_news mission)
    // =========================================================================
    {
        id: 'q1_zanahoria',
        missionId: 'fake_news',
        type: 'quiz',
        title: '¿Cuáles son las señales de que esta noticia es falsa?',
        subtitle: 'Selecciona todos los elementos sospechosos',
        content: 'Científicos descubren que beber jugo de zanahoria hace que puedas ver en la oscuridad. Según un estudio reciente, beber un vaso de jugo de zanahoria diariamente durante 30 días permite desarrollar visión nocturna similar a la de los gatos.',
        imageUrl: null,
        source: 'ElNoticiero.com',
        date: 'Publicado: Hoy',
        options: [
            { id: 'author', text: 'Autor no es un experto real', isCorrect: true, feedback: 'El "Dr. Inventado" no es un experto verificable' },
            { id: 'source', text: 'Fuente no confiable', isCorrect: true, feedback: 'ElNoticiero.com no es una fuente verificada' },
            { id: 'image', text: 'Imagen manipulada', isCorrect: false, feedback: 'No hay imagen en esta noticia' },
            { id: 'data', text: 'Datos exagerados', isCorrect: true, feedback: '"Visión de gato en 30 días" es claramente exagerado' },
        ],
        explanation: '¡Excelente! Identificaste correctamente las señales de desinformación. Las zanahorias ayudan a la salud visual pero no dan visión nocturna.',
        incorrectExplanation: 'Esta noticia es falsa. El autor "Dr. Inventado" no es real, la fuente no es confiable, y los datos son exagerados. Las zanahorias ayudan pero no dan visión nocturna.',
        order: 1,
    },
    {
        id: 'q2_vacunas',
        missionId: 'fake_news',
        type: 'quiz',
        title: '¿Qué señales indican que esta noticia es falsa?',
        subtitle: 'Selecciona todos los elementos sospechosos',
        content: '¡URGENTE! Vacunas causan superpoderes en niños, dice estudio. Un grupo de científicos anónimos reveló que las vacunas están diseñadas para dar superpoderes a los niños. ¡Comparte antes de que lo borren!',
        imageUrl: null,
        source: 'NoticiasTotales.net',
        date: 'Publicado: Hace 2 horas',
        options: [
            { id: 'author', text: 'Autor anónimo (no confiable)', isCorrect: true, feedback: 'Los "científicos anónimos" no son verificables' },
            { id: 'source', text: 'Fuente no verificada', isCorrect: true, feedback: 'NoticiasTotales.net no es un medio reconocido' },
            { id: 'urgency', text: 'Presión para compartir', isCorrect: true, feedback: '"¡Comparte antes de que lo borren!" es manipulación emocional' },
            { id: 'claim', text: 'Afirmación absurda', isCorrect: true, feedback: '"Superpoderes" es científicamente imposible' },
        ],
        explanation: '¡Perfecto! Esta es una noticia falsa peligrosa. Todas las opciones son señales de desinformación.',
        incorrectExplanation: 'Esta es una noticia falsa. Usa autor anónimo, fuente no verificada, presión emocional y afirmaciones absurdas. Nunca compartas sin verificar.',
        order: 2,
    },
    {
        id: 'q3_agua_mar',
        missionId: 'fake_news',
        type: 'quiz',
        title: '¿Por qué esta noticia es falsa?',
        subtitle: 'Selecciona las señales de desinformación',
        content: 'Médicos ocultan la verdad: beber agua de mar cura todas las enfermedades. La industria farmacéutica no quiere que sepas esto: el agua de mar puede curar cáncer, diabetes y hasta el resfriado común.',
        imageUrl: null,
        source: 'SaludAlternativa.blog',
        date: 'Publicado: Ayer',
        options: [
            { id: 'conspiracy', text: 'Teoría de conspiración', isCorrect: true, feedback: '"Médicos ocultan" es típico de conspiraciones' },
            { id: 'miracle', text: 'Promesa de cura milagrosa', isCorrect: true, feedback: 'Prometer curar "todas las enfermedades" es imposible' },
            { id: 'source', text: 'Fuente no científica', isCorrect: true, feedback: 'Un blog no es fuente científica' },
            { id: 'evidence', text: 'Sin evidencia verificable', isCorrect: true, feedback: 'No cita estudios ni datos reales' },
        ],
        explanation: '¡Excelente trabajo! Identificaste todas las señales. Esta información es peligrosa: beber agua de mar puede causar deshidratación severa.',
        incorrectExplanation: 'Esta noticia es falsa y peligrosa. Usa teorías de conspiración, promete curas milagrosas sin evidencia. ¡Beber agua de mar es peligroso!',
        order: 3,
    },

    // =========================================================================
    // VERACIDADVILLE - True/False Questions (titular mission)
    // =========================================================================
    {
        id: 'tf_q1',
        missionId: 'titular',
        type: 'trueFalse',
        title: '¿Esta noticia es verdadera o falsa?',
        content: '¡CURA MÁGICA PARA EL RESFRIADO! Científicos descubren que beber agua con limón y miel ¡ELIMINA INSTANTÁNEAMENTE CUALQUIER VIRUS! Compartir con todos tus contactos para protegerlos. 🍋',
        imageUrl: null,
        source: 'SaludTotal.com',
        date: 'Hace 2 horas',
        options: [
            { id: 'true', text: 'Verdadero', isCorrect: false, feedback: 'El lenguaje exagerado y las mayúsculas son señales de desinformación' },
            { id: 'false', text: 'Falso', isCorrect: true, feedback: 'Correcto - el agua con limón y miel puede aliviar síntomas, pero no "elimina virus instantáneamente"' },
        ],
        correctBoolAnswer: false,
        explanation: '¡Muy bien! El lenguaje exagerado ("ELIMINA INSTANTÁNEAMENTE"), mayúsculas excesivas y presión para compartir son señales claras de desinformación.',
        incorrectExplanation: 'Esta noticia es FALSA. Fíjate en las mayúsculas, la promesa exagerada y la presión para compartir. El agua con limón y miel puede aliviar síntomas, pero no cura virus.',
        order: 1,
    },
    {
        id: 'tf_q2',
        missionId: 'titular',
        type: 'trueFalse',
        title: '¿Esta noticia es verdadera o falsa?',
        content: 'Estudio revela beneficios del ejercicio regular. Investigadores de la Universidad Nacional publicaron un estudio en la revista médica "The Lancet" que muestra cómo 30 minutos de ejercicio diario pueden mejorar la salud cardiovascular.',
        imageUrl: null,
        source: 'CienciaHoy.edu',
        date: 'Hace 1 día',
        options: [
            { id: 'true', text: 'Verdadero', isCorrect: true, feedback: 'Correcto - tiene fuentes verificables y usa lenguaje moderado' },
            { id: 'false', text: 'Falso', isCorrect: false, feedback: 'Esta noticia tiene características de información confiable' },
        ],
        correctBoolAnswer: true,
        explanation: '¡Excelente! Esta noticia es VERDADERA. Cita fuentes verificables (Universidad, The Lancet), usa datos específicos y lenguaje profesional.',
        incorrectExplanation: 'Esta noticia es VERDADERA. Fíjate que cita fuentes verificables (Universidad Nacional, The Lancet), usa datos específicos y lenguaje moderado.',
        order: 2,
    },
    {
        id: 'tf_q3',
        missionId: 'titular',
        type: 'trueFalse',
        title: '¿Esta noticia es verdadera o falsa?',
        content: '¡GOBIERNO OCULTA LA VERDAD! ¡LO QUE NO QUIEREN QUE SEPAS! Las antenas 5G están controlando nuestras mentes. ¡COMPARTE ANTES DE QUE BORREN ESTE MENSAJE! 👁️',
        imageUrl: null,
        source: 'NoticiasSinCensurar.net',
        date: 'Hace 3 horas',
        options: [
            { id: 'true', text: 'Verdadero', isCorrect: false, feedback: 'Esta noticia tiene múltiples señales de desinformación' },
            { id: 'false', text: 'Falso', isCorrect: true, feedback: 'Correcto - es una teoría de conspiración sin fundamento científico' },
        ],
        correctBoolAnswer: false,
        explanation: '¡Perfecto! Es una teoría de conspiración FALSA. Las mayúsculas, lenguaje alarmista y presión para compartir son señales claras.',
        incorrectExplanation: 'Esta es una teoría de conspiración FALSA. Fíjate en el lenguaje alarmista, las mayúsculas y la presión para compartir. No hay evidencia científica.',
        order: 3,
    },

    // =========================================================================
    // ZONA CERO ODIO - Word Selection (mensaje_escondido mission)
    // =========================================================================
    {
        id: 'ws_1',
        missionId: 'mensaje_escondido',
        type: 'wordSelection',
        title: 'Identifica las palabras que promueven el odio',
        subtitle: 'Selecciona las palabras negativas en este mensaje',
        content: 'Analiza el siguiente mensaje y encuentra el lenguaje dañino.',
        options: [
            { id: 'w1', text: 'Respeto', isCorrect: false, feedback: 'Esta es una palabra positiva' },
            { id: 'w2', text: 'Discriminar', isCorrect: true, feedback: 'Discriminar significa tratar de forma desigual' },
            { id: 'w3', text: 'Igualdad', isCorrect: false, feedback: 'Esta es una palabra que promueve inclusión' },
            { id: 'w4', text: 'Odio', isCorrect: true, feedback: 'El odio es un sentimiento destructivo' },
            { id: 'w5', text: 'Tolerancia', isCorrect: false, feedback: 'La tolerancia es un valor positivo' },
            { id: 'w6', text: 'Insultar', isCorrect: true, feedback: 'Los insultos lastiman a las personas' },
        ],
        correctWords: ['Discriminar', 'Odio', 'Insultar'],
        explanation: '¡Perfecto! Identificaste correctamente las palabras que causan daño: discriminar, odio e insultar dividen a las personas.',
        incorrectExplanation: 'Las palabras discriminar, odio e insultar son ejemplos de lenguaje negativo. El respeto, igualdad y tolerancia son valores positivos.',
        order: 1,
    },
    {
        id: 'ws_2',
        missionId: 'mensaje_escondido',
        type: 'wordSelection',
        title: 'Encuentra el lenguaje inclusivo',
        subtitle: 'Selecciona las palabras que promueven la inclusión',
        content: 'Identifica las palabras que construyen comunidad.',
        options: [
            { id: 'w1', text: 'Empatía', isCorrect: true, feedback: 'Empatía es ponerse en el lugar del otro' },
            { id: 'w2', text: 'Exclusión', isCorrect: false, feedback: 'Excluir es dejar fuera a alguien' },
            { id: 'w3', text: 'Diversidad', isCorrect: true, feedback: 'La diversidad nos enriquece como sociedad' },
            { id: 'w4', text: 'Prejuicio', isCorrect: false, feedback: 'Los prejuicios son opiniones sin fundamento' },
            { id: 'w5', text: 'Respeto', isCorrect: true, feedback: 'El respeto es la base de la convivencia' },
            { id: 'w6', text: 'Burla', isCorrect: false, feedback: 'La burla lastima a los demás' },
        ],
        correctWords: ['Empatía', 'Diversidad', 'Respeto'],
        explanation: '¡Excelente! Empatía, diversidad y respeto son valores que construyen una sociedad más inclusiva y unida.',
        incorrectExplanation: 'Las palabras correctas son empatía, diversidad y respeto. La exclusión, prejuicio y burla son comportamientos dañinos.',
        order: 2,
    },
    {
        id: 'ws_3',
        missionId: 'mensaje_escondido',
        type: 'wordSelection',
        title: '¿Qué comentarios son dañinos?',
        subtitle: 'Identifica el discurso de odio',
        content: 'En redes sociales vemos muchos tipos de comentarios. ¿Cuáles debemos evitar?',
        options: [
            { id: 'w1', text: 'Vuelve a tu país', isCorrect: true, feedback: 'Xenofobia - rechaza a personas por su origen' },
            { id: 'w2', text: 'Bienvenido/a', isCorrect: false, feedback: 'Expresión amable y acogedora' },
            { id: 'w3', text: 'Eres diferente', isCorrect: false, feedback: 'Observación neutral' },
            { id: 'w4', text: 'No mereces estar aquí', isCorrect: true, feedback: 'Deshumaniza y excluye a la persona' },
            { id: 'w5', text: 'Todos somos iguales', isCorrect: false, feedback: 'Mensaje de igualdad y respeto' },
            { id: 'w6', text: 'Gente como tú...', isCorrect: true, feedback: 'Generaliza negativamente a un grupo' },
        ],
        correctWords: ['Vuelve a tu país', 'No mereces estar aquí', 'Gente como tú...'],
        explanation: '¡Muy bien! Identificaste el discurso de odio. Estas frases excluyen y atacan a personas por su identidad.',
        incorrectExplanation: 'Frases como "Vuelve a tu país", "No mereces estar aquí" y "Gente como tú..." son discurso de odio que excluye y daña.',
        order: 3,
    },

    // =========================================================================
    // CIBERSEGURIDAD - Quiz Questions (q1_phishing mission)
    // =========================================================================
    {
        id: 'cyber_q1',
        missionId: 'q1_phishing',
        type: 'quiz',
        title: '¿Cómo identificar un correo de phishing?',
        subtitle: 'Selecciona las señales de alerta',
        content: 'Recibiste un correo de "tu banco" que dice: "URGENTE: Su cuenta será bloqueada en 24 horas. Haga clic aquí para verificar sus datos."',
        imageUrl: null,
        source: 'soporte@banc0-seguro.xyz',
        options: [
            { id: 'urgency', text: 'Mensaje de urgencia extrema', isCorrect: true, feedback: 'Los estafadores crean urgencia para que actúes sin pensar' },
            { id: 'domain', text: 'Dominio sospechoso (.xyz)', isCorrect: true, feedback: 'Los bancos usan dominios oficiales, no .xyz' },
            { id: 'spelling', text: 'Error en nombre del banco', isCorrect: true, feedback: '"banc0" con cero es un truco para engañar' },
            { id: 'link', text: 'Pide hacer clic en enlace', isCorrect: true, feedback: 'Los bancos nunca piden datos por correo' },
        ],
        explanation: '¡Excelente! Identificaste todas las señales de phishing. Siempre verifica contactando directamente a tu banco.',
        incorrectExplanation: 'Todas son señales de phishing: urgencia extrema, dominio sospechoso (.xyz), error ortográfico (banc0) y solicitud de clic. Los bancos nunca piden datos por correo.',
        order: 1,
    },
    {
        id: 'cyber_q2',
        missionId: 'q1_phishing',
        type: 'quiz',
        title: '¿Qué hacer si recibes un mensaje sospechoso?',
        subtitle: 'Elige la mejor acción',
        content: 'Recibes un SMS: "Has ganado $1000! Responde con tu número de tarjeta para reclamar tu premio."',
        options: [
            { id: 'ignore', text: 'Ignorar y eliminar el mensaje', isCorrect: true, feedback: 'Correcto - nunca respondas a mensajes sospechosos' },
            { id: 'respond', text: 'Responder para investigar', isCorrect: false, feedback: 'Responder confirma que tu número está activo' },
            { id: 'click', text: 'Hacer clic para ver si es real', isCorrect: false, feedback: 'Los enlaces pueden instalar malware' },
            { id: 'share', text: 'Compartir con amigos', isCorrect: false, feedback: 'Estarías propagando la estafa' },
        ],
        explanation: '¡Perfecto! La mejor acción es ignorar y eliminar. Los premios legítimos nunca piden datos bancarios por SMS.',
        incorrectExplanation: 'Nunca respondas ni hagas clic en mensajes sospechosos. La mejor acción es ignorar y eliminar. Los premios reales no piden datos por SMS.',
        order: 2,
    },
    {
        id: 'cyber_q3',
        missionId: 'q1_phishing',
        type: 'trueFalse',
        title: '¿Es seguro dar tu contraseña a alguien del "soporte técnico" que te llama?',
        content: 'Alguien llama diciendo ser del soporte técnico de tu computadora y necesita tu contraseña para "arreglar un virus".',
        options: [
            { id: 'true', text: 'Sí, si parece legítimo', isCorrect: false, feedback: 'Nunca des tu contraseña por teléfono, sin importar quién llame' },
            { id: 'false', text: 'No, nunca', isCorrect: true, feedback: 'Correcto - el soporte técnico legítimo nunca pide contraseñas' },
        ],
        correctBoolAnswer: false,
        explanation: '¡Excelente! NUNCA des tu contraseña por teléfono. El soporte técnico real tiene otras formas de ayudarte.',
        incorrectExplanation: 'NUNCA des tu contraseña por teléfono. El soporte técnico legítimo nunca necesita tu contraseña. Es una estafa común.',
        order: 3,
    },

    // =========================================================================
    // CIBERSEGURIDAD - Quiz Questions (q2_malware mission)
    // =========================================================================
    {
        id: 'malware_q1',
        missionId: 'q2_malware',
        type: 'quiz',
        title: '¿Cuáles son señales de que tu dispositivo tiene malware?',
        subtitle: 'Selecciona todas las señales sospechosas',
        content: 'Tu computadora ha estado actuando extraño últimamente. ¿Qué podría indicar que tiene un virus o malware?',
        options: [
            { id: 'slow', text: 'Se vuelve muy lenta de repente', isCorrect: true, feedback: 'El malware consume recursos del sistema' },
            { id: 'popups', text: 'Aparecen ventanas emergentes constantemente', isCorrect: true, feedback: 'Los pop-ups excesivos son señal de adware' },
            { id: 'programs', text: 'Hay programas que no instalaste', isCorrect: true, feedback: 'Software no autorizado puede ser malicioso' },
            { id: 'battery', text: 'La batería dura menos', isCorrect: true, feedback: 'El malware puede drenar la batería' },
        ],
        explanation: '¡Perfecto! Todas estas son señales comunes de malware. Si notas varias, escanea tu dispositivo con un antivirus.',
        incorrectExplanation: 'Todas son señales de malware: lentitud, pop-ups, programas desconocidos y batería agotada. Escanea tu dispositivo si notas estos síntomas.',
        order: 1,
    },
    {
        id: 'malware_q2',
        missionId: 'q2_malware',
        type: 'quiz',
        title: '¿Cómo puedes protegerte del malware?',
        subtitle: 'Elige las mejores prácticas',
        content: 'Quieres mantener tu dispositivo seguro. ¿Qué acciones deberías tomar?',
        options: [
            { id: 'antivirus', text: 'Instalar y actualizar antivirus', isCorrect: true, feedback: 'Un antivirus actualizado es tu primera defensa' },
            { id: 'downloads', text: 'Descargar solo de fuentes oficiales', isCorrect: true, feedback: 'Las tiendas oficiales verifican las apps' },
            { id: 'updates', text: 'Mantener el sistema actualizado', isCorrect: true, feedback: 'Las actualizaciones corrigen vulnerabilidades' },
            { id: 'links', text: 'No hacer clic en enlaces sospechosos', isCorrect: true, feedback: 'Los enlaces pueden llevar a descargas maliciosas' },
        ],
        explanation: '¡Excelente! Todas son prácticas esenciales de seguridad. Combínalas para máxima protección.',
        incorrectExplanation: 'Todas son importantes: antivirus actualizado, descargas oficiales, sistema al día y cuidado con los enlaces.',
        order: 2,
    },
    {
        id: 'malware_q3',
        missionId: 'q2_malware',
        type: 'trueFalse',
        title: '¿Es seguro descargar juegos o apps de sitios no oficiales porque son gratis?',
        content: 'Encontraste un sitio que ofrece juegos de pago gratis. Solo tienes que descargar e instalar.',
        options: [
            { id: 'true', text: 'Sí, si otros lo recomiendan', isCorrect: false, feedback: 'El software pirata frecuentemente contiene malware oculto' },
            { id: 'false', text: 'No, es muy riesgoso', isCorrect: true, feedback: 'Correcto - el software no oficial puede contener virus' },
        ],
        correctBoolAnswer: false,
        explanation: '¡Muy bien! Los sitios de software pirata son una fuente común de malware. Siempre usa tiendas oficiales.',
        incorrectExplanation: 'Descargar software de sitios no oficiales es MUY riesgoso. Estos archivos frecuentemente contienen malware que puede robar tus datos.',
        order: 3,
    },

    // =========================================================================
    // CIBERSEGURIDAD - Quiz Questions (q3_passwords mission)
    // =========================================================================
    {
        id: 'pass_q1',
        missionId: 'q3_passwords',
        type: 'quiz',
        title: '¿Qué hace que una contraseña sea fuerte?',
        subtitle: 'Selecciona las características importantes',
        content: 'Vas a crear una nueva contraseña para tu cuenta. ¿Qué debería tener una buena contraseña?',
        options: [
            { id: 'length', text: 'Más de 12 caracteres', isCorrect: true, feedback: 'Las contraseñas largas son más difíciles de adivinar' },
            { id: 'mixed', text: 'Mezcla de mayúsculas, minúsculas y números', isCorrect: true, feedback: 'La variedad aumenta las combinaciones posibles' },
            { id: 'symbols', text: 'Incluir símbolos especiales (!@#$)', isCorrect: true, feedback: 'Los símbolos añaden otra capa de complejidad' },
            { id: 'unique', text: 'Diferente para cada cuenta', isCorrect: true, feedback: 'Si hackean una, las demás siguen seguras' },
        ],
        explanation: '¡Perfecto! Una contraseña fuerte es larga, variada, con símbolos y única para cada cuenta.',
        incorrectExplanation: 'Una buena contraseña debe: tener más de 12 caracteres, mezclar tipos de caracteres, incluir símbolos y ser única para cada cuenta.',
        order: 1,
    },
    {
        id: 'pass_q2',
        missionId: 'q3_passwords',
        type: 'quiz',
        title: '¿Cuál de estas contraseñas es la MÁS segura?',
        subtitle: 'Elige la mejor opción',
        content: 'Tu amigo necesita crear una nueva contraseña. ¿Cuál le recomendarías?',
        options: [
            { id: 'weak1', text: '123456789', isCorrect: false, feedback: 'Esta es una de las contraseñas más hackeadas del mundo' },
            { id: 'weak2', text: 'miperro2020', isCorrect: false, feedback: 'Información personal es fácil de adivinar' },
            { id: 'strong', text: 'P@ssw0rd_Segur@!2024', isCorrect: true, feedback: 'Combina longitud, variedad y símbolos' },
            { id: 'weak3', text: 'password', isCorrect: false, feedback: 'Esta palabra está en todas las listas de hackers' },
        ],
        explanation: '¡Excelente elección! P@ssw0rd_Segur@!2024 es fuerte porque es larga, tiene símbolos y mezcla caracteres.',
        incorrectExplanation: 'La correcta es "P@ssw0rd_Segur@!2024" porque es larga, tiene símbolos, números y mezcla mayúsculas/minúsculas.',
        order: 2,
    },
    {
        id: 'pass_q3',
        missionId: 'q3_passwords',
        type: 'trueFalse',
        title: '¿Es buena idea usar la misma contraseña para todas tus cuentas?',
        content: 'Tu amigo usa la misma contraseña para su correo, redes sociales y banco porque es más fácil de recordar.',
        options: [
            { id: 'true', text: 'Sí, es más práctico', isCorrect: false, feedback: 'Si hackean una cuenta, tienen acceso a todas' },
            { id: 'false', text: 'No, es muy peligroso', isCorrect: true, feedback: 'Correcto - cada cuenta debe tener contraseña única' },
        ],
        correctBoolAnswer: false,
        explanation: '¡Correcto! Usar la misma contraseña es peligroso. Si hackean una cuenta, todas quedan expuestas.',
        incorrectExplanation: 'NUNCA uses la misma contraseña para todo. Si un sitio es hackeado, los atacantes probarán esa contraseña en todos tus demás servicios.',
        order: 3,
    },

    // =========================================================================
    // VERACIDADVILLE - Quiz Questions (fuentes_confiables mission)
    // =========================================================================
    {
        id: 'fuentes_q1',
        missionId: 'fuentes_confiables',
        type: 'quiz',
        title: '¿Qué características tiene una fuente confiable?',
        subtitle: 'Selecciona las señales de credibilidad',
        content: 'Estás investigando un tema para un trabajo escolar. ¿Cómo sabes si una fuente es confiable?',
        options: [
            { id: 'author', text: 'El autor es identificable y experto', isCorrect: true, feedback: 'Los expertos verificables dan credibilidad' },
            { id: 'sources', text: 'Cita sus propias fuentes', isCorrect: true, feedback: 'Las fuentes confiables muestran de dónde sacan la información' },
            { id: 'domain', text: 'Usa dominios oficiales (.edu, .gov)', isCorrect: true, feedback: 'Los dominios institucionales tienen más control' },
            { id: 'date', text: 'Tiene fecha de publicación reciente', isCorrect: true, feedback: 'La información actualizada es más confiable' },
        ],
        explanation: '¡Perfecto! Una fuente confiable tiene autor experto, cita sus fuentes, usa dominios oficiales y está actualizada.',
        incorrectExplanation: 'Las fuentes confiables: tienen autor verificable, citan sus fuentes, usan dominios oficiales y están actualizadas.',
        order: 1,
    },
    {
        id: 'fuentes_q2',
        missionId: 'fuentes_confiables',
        type: 'quiz',
        title: '¿Cuál de estos sitios es MÁS confiable para información de salud?',
        subtitle: 'Elige la fuente más creíble',
        content: 'Quieres saber sobre una enfermedad. ¿Dónde buscarías información?',
        options: [
            { id: 'blog', text: 'SaludTotal.blog (blog personal)', isCorrect: false, feedback: 'Los blogs personales no tienen revisión médica' },
            { id: 'gov', text: 'Ministerio de Salud (.gov)', isCorrect: true, feedback: 'Las instituciones oficiales tienen información verificada' },
            { id: 'social', text: 'Post viral en Facebook', isCorrect: false, feedback: 'Las redes sociales propagan mucha desinformación' },
            { id: 'video', text: 'Video de YouTuber famoso', isCorrect: false, feedback: 'La fama no garantiza conocimiento médico' },
        ],
        explanation: '¡Excelente! El Ministerio de Salud es la fuente más confiable porque es oficial y tiene expertos.',
        incorrectExplanation: 'Para información de salud, siempre usa fuentes oficiales como el Ministerio de Salud. Los blogs y redes sociales no son confiables.',
        order: 2,
    },
    {
        id: 'fuentes_q3',
        missionId: 'fuentes_confiables',
        type: 'trueFalse',
        title: '¿Wikipedia siempre es una fuente 100% confiable?',
        content: 'Tu compañero dice que Wikipedia es perfecta para citar en trabajos escolares porque cualquiera puede corregir errores.',
        options: [
            { id: 'true', text: 'Sí, es muy confiable', isCorrect: false, feedback: 'Wikipedia es un buen punto de partida pero no debe ser tu única fuente' },
            { id: 'false', text: 'No, hay que verificar', isCorrect: true, feedback: 'Correcto - Wikipedia puede tener errores y debe verificarse' },
        ],
        correctBoolAnswer: false,
        explanation: '¡Muy bien! Wikipedia es útil para empezar, pero debes verificar la información con las fuentes que ella misma cita.',
        incorrectExplanation: 'Wikipedia NO es 100% confiable. Cualquiera puede editarla. Úsala como punto de partida y verifica con las fuentes originales que cita.',
        order: 3,
    },

    // =========================================================================
    // ZONA CERO ODIO - Quiz Questions (empatia_digital mission)
    // =========================================================================
    {
        id: 'empatia_q1',
        missionId: 'empatia_digital',
        type: 'quiz',
        title: '¿Cómo responder a alguien que está triste en línea?',
        subtitle: 'Elige las respuestas empáticas',
        content: 'Tu amigo publicó que se siente muy solo. ¿Qué respuestas muestran empatía?',
        options: [
            { id: 'listen', text: 'Estoy aquí si quieres hablar', isCorrect: true, feedback: 'Ofrecer escuchar muestra apoyo genuino' },
            { id: 'validate', text: 'Es normal sentirse así a veces', isCorrect: true, feedback: 'Validar sus sentimientos lo hace sentir comprendido' },
            { id: 'dismiss', text: 'Supéralo, no es para tanto', isCorrect: false, feedback: 'Esto minimiza sus sentimientos' },
            { id: 'offer', text: '¿Quieres que hagamos algo juntos?', isCorrect: true, feedback: 'Ofrecer compañía demuestra que te importa' },
        ],
        explanation: '¡Perfecto! Escuchar, validar y ofrecer compañía son formas de mostrar empatía.',
        incorrectExplanation: 'La empatía incluye: ofrecer escuchar, validar sentimientos y proponer compañía. Decir "supéralo" minimiza el sufrimiento.',
        order: 1,
    },
    {
        id: 'empatia_q2',
        missionId: 'empatia_digital',
        type: 'quiz',
        title: '¿Qué hacer si ves que alguien es acosado en línea?',
        subtitle: 'Elige las mejores acciones',
        content: 'En un grupo de WhatsApp, varios están molestando a un compañero con insultos. ¿Qué deberías hacer?',
        options: [
            { id: 'defend', text: 'Escribir que eso está mal', isCorrect: true, feedback: 'Alzar la voz contra el acoso puede detenerlo' },
            { id: 'private', text: 'Escribirle en privado ofreciendo apoyo', isCorrect: true, feedback: 'El apoyo privado ayuda a la víctima a no sentirse sola' },
            { id: 'join', text: 'Unirte a las burlas para encajar', isCorrect: false, feedback: 'Unirse al acoso causa más daño' },
            { id: 'adult', text: 'Contarle a un adulto de confianza', isCorrect: true, feedback: 'Los adultos pueden intervenir y ayudar' },
        ],
        explanation: '¡Excelente! Defender a la víctima, ofrecer apoyo privado y avisar a un adulto son acciones que marcan la diferencia.',
        incorrectExplanation: 'Ante el acoso: defiende a la víctima, ofrece apoyo privado y avisa a un adulto. Nunca te unas al acoso.',
        order: 2,
    },
    {
        id: 'empatia_q3',
        missionId: 'empatia_digital',
        type: 'trueFalse',
        title: '¿Está bien hacer bromas hirientes si "solo es internet"?',
        content: 'Tu amigo dice que puede burlarse de otros en línea porque "es solo internet" y "no es la vida real".',
        options: [
            { id: 'true', text: 'Sí, en internet no cuenta', isCorrect: false, feedback: 'Las palabras en línea causan daño real' },
            { id: 'false', text: 'No, las palabras duelen igual', isCorrect: true, feedback: 'Correcto - el ciberacoso causa sufrimiento real' },
        ],
        correctBoolAnswer: false,
        explanation: '¡Correcto! Internet ES la vida real. Las palabras hirientes causan daño emocional verdadero.',
        incorrectExplanation: 'Las palabras en línea SÍ duelen. El ciberacoso causa ansiedad, depresión y sufrimiento real. Trata a todos con respeto, en línea y fuera.',
        order: 3,
    },

    // =========================================================================
    // ZONA CERO ODIO - TrueFalse Questions (reportar_odio mission)
    // =========================================================================
    {
        id: 'reportar_q1',
        missionId: 'reportar_odio',
        type: 'trueFalse',
        title: '¿Deberías reportar un comentario que ataca a un grupo por su religión?',
        content: 'Ves un comentario que dice "Todas las personas de X religión son terroristas y deberían irse del país."',
        options: [
            { id: 'true', text: 'Sí, es discurso de odio', isCorrect: true, feedback: 'Correcto - generalizar negativamente sobre un grupo religioso es discurso de odio' },
            { id: 'false', text: 'No, es solo una opinión', isCorrect: false, feedback: 'Atacar a todo un grupo por su religión va más allá de una opinión' },
        ],
        correctBoolAnswer: true,
        explanation: '¡Correcto! Este comentario generaliza negativamente sobre un grupo religioso. Es discurso de odio y debe reportarse.',
        incorrectExplanation: 'Este comentario ES discurso de odio. Generaliza negativamente sobre todas las personas de una religión. Deberías reportarlo.',
        order: 1,
    },
    {
        id: 'reportar_q2',
        missionId: 'reportar_odio',
        type: 'trueFalse',
        title: '¿Es discurso de odio decir "No me gusta el fútbol"?',
        content: 'Alguien escribe: "No me gusta el fútbol, prefiero otros deportes."',
        options: [
            { id: 'true', text: 'Sí, es odio hacia el fútbol', isCorrect: false, feedback: 'Expresar preferencias personales no es discurso de odio' },
            { id: 'false', text: 'No, es una preferencia personal', isCorrect: true, feedback: 'Correcto - preferir algo diferente no ataca a nadie' },
        ],
        correctBoolAnswer: false,
        explanation: '¡Correcto! Expresar preferencias personales NO es discurso de odio. No ataca a ningún grupo de personas.',
        incorrectExplanation: 'Esto NO es discurso de odio. Es simplemente una preferencia personal. El discurso de odio ataca a grupos por su identidad.',
        order: 2,
    },
    {
        id: 'reportar_q3',
        missionId: 'reportar_odio',
        type: 'trueFalse',
        title: '¿Deberías reportar incluso si el contenido no te ataca directamente a ti?',
        content: 'Ves un post atacando a personas de otro país con insultos muy fuertes. Tú no eres de ese país.',
        options: [
            { id: 'true', text: 'Sí, el odio nos afecta a todos', isCorrect: true, feedback: 'Correcto - todos somos responsables de crear espacios seguros' },
            { id: 'false', text: 'No, no es mi problema', isCorrect: false, feedback: 'El silencio ante el odio permite que continúe' },
        ],
        correctBoolAnswer: true,
        explanation: '¡Excelente! Aunque no te afecte directamente, reportar el odio ayuda a proteger a otros y crea comunidades más seguras.',
        incorrectExplanation: 'SÍ deberías reportar. El silencio ante el odio permite que continúe. Todos somos responsables de crear espacios seguros en línea.',
        order: 3,
    },

    // =========================================================================
    // NUEVOS TIPOS - CLASSIFY (Clasificar en categorías)
    // =========================================================================
    {
        id: 'classify_fake_news_signals',
        missionId: 'fake_news',
        type: 'classify',
        title: 'Clasifica cada elemento según su tipo',
        subtitle: 'Arrastra cada señal a la categoría correcta',
        categories: ['Señal de Noticia Real', 'Señal de Fake News'],
        classifyItems: [
            { id: 'item1', text: 'Autor verificable', correctCategory: 'Señal de Noticia Real' },
            { id: 'item2', text: 'Fuente reconocida', correctCategory: 'Señal de Noticia Real' },
            { id: 'item3', text: 'Titular sensacionalista', correctCategory: 'Señal de Fake News' },
            { id: 'item4', text: 'Sin fecha de publicación', correctCategory: 'Señal de Fake News' },
            { id: 'item5', text: 'Cita expertos reales', correctCategory: 'Señal de Noticia Real' },
            { id: 'item6', text: '"¡Comparte antes de que lo borren!"', correctCategory: 'Señal de Fake News' },
        ],
        options: [],
        explanation: '¡Excelente! Identificaste correctamente las señales. Las noticias reales tienen fuentes verificables, autores identificables y datos comprobables.',
        incorrectExplanation: 'Revisa las señales: los titulares sensacionalistas, la presión para compartir y la falta de fuentes son señales de noticias falsas.',
        order: 10,
    },
    {
        id: 'classify_phishing_vs_legit',
        missionId: 'q1_phishing',
        type: 'classify',
        title: 'Clasifica estos elementos de correo electrónico',
        subtitle: '¿Qué caracteriza a un email legítimo vs phishing?',
        categories: ['Email Legítimo', 'Email de Phishing'],
        classifyItems: [
            { id: 'item1', text: 'Remitente: soporte@banco.com', correctCategory: 'Email Legítimo' },
            { id: 'item2', text: 'Link: banco-seguro.xyz/login', correctCategory: 'Email de Phishing' },
            { id: 'item3', text: '"Tu cuenta será cerrada en 2 horas"', correctCategory: 'Email de Phishing' },
            { id: 'item4', text: 'Logo oficial del banco', correctCategory: 'Email Legítimo' },
            { id: 'item5', text: 'Errores de ortografía', correctCategory: 'Email de Phishing' },
            { id: 'item6', text: 'Número de teléfono oficial', correctCategory: 'Email Legítimo' },
        ],
        options: [],
        explanation: '¡Muy bien! Los emails de phishing usan links falsos, crean urgencia y contienen errores. Los legítimos tienen datos oficiales verificables.',
        incorrectExplanation: 'Recuerda: emails de phishing usan dominios extraños, presionan con urgencia y tienen errores. Los legítimos tienen contactos oficiales.',
        order: 10,
    },
    {
        id: 'classify_hate_vs_opinion',
        missionId: 'mensaje_escondido',
        type: 'classify',
        title: 'Clasifica estos mensajes',
        subtitle: 'Distingue entre opinión legítima y discurso de odio',
        categories: ['Opinión Legítima', 'Discurso de Odio'],
        classifyItems: [
            { id: 'item1', text: 'No estoy de acuerdo con esa política', correctCategory: 'Opinión Legítima' },
            { id: 'item2', text: 'Todos los de ese país son ladrones', correctCategory: 'Discurso de Odio' },
            { id: 'item3', text: 'Prefiero otro tipo de música', correctCategory: 'Opinión Legítima' },
            { id: 'item4', text: 'Esa religión debería prohibirse', correctCategory: 'Discurso de Odio' },
            { id: 'item5', text: 'No me gusta esa decisión del gobierno', correctCategory: 'Opinión Legítima' },
        ],
        options: [],
        explanation: '¡Perfecto! El discurso de odio ataca grupos por su identidad (nacionalidad, religión, etc). Las opiniones legítimas critican ideas, no personas.',
        incorrectExplanation: 'Recuerda: generalizar negativamente sobre grupos (nacionalidad, religión) es odio. Criticar ideas o políticas es opinión legítima.',
        order: 10,
    },

    // =========================================================================
    // NUEVOS TIPOS - FILLBLANK (Completar texto)
    // =========================================================================
    {
        id: 'fillblank_phishing_definition',
        missionId: 'q1_phishing',
        type: 'fillBlank',
        title: 'Completa la definición',
        subtitle: 'Selecciona un espacio y luego una palabra del banco',
        textWithBlanks: 'El _____ es un tipo de ataque donde el atacante se hace pasar por una entidad _____ para robar información _____.',
        blankAnswers: ['phishing', 'confiable', 'personal'],
        wordBank: ['phishing', 'malware', 'confiable', 'peligrosa', 'personal', 'pública', 'virus'],
        options: [],
        explanation: '¡Correcto! El phishing es cuando alguien se hace pasar por una entidad confiable para robar tu información personal.',
        incorrectExplanation: 'La respuesta correcta es: El PHISHING es un ataque donde el atacante se hace pasar por una entidad CONFIABLE para robar información PERSONAL.',
        order: 11,
    },
    {
        id: 'fillblank_fake_news_signs',
        missionId: 'fake_news',
        type: 'fillBlank',
        title: 'Completa los consejos',
        subtitle: 'Rellena los espacios con las palabras correctas',
        textWithBlanks: 'Para identificar fake news, siempre debes verificar la _____ de la noticia y buscar si otras _____ confiables reportan lo mismo.',
        blankAnswers: ['fuente', 'fuentes'],
        wordBank: ['fuente', 'fuentes', 'fecha', 'autor', 'imagen', 'título'],
        options: [],
        explanation: '¡Muy bien! Verificar la fuente y contrastar con otras fuentes confiables es clave para detectar noticias falsas.',
        incorrectExplanation: 'Recuerda: siempre verifica la FUENTE de la noticia y busca si otras FUENTES confiables reportan lo mismo.',
        order: 11,
    },
    {
        id: 'fillblank_password_security',
        missionId: 'q3_passwords',
        type: 'fillBlank',
        title: 'Completa el consejo de seguridad',
        subtitle: 'Rellena con las palabras correctas',
        textWithBlanks: 'Una contraseña _____ debe tener al menos 12 _____ e incluir números, letras y _____.',
        blankAnswers: ['segura', 'caracteres', 'símbolos'],
        wordBank: ['segura', 'débil', 'caracteres', 'letras', 'símbolos', 'espacios', 'números'],
        options: [],
        explanation: '¡Excelente! Una contraseña segura tiene al menos 12 caracteres e incluye números, letras y símbolos.',
        incorrectExplanation: 'Una contraseña SEGURA debe tener al menos 12 CARACTERES e incluir números, letras y SÍMBOLOS.',
        order: 11,
    },

    // =========================================================================
    // NUEVOS TIPOS - MATCHPAIRS (Conectar parejas)
    // =========================================================================
    {
        id: 'matchpairs_cyber_terms',
        missionId: 'q1_phishing',
        type: 'matchPairs',
        title: 'Conecta cada término con su definición',
        subtitle: 'Toca un término de la izquierda y luego su definición a la derecha',
        matchPairs: [
            { id: 'p1', left: 'Phishing', right: 'Suplantación de identidad' },
            { id: 'p2', left: 'Malware', right: 'Software malicioso' },
            { id: 'p3', left: 'Firewall', right: 'Barrera de seguridad' },
            { id: 'p4', left: 'Spam', right: 'Correo no deseado' },
        ],
        options: [],
        explanation: '¡Excelente! Conocer estos términos te ayuda a identificar amenazas en línea.',
        incorrectExplanation: 'Revisa: Phishing = Suplantación, Malware = Software malicioso, Firewall = Barrera de seguridad, Spam = Correo no deseado.',
        order: 12,
    },
    {
        id: 'matchpairs_fake_news_elements',
        missionId: 'fake_news',
        type: 'matchPairs',
        title: 'Conecta cada señal con su significado',
        subtitle: 'Une las señales con lo que indican',
        matchPairs: [
            { id: 'p1', left: 'Titular sensacionalista', right: 'Busca generar clics' },
            { id: 'p2', left: 'Autor anónimo', right: 'No se puede verificar' },
            { id: 'p3', left: 'Fuente oficial', right: 'Información confiable' },
            { id: 'p4', left: '"Comparte urgente"', right: 'Manipulación emocional' },
        ],
        options: [],
        explanation: '¡Muy bien! Reconocer estas señales te ayuda a distinguir noticias reales de falsas.',
        incorrectExplanation: 'Los titulares sensacionalistas buscan clics, los autores anónimos no son verificables, y "comparte urgente" es manipulación.',
        order: 12,
    },
    {
        id: 'matchpairs_emotions_online',
        missionId: 'empatia_digital',
        type: 'matchPairs',
        title: 'Conecta la situación con la mejor respuesta',
        subtitle: 'Une cada situación con cómo deberías responder',
        matchPairs: [
            { id: 'p1', left: 'Amigo triste', right: 'Ofrecer apoyo' },
            { id: 'p2', left: 'Alguien siendo acosado', right: 'Reportar y ayudar' },
            { id: 'p3', left: 'Comentario ofensivo', right: 'No responder con odio' },
            { id: 'p4', left: 'Rumor sobre alguien', right: 'No compartir' },
        ],
        options: [],
        explanation: '¡Perfecto! La empatía digital significa tratar a otros como quisieras ser tratado.',
        incorrectExplanation: 'Recuerda: ofrece apoyo a amigos tristes, reporta el acoso, no respondas al odio con odio, y no compartas rumores.',
        order: 12,
    },
];

// ============================================================================
// SEED FUNCTIONS
// ============================================================================

async function seedUnifiedQuestions() {
    console.log('\n📝 Seeding Unified Questions with feedback...\n');

    const batch = db.batch();

    for (const question of unifiedQuestions) {
        const ref = db.collection('unified_questions').doc(question.id);
        console.log(`  ✓ ${question.type}: ${question.title.substring(0, 40)}...`);

        if (!DRY_RUN) {
            batch.set(ref, {
                ...question,
                createdAt: new Date(),
                updatedAt: new Date(),
            });
        }
    }

    if (!DRY_RUN) {
        await batch.commit();
    }

    console.log(`\n✅ Seeded ${unifiedQuestions.length} unified questions with feedback\n`);
}

// ============================================================================
// MAIN
// ============================================================================

async function main() {
    console.log('');
    console.log('='.repeat(60));
    console.log('  PiensaPlay - Unified Questions Seed v2 (with feedback)');
    console.log('='.repeat(60));

    if (DRY_RUN) {
        console.log('\n⚠️  DRY RUN MODE - No data will be written\n');
    }

    try {
        await seedUnifiedQuestions();
        console.log('🎉 Seed completed successfully!\n');
    } catch (error) {
        console.error('❌ Error during seed:', error);
        process.exit(1);
    }
}

main();
