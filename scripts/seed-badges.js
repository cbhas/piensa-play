/**
 * Firebase Seed Script - Badges para las 9 Misiones
 * 
 * Este script actualiza los badges correspondientes a cada misión.
 * Los IDs de badges DEBEN seguir el formato: mission_{missionId}
 * El sistema de gamificación busca badges con este patrón.
 * 
 * Usage:
 *   npm run seed:badges
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
// BADGES - Formato: mission_{missionId} (requerido por GamificationService)
// ============================================================================

const badges = [
    // =========================================================================
    // VERACIDADVILLE - 3 Badges
    // =========================================================================
    {
        id: 'mission_fake_news',  // DEBE coincidir con missionId
        missionId: 'fake_news',
        categoryId: 'veracidadville',
        title: 'Cazador de\nFake News',
        description: 'Completaste la misión de detectar noticias falsas.',
        iconName: 'fact_check',
        colorHex: '0xFF6EC6FF',
        order: 1,
    },
    {
        id: 'mission_titular',
        missionId: 'titular',
        categoryId: 'veracidadville',
        title: 'Descifrador\nde Titulares',
        description: 'Dominaste el arte de analizar titulares engañosos.',
        iconName: 'newspaper',
        colorHex: '0xFF6EC6FF',
        order: 2,
    },
    {
        id: 'mission_fuentes_confiables',
        missionId: 'fuentes_confiables',
        categoryId: 'veracidadville',
        title: 'Verificador\nde Fuentes',
        description: 'Aprendiste a identificar fuentes de información confiables.',
        iconName: 'verified',
        colorHex: '0xFF6EC6FF',
        order: 3,
    },
    // =========================================================================
    // ZONA CERO ODIO - 3 Badges
    // =========================================================================
    {
        id: 'mission_mensaje_escondido',
        missionId: 'mensaje_escondido',
        categoryId: 'zona_cero_odio',
        title: 'Detective del\nMensaje Oculto',
        description: 'Identificaste palabras y frases que promueven el odio.',
        iconName: 'search',
        colorHex: '0xFFA4D65E',
        order: 4,
    },
    {
        id: 'mission_empatia_digital',
        missionId: 'empatia_digital',
        categoryId: 'zona_cero_odio',
        title: 'Embajador de\nla Empatía',
        description: 'Aprendiste a responder con empatía en línea.',
        iconName: 'favorite',
        colorHex: '0xFFA4D65E',
        order: 5,
    },
    {
        id: 'mission_reportar_odio',
        missionId: 'reportar_odio',
        categoryId: 'zona_cero_odio',
        title: 'Guardián del\nRespeto',
        description: 'Sabes cuándo y cómo reportar contenido de odio.',
        iconName: 'shield',
        colorHex: '0xFFA4D65E',
        order: 6,
    },
    // =========================================================================
    // CIBERSEGURIDAD - 3 Badges
    // =========================================================================
    {
        id: 'mission_q1_phishing',
        missionId: 'q1_phishing',
        categoryId: 'ciberseguridad',
        title: 'Escudo\nAnti-Phishing',
        description: 'Detectas correos y mensajes fraudulentos como un experto.',
        iconName: 'security',
        colorHex: '0xFFFF6B6B',
        order: 7,
    },
    {
        id: 'mission_q2_malware',
        missionId: 'q2_malware',
        categoryId: 'ciberseguridad',
        title: 'Cazador de\nMalware',
        description: 'Identificas software malicioso y sabes cómo protegerte.',
        iconName: 'bug_report',
        colorHex: '0xFFFF6B6B',
        order: 8,
    },
    {
        id: 'mission_q3_passwords',
        missionId: 'q3_passwords',
        categoryId: 'ciberseguridad',
        title: 'Maestro de\nContraseñas',
        description: 'Creas contraseñas seguras y robustas.',
        iconName: 'lock',
        colorHex: '0xFFFF6B6B',
        order: 9,
    },
];

// También necesitamos badges para categorías completas
const categoryBadges = [
    {
        id: 'category_veracidadville',
        categoryId: 'veracidadville',
        title: 'Maestro de\nVeracidadville',
        description: '¡Completaste todas las misiones de Veracidadville!',
        iconName: 'workspace_premium',
        colorHex: '0xFF6EC6FF',
        order: 10,
    },
    {
        id: 'category_zona_cero_odio',
        categoryId: 'zona_cero_odio',
        title: 'Campeón\nZona Cero Odio',
        description: '¡Completaste todas las misiones de Zona Cero Odio!',
        iconName: 'workspace_premium',
        colorHex: '0xFFA4D65E',
        order: 11,
    },
    {
        id: 'category_ciberseguridad',
        categoryId: 'ciberseguridad',
        title: 'Experto en\nCiberseguridad',
        description: '¡Completaste todas las misiones de Ciberseguridad!',
        iconName: 'workspace_premium',
        colorHex: '0xFFFF6B6B',
        order: 12,
    },
];

// ============================================================================
// SEED FUNCTION
// ============================================================================

async function seedBadges() {
    console.log('\n🏆 Actualizando Badges para Misiones...\n');

    const batch = db.batch();

    // Badges de misiones
    for (const badge of badges) {
        const ref = db.collection('badges').doc(badge.id);
        console.log(`  ✓ [${badge.categoryId}] ${badge.id} → "${badge.title.replace('\n', ' ')}"`);
        batch.set(ref, {
            ...badge,
            updatedAt: new Date(),
        }, { merge: true });
    }

    console.log('');

    // Badges de categorías
    for (const badge of categoryBadges) {
        const ref = db.collection('badges').doc(badge.id);
        console.log(`  ✓ [CATEGORY] ${badge.id} → "${badge.title.replace('\n', ' ')}"`);
        batch.set(ref, {
            ...badge,
            updatedAt: new Date(),
        }, { merge: true });
    }

    await batch.commit();
    console.log(`\n✅ ${badges.length + categoryBadges.length} badges actualizados\n`);
}

// ============================================================================
// MAIN
// ============================================================================

async function main() {
    console.log('');
    console.log('='.repeat(60));
    console.log('  PiensaPlay - Seed Badges para Misiones');
    console.log('='.repeat(60));

    try {
        await seedBadges();
        console.log('🎉 ¡Badges actualizados correctamente!\n');
    } catch (error) {
        console.error('❌ Error:', error);
        process.exit(1);
    }
}

main();
