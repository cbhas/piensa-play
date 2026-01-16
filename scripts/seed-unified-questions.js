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
