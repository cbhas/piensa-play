/**
 * Firebase Seed Script - Shop Items
 * 
 * Este script crea los items de la tienda.
 * 
 * Usage:
 *   npm run seed:shop
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
// SHOP ITEMS
// ============================================================================

const shopItems = [
    // Avatares inspirados en el contenido
    {
        id: 'avatar_pacifista',
        name: 'Vizcacha Pacifista',
        description: 'Promotora de la paz y contra el odio',
        price: 100,
        category: 'avatar',
        assetPath: 'assets/avatars/vizcacha_pacifista.png',
    },
    {
        id: 'avatar_guardian',
        name: 'Vizcacha Guardián',
        description: 'Protectora de la privacidad',
        price: 120,
        category: 'avatar',
        assetPath: 'assets/avatars/vizcacha_guardian.png',
    },
    {
        id: 'avatar_ciberexperta',
        name: 'Vizcacha Ciberexperta',
        description: 'Especialista en seguridad digital',
        price: 120,
        category: 'avatar',
        assetPath: 'assets/avatars/vizcacha_ciberexperta.png',
    },
    {
        id: 'avatar_huella',
        name: 'Vizcacha Huella Digital',
        description: 'Experta en identidad online',
        price: 150,
        category: 'avatar',
        assetPath: 'assets/avatars/vizcacha_huella.png',
    },
    {
        id: 'avatar_arcoiris',
        name: 'Vizcacha Arcoíris',
        description: '¡El avatar más exclusivo y colorido!',
        price: 1000,
        category: 'avatar',
        assetPath: 'assets/avatars/vizcacha_oro.png',
    },
    // Power-up
    {
        id: 'streak_freeze',
        name: 'Congelar Racha',
        description: 'Protege tu racha por un día si no puedes jugar',
        price: 50,
        category: 'powerup',
        assetPath: 'assets/icons/streak_freeze.png',
    },
];

// ============================================================================
// SEED FUNCTION
// ============================================================================

async function seedShopItems() {
    console.log('\n🛍️  Seeding shop items...\n');

    for (const item of shopItems) {
        console.log(`   → ${item.name} (${item.price} 🪙)`);

        if (!DRY_RUN) {
            await db.collection('shop_items').doc(item.id).set({
                name: item.name,
                description: item.description,
                price: item.price,
                category: item.category,
                assetPath: item.assetPath,
                createdAt: FieldValue.serverTimestamp(),
            }, { merge: true });
        }
    }

    console.log(`\n   ✅ ${shopItems.length} items created/updated`);
}

// ============================================================================
// MAIN
// ============================================================================

async function main() {
    console.log('');
    console.log('='.repeat(60));
    console.log('  PiensaPlay - Seed: Shop Items');
    console.log('='.repeat(60));

    if (DRY_RUN) {
        console.log('\n⚠️  DRY RUN MODE - No data will be written\n');
    }

    try {
        await seedShopItems();

        console.log('\n' + '='.repeat(60));
        console.log('🎉 Seed completed successfully!');
        console.log('');
        console.log('Items:');
        console.log('   • 6 avatares');
        console.log('   • 1 power-up (Congelar Racha)');

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
