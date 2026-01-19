/**
 * Firebase Seed Script - Solo Misiones
 * 
 * Este script actualiza SOLO las misiones y categorías.
 * No toca badges, learn_content ni otros datos.
 * 
 * Usage:
 *   npm run seed:missions
 */

import { initializeApp, cert } from 'firebase-admin/app';
import { getFirestore } from 'firebase-admin/firestore';
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

// ============================================================================
// MISSION CATEGORIES (3 categorías)
// ============================================================================

const missionCategories = [
    {
        id: 'veracidadville',
        title: 'Veracidadville',
        description: 'Detecta la desinformación y defiende la verdad.',
        iconName: 'shield',
        colorHex: '0xFF6EC6FF',
        order: 0,
    },
    {
        id: 'zona_cero_odio',
        title: 'Zona Cero Odio',
        description: 'Reconoce y contrarresta el discurso de odio en línea.',
        iconName: 'message',
        colorHex: '0xFFA4D65E',
        order: 1,
    },
    {
        id: 'ciberseguridad',
        title: 'Misión Ciberseguridad',
        description: 'Defiende el ciberespacio de amenazas y ataques.',
        iconName: 'security',
        colorHex: '0xFFFF6B6B',
        order: 2,
    },
];

// ============================================================================
// MISSIONS (9 misiones - 3 por categoría)
// ============================================================================

const missions = [
    // =========================================================================
    // VERACIDADVILLE - 3 Misiones
    // =========================================================================
    {
        id: 'fake_news',
        categoryId: 'veracidadville',
        title: 'Cazadores de Fake News',
        subtitle: 'Veracidadville',
        description: 'Aprende a identificar noticias engañosas',
        iconName: 'check',
        type: 'quiz',
        order: 1,
    },
    {
        id: 'titular',
        categoryId: 'veracidadville',
        title: 'El Enigma del Titular',
        subtitle: 'Veracidadville',
        description: 'Desentraña titulares para encontrar la verdad.',
        iconName: 'warning',
        type: 'trueFalse',
        order: 2,
    },
    {
        id: 'fuentes_confiables',
        categoryId: 'veracidadville',
        title: 'Fuentes Confiables',
        subtitle: 'Veracidadville',
        description: 'Aprende a identificar fuentes de información confiables.',
        iconName: 'search',
        type: 'quiz',
        order: 3,
    },
    // =========================================================================
    // ZONA CERO ODIO - 3 Misiones
    // =========================================================================
    {
        id: 'mensaje_escondido',
        categoryId: 'zona_cero_odio',
        title: 'El Mensaje Escondido',
        subtitle: 'Zona Cero Odio',
        description: 'Identifica palabras y frases que promueven el odio.',
        iconName: 'lock',
        type: 'wordSelection',
        order: 1,
    },
    {
        id: 'empatia_digital',
        categoryId: 'zona_cero_odio',
        title: 'Empatía Digital',
        subtitle: 'Zona Cero Odio',
        description: 'Aprende a responder con empatía en línea.',
        iconName: 'favorite',
        type: 'quiz',
        order: 2,
    },
    {
        id: 'reportar_odio',
        categoryId: 'zona_cero_odio',
        title: 'Reportar y Actuar',
        subtitle: 'Zona Cero Odio',
        description: 'Aprende cuándo y cómo reportar contenido de odio.',
        iconName: 'flag',
        type: 'trueFalse',
        order: 3,
    },
    // =========================================================================
    // CIBERSEGURIDAD - 3 Misiones
    // =========================================================================
    {
        id: 'q1_phishing',
        categoryId: 'ciberseguridad',
        title: 'El Ataque Phishing',
        subtitle: 'Ciberseguridad',
        description: 'Detecta correos y mensajes fraudulentos.',
        iconName: 'flag',
        type: 'quiz',
        order: 1,
    },
    {
        id: 'q2_malware',
        categoryId: 'ciberseguridad',
        title: 'La Amenaza Oculta',
        subtitle: 'Ciberseguridad',
        description: 'Identifica software malicioso y protégete.',
        iconName: 'flag',
        type: 'quiz',
        order: 2,
    },
    {
        id: 'q3_passwords',
        categoryId: 'ciberseguridad',
        title: 'Fortaleza de Contraseñas',
        subtitle: 'Ciberseguridad',
        description: 'Crea contraseñas seguras y robustas.',
        iconName: 'flag',
        type: 'quiz',
        order: 3,
    },
];

// ============================================================================
// SEED FUNCTIONS
// ============================================================================

async function seedCategories() {
    console.log('\n📁 Actualizando Mission Categories...\n');

    const batch = db.batch();

    for (const category of missionCategories) {
        const ref = db.collection('mission_categories').doc(category.id);
        console.log(`  ✓ ${category.title}`);
        batch.set(ref, {
            ...category,
            updatedAt: new Date(),
        }, { merge: true });
    }

    await batch.commit();
    console.log(`\n✅ ${missionCategories.length} categorías actualizadas\n`);
}

async function seedMissions() {
    console.log('\n🎯 Actualizando Missions...\n');

    const batch = db.batch();

    for (const mission of missions) {
        const ref = db.collection('missions').doc(mission.id);
        console.log(`  ✓ [${mission.categoryId}] ${mission.title}`);
        batch.set(ref, {
            ...mission,
            updatedAt: new Date(),
        }, { merge: true });
    }

    await batch.commit();
    console.log(`\n✅ ${missions.length} misiones actualizadas\n`);
}

// ============================================================================
// MAIN
// ============================================================================

async function main() {
    console.log('');
    console.log('='.repeat(60));
    console.log('  PiensaPlay - Seed Misiones y Categorías');
    console.log('='.repeat(60));

    try {
        await seedCategories();
        await seedMissions();
        console.log('🎉 ¡Misiones actualizadas correctamente!\n');
    } catch (error) {
        console.error('❌ Error:', error);
        process.exit(1);
    }
}

main();
