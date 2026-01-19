/**
 * Firebase Seed Script for PiensaPlay
 * 
 * This script populates Firestore with all the hardcoded data from the Flutter app.
 * 
 * Usage:
 *   1. Download your Firebase service account key from Firebase Console
 *   2. Save it as 'serviceAccountKey.json' in this folder
 *   3. Run: npm install
 *   4. Run: npm run seed
 * 
 * Collections populated:
 *   - badges (global catalog)
 *   - mission_categories
 *   - missions
 *   - questions
 *   - learn_content (videos and podcasts)
 */

import { initializeApp, cert } from 'firebase-admin/app';
import { getFirestore } from 'firebase-admin/firestore';
import { readFileSync, existsSync } from 'fs';

// ============================================================================
// CONFIGURATION
// ============================================================================

const DRY_RUN = process.argv.includes('--dry-run');

// Check for service account key
const SERVICE_ACCOUNT_PATH = './serviceAccountKey.json';

if (!existsSync(SERVICE_ACCOUNT_PATH)) {
  console.error('❌ Error: serviceAccountKey.json not found!');
  console.error('');
  console.error('To get your service account key:');
  console.error('1. Go to Firebase Console → Project Settings → Service Accounts');
  console.error('2. Click "Generate new private key"');
  console.error('3. Save the file as "serviceAccountKey.json" in the scripts/ folder');
  process.exit(1);
}

const serviceAccount = JSON.parse(readFileSync(SERVICE_ACCOUNT_PATH, 'utf8'));

// Initialize Firebase
initializeApp({
  credential: cert(serviceAccount)
});

const db = getFirestore();

// ============================================================================
// SEED DATA: BADGES (Global Catalog)
// ============================================================================

const badges = [
  {
    id: 'investigador_junior',
    title: 'Investigador\nJunior',
    description: 'Completa tu primera misión de verificación de información',
    iconName: 'search',
    order: 1,
  },
  {
    id: 'maestro_contrasenas',
    title: 'Maestro\nde Contraseñas',
    description: 'Aprende a crear contraseñas seguras y robustas',
    iconName: 'lock',
    order: 2,
  },
  {
    id: 'guardian_digital',
    title: 'Guardian Digital',
    description: 'Protege tu identidad digital completando misiones de privacidad',
    iconName: 'shield',
    order: 3,
  },
  {
    id: 'detector_spam',
    title: 'Detector\nde Spam',
    description: 'Identifica correos y mensajes fraudulentos correctamente',
    iconName: 'flag',
    order: 4,
  },
  {
    id: 'navegante_experto',
    title: 'Navegante\nExperto',
    description: 'Domina la navegación segura por internet',
    iconName: 'explore',
    order: 5,
  },
];

// ============================================================================
// SEED DATA: MISSION CATEGORIES
// ============================================================================

const missionCategories = [
  {
    id: 'veracidadville',
    title: 'Veracidadville',
    description: 'Detecta la desinformación y defiende la verdad.',
    iconName: 'shield',
    colorHex: '0xFF6EC6FF',
    order: 1,
  },
  {
    id: 'zona_cero_odio',
    title: 'Zona Cero Odio',
    description: 'Reconoce y contrarresta el discurso de odio en línea.',
    iconName: 'message',
    colorHex: '0xFFA4D65E',
    order: 2,
  },
  {
    id: 'fortaleza_privacidad',
    title: 'Fortaleza Privacidad',
    description: 'Protege tu identidad digital y navega seguro.',
    iconName: 'lock',
    colorHex: '0xFFF4D03F',
    order: 3,
  },
  {
    id: 'ciberseguridad',
    title: 'Misión Ciberseguridad',
    description: 'Defiende el ciberespacio de amenazas y ataques.',
    iconName: 'security',
    colorHex: '0xFFFF6B6B',
    order: 4,
  },
];

// ============================================================================
// SEED DATA: MISSIONS
// ============================================================================

const missions = [
  // Veracidadville missions (3 misiones)
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
  // Zona Cero Odio missions (3 misiones)
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
  // Ciberseguridad missions (3 misiones - ya completas)
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
// SEED DATA: QUESTIONS
// ============================================================================

const questions = [
  // =========================================================================
  // VERACIDADVILLE - Quiz Questions (fake_news mission)
  // =========================================================================
  {
    id: 'q1_zanahoria',
    missionId: 'fake_news',
    type: 'quiz',
    newsTitle: 'Científicos descubren que beber jugo de zanahoria hace que puedas ver en la oscuridad',
    newsContent: 'Según un estudio reciente, beber un vaso de jugo de zanahoria diariamente durante 30 días permite desarrollar visión nocturna similar a la de los gatos.',
    newsSource: 'ElNoticiero.com',
    newsDate: 'Publicado: Hoy',
    newsAuthor: 'Por: Dr. Inventado',
    newsShares: 'Compartido: 15,432 veces',
    newsImage: null,
    elements: [
      { id: 'author', text: 'Autor: ¿No es un experto real?', icon: 'person', isCorrect: true },
      { id: 'source', text: 'Fuente: ¿Es falsa?', icon: 'link', isCorrect: true },
      { id: 'image', text: 'Imagen: ¿Parece manipulada?', icon: 'image', isCorrect: false },
      { id: 'data', text: 'Datos: ¿Son exagerados?', icon: 'trending_up', isCorrect: true },
    ],
    explanation: '¡Correcto! Esta noticia es falsa. El autor "Dr. Inventado" no es real, la fuente no es confiable, y los datos son exagerados. Las zanahorias ayudan a la salud visual pero no dan visión nocturna.',
    correctAnswer: null,
    clues: null,
    order: 1,
  },
  {
    id: 'q2_vacunas',
    missionId: 'fake_news',
    type: 'quiz',
    newsTitle: '¡URGENTE! Vacunas causan superpoderes en niños, dice estudio',
    newsContent: 'Un grupo de científicos anónimos reveló que las vacunas están diseñadas para dar superpoderes a los niños. ¡Comparte antes de que lo borren!',
    newsSource: 'NoticiasTotales.net',
    newsDate: 'Publicado: Hace 2 horas',
    newsAuthor: 'Por: Anónimo',
    newsShares: 'Compartido: 50,000 veces',
    newsImage: null,
    elements: [
      { id: 'author', text: 'Autor: ¿No es un experto real?', icon: 'person', isCorrect: true },
      { id: 'source', text: 'Fuente: ¿Es falsa?', icon: 'link', isCorrect: true },
      { id: 'image', text: 'Imagen: ¿Parece manipulada?', icon: 'image', isCorrect: false },
      { id: 'data', text: 'Datos: ¿Son exagerados?', icon: 'trending_up', isCorrect: true },
    ],
    explanation: '¡Correcto! Esta es una noticia falsa peligrosa. El autor es anónimo (no confiable), la fuente no es verificada, y la afirmación de "superpoderes" es completamente falsa. Las vacunas salvan vidas, no dan superpoderes.',
    correctAnswer: null,
    clues: null,
    order: 2,
  },
  {
    id: 'q3_agua_mar',
    missionId: 'fake_news',
    type: 'quiz',
    newsTitle: 'Médicos ocultan la verdad: beber agua de mar cura todas las enfermedades',
    newsContent: 'La industria farmacéutica no quiere que sepas esto: el agua de mar puede curar cáncer, diabetes y hasta el resfriado común. Miles de personas ya lo probaron.',
    newsSource: 'SaludAlternativa.blog',
    newsDate: 'Publicado: Ayer',
    newsAuthor: 'Por: Naturista123',
    newsShares: 'Compartido: 25,678 veces',
    newsImage: null,
    elements: [
      { id: 'author', text: 'Autor: ¿No es un experto real?', icon: 'person', isCorrect: true },
      { id: 'source', text: 'Fuente: ¿Es falsa?', icon: 'link', isCorrect: true },
      { id: 'image', text: 'Imagen: ¿Parece manipulada?', icon: 'image', isCorrect: false },
      { id: 'data', text: 'Datos: ¿Son exagerados?', icon: 'trending_up', isCorrect: true },
    ],
    explanation: '¡Correcto! Esta noticia es falsa y peligrosa. "Naturista123" no es un médico, la fuente es un blog no verificado, y afirmar que algo "cura todo" es una señal clara de información falsa. Beber agua de mar es peligroso.',
    correctAnswer: null,
    clues: null,
    order: 3,
  },

  // =========================================================================
  // VERACIDADVILLE - True/False Questions (titular mission)
  // =========================================================================
  {
    id: 'tf_q1',
    missionId: 'titular',
    type: 'trueFalse',
    newsTitle: '¡CURA MÁGICA PARA EL RESFRIADO!',
    newsContent: 'Científicos descubren que beber agua con limón y miel ¡ELIMINA INSTANTÁNEAMENTE CUALQUIER VIRUS! Compartir con todos tus contactos para protegerlos. 🍋',
    newsSource: 'SaludTotal.com',
    newsDate: 'Hace 2 horas',
    newsAuthor: '@SuperSaludable',
    newsShares: '15.2K compartidos',
    newsImage: null,
    elements: [
      { id: 'true', text: 'Verdadero', icon: 'check_circle', isCorrect: false },
      { id: 'false', text: 'Falso', icon: 'cancel', isCorrect: true },
    ],
    explanation: '¡Correcto! Esta noticia es FALSA. El lenguaje exagerado, la falta de fuentes verificables y la presión para compartir son señales claras de desinformación.',
    correctAnswer: false,
    clues: [
      'Lenguaje exagerado: "ELIMINA INSTANTÁNEAMENTE"',
      'Amenaza o presión: "Compartir o podrías enfermar"',
      'Falta de fuentes científicas verificables',
      'Uso de mayúsculas y signos de exclamación excesivos',
    ],
    order: 1,
  },
  {
    id: 'tf_q2',
    missionId: 'titular',
    type: 'trueFalse',
    newsTitle: 'Estudio revela beneficios del ejercicio regular',
    newsContent: 'Investigadores de la Universidad Nacional publicaron un estudio en la revista médica "The Lancet" que muestra cómo 30 minutos de ejercicio diario pueden mejorar la salud cardiovascular. El estudio incluyó 5,000 participantes durante 2 años.',
    newsSource: 'CienciaHoy.edu',
    newsDate: 'Hace 1 día',
    newsAuthor: 'Dr. María González',
    newsShares: '2.3K compartidos',
    newsImage: null,
    elements: [
      { id: 'true', text: 'Verdadero', icon: 'check_circle', isCorrect: true },
      { id: 'false', text: 'Falso', icon: 'cancel', isCorrect: false },
    ],
    explanation: '¡Correcto! Esta noticia es VERDADERA. Tiene fuentes verificables, datos específicos y lenguaje profesional. Es información confiable.',
    correctAnswer: true,
    clues: [
      'Fuente verificable: Universidad Nacional',
      'Publicación en revista científica reconocida',
      'Datos específicos: 5,000 participantes, 2 años',
      'Lenguaje moderado y profesional',
    ],
    order: 2,
  },
  {
    id: 'tf_q3',
    missionId: 'titular',
    type: 'trueFalse',
    newsTitle: '¡GOBIERNO OCULTA LA VERDAD!',
    newsContent: '¡LO QUE NO QUIEREN QUE SEPAS! Las antenas 5G están controlando nuestras mentes. ¡COMPARTE ANTES DE QUE BORREN ESTE MENSAJE! Solo los despiertos conocen la verdad. 👁️',
    newsSource: 'NoticiasSinCensurar.net',
    newsDate: 'Hace 3 horas',
    newsAuthor: 'Anónimo',
    newsShares: '45.8K compartidos',
    newsImage: null,
    elements: [
      { id: 'true', text: 'Verdadero', icon: 'check_circle', isCorrect: false },
      { id: 'false', text: 'Falso', icon: 'cancel', isCorrect: true },
    ],
    explanation: '¡Correcto! Esta es una teoría de conspiración FALSA. El autor anónimo, lenguaje alarmista y falta de evidencia son señales claras de desinformación.',
    correctAnswer: false,
    clues: [
      'Teoría de conspiración sin evidencia',
      'Presión para compartir: "ANTES DE QUE BORREN"',
      'Autor anónimo sin credenciales',
      'Lenguaje alarmista y mayúsculas excesivas',
    ],
    order: 3,
  },

  // =========================================================================
  // ZONA CERO ODIO - Word Trail Questions (mensaje_escondido mission)
  // =========================================================================
  {
    id: 'zc_word_1',
    missionId: 'mensaje_escondido',
    type: 'trueFalse',
    newsTitle: 'Mensaje Escondido',
    newsContent: 'Vuelve a tu país, nadie te quiere aquí.',
    newsSource: 'Zona Cero Odio',
    newsDate: '',
    newsAuthor: '',
    newsShares: '',
    newsImage: null,
    elements: [
      { id: 'harmful', text: 'Dañino', icon: 'block', isCorrect: true },
      { id: 'safe', text: 'No Dañino', icon: 'check_circle', isCorrect: false },
    ],
    explanation: 'Todos merecen sentirse bienvenidos sin importar de dónde vienen.',
    correctAnswer: true,
    clues: null,
    order: 1,
  },
  {
    id: 'zc_word_2',
    missionId: 'mensaje_escondido',
    type: 'trueFalse',
    newsTitle: 'Mensaje Escondido',
    newsContent: 'Eres parte de nuestro equipo, contamos contigo.',
    newsSource: 'Zona Cero Odio',
    newsDate: '',
    newsAuthor: '',
    newsShares: '',
    newsImage: null,
    elements: [
      { id: 'harmful', text: 'Dañino', icon: 'block', isCorrect: false },
      { id: 'safe', text: 'No Dañino', icon: 'check_circle', isCorrect: true },
    ],
    explanation: 'Las palabras que animan hacen que todos se sientan seguros.',
    correctAnswer: false,
    clues: null,
    order: 2,
  },
  {
    id: 'zc_word_3',
    missionId: 'mensaje_escondido',
    type: 'trueFalse',
    newsTitle: 'Mensaje Escondido',
    newsContent: 'Hablas raro, no te entiendo.',
    newsSource: 'Zona Cero Odio',
    newsDate: '',
    newsAuthor: '',
    newsShares: '',
    newsImage: null,
    elements: [
      { id: 'harmful', text: 'Dañino', icon: 'block', isCorrect: true },
      { id: 'safe', text: 'No Dañino', icon: 'check_circle', isCorrect: false },
    ],
    explanation: 'Burlarse lastima. Mejor pregunta con cariño para entender.',
    correctAnswer: true,
    clues: null,
    order: 3,
  },
  {
    id: 'zc_word_4',
    missionId: 'mensaje_escondido',
    type: 'trueFalse',
    newsTitle: 'Mensaje Escondido',
    newsContent: 'Gracias por compartir tu cultura con nosotros.',
    newsSource: 'Zona Cero Odio',
    newsDate: '',
    newsAuthor: '',
    newsShares: '',
    newsImage: null,
    elements: [
      { id: 'harmful', text: 'Dañino', icon: 'block', isCorrect: false },
      { id: 'safe', text: 'No Dañino', icon: 'check_circle', isCorrect: true },
    ],
    explanation: 'Agradecer y escuchar crea amistad.',
    correctAnswer: false,
    clues: null,
    order: 4,
  },
  {
    id: 'zc_word_5',
    missionId: 'mensaje_escondido',
    type: 'trueFalse',
    newsTitle: 'Mensaje Escondido',
    newsContent: 'No puedes jugar, esto no es para ti.',
    newsSource: 'Zona Cero Odio',
    newsDate: '',
    newsAuthor: '',
    newsShares: '',
    newsImage: null,
    elements: [
      { id: 'harmful', text: 'Dañino', icon: 'block', isCorrect: true },
      { id: 'safe', text: 'No Dañino', icon: 'check_circle', isCorrect: false },
    ],
    explanation: 'Todos pueden jugar. Invitar hace que nadie se quede solo.',
    correctAnswer: true,
    clues: null,
    order: 5,
  },
  {
    id: 'zc_word_6',
    missionId: 'mensaje_escondido',
    type: 'trueFalse',
    newsTitle: 'Mensaje Escondido',
    newsContent: 'Tu idea es genial, cuéntame más.',
    newsSource: 'Zona Cero Odio',
    newsDate: '',
    newsAuthor: '',
    newsShares: '',
    newsImage: null,
    elements: [
      { id: 'harmful', text: 'Dañino', icon: 'block', isCorrect: false },
      { id: 'safe', text: 'No Dañino', icon: 'check_circle', isCorrect: true },
    ],
    explanation: 'Animar a otros ayuda a que sus ideas crezcan.',
    correctAnswer: false,
    clues: null,
    order: 6,
  },
  {
    id: 'zc_word_7',
    missionId: 'mensaje_escondido',
    type: 'trueFalse',
    newsTitle: 'Mensaje Escondido',
    newsContent: 'Nadie quiere sentarse contigo.',
    newsSource: 'Zona Cero Odio',
    newsDate: '',
    newsAuthor: '',
    newsShares: '',
    newsImage: null,
    elements: [
      { id: 'harmful', text: 'Dañino', icon: 'block', isCorrect: true },
      { id: 'safe', text: 'No Dañino', icon: 'check_circle', isCorrect: false },
    ],
    explanation: 'Dejar a alguien fuera duele. Invitar hace sentir bien.',
    correctAnswer: true,
    clues: null,
    order: 7,
  },
  {
    id: 'zc_word_8',
    missionId: 'mensaje_escondido',
    type: 'trueFalse',
    newsTitle: 'Mensaje Escondido',
    newsContent: 'Me gusta aprender palabras nuevas de ti.',
    newsSource: 'Zona Cero Odio',
    newsDate: '',
    newsAuthor: '',
    newsShares: '',
    newsImage: null,
    elements: [
      { id: 'harmful', text: 'Dañino', icon: 'block', isCorrect: false },
      { id: 'safe', text: 'No Dañino', icon: 'check_circle', isCorrect: true },
    ],
    explanation: 'Aprender del otro nos une.',
    correctAnswer: false,
    clues: null,
    order: 8,
  },
  {
    id: 'zc_word_9',
    missionId: 'mensaje_escondido',
    type: 'trueFalse',
    newsTitle: 'Mensaje Escondido',
    newsContent: 'Eres muy raro.',
    newsSource: 'Zona Cero Odio',
    newsDate: '',
    newsAuthor: '',
    newsShares: '',
    newsImage: null,
    elements: [
      { id: 'harmful', text: 'Dañino', icon: 'block', isCorrect: true },
      { id: 'safe', text: 'No Dañino', icon: 'check_circle', isCorrect: false },
    ],
    explanation: 'Etiquetar lastima. Podemos decir: "Eres único y eso es genial".',
    correctAnswer: true,
    clues: null,
    order: 9,
  },
  {
    id: 'zc_word_10',
    missionId: 'mensaje_escondido',
    type: 'trueFalse',
    newsTitle: 'Mensaje Escondido',
    newsContent: 'Todos somos bienvenidos en este juego.',
    newsSource: 'Zona Cero Odio',
    newsDate: '',
    newsAuthor: '',
    newsShares: '',
    newsImage: null,
    elements: [
      { id: 'harmful', text: 'Dañino', icon: 'block', isCorrect: false },
      { id: 'safe', text: 'No Dañino', icon: 'check_circle', isCorrect: true },
    ],
    explanation: 'Cuando incluimos a todos, el lugar se vuelve feliz.',
    correctAnswer: false,
    clues: null,
    order: 10,
  },

  // =========================================================================
  // CIBERSEGURIDAD - Questions
  // =========================================================================
  {
    id: 'cib_q1_phishing',
    missionId: 'q1_phishing',
    type: 'quiz',
    newsTitle: '¡Urgente! Actualiza tu información bancaria',
    newsContent: 'Hemos detectado actividad sospechosa en tu cuenta. Por favor, haz clic aquí y actualiza tu información inmediatamente para evitar el bloqueo.',
    newsSource: 'BancoFalso.com',
    newsDate: 'Publicado: Hoy',
    newsAuthor: 'Departamento de Seguridad',
    newsShares: 'Compartido: 123 veces',
    newsImage: null,
    elements: [
      { id: 'urgency', text: '¿El mensaje crea sensación de urgencia?', icon: 'alarm', isCorrect: true },
      { id: 'sender', text: '¿El remitente es desconocido o sospechoso?', icon: 'person', isCorrect: true },
      { id: 'link', text: '¿El enlace parece sospechoso?', icon: 'link', isCorrect: true },
    ],
    explanation: '¡Correcto! Este es un intento de phishing. Los correos urgentes, de remitentes desconocidos y con enlaces sospechosos suelen ser fraudulentos.',
    correctAnswer: null,
    clues: null,
    order: 1,
  },
  {
    id: 'cib_q2_malware',
    missionId: 'q2_malware',
    type: 'quiz',
    newsTitle: 'Descarga gratis el nuevo juego [Nombre del Juego] ¡Edición Limitada!',
    newsContent: '¡Sé el primero en jugar el nuevo [Nombre del Juego]! Descárgalo ahora desde nuestro sitio web.',
    newsSource: 'SitioWebDeJuegosFalsos.com',
    newsDate: 'Publicado: Ayer',
    newsAuthor: 'Equipo de Desarrollo',
    newsShares: 'Compartido: 456 veces',
    newsImage: null,
    elements: [
      { id: 'source', text: '¿La fuente es desconocida o no oficial?', icon: 'link', isCorrect: true },
      { id: 'free', text: '¿Ofrecen algo gratis que normalmente cuesta dinero?', icon: 'attach_money', isCorrect: true },
      { id: 'permissions', text: '¿El juego pide permisos extraños al instalarse?', icon: 'security', isCorrect: true },
    ],
    explanation: '¡Correcto! Este podría ser un intento de distribuir malware. Descargar software de fuentes no oficiales es peligroso.',
    correctAnswer: null,
    clues: null,
    order: 1,
  },
  {
    id: 'cib_q3_passwords',
    missionId: 'q3_passwords',
    type: 'quiz',
    newsTitle: '¡Tu contraseña es tu llave!',
    newsContent: '¿Usas la misma contraseña para todo? ¡Es hora de cambiar eso! Una contraseña segura debe ser larga, aleatoria y única.',
    newsSource: 'BlogDeSeguridad.net',
    newsDate: 'Publicado: Hace 1 semana',
    newsAuthor: 'ExpertoEnSeguridad',
    newsShares: 'Compartido: 789 veces',
    newsImage: null,
    elements: [
      { id: 'length', text: '¿La contraseña tiene menos de 8 caracteres?', icon: 'text_fields', isCorrect: true },
      { id: 'reuse', text: '¿La usas en múltiples sitios web?', icon: 'repeat', isCorrect: true },
      { id: 'personal', text: '¿Contiene información personal fácil de adivinar?', icon: 'person', isCorrect: true },
    ],
    explanation: '¡Correcto! Usar contraseñas débiles es un riesgo. Asegúrate de crear contraseñas fuertes y únicas para cada cuenta.',
    correctAnswer: null,
    clues: null,
    order: 1,
  },
];

// ============================================================================
// SEED DATA: LEARN CONTENT (Videos & Podcasts)
// ============================================================================

const learnContent = [
  {
    id: 'video_01',
    title: 'Alfabetización Mediática',
    description: 'Aprende sobre los medios de comunicación y cómo interpretarlos correctamente.',
    type: 'video',
    category: 'Videos',
    thumbnailUrl: '',
    youtubeId: 'ul7siGvqmB8',
    audioUrl: null,
    durationSeconds: 60,
    order: 1,
  },
  // Add more videos/podcasts here as needed
];

// ============================================================================
// SEED FUNCTIONS
// ============================================================================

async function seedCollection(collectionName, documents, idField = 'id') {
  console.log(`\n📦 Seeding ${collectionName}...`);

  const batch = db.batch();
  let count = 0;

  for (const doc of documents) {
    const docId = doc[idField];
    const docRef = db.collection(collectionName).doc(docId);

    // Remove id from the document data (it's already in the document ID)
    const docData = { ...doc };
    delete docData[idField];

    if (DRY_RUN) {
      console.log(`   [DRY RUN] Would create: ${collectionName}/${docId}`);
    } else {
      batch.set(docRef, docData);
    }
    count++;
  }

  if (!DRY_RUN) {
    await batch.commit();
  }

  console.log(`   ✅ ${count} documents ${DRY_RUN ? 'would be ' : ''}created in ${collectionName}`);
}

async function main() {
  console.log('🚀 PiensaPlay Firebase Seed Script');
  console.log('==================================');

  if (DRY_RUN) {
    console.log('⚠️  DRY RUN MODE - No changes will be made to Firebase');
  }

  try {
    // Seed badges (global catalog)
    await seedCollection('badges', badges);

    // Seed mission categories
    await seedCollection('mission_categories', missionCategories);

    // Seed missions
    await seedCollection('missions', missions);

    // Seed questions
    await seedCollection('questions', questions);

    // Seed learn content (videos & podcasts)
    await seedCollection('learn_content', learnContent);

    console.log('\n==================================');
    console.log('🎉 Seed completed successfully!');
    console.log('\nCollections populated:');
    console.log(`   • badges: ${badges.length} documents`);
    console.log(`   • mission_categories: ${missionCategories.length} documents`);
    console.log(`   • missions: ${missions.length} documents`);
    console.log(`   • questions: ${questions.length} documents`);
    console.log(`   • learn_content: ${learnContent.length} documents`);

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
