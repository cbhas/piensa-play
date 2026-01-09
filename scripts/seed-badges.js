/**
 * Script para poblar Firebase con badges para cada misión y categoría
 * 
 * Badges de misión: Se desbloquean al completar una misión
 * Badges de categoría: Se desbloquean al completar todas las misiones de una categoría
 * 
 * Ejecutar con: npm run seed-badges
 */

import admin from 'firebase-admin';
import { readFileSync } from 'fs';

const serviceAccount = JSON.parse(
    readFileSync('./serviceAccountKey.json', 'utf8')
);

admin.initializeApp({
    credential: admin.credential.cert(serviceAccount)
});

const db = admin.firestore();


// Badges para misiones (basado en missions_local_datasource.dart)
const missionBadges = [
    // Veracidadville
    {
        id: 'mission_fake_news',
        title: 'Cazador de\nFake News',
        description: 'Completaste la misión Cazadores de Fake News',
        iconName: 'search',
        order: 1,
        type: 'mission',
    },
    {
        id: 'mission_titular',
        title: 'Descifrador\nde Titulares',
        description: 'Completaste la misión El Enigma del Titular',
        iconName: 'text_snippet',
        order: 2,
        type: 'mission',
    },
    // Zona Cero Odio
    {
        id: 'mission_mensaje_escondido',
        title: 'Guardián de\nlas Palabras',
        description: 'Completaste El Mensaje Escondido',
        iconName: 'chat',
        order: 3,
        type: 'mission',
    },
    {
        id: 'mission_stereotypes',
        title: 'Rompe\nEstereotipos',
        description: 'Completaste Rompe Estereotipos',
        iconName: 'diversity_3',
        order: 4,
        type: 'mission',
    },
    // Fortaleza Privacidad
    {
        id: 'mission_navegacion_segura',
        title: 'Navegante\nSeguro',
        description: 'Completaste Navegación Segura',
        iconName: 'security',
        order: 5,
        type: 'mission',
    },
    // Ciberseguridad
    {
        id: 'mission_q1_phishing',
        title: 'Detector de\nPhishing',
        description: 'Completaste El Ataque Phishing',
        iconName: 'email',
        order: 6,
        type: 'mission',
    },
    {
        id: 'mission_q2_malware',
        title: 'Cazador de\nMalware',
        description: 'Completaste La Amenaza Oculta',
        iconName: 'bug_report',
        order: 7,
        type: 'mission',
    },
    {
        id: 'mission_q3_passwords',
        title: 'Maestro de\nContraseñas',
        description: 'Completaste Fortaleza de Contraseñas',
        iconName: 'lock',
        order: 8,
        type: 'mission',
    },
];

// Badges para categorías completas
const categoryBadges = [
    {
        id: 'category_veracidadville',
        title: 'Héroe de\nVeracidadville',
        description: '¡Completaste todas las misiones de Veracidadville!',
        iconName: 'shield',
        order: 100,
        type: 'category',
    },
    {
        id: 'category_zona_cero_odio',
        title: 'Campeón\nZona Cero',
        description: '¡Completaste todas las misiones de Zona Cero Odio!',
        iconName: 'favorite',
        order: 101,
        type: 'category',
    },
    {
        id: 'category_fortaleza_privacidad',
        title: 'Guardian de\nla Privacidad',
        description: '¡Completaste todas las misiones de Fortaleza Privacidad!',
        iconName: 'privacy_tip',
        order: 102,
        type: 'category',
    },
    {
        id: 'category_ciberseguridad',
        title: 'Experto en\nCiberseguridad',
        description: '¡Completaste todas las misiones de Ciberseguridad!',
        iconName: 'verified_user',
        order: 103,
        type: 'category',
    },
];

async function seedBadges() {
    console.log('🚀 Iniciando seed de badges...\n');

    const allBadges = [...missionBadges, ...categoryBadges];
    const batch = db.batch();

    for (const badge of allBadges) {
        const docRef = db.collection('badges').doc(badge.id);
        batch.set(docRef, {
            title: badge.title,
            description: badge.description,
            iconName: badge.iconName,
            order: badge.order,
            type: badge.type,
            createdAt: admin.firestore.FieldValue.serverTimestamp(),
        });
        console.log(`📛 Preparando badge: ${badge.id} - ${badge.title.replace('\n', ' ')}`);
    }

    await batch.commit();

    console.log(`\n✅ ¡Seed completado! ${allBadges.length} badges creados.`);
    console.log(`   - ${missionBadges.length} badges de misión`);
    console.log(`   - ${categoryBadges.length} badges de categoría`);

    process.exit(0);
}

seedBadges().catch((error) => {
    console.error('❌ Error:', error);
    process.exit(1);
});
