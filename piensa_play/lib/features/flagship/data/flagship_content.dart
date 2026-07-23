import 'package:flutter/material.dart';

import '../domain/flagship_mission.dart';

const _pause = LocalizedText(
  es: 'Respira y evita compartir mientras sientes urgencia.',
  en: 'Take a breath and avoid sharing while you feel urgency.',
);

class FlagshipContent {
  static const missions = <FlagshipMission>[
    FlagshipMission(
      id: 'viral_post',
      titleKey: 'mission1Title',
      subtitleKey: 'mission1Subtitle',
      icon: Icons.campaign_rounded,
      color: Color(0xFFF6E16B),
      skills: [PiensaSkill.pause, PiensaSkill.identify, PiensaSkill.seek],
      challenges: [
        FlagshipChallenge(
          id: 'viral_urgency',
          skill: PiensaSkill.pause,
          context: LocalizedText(
            es: 'Un mensaje dice: “¡URGENTE! Mañana cerrarán todas las escuelas. Comparte antes de que lo borren”.',
            en: 'A message says: “URGENT! Every school will close tomorrow. Share before they delete this”.',
          ),
          prompt: LocalizedText(
            es: '¿Cuál es tu primera acción?',
            en: 'What is your first action?',
          ),
          clues: [
            LocalizedText(
              es: 'Usa miedo y urgencia.',
              en: 'It uses fear and urgency.',
            ),
            LocalizedText(
              es: 'No muestra autor ni enlace oficial.',
              en: 'It has no author or official link.',
            ),
          ],
          choices: [
            FlagshipChoice(
              text: LocalizedText(
                es: 'Compartir para prevenir a todos',
                en: 'Share it to warn everyone',
              ),
              isBestChoice: false,
              feedback: LocalizedText(
                es: 'La urgencia puede hacer que amplifiques un rumor.',
                en: 'Urgency can make you amplify a rumor.',
              ),
            ),
            FlagshipChoice(
              text: LocalizedText(
                es: 'Pausar y buscar el anuncio oficial',
                en: 'Pause and look for the official notice',
              ),
              isBestChoice: true,
              feedback: _pause,
            ),
            FlagshipChoice(
              text: LocalizedText(
                es: 'Creerlo porque lo envió un amigo',
                en: 'Believe it because a friend sent it',
              ),
              isBestChoice: false,
              feedback: LocalizedText(
                es: 'Una persona conocida también puede compartir algo incorrecto.',
                en: 'Someone you know can also share incorrect information.',
              ),
            ),
          ],
          takeaway: LocalizedText(
            es: 'La emoción es una señal para pausar, no una prueba de que algo sea cierto.',
            en: 'Emotion is a signal to pause, not proof that something is true.',
          ),
        ),
        FlagshipChallenge(
          id: 'viral_source',
          skill: PiensaSkill.identify,
          context: LocalizedText(
            es: 'Encuentras tres cuentas con el mismo aviso: @NoticiasYa, la cuenta oficial del municipio y una captura recortada.',
            en: 'You find the same alert on three accounts: @NewsNow, the city’s official account and a cropped screenshot.',
          ),
          prompt: LocalizedText(
            es: '¿Qué fuente debes examinar primero?',
            en: 'Which source should you examine first?',
          ),
          clues: [
            LocalizedText(
              es: 'Un nombre parecido no garantiza identidad.',
              en: 'A similar name does not prove identity.',
            ),
            LocalizedText(
              es: 'Una captura puede ocultar fecha y contexto.',
              en: 'A screenshot can hide date and context.',
            ),
          ],
          choices: [
            FlagshipChoice(
              text: LocalizedText(
                es: 'La publicación con más reacciones',
                en: 'The post with the most reactions',
              ),
              isBestChoice: false,
              feedback: LocalizedText(
                es: 'La popularidad no convierte una afirmación en evidencia.',
                en: 'Popularity does not turn a claim into evidence.',
              ),
            ),
            FlagshipChoice(
              text: LocalizedText(
                es: 'La cuenta oficial y su sitio web',
                en: 'The official account and its website',
              ),
              isBestChoice: true,
              feedback: LocalizedText(
                es: 'Identificar quién informa permite evaluar su autoridad y responsabilidad.',
                en: 'Identifying the source helps assess authority and accountability.',
              ),
            ),
            FlagshipChoice(
              text: LocalizedText(
                es: 'La captura más clara',
                en: 'The clearest screenshot',
              ),
              isBestChoice: false,
              feedback: LocalizedText(
                es: 'La calidad visual no demuestra el origen.',
                en: 'Visual quality does not prove origin.',
              ),
            ),
          ],
          takeaway: LocalizedText(
            es: 'Busca la fuente original, su identidad y la fecha completa.',
            en: 'Find the original source, its identity and the full date.',
          ),
        ),
        FlagshipChallenge(
          id: 'viral_corroborate',
          skill: PiensaSkill.seek,
          context: LocalizedText(
            es: 'El sitio oficial no menciona cierres. Dos medios locales confiables publican el calendario normal.',
            en: 'The official site mentions no closure. Two trusted local outlets publish the normal schedule.',
          ),
          prompt: LocalizedText(
            es: '¿Qué conclusión está mejor respaldada?',
            en: 'Which conclusion is best supported?',
          ),
          clues: [
            LocalizedText(
              es: 'Varias fuentes independientes coinciden.',
              en: 'Several independent sources agree.',
            ),
            LocalizedText(
              es: 'El mensaje viral no aporta evidencia.',
              en: 'The viral message provides no evidence.',
            ),
          ],
          choices: [
            FlagshipChoice(
              text: LocalizedText(
                es: 'El cierre es real pero secreto',
                en: 'The closure is real but secret',
              ),
              isBestChoice: false,
              feedback: LocalizedText(
                es: 'Eso añade una explicación sin evidencia.',
                en: 'That adds an explanation without evidence.',
              ),
            ),
            FlagshipChoice(
              text: LocalizedText(
                es: 'No hay evidencia suficiente para compartir el aviso',
                en: 'There is not enough evidence to share the alert',
              ),
              isBestChoice: true,
              feedback: LocalizedText(
                es: 'Corroborar reduce la posibilidad de amplificar información errónea.',
                en: 'Corroboration lowers the chance of amplifying misinformation.',
              ),
            ),
            FlagshipChoice(
              text: LocalizedText(
                es: 'Da igual porque pronto se sabrá',
                en: 'It does not matter because people will know soon',
              ),
              isBestChoice: false,
              feedback: LocalizedText(
                es: 'Un rumor ya puede causar confusión y miedo.',
                en: 'A rumor can already cause confusion and fear.',
              ),
            ),
          ],
          takeaway: LocalizedText(
            es: 'Busca confirmación independiente antes de aceptar o compartir una afirmación.',
            en: 'Seek independent confirmation before accepting or sharing a claim.',
          ),
        ),
      ],
    ),
    FlagshipMission(
      id: 'ai_lab',
      titleKey: 'mission2Title',
      subtitleKey: 'mission2Subtitle',
      icon: Icons.auto_awesome_rounded,
      color: Color(0xFF75C9E8),
      skills: [PiensaSkill.examine, PiensaSkill.notice, PiensaSkill.seek],
      challenges: [
        FlagshipChallenge(
          id: 'ai_claim',
          skill: PiensaSkill.examine,
          context: LocalizedText(
            es: 'Una imagen muestra un animal extraordinario en el parque. El texto afirma que fue descubierto hoy, pero no enlaza ningún reporte.',
            en: 'An image shows an extraordinary animal in the park. The caption says it was discovered today but links to no report.',
          ),
          prompt: LocalizedText(
            es: '¿Qué debes examinar?',
            en: 'What should you examine?',
          ),
          clues: [
            LocalizedText(
              es: 'Una imagen impactante también necesita procedencia.',
              en: 'A striking image still needs provenance.',
            ),
            LocalizedText(
              es: 'Detectar errores visuales no es un método infalible.',
              en: 'Spotting visual glitches is not a foolproof method.',
            ),
          ],
          choices: [
            FlagshipChoice(
              text: LocalizedText(
                es: 'Solo contar dedos y sombras',
                en: 'Only count fingers and shadows',
              ),
              isBestChoice: false,
              feedback: LocalizedText(
                es: 'La IA mejora rápidamente; una imagen sin defectos también puede ser sintética.',
                en: 'AI improves quickly; a flawless image can still be synthetic.',
              ),
            ),
            FlagshipChoice(
              text: LocalizedText(
                es: 'Origen, fecha, autor y evidencia relacionada',
                en: 'Origin, date, author and related evidence',
              ),
              isBestChoice: true,
              feedback: LocalizedText(
                es: 'La procedencia y el contexto son más sólidos que adivinar por apariencia.',
                en: 'Provenance and context are stronger than guessing from appearance.',
              ),
            ),
            FlagshipChoice(
              text: LocalizedText(
                es: 'Si se ve real, aceptarla',
                en: 'Accept it if it looks real',
              ),
              isBestChoice: false,
              feedback: LocalizedText(
                es: 'La apariencia puede diseñarse para convencerte.',
                en: 'Appearance can be designed to persuade you.',
              ),
            ),
          ],
          takeaway: LocalizedText(
            es: 'No preguntes solo “¿es IA?”; pregunta “¿de dónde viene y qué la respalda?”.',
            en: 'Do not only ask “is it AI?”; ask “where did it come from and what supports it?”.',
          ),
        ),
        FlagshipChallenge(
          id: 'ai_emotion',
          skill: PiensaSkill.notice,
          context: LocalizedText(
            es: 'El texto añade: “Los científicos no quieren que sepas esto”. Miles de comentarios expresan enojo.',
            en: 'The caption adds: “Scientists do not want you to know this”. Thousands of comments express anger.',
          ),
          prompt: LocalizedText(
            es: '¿Qué intención debes notar?',
            en: 'What intention should you notice?',
          ),
          clues: [
            LocalizedText(
              es: 'Presenta una conspiración sin prueba.',
              en: 'It presents a conspiracy without proof.',
            ),
            LocalizedText(
              es: 'El enojo aumenta la interacción.',
              en: 'Anger increases engagement.',
            ),
          ],
          choices: [
            FlagshipChoice(
              text: LocalizedText(
                es: 'Informar con precisión',
                en: 'Inform accurately',
              ),
              isBestChoice: false,
              feedback: LocalizedText(
                es: 'No ofrece datos verificables ni una fuente responsable.',
                en: 'It offers no verifiable data or accountable source.',
              ),
            ),
            FlagshipChoice(
              text: LocalizedText(
                es: 'Provocar emoción para obtener atención',
                en: 'Trigger emotion to gain attention',
              ),
              isBestChoice: true,
              feedback: LocalizedText(
                es: 'Notar la emoción ayuda a recuperar el control de tu decisión.',
                en: 'Noticing emotion helps you regain control of your decision.',
              ),
            ),
            FlagshipChoice(
              text: LocalizedText(
                es: 'Hacer una broma sin consecuencias',
                en: 'Make a harmless joke',
              ),
              isBestChoice: false,
              feedback: LocalizedText(
                es: 'Aunque fuera una broma, puede confundir si no está señalada.',
                en: 'Even a joke can mislead if it is not clearly labeled.',
              ),
            ),
          ],
          takeaway: LocalizedText(
            es: 'Pregúntate quién se beneficia de tu reacción y de tu clic.',
            en: 'Ask who benefits from your reaction and your click.',
          ),
        ),
        FlagshipChallenge(
          id: 'ai_verify',
          skill: PiensaSkill.seek,
          context: LocalizedText(
            es: 'Una búsqueda inversa encuentra la misma imagen en una galería de arte generado. El parque publica fotos de animales reales.',
            en: 'A reverse search finds the same image in an AI art gallery. The park posts photos of the real animals.',
          ),
          prompt: LocalizedText(
            es: '¿Qué respuesta ayuda más a la comunidad?',
            en: 'Which response helps the community most?',
          ),
          clues: [
            LocalizedText(
              es: 'Ya encontraste el origen.',
              en: 'You found the origin.',
            ),
            LocalizedText(
              es: 'Corregir sin atacar reduce la polarización.',
              en: 'Correcting without attacking reduces polarization.',
            ),
          ],
          choices: [
            FlagshipChoice(
              text: LocalizedText(
                es: 'Burlarte de quien la compartió',
                en: 'Mock the person who shared it',
              ),
              isBestChoice: false,
              feedback: LocalizedText(
                es: 'Atacar personas dificulta que escuchen la corrección.',
                en: 'Attacking people makes correction harder to hear.',
              ),
            ),
            FlagshipChoice(
              text: LocalizedText(
                es: 'Compartir el origen y explicar cómo lo verificaste',
                en: 'Share the origin and explain how you verified it',
              ),
              isBestChoice: true,
              feedback: LocalizedText(
                es: 'Mostrar el proceso enseña a otras personas a verificar.',
                en: 'Showing the process teaches others how to verify.',
              ),
            ),
            FlagshipChoice(
              text: LocalizedText(
                es: 'Volver a publicar la imagen sin contexto',
                en: 'Repost the image without context',
              ),
              isBestChoice: false,
              feedback: LocalizedText(
                es: 'Podrías amplificarla incluso si querías corregirla.',
                en: 'You may amplify it even if you meant to correct it.',
              ),
            ),
          ],
          takeaway: LocalizedText(
            es: 'Verifica, explica tu evidencia y evita amplificar el contenido dañino.',
            en: 'Verify, explain your evidence and avoid amplifying harmful content.',
          ),
        ),
      ],
    ),
    FlagshipMission(
      id: 'sharing_ripple',
      titleKey: 'mission3Title',
      subtitleKey: 'mission3Subtitle',
      icon: Icons.hub_rounded,
      color: Color(0xFFBDD87B),
      skills: [PiensaSkill.notice, PiensaSkill.act, PiensaSkill.pause],
      challenges: [
        FlagshipChallenge(
          id: 'ripple_stereotype',
          skill: PiensaSkill.notice,
          context: LocalizedText(
            es: 'Un meme culpa a todo un grupo de estudiantes por un incidente cometido por una sola persona.',
            en: 'A meme blames an entire group of students for an incident caused by one person.',
          ),
          prompt: LocalizedText(
            es: '¿Qué problema notas?',
            en: 'What problem do you notice?',
          ),
          clues: [
            LocalizedText(
              es: 'Convierte un caso individual en una etiqueta colectiva.',
              en: 'It turns one case into a label for a whole group.',
            ),
            LocalizedText(
              es: 'Puede causar discriminación.',
              en: 'It can cause discrimination.',
            ),
          ],
          choices: [
            FlagshipChoice(
              text: LocalizedText(
                es: 'Es gracioso, así que no causa daño',
                en: 'It is funny, so it causes no harm',
              ),
              isBestChoice: false,
              feedback: LocalizedText(
                es: 'El humor también puede normalizar estereotipos dañinos.',
                en: 'Humor can also normalize harmful stereotypes.',
              ),
            ),
            FlagshipChoice(
              text: LocalizedText(
                es: 'Generaliza y promueve un estereotipo',
                en: 'It generalizes and promotes a stereotype',
              ),
              isBestChoice: true,
              feedback: LocalizedText(
                es: 'Reconocer la generalización evita tratar una etiqueta como evidencia.',
                en: 'Recognizing generalization stops a label from becoming “evidence”.',
              ),
            ),
            FlagshipChoice(
              text: LocalizedText(
                es: 'Solo importa si se vuelve viral',
                en: 'It only matters if it goes viral',
              ),
              isBestChoice: false,
              feedback: LocalizedText(
                es: 'Una sola publicación ya puede herir o excluir.',
                en: 'A single post can already hurt or exclude.',
              ),
            ),
          ],
          takeaway: LocalizedText(
            es: 'Examina a quién representa el contenido y quién puede resultar dañado.',
            en: 'Examine who the content represents and who may be harmed.',
          ),
        ),
        FlagshipChallenge(
          id: 'ripple_action',
          skill: PiensaSkill.act,
          context: LocalizedText(
            es: 'El meme empieza a circular en el chat del curso. Una compañera pide que dejen de compartirlo.',
            en: 'The meme begins circulating in the class chat. A classmate asks people to stop sharing it.',
          ),
          prompt: LocalizedText(
            es: '¿Cuál es la mejor acción?',
            en: 'What is the best action?',
          ),
          clues: [
            LocalizedText(
              es: 'No compartir corta parte de la difusión.',
              en: 'Not sharing stops part of the spread.',
            ),
            LocalizedText(
              es: 'Apoyar a la persona afectada importa.',
              en: 'Supporting the affected person matters.',
            ),
          ],
          choices: [
            FlagshipChoice(
              text: LocalizedText(
                es: 'No reenviar, pedir que se elimine y apoyar a la compañera',
                en: 'Do not forward, ask for removal and support the classmate',
              ),
              isBestChoice: true,
              feedback: LocalizedText(
                es: 'Actuar responsablemente protege sin amplificar.',
                en: 'Responsible action protects without amplifying.',
              ),
            ),
            FlagshipChoice(
              text: LocalizedText(
                es: 'Reenviarlo para preguntar si ofende',
                en: 'Forward it to ask whether it is offensive',
              ),
              isBestChoice: false,
              feedback: LocalizedText(
                es: 'Reenviarlo aumenta su alcance y el posible daño.',
                en: 'Forwarding increases its reach and potential harm.',
              ),
            ),
            FlagshipChoice(
              text: LocalizedText(
                es: 'Ignorar a la compañera',
                en: 'Ignore the classmate',
              ),
              isBestChoice: false,
              feedback: LocalizedText(
                es: 'El silencio puede dejar sola a la persona afectada.',
                en: 'Silence can leave the affected person alone.',
              ),
            ),
          ],
          takeaway: LocalizedText(
            es: 'Actuar también significa no amplificar, apoyar y usar las herramientas de reporte.',
            en: 'Acting also means not amplifying, supporting others and using reporting tools.',
          ),
        ),
        FlagshipChallenge(
          id: 'ripple_create',
          skill: PiensaSkill.act,
          context: LocalizedText(
            es: 'El curso quiere publicar un mensaje que repare el daño y ayude a reconocer estereotipos.',
            en: 'The class wants to post a message that repairs harm and helps people recognize stereotypes.',
          ),
          prompt: LocalizedText(
            es: '¿Qué publicación crearías?',
            en: 'Which post would you create?',
          ),
          clues: [
            LocalizedText(
              es: 'Debe centrarse en la conducta, no atacar personas.',
              en: 'Focus on behavior, not attacking people.',
            ),
            LocalizedText(
              es: 'Debe ofrecer una acción concreta.',
              en: 'Offer a concrete action.',
            ),
          ],
          choices: [
            FlagshipChoice(
              text: LocalizedText(
                es: '“Quien compartió esto es una mala persona”',
                en: '“Whoever shared this is a bad person”',
              ),
              isBestChoice: false,
              feedback: LocalizedText(
                es: 'Cambiar un ataque por otro no repara la conversación.',
                en: 'Replacing one attack with another does not repair the conversation.',
              ),
            ),
            FlagshipChoice(
              text: LocalizedText(
                es: '“No generalicemos: revisemos los hechos y tratemos a cada persona con respeto”',
                en: '“Let’s not generalize: check the facts and treat each person with respect”',
              ),
              isBestChoice: true,
              feedback: LocalizedText(
                es: 'Es claro, respetuoso y propone una práctica responsable.',
                en: 'It is clear, respectful and proposes responsible behavior.',
              ),
            ),
            FlagshipChoice(
              text: LocalizedText(
                es: 'Publicar el meme otra vez con emojis tristes',
                en: 'Post the meme again with sad emojis',
              ),
              isBestChoice: false,
              feedback: LocalizedText(
                es: 'La imagen dañina vuelve a circular aunque cambie tu intención.',
                en: 'The harmful image circulates again even if your intention changes.',
              ),
            ),
          ],
          takeaway: LocalizedText(
            es: 'La alfabetización mediática incluye crear mensajes éticos que mejoren la comunidad.',
            en: 'Media literacy includes creating ethical messages that improve the community.',
          ),
        ),
      ],
    ),
  ];
}
