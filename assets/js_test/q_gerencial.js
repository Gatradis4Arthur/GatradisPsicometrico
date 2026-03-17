// ═══ BATERÍA: PUESTOS GERENCIALES ════════════════════════════
// Tests: Raven Avanzado, Liderazgo, Big Five Directivo, Int Emocional, Toma de Decisiones
const SECS_GERENCIAL = [
  {id:"reasoning_ger",name:"Razonamiento Estratégico",time:"7 min",desc:"Evalúa capacidad analítica y resolución de problemas complejos."},
  {id:"leadership",name:"Estilo de Liderazgo",time:"7 min",desc:"Evalúa su capacidad para dirigir equipos e influir positivamente."},
  {id:"personality_ger",name:"Perfil Directivo",time:"6 min",desc:"Indique qué tan de acuerdo está con cada afirmación."},
  {id:"emotional_ger",name:"Inteligencia Emocional",time:"6 min",desc:"Evalúa manejo de emociones propias y de equipos."},
  {id:"decisions",name:"Toma de Decisiones",time:"7 min",desc:"Seleccione la mejor decisión ante cada escenario gerencial."},
];
const Q_GER = {
// ─── Raven Avanzado: Razonamiento Estratégico ───────────────
reasoning_ger:[
  {t:"Una empresa tiene 3 líneas de negocio. La línea A genera 40% de ingresos con 60% de costos, B genera 35% con 25%, C genera 25% con 15%. ¿Cuál es más rentable?",o:["Línea A","Línea B","Línea C","Todas igual"],s:[1,2,5,1]},
  {t:"Si la rotación de personal cuesta 3 meses de salario por empleado y tienes 20% de rotación anual en un equipo de 50 personas, con salario promedio de $15,000, ¿cuál es el costo anual de rotación?",o:["$450,000","$150,000","$225,000","$300,000"],s:[5,1,1,1]},
  {t:"Un proyecto se retrasará 3 semanas. Tienes opciones: A) Agregar 4 personas ($200K extra), B) Negociar extensión con cliente (riesgo de penalización de $500K), C) Reducir alcance. La penalización tiene 40% de probabilidad. ¿Cuál tiene menor costo esperado?",o:["Opción A: $200K","Opción B: $200K esperado","Opción C: depende","Las tres son iguales"],s:[5,4,2,1]},
  {t:"Serie compleja: 1, 4, 9, 16, 25, __",o:["30","36","42","49"],s:[1,5,1,1]},
  {t:"Un gerente tiene 6 reportes directos. Cada uno tiene en promedio 8 personas. ¿Cuál es el span of control total de la estructura?",o:["14","48","54","6"],s:[1,1,5,1]},
  {t:"Si la productividad cae 15% al cambiar de sistema y la curva de aprendizaje es de 3 meses, pero el nuevo sistema mejora 30% después, ¿en cuántos meses se recupera la inversión en productividad?",o:["3 meses","4.5 meses","6 meses","Nunca"],s:[1,5,1,1]},
  {t:"Tienes $1M de presupuesto. Proyecto X tiene 70% probabilidad de generar $2M. Proyecto Y tiene 90% probabilidad de generar $1.3M. ¿Cuál tiene mayor valor esperado?",o:["X: $1.4M","Y: $1.17M","Son iguales","Falta información"],s:[5,1,1,1]},
  {t:"En una negociación, tu BATNA (mejor alternativa) es un contrato de $800K. Te ofrecen $750K. Lo correcto es:",o:["Aceptar para cerrar rápido","Rechazar, tu BATNA es mejor","Pedir $900K","Aceptar con condiciones"],s:[1,5,1,2]},
  {t:"Tu equipo tiene 5 proyectos con deadline esta semana. Solo puedes completar 3. ¿Cómo priorizas?",o:["Los más fáciles primero","Por impacto en cliente y riesgo de cada uno","Los que me pidió el director","Los que llevan más avance"],s:[1,5,1,2]},
  {t:"Un KPI clave cayó 20% este trimestre. El primer paso debería ser:",o:["Cambiar al responsable","Analizar causa raíz con datos antes de actuar","Implementar cambios inmediatos","Reportar y esperar instrucciones"],s:[1,5,1,1]},
],
// ─── Liderazgo ──────────────────────────────────────────────
leadership:[
  {t:"Un miembro de tu equipo comete un error grave frente a un cliente.",o:["Lo reprendo públicamente para que aprenda","Asumo responsabilidad ante el cliente y luego doy retroalimentación en privado","Lo ignoro y yo corrijo el error","Lo despido"],s:[1,5,2,1]},
  {t:"Dos miembros de tu equipo tienen un conflicto personal que afecta resultados.",o:["Dejo que lo resuelvan solos","Hablo con ambos por separado, entiendo perspectivas y facilito acuerdo","Tomo partido por el que tiene razón","Separo sus responsabilidades sin hablar del tema"],s:[1,5,1,2]},
  {t:"Tu equipo debe implementar un cambio que genera resistencia.",o:["Impongo el cambio por autoridad","Explico el por qué, involucro al equipo en el cómo e implemento gradualmente","Espero a que se acostumbren solos","Cancelo el cambio si hay resistencia"],s:[1,5,1,1]},
  {t:"Un colaborador talentoso te dice que está considerando irse a otra empresa.",o:["Le digo que se vaya si quiere","Escucho sus razones, evalúo qué puedo ofrecer y diseño plan de retención","Le aumento sueldo inmediatamente","Le digo que nadie es indispensable"],s:[1,5,2,1]},
  {t:"Un empleado nuevo no está rindiendo como se esperaba después de 2 meses.",o:["Lo despido por bajo desempeño","Reviso su plan de inducción, doy retroalimentación clara y establezco metas a 30 días","Espero 6 meses más","Le asigno tareas más fáciles"],s:[1,5,1,2]},
  {t:"Tu equipo logra un resultado excepcional.",o:["Me llevo el crédito como líder","Reconozco públicamente al equipo y comunico logro hacia arriba","No digo nada, es su trabajo","Solo reconozco al que más trabajó"],s:[1,5,1,2]},
  {t:"Debes reducir el presupuesto de tu área 20%. ¿Cómo comunicas?",o:["Por correo sin más explicación","Reúno al equipo, explico situación, presento plan y pido ideas de optimización","No digo nada y hago recortes","Le paso la responsabilidad a RH"],s:[1,5,1,1]},
  {t:"Considero que mi estilo de liderazgo se adapta según la madurez de cada colaborador.",s:[5,4,3,2,1]},
  {t:"Invierto tiempo regularmente en desarrollar las habilidades de mi equipo.",s:[5,4,3,2,1]},
  {t:"Delego no solo tareas sino también autoridad para tomar decisiones.",s:[5,4,3,2,1]},
],
// ─── Big Five Directivo ─────────────────────────────────────
personality_ger:[
  {t:"Tomo decisiones difíciles con rapidez cuando es necesario.",tr:"C",d:1},
  {t:"Genero confianza en mi equipo a través de mi ejemplo.",tr:"A",d:1},
  {t:"Me resulta difícil dar retroalimentación negativa.",tr:"A",d:-1},
  {t:"Busco constantemente nuevas oportunidades de negocio o mejora.",tr:"O",d:1},
  {t:"Mantengo la calma en situaciones de crisis.",tr:"N",d:-1},
  {t:"Me siento cómodo presentando ideas ante grupos grandes.",tr:"E",d:1},
  {t:"Considero múltiples perspectivas antes de tomar una decisión importante.",tr:"O",d:1},
  {t:"Mi equipo sabe exactamente qué espero de ellos.",tr:"C",d:1},
  {t:"Me cuesta trabajo confiar en las decisiones de otros.",tr:"A",d:-1},
  {t:"Asumo la responsabilidad cuando las cosas salen mal en mi área.",tr:"C",d:1},
  {t:"Anticipo problemas antes de que ocurran.",tr:"C",d:1},
  {t:"Me adapto rápidamente a cambios en el mercado o la industria.",tr:"O",d:1},
],
// ─── Inteligencia Emocional Gerencial ───────────────────────
emotional_ger:[
  {t:"Reconozco cómo mis emociones afectan mi estilo de liderazgo.",s:[5,4,3,2,1]},
  {t:"Puedo motivar a mi equipo incluso en momentos difíciles.",s:[5,4,3,2,1]},
  {t:"Identifico cuando un colaborador tiene problemas aunque no me lo diga.",s:[5,4,3,2,1]},
  {t:"Manejo la presión de los superiores sin descargarla en mi equipo.",s:[5,4,3,2,1]},
  {t:"En una negociación difícil, controlo mis emociones para obtener mejor resultado.",s:[5,4,3,2,1]},
  {t:"Cuando recibo una noticia mala, me tomo un momento antes de reaccionar.",s:[5,4,3,2,1]},
  {t:"Puedo comunicar malas noticias al equipo sin generar pánico.",s:[5,4,3,2,1]},
  {t:"Entiendo que diferentes personas necesitan diferentes estilos de comunicación.",s:[5,4,3,2,1]},
  {t:"Separo mis opiniones personales de las decisiones de negocio.",s:[5,4,3,2,1]},
  {t:"Celebro los logros de mi equipo con la misma importancia que analizo los fracasos.",s:[5,4,3,2,1]},
],
// ─── Toma de Decisiones Gerenciales ─────────────────────────
decisions:[
  {t:"Un cliente importante amenaza con irse si no reduces precio 30%. Tu margen actual es 25%.",o:["Acepto para no perder al cliente","Analizo su valor a largo plazo, negocio condiciones y ofrezco alternativas con valor agregado","Dejo que se vaya","Le subo el precio"],s:[1,5,1,1]},
  {t:"Tienes que elegir entre invertir en automatización ($2M, ahorra 40% costos en 3 años) o contratar más personal ($800K/año).",o:["Personal, es más barato ahora","Automatización, el ROI a 3 años es mayor","No invierto en nada","Hago ambas a medias"],s:[1,5,1,1]},
  {t:"Descubres que un gerente de tu equipo comete una falta ética menor pero recurrente.",o:["Lo ignoro porque da buenos resultados","Documento, confronto con evidencia y establezco consecuencias claras","Lo despido inmediatamente","Se lo comento informalmente"],s:[1,5,2,2]},
  {t:"El mercado cambia y tu producto estrella pierde 15% de ventas en un trimestre.",o:["Espero a que se recupere solo","Analizo tendencia, investigo causa y diseño estrategia de respuesta","Recorto presupuesto de marketing","Cambio de giro"],s:[1,5,1,1]},
  {t:"Dos áreas de tu empresa tienen un conflicto por recursos compartidos.",o:["Tomo partido por la más importante","Facilito acuerdo basado en datos, prioridades estratégicas y métricas compartidas","Dejo que lo resuelvan entre ellos","Le paso el problema a mi jefe"],s:[1,5,1,1]},
  {t:"Recibes una oportunidad de negocio grande pero con plazo de respuesta de 48 horas.",o:["La rechazo por falta de tiempo para analizar","Reúno información clave, evalúo riesgo/beneficio y tomo decisión informada","La acepto sin analizar","Pido más tiempo sin evaluar"],s:[1,5,1,2]},
  {t:"Tu plan estratégico a 3 años no va en línea con los resultados del primer año.",o:["Sigo el plan sin cambios","Reviso supuestos, ajusto estrategia manteniendo la visión de largo plazo","Desecho el plan completo","Culpo a factores externos"],s:[1,5,1,1]},
  {t:"Ante una decisión estratégica, los datos apuntan en una dirección pero tu intuición en otra.",o:["Siempre sigo los datos","Profundizo en los datos, valido mi intuición con más información y luego decido","Siempre sigo mi intuición","Pido a alguien más que decida"],s:[2,5,1,1]},
]};
