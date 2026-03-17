// ═══ BATERÍA: PUESTOS ADMINISTRATIVOS ════════════════════════
// Tests: Raven, Aptitudes Administrativas, Big Five, Int Emocional, Estilo Trabajo
const SECS_ADMINISTRATIVO = [
  {id:"reasoning_adm",name:"Razonamiento Analítico",time:"6 min",desc:"Evalúa capacidad de análisis y resolución de problemas."},
  {id:"admin_apt",name:"Aptitudes Administrativas",time:"6 min",desc:"Evalúa organización, planeación y manejo de información."},
  {id:"personality_adm",name:"Personalidad Laboral",time:"5 min",desc:"Indique qué tan de acuerdo está con cada afirmación."},
  {id:"emotional_iq",name:"Inteligencia Emocional",time:"6 min",desc:"Evalúa manejo de emociones y relaciones interpersonales."},
  {id:"work_style",name:"Estilo de Trabajo",time:"5 min",desc:"Sobre su compromiso, organización y manejo del tiempo."},
];
const Q_ADM = {
// ─── Raven: Razonamiento Analítico ──────────────────────────
reasoning_adm:[
  {t:"Serie: 2, 6, 18, 54, __",o:["108","162","72","96"],s:[1,5,1,1]},
  {t:"Si el presupuesto de un proyecto es $100,000 y se ha gastado el 35%, ¿cuánto queda disponible?",o:["$55,000","$65,000","$75,000","$45,000"],s:[1,5,1,1]},
  {t:"'Todo reporte debe ser revisado antes de enviarse. Juan envió un reporte.' Entonces:",o:["Juan revisó su reporte","El reporte debió ser revisado","Juan no envió nada","No se puede saber"],s:[1,5,1,1]},
  {t:"Si 4 personas completan un informe en 8 horas, ¿cuánto tardarán 8 personas?",o:["16 horas","4 horas","6 horas","2 horas"],s:[1,5,1,1]},
  {t:"Serie: A2, C4, E6, G8, __",o:["H10","I10","J12","I9"],s:[2,5,1,1]},
  {t:"Un departamento tiene 12 empleados. Si 25% está de vacaciones y 1/3 del resto en capacitación, ¿cuántos trabajan normalmente?",o:["4","5","6","8"],s:[1,1,5,1]},
  {t:"¿Cuál NO pertenece? Excel, Word, Chrome, PowerPoint",o:["Excel","Word","Chrome","PowerPoint"],s:[1,1,5,1]},
  {t:"Si un proceso tiene 5 pasos y cada paso toma 15 minutos, pero los pasos 2 y 3 pueden hacerse simultáneamente, ¿cuánto toma todo?",o:["75 min","60 min","45 min","50 min"],s:[1,5,1,1]},
  {t:"Serie: 100, 95, 85, 70, __",o:["60","55","50","45"],s:[1,1,5,1]},
  {t:"En una base de datos de 1,000 registros, el 3% tiene errores. Si corriges 20 errores, ¿cuántos quedan?",o:["30","10","15","5"],s:[1,5,1,1]},
],
// ─── Aptitudes Administrativas ──────────────────────────────
admin_apt:[
  {t:"Al organizar archivos, lo más efectivo es:",o:["Apilarlos por fecha de llegada","Clasificarlos por categoría con nomenclatura estandarizada","Guardarlos como vayan llegando","Memorizar dónde está cada uno"],s:[2,5,1,1]},
  {t:"Para dar seguimiento a 15 pendientes con diferentes fechas de entrega, usarías:",o:["Memoria","Lista priorizada con fechas y estatus","Notas en papeles sueltos","Le pregunto a mi jefe cada mañana"],s:[1,5,1,1]},
  {t:"Recibes un correo con instrucciones confusas de tu director. Lo mejor es:",o:["Hacer lo que entendí","Pedir aclaración antes de empezar","Ignorar el correo","Preguntarle a un compañero qué cree que dice"],s:[1,5,1,2]},
  {t:"Un proveedor te envía una factura con un monto diferente al cotizado. ¿Qué haces?",o:["La pago como está","Verifico contra la cotización y notifico la discrepancia","La rechazo sin explicación","Espero a que alguien más la revise"],s:[1,5,1,1]},
  {t:"¿Cuál es la mejor forma de preparar una reunión importante?",o:["Improvisar según el momento","Definir agenda, preparar información y enviarla previamente","Esperar a que el jefe diga qué hacer","Llevar notas generales"],s:[1,5,1,2]},
  {t:"Si dos tareas urgentes tienen la misma fecha límite, priorizas por:",o:["La que me gusta más","Impacto en la operación y necesidades del área","La más fácil primero","La que me pidió mi jefe directo solamente"],s:[1,5,1,2]},
  {t:"Un compañero te pide ayuda con un reporte pero tienes tus propios pendientes.",o:["Lo ayudo y dejo mis pendientes","Evalúo mi carga, y si puedo le ayudo; si no, le sugiero alternativa","Le digo que no sin explicar","Hago su trabajo mal para que no me vuelva a pedir"],s:[1,5,1,1]},
  {t:"Encuentras un error en un reporte que ya fue enviado a dirección.",o:["No digo nada, ya se envió","Notifico el error, corrijo y reenvío la versión corregida","Espero a que alguien lo note","Le echo la culpa al sistema"],s:[1,5,1,1]},
],
// ─── Big Five: Personalidad Administrativa ──────────────────
personality_adm:[
  {t:"Me considero una persona organizada en mi trabajo y vida personal.",tr:"C",d:1},
  {t:"Disfruto trabajar en equipo más que de forma individual.",tr:"E",d:1},
  {t:"Me adapto fácilmente a nuevos sistemas o formas de trabajo.",tr:"O",d:1},
  {t:"Cuando algo me molesta en el trabajo, tiendo a guardármelo.",tr:"N",d:1},
  {t:"Me gusta proponer ideas y mejoras en los procesos.",tr:"O",d:1},
  {t:"Soy de las personas que siempre entrega a tiempo o antes.",tr:"C",d:1},
  {t:"Me cuesta delegar tareas porque prefiero hacerlas yo.",tr:"E",d:-1},
  {t:"Mantengo la calma cuando hay cambios de última hora.",tr:"N",d:-1},
  {t:"Me resulta fácil comunicar mis ideas de forma clara.",tr:"E",d:1},
  {t:"Reviso mi trabajo varias veces antes de entregarlo.",tr:"C",d:1},
  {t:"Los conflictos entre compañeros me generan mucha ansiedad.",tr:"N",d:1},
  {t:"Me interesa aprender habilidades nuevas aunque no sean de mi área.",tr:"O",d:1},
],
// ─── Inteligencia Emocional ─────────────────────────────────
emotional_iq:[
  {t:"Un compañero está visiblemente frustrado por una tarea. Lo mejor es:",o:["Ignorarlo, es su problema","Preguntarle si necesita ayuda y escucharlo","Decirle que se calme","Reportarlo a RH por inestable"],s:[1,5,1,1]},
  {t:"Tu jefe critica tu trabajo en una junta. Tu primera reacción debería ser:",o:["Defenderme agresivamente","Escuchar con apertura y pedir ejemplos específicos","Quedarme callado y resentido","Llorar o salir de la sala"],s:[1,5,1,1]},
  {t:"Dos compañeros de tu equipo tienen un conflicto que afecta el trabajo.",o:["No me meto","Facilito una conversación para que lleguen a un acuerdo","Tomo partido por uno","Lo reporto sin intentar resolver"],s:[1,5,1,2]},
  {t:"Identifico cuándo mis emociones pueden afectar mis decisiones laborales.",s:[5,4,3,2,1]},
  {t:"Puedo mantener una actitud positiva aunque tenga problemas personales.",s:[5,4,3,2,1]},
  {t:"Me resulta fácil entender el punto de vista de personas con opiniones diferentes a las mías.",s:[5,4,3,2,1]},
  {t:"Cuando cometo un error, lo reconozco sin culpar a otros.",s:[5,4,3,2,1]},
  {t:"Sé manejar la frustración cuando un proyecto no sale como esperaba.",s:[5,4,3,2,1]},
  {t:"Puedo dar retroalimentación difícil a un compañero sin ofenderlo.",s:[5,4,3,2,1]},
  {t:"Me considero bueno para motivar a otros en momentos difíciles.",s:[5,4,3,2,1]},
],
// ─── Estilo de Trabajo ──────────────────────────────────────
work_style:[
  {t:"Planifico mi semana laboral con anticipación.",s:[5,4,3,2,1]},
  {t:"Suelo dejar las tareas difíciles para el final.",s:[1,2,3,4,5]},
  {t:"Manejo múltiples tareas simultáneamente de forma efectiva.",s:[5,4,3,2,1]},
  {t:"Reviso periódicamente el avance de mis objetivos.",s:[5,4,3,2,1]},
  {t:"Me cuesta llegar puntual a reuniones o compromisos.",s:[1,2,3,4,5]},
  {t:"Busco formas de hacer mi trabajo más eficiente.",s:[5,4,3,2,1]},
  {t:"Cuando termino mis tareas, busco en qué más apoyar.",s:[5,4,3,2,1]},
  {t:"Necesito que me supervisen constantemente para cumplir.",s:[1,2,3,4,5]},
  {t:"Documento mis procesos para que otros puedan replicarlos.",s:[5,4,3,2,1]},
  {t:"Mi compromiso con la empresa va más allá de mi horario laboral.",s:[5,4,3,2,1]},
]};
