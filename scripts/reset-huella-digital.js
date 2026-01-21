/**
 * Firebase Reset Script - Huella Digital (para demos)
 * 
 * Este script BORRA y luego RE-CREA todo lo de Huella Digital.
 * Úsalo para resetear antes de una demo.
 * 
 * Usage:
 *   npm run reset:huella-digital
 */

import { initializeApp, cert } from 'firebase-admin/app';
import { getFirestore, FieldValue } from 'firebase-admin/firestore';
import { readFileSync, existsSync } from 'fs';

// ============================================================================
// CONFIGURATION
// ============================================================================

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

// IDs a borrar
const CATEGORY_ID = 'huella_digital';
const MISSION_IDS = ['identidad_online', 'rastro_digital', 'protege_tu_huella'];
const QUESTION_IDS = [
    'hd_m1_q1_quiz', 'hd_m1_q2_words',
    'hd_m2_q1_fillblank', 'hd_m2_q2_truefalse',
    'hd_m3_q1_matchpairs', 'hd_m3_q2_classify',
];
const BADGE_IDS = [
    'mission_identidad_online', 'mission_rastro_digital',
    'mission_protege_tu_huella', 'category_huella_digital',
];

// ============================================================================
// DELETE FUNCTIONS
// ============================================================================

async function deleteAll() {
    console.log('\n🗑️  Borrando datos de Huella Digital...\n');

    // Borrar categoría
    console.log('   → Borrando categoría...');
    await db.collection('mission_categories').doc(CATEGORY_ID).delete();

    // Borrar misiones
    console.log('   → Borrando misiones...');
    for (const id of MISSION_IDS) {
        await db.collection('missions').doc(id).delete();
    }

    // Borrar preguntas
    console.log('   → Borrando preguntas...');
    for (const id of QUESTION_IDS) {
        await db.collection('unified_questions').doc(id).delete();
    }

    // Borrar badges
    console.log('   → Borrando badges...');
    for (const id of BADGE_IDS) {
        await db.collection('badges').doc(id).delete();
    }

    console.log('\n   ✅ Todo borrado correctamente\n');
}

// ============================================================================
// MAIN
// ============================================================================

async function main() {
    console.log('');
    console.log('='.repeat(60));
    console.log('  PiensaPlay - RESET: Huella Digital');
    console.log('='.repeat(60));

    try {
        await deleteAll();

        console.log('='.repeat(60));
        console.log('🎯 Listo para la demo!');
        console.log('');
        console.log('Cuando quieras crear la categoría durante la demo, ejecuta:');
        console.log('   npm run seed:huella-digital');
        console.log('');

    } catch (error) {
        console.error('\n❌ Error:', error);
        process.exit(1);
    }

    process.exit(0);
}

main();
