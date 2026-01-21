/**
 * Firebase Seed Script - Nueva Categoría: Huella Digital
 * 
 * Este script AGREGA datos sin borrar los existentes.
 * Usa set() con merge para actualizar de forma segura.
 * 
 * Contenido:
 *   - 1 nueva categoría: huella_digital
 *   - 3 misiones con preguntas de todos los tipos
 *   - 3 badges (uno por misión) + 1 badge de categoría
 * 
 * Usage:
 *   npm run seed:huella-digital
 *   npm run seed:huella-digital -- --dry-run
 */

import { initializeApp, cert } from 'firebase-admin/app';
import { getFirestore, FieldValue } from 'firebase-admin/firestore';
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
// NUEVA CATEGORÍA: HUELLA DIGITAL
// ============================================================================

const newCategory = {
    id: 'huella_digital',
    title: 'Huella Digital',
    description: 'Aprende sobre tu identidad en internet y cómo protegerla.',
    iconName: 'fingerprint',
    colorHex: '0xFF9C27B0', // Púrpura
    order: 5,
};

// ============================================================================
// MISIONES DE LA CATEGORÍA
// ============================================================================

const missions = [
    {
        id: 'identidad_online',
        categoryId: 'huella_digital',
        title: 'Tu Identidad Online',
        subtitle: 'Huella Digital',
        description: 'Descubre qué información compartes sin darte cuenta.',
        iconName: 'person_search',
        type: 'quiz',
        order: 1,
    },
    {
        id: 'rastro_digital',
        categoryId: 'huella_digital',
        title: 'El Rastro que Dejas',
        subtitle: 'Huella Digital',
        description: 'Aprende cómo tus acciones quedan registradas en internet.',
        iconName: 'history',
        type: 'fillBlank',
        order: 2,
    },
    {
        id: 'protege_tu_huella',
        categoryId: 'huella_digital',
        title: 'Protege tu Huella',
        subtitle: 'Huella Digital',
        description: 'Técnicas para mantener tu privacidad en línea.',
        iconName: 'security',
        type: 'matchPairs',
        order: 3,
    },
];

// ============================================================================
// PREGUNTAS - MISIÓN 1: Tu Identidad Online (2 preguntas)
// ============================================================================

const questionsIdentidadOnline = [
    // Pregunta 1: Quiz
    {
        id: 'hd_m1_q1_quiz',
        missionId: 'identidad_online',
        type: 'quiz',
        title: '¿Qué información puede revelar tu huella digital?',
        subtitle: 'Selecciona todas las opciones correctas',
        content: 'Cada vez que usas internet, dejas rastros de información. ¿Cuáles de estos datos pueden formar parte de tu huella digital?',
        options: [
            { id: 'opt1', text: 'Las páginas web que visitas', isCorrect: true, feedback: 'Correcto - tu historial de navegación es parte de tu huella digital' },
            { id: 'opt2', text: 'Las fotos que subes a redes sociales', isCorrect: true, feedback: 'Correcto - las imágenes contienen metadatos y revelan información sobre ti' },
            { id: 'opt3', text: 'Tus pensamientos privados', isCorrect: false, feedback: 'Tus pensamientos son privados a menos que los compartas en línea' },
            { id: 'opt4', text: 'Los "me gusta" que das', isCorrect: true, feedback: 'Correcto - tus interacciones revelan tus gustos e intereses' },
        ],
        explanation: '¡Excelente! Tu huella digital incluye todo lo que haces en línea: sitios visitados, fotos compartidas e interacciones en redes sociales.',
        incorrectExplanation: 'Tu huella digital incluye las páginas que visitas, fotos que subes y los "me gusta" que das. Solo tus pensamientos no compartidos son privados.',
        order: 1,
    },
    // Pregunta 2: Word Selection
    {
        id: 'hd_m1_q2_words',
        missionId: 'identidad_online',
        type: 'wordSelection',
        title: 'Identifica información sensible',
        subtitle: 'Selecciona los datos que NO deberías compartir públicamente',
        content: 'Algunos datos son más sensibles que otros. ¿Cuáles debes proteger?',
        options: [
            { id: 'w1', text: 'Tu nombre de usuario', isCorrect: false, feedback: 'El nombre de usuario es público por diseño' },
            { id: 'w2', text: 'Tu contraseña', isCorrect: true, feedback: 'Correcto - nunca compartas contraseñas' },
            { id: 'w3', text: 'Tu dirección de casa', isCorrect: true, feedback: 'Correcto - la dirección física es información sensible' },
            { id: 'w4', text: 'Tu color favorito', isCorrect: false, feedback: 'Esta información no es sensible' },
            { id: 'w5', text: 'El nombre de tu escuela', isCorrect: true, feedback: 'Correcto - puede usarse para ubicarte' },
            { id: 'w6', text: 'Tu número de teléfono', isCorrect: true, feedback: 'Correcto - el teléfono es información personal sensible' },
        ],
        correctWords: ['Tu contraseña', 'Tu dirección de casa', 'El nombre de tu escuela', 'Tu número de teléfono'],
        explanation: '¡Muy bien! La contraseña, dirección, escuela y teléfono son datos sensibles que debes proteger.',
        incorrectExplanation: 'Los datos sensibles son: contraseña, dirección de casa, nombre de tu escuela y número de teléfono. El color favorito y nombre de usuario no son sensibles.',
        order: 2,
    },
];

// ============================================================================
// PREGUNTAS - MISIÓN 2: El Rastro que Dejas (2 preguntas)
// ============================================================================

const questionsRastroDigital = [
    // Pregunta 1: Fill Blank
    {
        id: 'hd_m2_q1_fillblank',
        missionId: 'rastro_digital',
        type: 'fillBlank',
        title: 'Completa la oración sobre huella digital',
        subtitle: 'Arrastra las palabras correctas a los espacios',
        content: 'Aprende los conceptos clave de la huella digital.',
        textWithBlanks: 'Cuando navegas por internet, los sitios web guardan pequeños archivos llamados _____ en tu dispositivo. Estos archivos pueden _____ tu actividad y preferencias.',
        blankAnswers: ['cookies', 'rastrear'],
        wordBank: ['cookies', 'rastrear', 'virus', 'eliminar', 'proteger', 'mensajes'],
        options: [],
        explanation: '¡Correcto! Las cookies son archivos que los sitios web usan para rastrear tu actividad y recordar tus preferencias.',
        incorrectExplanation: 'Las cookies son pequeños archivos que los sitios web guardan para rastrear tu actividad. No son virus, pero sí recopilan información.',
        order: 1,
    },
    // Pregunta 2: True/False
    {
        id: 'hd_m2_q2_truefalse',
        missionId: 'rastro_digital',
        type: 'trueFalse',
        title: '¿Verdadero o Falso?',
        content: 'Navegar en "modo incógnito" te hace completamente invisible en internet y no deja ningún rastro.',
        options: [
            { id: 'true', text: 'Verdadero', isCorrect: false, feedback: 'El modo incógnito solo evita guardar historial localmente' },
            { id: 'false', text: 'Falso', isCorrect: true, feedback: 'Correcto - tu proveedor de internet y los sitios web aún pueden ver tu actividad' },
        ],
        correctBoolAnswer: false,
        explanation: '¡Correcto! El modo incógnito solo evita que se guarde el historial en tu dispositivo, pero tu proveedor de internet, tu escuela o trabajo, y los sitios web aún pueden ver tu actividad.',
        incorrectExplanation: 'El modo incógnito NO te hace invisible. Solo evita guardar historial localmente. Tu ISP, escuela y los sitios web pueden ver tu actividad.',
        order: 2,
    },
];

// ============================================================================
// PREGUNTAS - MISIÓN 3: Protege tu Huella (2 preguntas)
// ============================================================================

const questionsProtegeTuHuella = [
    // Pregunta 1: Match Pairs
    {
        id: 'hd_m3_q1_matchpairs',
        missionId: 'protege_tu_huella',
        type: 'matchPairs',
        title: 'Conecta cada amenaza con su protección',
        subtitle: 'Une cada problema con la solución correcta',
        content: 'Aprende qué hacer ante cada tipo de amenaza a tu privacidad.',
        matchPairs: [
            { id: 'p1', left: 'Contraseña débil', right: 'Usar contraseña larga y única' },
            { id: 'p2', left: 'Rastreo de cookies', right: 'Borrar cookies regularmente' },
            { id: 'p3', left: 'Fotos con ubicación', right: 'Desactivar geolocalización' },
            { id: 'p4', left: 'Perfil público', right: 'Configurar privacidad' },
        ],
        options: [],
        explanation: '¡Perfecto! Cada amenaza tiene una solución específica para proteger tu privacidad.',
        incorrectExplanation: 'Las soluciones correctas son: contraseña larga para contraseñas débiles, borrar cookies para evitar rastreo, desactivar geolocalización para fotos, y configurar privacidad para perfiles públicos.',
        order: 1,
    },
    // Pregunta 2: Classify
    {
        id: 'hd_m3_q2_classify',
        missionId: 'protege_tu_huella',
        type: 'classify',
        title: 'Clasifica las acciones',
        subtitle: 'Arrastra cada acción a la categoría correcta',
        content: '¿Qué acciones protegen tu privacidad y cuáles la ponen en riesgo?',
        categories: ['Protege tu privacidad', 'Pone en riesgo tu privacidad'],
        classifyItems: [
            { id: 'item1', text: 'Usar la misma contraseña en todo', correctCategory: 'Pone en riesgo tu privacidad' },
            { id: 'item2', text: 'Revisar permisos de apps', correctCategory: 'Protege tu privacidad' },
            { id: 'item3', text: 'Compartir tu ubicación siempre', correctCategory: 'Pone en riesgo tu privacidad' },
            { id: 'item4', text: 'Usar autenticación de dos factores', correctCategory: 'Protege tu privacidad' },
            { id: 'item5', text: 'Aceptar todas las cookies sin leer', correctCategory: 'Pone en riesgo tu privacidad' },
            { id: 'item6', text: 'Revisar configuración de privacidad', correctCategory: 'Protege tu privacidad' },
        ],
        options: [],
        explanation: '¡Excelente! Proteger tu privacidad incluye: revisar permisos, usar 2FA y revisar configuración. Riesgos: misma contraseña, compartir ubicación y aceptar cookies sin leer.',
        incorrectExplanation: 'Acciones que protegen: revisar permisos de apps, usar autenticación de dos factores, revisar configuración de privacidad. Riesgos: misma contraseña en todo, compartir ubicación siempre, aceptar cookies sin leer.',
        order: 2,
    },
];

// ============================================================================
// BADGES
// ============================================================================

const badges = [
    // Badges de misión
    {
        id: 'mission_identidad_online',
        title: 'Detective\\nDigital',
        description: 'Completaste la misión Tu Identidad Online',
        iconName: 'person_search',
        order: 20,
        type: 'mission',
    },
    {
        id: 'mission_rastro_digital',
        title: 'Rastreador\\nExperto',
        description: 'Completaste la misión El Rastro que Dejas',
        iconName: 'history',
        order: 21,
        type: 'mission',
    },
    {
        id: 'mission_protege_tu_huella',
        title: 'Guardián\\nde Privacidad',
        description: 'Completaste la misión Protege tu Huella',
        iconName: 'security',
        order: 22,
        type: 'mission',
    },
    // Badge de categoría
    {
        id: 'category_huella_digital',
        title: 'Maestro de\\nHuella Digital',
        description: '¡Completaste todas las misiones de Huella Digital!',
        iconName: 'fingerprint',
        order: 104,
        type: 'category',
    },
];

// ============================================================================
// SEED FUNCTIONS
// ============================================================================

async function seedCategory() {
    console.log('\n📂 Seeding new category: huella_digital...');

    if (!DRY_RUN) {
        await db.collection('mission_categories').doc(newCategory.id).set({
            title: newCategory.title,
            description: newCategory.description,
            iconName: newCategory.iconName,
            colorHex: newCategory.colorHex,
            order: newCategory.order,
            createdAt: FieldValue.serverTimestamp(),
        }, { merge: true });
    }

    console.log(`   ✅ Category "${newCategory.title}" created/updated`);
}

async function seedMissions() {
    console.log('\n🎯 Seeding missions...');

    for (const mission of missions) {
        console.log(`   → ${mission.title}`);

        if (!DRY_RUN) {
            await db.collection('missions').doc(mission.id).set({
                categoryId: mission.categoryId,
                title: mission.title,
                subtitle: mission.subtitle,
                description: mission.description,
                iconName: mission.iconName,
                type: mission.type,
                order: mission.order,
                createdAt: FieldValue.serverTimestamp(),
            }, { merge: true });
        }
    }

    console.log(`   ✅ ${missions.length} missions created/updated`);
}

async function seedQuestions() {
    console.log('\n❓ Seeding unified questions...');

    const allQuestions = [
        ...questionsIdentidadOnline,
        ...questionsRastroDigital,
        ...questionsProtegeTuHuella,
    ];

    for (const question of allQuestions) {
        console.log(`   → [${question.type}] ${question.title.substring(0, 40)}...`);

        if (!DRY_RUN) {
            await db.collection('unified_questions').doc(question.id).set({
                ...question,
                createdAt: FieldValue.serverTimestamp(),
                updatedAt: FieldValue.serverTimestamp(),
            }, { merge: true });
        }
    }

    console.log(`   ✅ ${allQuestions.length} questions created/updated`);
}

async function seedBadges() {
    console.log('\n🏆 Seeding badges...');

    for (const badge of badges) {
        console.log(`   → ${badge.title.replace('\\n', ' ')}`);

        if (!DRY_RUN) {
            await db.collection('badges').doc(badge.id).set({
                title: badge.title,
                description: badge.description,
                iconName: badge.iconName,
                order: badge.order,
                type: badge.type,
                createdAt: FieldValue.serverTimestamp(),
            }, { merge: true });
        }
    }

    console.log(`   ✅ ${badges.length} badges created/updated`);
}

// ============================================================================
// MAIN
// ============================================================================

async function main() {
    console.log('');
    console.log('='.repeat(60));
    console.log('  PiensaPlay - Seed: Huella Digital');
    console.log('='.repeat(60));

    if (DRY_RUN) {
        console.log('\n⚠️  DRY RUN MODE - No data will be written\n');
    }

    try {
        await seedCategory();
        await seedMissions();
        await seedQuestions();
        await seedBadges();

        console.log('\n' + '='.repeat(60));
        console.log('🎉 Seed completed successfully!');
        console.log('');
        console.log('Summary:');
        console.log(`   • 1 new category: ${newCategory.title}`);
        console.log(`   • ${missions.length} missions`);
        console.log(`   • ${questionsIdentidadOnline.length + questionsRastroDigital.length + questionsProtegeTuHuella.length} questions (all types)`);
        console.log(`   • ${badges.length} badges`);

        if (DRY_RUN) {
            console.log('\n⚠️  This was a DRY RUN. Run without --dry-run to apply changes.');
        }

    } catch (error) {
        console.error('\n❌ Error during seed:', error);
        process.exit(1);
    }

    process.exit(0);
}

main();
