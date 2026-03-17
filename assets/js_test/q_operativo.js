// ═══ BATERÍA: PUESTOS OPERATIVOS ═════════════════════════════
// Tests: Toulouse-Piéron, D48, 16PF, Honestidad, Trabajo bajo presión
const SECS_OPERATIVO = [
  {id:"attention",name:"Atención y Concentración",time:"5 min",desc:"Evalúa su capacidad de atención sostenida y precisión. Seleccione la respuesta correcta lo más rápido posible."},
  {id:"reasoning",name:"Razonamiento Lógico",time:"5 min",desc:"Identifique patrones y resuelva las secuencias presentadas."},
  {id:"personality_op",name:"Personalidad Laboral",time:"5 min",desc:"Indique qué tan de acuerdo está con cada afirmación."},
  {id:"honesty",name:"Honestidad e Integridad",time:"5 min",desc:"Evalúe cada situación con total honestidad."},
  {id:"pressure",name:"Trabajo Bajo Presión",time:"5 min",desc:"Seleccione cómo reaccionaría ante cada situación."},
];
const Q_OP = {
// ─── Toulouse-Piéron: Atención y Concentración ──────────────
attention:[
  {t:"En la serie: 3, 6, 9, 12, __, ¿qué número sigue?",o:["14","15","16","18"],s:[1,5,1,1]},
  {t:"¿Cuál es diferente? Llave, Martillo, Destornillador, Manzana",o:["Llave","Martillo","Destornillador","Manzana"],s:[1,1,1,5]},
  {t:"Si 'SEGURO' se escribe al revés, ¿cuál es la tercera letra?",o:["U","G","R","O"],s:[1,1,5,1]},
  {t:"En la serie: 2, 4, 8, 16, __, ¿qué número sigue?",o:["24","30","32","20"],s:[1,1,5,1]},
  {t:"¿Cuántos triángulos hay si un triángulo grande contiene una línea que va de un vértice al lado opuesto?",o:["1","2","3","4"],s:[1,5,1,1]},
  {t:"¿Cuál palabra NO pertenece al grupo? Diésel, Gasolina, Turbosina, Cemento",o:["Diésel","Gasolina","Turbosina","Cemento"],s:[1,1,1,5]},
  {t:"Si hoy es miércoles, ¿qué día será dentro de 5 días?",o:["Domingo","Lunes","Martes","Sábado"],s:[1,5,1,1]},
  {t:"En la secuencia: A1, B2, C3, D__, ¿qué falta?",o:["5","D","4","E"],s:[1,1,5,1]},
  {t:"Un tanque de 10,000 litros está al 75%. ¿Cuántos litros tiene?",o:["7,000","7,500","8,000","5,000"],s:[1,5,1,1]},
  {t:"¿Cuál es el opuesto de NEGLIGENTE?",o:["Descuidado","Cuidadoso","Lento","Rápido"],s:[1,5,1,1]},
],
// ─── D48: Razonamiento Lógico ───────────────────────────────
reasoning:[
  {t:"Si todos los operadores usan casco y Juan es operador, entonces:",o:["Juan podría usar casco","Juan no necesita casco","Juan usa casco","No se puede saber"],s:[1,1,5,1]},
  {t:"Serie: 5, 10, 20, 40, __",o:["60","70","80","50"],s:[1,1,5,1]},
  {t:"Si A es mayor que B, y B es mayor que C, entonces:",o:["C es mayor que A","A es mayor que C","Son iguales","B es el mayor"],s:[1,5,1,1]},
  {t:"¿Qué número completa: 3, 5, 8, 12, __?",o:["15","16","17","14"],s:[1,1,5,1]},
  {t:"Un camión recorre 80 km/h. ¿Cuánto tardará en recorrer 240 km?",o:["2 horas","3 horas","4 horas","2.5 horas"],s:[1,5,1,1]},
  {t:"Si reorganizamos 'DADIGURSE', obtenemos:",o:["SEGURIDAD","DISGUSTAR","GUARIDAS","SALUDRIGE"],s:[5,1,1,1]},
  {t:"Serie: 1, 1, 2, 3, 5, 8, __",o:["10","11","12","13"],s:[1,1,1,5]},
  {t:"Si 3 operadores cargan un tanque en 6 horas, ¿cuánto tardarán 6 operadores?",o:["12 horas","3 horas","2 horas","4 horas"],s:[1,5,1,1]},
  {t:"¿Cuál figura NO encaja? Círculo, Cuadrado, Triángulo, Línea",o:["Círculo","Cuadrado","Triángulo","Línea"],s:[1,1,1,5]},
  {t:"Un reloj marca las 3:15. ¿Qué ángulo forman las manecillas?",o:["90°","7.5°","0°","45°"],s:[1,5,1,1]},
],
// ─── 16PF: Personalidad Laboral ─────────────────────────────
personality_op:[
  {t:"Sigo las instrucciones de mi supervisor aunque no esté de acuerdo.",tr:"C",d:1},
  {t:"Me adapto rápidamente cuando cambian mis tareas o mi área de trabajo.",tr:"O",d:1},
  {t:"Me cuesta trabajo aceptar cuando me equivoco.",tr:"A",d:-1},
  {t:"Prefiero un trabajo con rutinas establecidas que uno que cambie constantemente.",tr:"O",d:-1},
  {t:"Mis compañeros me consideran una persona confiable.",tr:"C",d:1},
  {t:"Me pongo nervioso cuando tengo que hacer algo nuevo.",tr:"N",d:1},
  {t:"Me gusta ayudar a los compañeros nuevos a integrarse.",tr:"A",d:1},
  {t:"Termino mis tareas antes de la fecha límite.",tr:"C",d:1},
  {t:"Me cuesta concentrarme cuando hay ruido o distracciones.",tr:"N",d:1},
  {t:"Me resulta fácil seguir instrucciones escritas paso a paso.",tr:"C",d:1},
  {t:"Cuando hay un conflicto con un compañero, busco resolverlo hablando.",tr:"A",d:1},
  {t:"Me considero una persona puntual y organizada.",tr:"C",d:1},
],
// ─── Honestidad e Integridad ────────────────────────────────
honesty:[
  {t:"Si encuentro herramienta de la empresa tirada, la regreso a su lugar.",s:[5,4,3,2,1]},
  {t:"Está bien tomar materiales sobrantes de la empresa si nadie los usa.",s:[1,2,3,4,5]},
  {t:"Reportaría a un compañero que roba material de trabajo.",s:[5,4,3,2,1]},
  {t:"Si llego tarde y nadie se da cuenta, no lo registro.",s:[1,2,3,4,5]},
  {t:"Nunca he mentido a un supervisor sobre mi trabajo.",s:[5,4,3,2,1]},
  {t:"Si cometo un error que nadie ve, lo corrijo sin decir nada.",s:[2,3,3,4,5]},
  {t:"Considero que la honestidad es más importante que caer bien.",s:[5,4,3,2,1]},
  {t:"A veces es necesario exagerar un poco para quedar bien con el jefe.",s:[1,2,3,4,5]},
  {t:"Si un compañero me pide cubrir una falta, lo haría por lealtad.",s:[1,2,3,4,5]},
  {t:"Me sentiría incómodo si tuviera que mentir por instrucción de un jefe.",s:[5,4,3,2,1]},
],
// ─── Trabajo Bajo Presión ───────────────────────────────────
pressure:[
  {t:"Tu supervisor te pide terminar un trabajo urgente en la mitad del tiempo habitual.",o:["Me estreso y no sé por dónde empezar","Priorizo tareas, me organizo y trabajo enfocado","Me quejo de que es imposible","Hago el trabajo rápido aunque quede mal"],s:[1,5,1,2]},
  {t:"Dos supervisores te dan instrucciones diferentes al mismo tiempo.",o:["Hago lo del que me caiga mejor","Pido aclaración para saber cuál es prioridad","Ignoro a los dos","Hago uno y dejo el otro"],s:[1,5,1,2]},
  {t:"Un equipo se descompone y no hay refacciones disponibles.",o:["Espero sin hacer nada","Busco alternativas, informo y propongo solución temporal","Me frusto y reclamo","Improviso una reparación peligrosa"],s:[1,5,1,1]},
  {t:"Llevas varios días trabajando horas extra y estás agotado.",o:["Bajo mi rendimiento sin avisar","Hablo con mi supervisor sobre mi carga","Me enfermo para descansar","Continúo hasta colapsar"],s:[1,5,1,1]},
  {t:"Un compañero comete un error que afecta tu trabajo.",o:["Lo confronto agresivamente","Lo hablo con calma y buscamos solución","Lo ignoro pero guardo rencor","Lo acuso con el jefe sin hablar con él"],s:[1,5,1,2]},
  {t:"Te piden hacer una tarea que nunca has hecho antes.",o:["Me niego porque no me corresponde","Pido capacitación o ayuda y la intento","La hago sin saber y espero que salga","Digo que ya la sé aunque no sea cierto"],s:[1,5,1,1]},
  {t:"Estás en medio de tu trabajo y se va la luz / falla el sistema.",o:["Me desespero","Sigo protocolo de emergencia, notifico y espero instrucciones","Me voy a mi casa","Intento arreglar el problema yo solo"],s:[1,5,1,2]},
  {t:"Tu jefe te da retroalimentación negativa frente a tus compañeros.",o:["Le respondo mal enfrente de todos","Lo escucho y después le pido hablar en privado","Me callo pero guardo resentimiento","Dejo de esforzarme en mi trabajo"],s:[1,5,2,1]},
]};
