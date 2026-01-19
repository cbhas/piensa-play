// scripts/seed-daily-questions.js
// Pool de 30 preguntas para la pregunta diaria
// Ejecutar: node scripts/seed-daily-questions.js

import admin from "firebase-admin";
import { readFileSync } from "fs";
import { fileURLToPath } from 'url';
import { dirname, join } from 'path';

const __filename = fileURLToPath(import.meta.url);
const __dirname = dirname(__filename);

const serviceAccount = JSON.parse(
    readFileSync(join(__dirname, './serviceAccountKey.json'), 'utf8')
);

admin.initializeApp({
    credential: admin.credential.cert(serviceAccount),
});

const db = admin.firestore();

const dailyQuestions = [
    // Día 1 - Quiz sobre phishing
    {
        id: "daily_01",
        type: "quiz",
        title: "¿Qué es el phishing?",
        content: "El phishing es una técnica utilizada por ciberdelincuentes.",
        explanation: "El phishing busca engañarte para robar tu información personal como contraseñas y datos bancarios.",
        options: [
            { id: "a", text: "Un tipo de virus informático", isCorrect: false },
            { id: "b", text: "Una técnica para robar información personal", isCorrect: true },
            { id: "c", text: "Un programa de seguridad", isCorrect: false },
            { id: "d", text: "Una red social", isCorrect: false },
        ],
    },
    // Día 2 - Verdadero/Falso
    {
        id: "daily_02",
        type: "trueFalse",
        title: "Los bancos nunca piden tu contraseña por correo electrónico",
        content: "Recibiste un correo del banco pidiendo que confirmes tu contraseña.",
        explanation: "Los bancos NUNCA solicitan contraseñas por correo. Si recibes un mensaje así, es fraude.",
        correctBoolAnswer: true,
    },
    // Día 3 - Quiz
    {
        id: "daily_03",
        type: "quiz",
        title: "¿Cuál es una contraseña segura?",
        explanation: "Una contraseña segura combina mayúsculas, minúsculas, números y símbolos.",
        options: [
            { id: "a", text: "123456", isCorrect: false },
            { id: "b", text: "password", isCorrect: false },
            { id: "c", text: "M!Cl@ve#2024", isCorrect: true },
            { id: "d", text: "qwerty", isCorrect: false },
        ],
    },
    // Día 4 - Verdadero/Falso
    {
        id: "daily_04",
        type: "trueFalse",
        title: "Es seguro conectarse a cualquier WiFi público",
        content: "Te conectas a la WiFi 'GRATIS_WIFI' en un centro comercial.",
        explanation: "Las redes WiFi públicas pueden ser inseguras. Los hackers pueden interceptar tu información.",
        correctBoolAnswer: false,
    },
    // Día 5 - Quiz
    {
        id: "daily_05",
        type: "quiz",
        title: "¿Qué debes hacer si ves una noticia muy alarmante?",
        explanation: "Siempre verifica la información en fuentes confiables antes de compartir.",
        options: [
            { id: "a", text: "Compartirla inmediatamente", isCorrect: false },
            { id: "b", text: "Verificar en fuentes confiables", isCorrect: true },
            { id: "c", text: "Ignorarla completamente", isCorrect: false },
            { id: "d", text: "Enviarla a todos mis contactos", isCorrect: false },
        ],
    },
    // Día 6 - Verdadero/Falso
    {
        id: "daily_06",
        type: "trueFalse",
        title: "Las fotos en internet siempre muestran la realidad",
        explanation: "Muchas fotos son editadas o sacadas de contexto. No todo lo que ves es real.",
        correctBoolAnswer: false,
    },
    // Día 7 - Quiz
    {
        id: "daily_07",
        type: "quiz",
        title: "¿Cómo identificar una página web segura?",
        explanation: "El candado y 'https://' indican que la conexión está encriptada.",
        options: [
            { id: "a", text: "Tiene muchos colores", isCorrect: false },
            { id: "b", text: "Tiene un candado en la barra de direcciones", isCorrect: true },
            { id: "c", text: "Tiene muchas imágenes", isCorrect: false },
            { id: "d", text: "Se carga rápido", isCorrect: false },
        ],
    },
    // Día 8 - Verdadero/Falso
    {
        id: "daily_08",
        type: "trueFalse",
        title: "Debes aceptar todas las cookies para usar un sitio web",
        explanation: "No es obligatorio aceptar todas las cookies. Puedes rechazar las no esenciales.",
        correctBoolAnswer: false,
    },
    // Día 9 - Quiz
    {
        id: "daily_09",
        type: "quiz",
        title: "¿Qué es la verificación en dos pasos?",
        explanation: "La verificación en dos pasos agrega una capa extra de seguridad a tu cuenta.",
        options: [
            { id: "a", text: "Iniciar sesión dos veces", isCorrect: false },
            { id: "b", text: "Usar dos contraseñas diferentes", isCorrect: false },
            { id: "c", text: "Confirmar tu identidad con un código adicional", isCorrect: true },
            { id: "d", text: "Tener dos cuentas", isCorrect: false },
        ],
    },
    // Día 10 - Verdadero/Falso
    {
        id: "daily_10",
        type: "trueFalse",
        title: "Si un correo viene de un amigo, siempre es seguro abrirlo",
        explanation: "Las cuentas de tus amigos pueden ser hackeadas. Verifica enlaces sospechosos.",
        correctBoolAnswer: false,
    },
    // Día 11 - Quiz
    {
        id: "daily_11",
        type: "quiz",
        title: "¿Qué hacer si alguien te pide información personal en línea?",
        explanation: "Nunca compartas datos personales con desconocidos en internet.",
        options: [
            { id: "a", text: "Darle toda la información que pida", isCorrect: false },
            { id: "b", text: "Ignorar y no responder", isCorrect: true },
            { id: "c", text: "Preguntarle para qué la necesita", isCorrect: false },
            { id: "d", text: "Compartir solo algunos datos", isCorrect: false },
        ],
    },
    // Día 12 - Verdadero/Falso
    {
        id: "daily_12",
        type: "trueFalse",
        title: "Los virus solo afectan a computadoras, no a celulares",
        explanation: "Los smartphones también pueden ser infectados con malware.",
        correctBoolAnswer: false,
    },
    // Día 13 - Quiz
    {
        id: "daily_13",
        type: "quiz",
        title: "¿Qué es una noticia falsa?",
        explanation: "Las noticias falsas son información inventada que parece real para engañar.",
        options: [
            { id: "a", text: "Una noticia de hace mucho tiempo", isCorrect: false },
            { id: "b", text: "Una noticia aburrida", isCorrect: false },
            { id: "c", text: "Información inventada que parece real", isCorrect: true },
            { id: "d", text: "Una noticia graciosa", isCorrect: false },
        ],
    },
    // Día 14 - Verdadero/Falso
    {
        id: "daily_14",
        type: "trueFalse",
        title: "Es buena idea usar la misma contraseña para todo",
        explanation: "Usar la misma contraseña es muy riesgoso. Si una cuenta es hackeada, todas lo serán.",
        correctBoolAnswer: false,
    },
    // Día 15 - Quiz
    {
        id: "daily_15",
        type: "quiz",
        title: "¿Cuál es la mejor forma de guardar tus contraseñas?",
        explanation: "Un gestor de contraseñas encripta y protege todas tus contraseñas de forma segura.",
        options: [
            { id: "a", text: "En un papel pegado al monitor", isCorrect: false },
            { id: "b", text: "En un archivo de texto en el escritorio", isCorrect: false },
            { id: "c", text: "En un gestor de contraseñas", isCorrect: true },
            { id: "d", text: "Memorizándolas todas", isCorrect: false },
        ],
    },
    // Día 16 - Verdadero/Falso
    {
        id: "daily_16",
        type: "trueFalse",
        title: "Las actualizaciones de software son innecesarias",
        explanation: "Las actualizaciones corrigen vulnerabilidades de seguridad importantes.",
        correctBoolAnswer: false,
    },
    // Día 17 - Quiz
    {
        id: "daily_17",
        type: "quiz",
        title: "¿Qué es el cyberbullying?",
        explanation: "El cyberbullying es acoso a través de medios digitales y puede causar mucho daño.",
        options: [
            { id: "a", text: "Un juego en línea", isCorrect: false },
            { id: "b", text: "Acoso a través de internet", isCorrect: true },
            { id: "c", text: "Una red social", isCorrect: false },
            { id: "d", text: "Un tipo de virus", isCorrect: false },
        ],
    },
    // Día 18 - Verdadero/Falso
    {
        id: "daily_18",
        type: "trueFalse",
        title: "Es seguro descargar apps de cualquier sitio web",
        explanation: "Solo descarga apps de tiendas oficiales como Google Play o App Store.",
        correctBoolAnswer: false,
    },
    // Día 19 - Quiz
    {
        id: "daily_19",
        type: "quiz",
        title: "Si ganaste un premio en internet sin participar, probablemente es...",
        explanation: "Los premios sorpresa suelen ser estafas para robar datos personales.",
        options: [
            { id: "a", text: "Tu día de suerte", isCorrect: false },
            { id: "b", text: "Una estafa", isCorrect: true },
            { id: "c", text: "Un regalo de la empresa", isCorrect: false },
            { id: "d", text: "Un error del sistema", isCorrect: false },
        ],
    },
    // Día 20 - Verdadero/Falso
    {
        id: "daily_20",
        type: "trueFalse",
        title: "Todo lo que publicas en redes sociales es privado",
        explanation: "Incluso con configuración privada, tu información puede ser compartida o hackeada.",
        correctBoolAnswer: false,
    },
    // Día 21 - Quiz
    {
        id: "daily_21",
        type: "quiz",
        title: "¿Qué significa 'https' en una dirección web?",
        explanation: "La 'S' significa 'Secure' e indica que la conexión está encriptada.",
        options: [
            { id: "a", text: "Hyper Text Transfer Protocol Secure", isCorrect: true },
            { id: "b", text: "High Tech Protection System", isCorrect: false },
            { id: "c", text: "Home Transfer Protocol Standard", isCorrect: false },
            { id: "d", text: "Hyper Text Total Protection Service", isCorrect: false },
        ],
    },
    // Día 22 - Verdadero/Falso
    {
        id: "daily_22",
        type: "trueFalse",
        title: "Los antivirus gratuitos no sirven para nada",
        explanation: "Los antivirus gratuitos ofrecen protección básica, aunque los de pago tienen más funciones.",
        correctBoolAnswer: false,
    },
    // Día 23 - Quiz
    {
        id: "daily_23",
        type: "quiz",
        title: "¿Cuál es una señal de que un enlace puede ser peligroso?",
        explanation: "Los enlaces acortados o con errores ortográficos suelen ser fraudulentos.",
        options: [
            { id: "a", text: "Tiene el nombre de una empresa conocida", isCorrect: false },
            { id: "b", text: "Errores ortográficos en la URL", isCorrect: true },
            { id: "c", text: "Empieza con www", isCorrect: false },
            { id: "d", text: "Es corto", isCorrect: false },
        ],
    },
    // Día 24 - Verdadero/Falso
    {
        id: "daily_24",
        type: "trueFalse",
        title: "Las redes VPN hacen tu navegación más segura",
        explanation: "Las VPN encriptan tu conexión, protegiendo tu privacidad en internet.",
        correctBoolAnswer: true,
    },
    // Día 25 - Quiz
    {
        id: "daily_25",
        type: "quiz",
        title: "¿Qué debes hacer antes de compartir una noticia?",
        explanation: "Verificar la fuente evita propagar información falsa.",
        options: [
            { id: "a", text: "Leer solo el título", isCorrect: false },
            { id: "b", text: "Ver cuántos likes tiene", isCorrect: false },
            { id: "c", text: "Verificar la fuente original", isCorrect: true },
            { id: "d", text: "Compartirla rápido antes que otros", isCorrect: false },
        ],
    },
    // Día 26 - Verdadero/Falso
    {
        id: "daily_26",
        type: "trueFalse",
        title: "Si un sitio web se ve profesional, siempre es confiable",
        explanation: "Los estafadores pueden crear sitios muy profesionales. Verifica siempre la URL.",
        correctBoolAnswer: false,
    },
    // Día 27 - Quiz
    {
        id: "daily_27",
        type: "quiz",
        title: "¿Qué es el 'sexting'?",
        explanation: "El sexting puede tener consecuencias graves si las imágenes se comparten sin consentimiento.",
        options: [
            { id: "a", text: "Un tipo de mensaje de texto normal", isCorrect: false },
            { id: "b", text: "Envío de mensajes o imágenes de contenido sexual", isCorrect: true },
            { id: "c", text: "Una app de mensajería", isCorrect: false },
            { id: "d", text: "Un juego en línea", isCorrect: false },
        ],
    },
    // Día 28 - Verdadero/Falso
    {
        id: "daily_28",
        type: "trueFalse",
        title: "Es buena idea aceptar solicitudes de amistad de desconocidos",
        explanation: "Acepta solo a personas que realmente conoces para proteger tu privacidad.",
        correctBoolAnswer: false,
    },
    // Día 29 - Quiz
    {
        id: "daily_29",
        type: "quiz",
        title: "¿Cuál es la edad mínima para usar la mayoría de redes sociales?",
        explanation: "La mayoría de redes sociales requieren tener al menos 13 años.",
        options: [
            { id: "a", text: "8 años", isCorrect: false },
            { id: "b", text: "10 años", isCorrect: false },
            { id: "c", text: "13 años", isCorrect: true },
            { id: "d", text: "18 años", isCorrect: false },
        ],
    },
    // Día 30 - Verdadero/Falso
    {
        id: "daily_30",
        type: "trueFalse",
        title: "Deberías contarle a un adulto si algo te incomoda en internet",
        explanation: "Siempre habla con un adulto de confianza si algo te hace sentir incómodo en línea.",
        correctBoolAnswer: true,
    },
];

async function seedDailyQuestions() {
    console.log("🚀 Seeding daily questions pool...");

    const batch = db.batch();

    for (const question of dailyQuestions) {
        const docRef = db.collection("daily_questions").doc(question.id);
        batch.set(docRef, {
            ...question,
            createdAt: admin.firestore.FieldValue.serverTimestamp(),
        });
        console.log(`  ✓ ${question.id}: ${question.title.substring(0, 40)}...`);
    }

    await batch.commit();
    console.log(`\n✅ Successfully seeded ${dailyQuestions.length} daily questions!`);
    process.exit(0);
}

seedDailyQuestions().catch((error) => {
    console.error("❌ Error seeding:", error);
    process.exit(1);
});
