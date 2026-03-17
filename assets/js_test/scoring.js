// ═══ SCORING ENGINE (ALL POSITIONS) ══════════════════════════
const TN={E:"Extraversión",A:"Amabilidad",C:"Responsabilidad",N:"Neuroticismo",O:"Apertura"};
const LK=["Totalmente en desacuerdo","En desacuerdo","Neutral","De acuerdo","Totalmente de acuerdo"];
const pct=(a,b)=>b?Math.round((a/b)*100):0;

function getQBank(puesto){
  if(puesto==='transporte') return {secs:SECS_TRANSPORTE,q:Q_TR};
  if(puesto==='operativo') return {secs:SECS_OPERATIVO,q:Q_OP};
  if(puesto==='administrativo') return {secs:SECS_ADMINISTRATIVO,q:Q_ADM};
  if(puesto==='gerencial') return {secs:SECS_GERENCIAL,q:Q_GER};
  return null;
}

function scorePersonality(qs,ans){
  const tm={E:[],A:[],C:[],N:[],O:[]};
  qs.forEach((q,i)=>{if(ans?.[i]!==undefined&&q.tr){const r=ans[i]+1;tm[q.tr].push(q.d===1?r:6-r);}});
  const p={};for(const[k,v]of Object.entries(tm)) if(v.length)p[k]=pct(v.reduce((a,b)=>a+b,0),v.length*5);
  return p;
}

function scoreLikertBank(qs,ans){
  let t=0,m=0;
  qs.forEach((q,i)=>{if(ans?.[i]===undefined)return;
    if(q.s){t+=q.s[ans[i]];m+=5;}
    else if(q.d!==undefined){const r=ans[i]+1;t+=q.d===1?r:6-r;m+=5;}
    else if(q.o){t+=q.s?q.s[ans[i]]:(ans[i]===0?5:ans[i]===1?4:ans[i]===2?2:1);m+=5;}
  });
  return pct(t,m);
}

function scoreChoiceBank(qs,ans){
  let t=0,m=0;
  qs.forEach((q,i)=>{if(ans?.[i]!==undefined&&q.s){t+=q.s[ans[i]];m+=5;}});
  return pct(t,m);
}

function scoreAll(puesto,allAns){
  const bank=getQBank(puesto);if(!bank)return{};
  const scores={};

  if(puesto==='transporte'){
    scores.personality=scorePersonality(bank.q.personality,allAns.personality);
    scores.integrity=scoreLikertBank(bank.q.integrity,allAns.integrity);
    // Corruption sub-scores
    let cats={sob:[0,0],cri:[0,0],rac:[0,0],his:[0,0]},cT=0,cM=0;
    bank.q.corruption.forEach((q,i)=>{if(allAns.corruption?.[i]===undefined)return;let v;
      if(q.ty==="sc")v=q.s[allAns.corruption[i]];else{const r=allAns.corruption[i]+1;v=q.d===1?r:6-r;}
      cT+=v;cM+=5;if(cats[q.c]){cats[q.c][0]+=v;cats[q.c][1]+=5;}});
    scores.corruption={total:pct(cT,cM),soborno:pct(cats.sob[0],cats.sob[1]),crimen:pct(cats.cri[0],cats.cri[1]),racionalizacion:pct(cats.rac[0],cats.rac[1]),historial:pct(cats.his[0],cats.his[1])};
    scores.stress=scoreChoiceBank(bank.q.stress,allAns.stress);
    scores.situational=scoreChoiceBank(bank.q.situational,allAns.situational);
    let rT=0,rM=0;bank.q.reliability.forEach((q,i)=>{if(allAns.reliability?.[i]===undefined)return;if(q.ch)rT+=q.s[allAns.reliability[i]];else{const r=allAns.reliability[i]+1;rT+=q.d===1?r:6-r;}rM+=5;});
    scores.reliability=pct(rT,rM);
  }
  else if(puesto==='operativo'){
    scores.attention=scoreChoiceBank(bank.q.attention,allAns.attention);
    scores.reasoning=scoreChoiceBank(bank.q.reasoning,allAns.reasoning);
    scores.personality=scorePersonality(bank.q.personality_op,allAns.personality_op);
    scores.honesty=scoreLikertBank(bank.q.honesty,allAns.honesty);
    scores.pressure=scoreChoiceBank(bank.q.pressure,allAns.pressure);
  }
  else if(puesto==='administrativo'){
    scores.reasoning=scoreChoiceBank(bank.q.reasoning_adm,allAns.reasoning_adm);
    scores.admin_apt=scoreChoiceBank(bank.q.admin_apt,allAns.admin_apt);
    scores.personality=scorePersonality(bank.q.personality_adm,allAns.personality_adm);
    scores.emotional_iq=scoreLikertBank(bank.q.emotional_iq,allAns.emotional_iq);
    scores.work_style=scoreLikertBank(bank.q.work_style,allAns.work_style);
  }
  else if(puesto==='gerencial'){
    scores.reasoning=scoreChoiceBank(bank.q.reasoning_ger,allAns.reasoning_ger);
    scores.leadership=scoreChoiceBank(bank.q.leadership,allAns.leadership);
    scores.personality=scorePersonality(bank.q.personality_ger,allAns.personality_ger);
    scores.emotional_iq=scoreLikertBank(bank.q.emotional_ger,allAns.emotional_ger);
    scores.decisions=scoreChoiceBank(bank.q.decisions,allAns.decisions);
  }
  return scores;
}

function genNarr(puesto,scores,candidate){
  let apt=[],noApt=[],warns=[];
  const s=scores, cn=candidate;

  // Generador genérico de interpretación
  const check=(val,name,hi,mid,hiT,midT,loT)=>{
    if(val>=hi)apt.push(`${hiT} (${val}%).`);
    else if(val>=mid)warns.push(`${midT} (${val}%).`);
    else noApt.push(`${loT} (${val}%).`);
  };

  if(puesto==='transporte'){
    // Corruption special handling
    if(s.corruption){
      check(s.corruption.total,"Corrupción",80,60,"Alta resistencia a la corrupción y soborno","Resistencia moderada a la corrupción. Profundizar en entrevista","Baja resistencia a la corrupción. Vulnerabilidad significativa ante ofertas ilícitas");
      if(s.corruption.soborno<60)noApt.push(`ALERTA SOBORNO: ${s.corruption.soborno}% en resistencia al soborno.`);
      if(s.corruption.crimen<60)noApt.push(`ALERTA NEXOS: ${s.corruption.crimen}% en resistencia a crimen organizado.`);
      if(s.corruption.racionalizacion<50)noApt.push(`Racionalización de conductas indebidas: ${s.corruption.racionalizacion}%.`);
    }
    check(s.integrity||0,"Integridad",78,58,"Integridad alta. Estándares éticos consistentes","Integridad moderada. Flexibilidad ética en presión","Integridad baja. Disposición a omitir información");
    check(s.stress||0,"Estrés",78,58,"Excelente manejo del estrés","Tolerancia moderada al estrés","Baja tolerancia al estrés. Riesgo en emergencias");
    check(s.situational||0,"Técnico",78,58,"Sólido juicio técnico y normativo","Juicio técnico promedio. Requiere capacitación","Juicio técnico deficiente");
    check(s.reliability||0,"Confiabilidad",78,58,"Alta confiabilidad operativa","Confiabilidad moderada","Baja confiabilidad");
  }
  else if(puesto==='operativo'){
    check(s.attention||0,"Atención",78,58,"Excelente capacidad de atención y concentración","Atención promedio. Evaluar en tareas repetitivas","Baja capacidad de atención. Riesgo en tareas de precisión");
    check(s.reasoning||0,"Razonamiento",70,50,"Buen razonamiento lógico","Razonamiento promedio","Razonamiento lógico por debajo del promedio");
    check(s.honesty||0,"Honestidad",78,58,"Alta integridad y honestidad laboral","Honestidad moderada. Verificar referencias","Indicadores de riesgo en honestidad laboral");
    check(s.pressure||0,"Presión",78,58,"Excelente desempeño bajo presión","Manejo moderado de presión. Evaluar en campo","Dificultad para trabajar bajo presión");
  }
  else if(puesto==='administrativo'){
    check(s.reasoning||0,"Razonamiento",78,58,"Sólida capacidad analítica y de resolución de problemas","Capacidad analítica promedio","Capacidad analítica por debajo de lo requerido");
    check(s.admin_apt||0,"Aptitudes",78,58,"Excelentes aptitudes administrativas: organización, planeación y atención al detalle","Aptitudes administrativas promedio. Capacitación recomendada","Aptitudes administrativas insuficientes para el puesto");
    check(s.emotional_iq||0,"IE",78,58,"Alta inteligencia emocional. Buen manejo de relaciones","Inteligencia emocional promedio","Baja inteligencia emocional. Dificultad en relaciones interpersonales");
    check(s.work_style||0,"Estilo",78,58,"Excelente compromiso, organización y manejo del tiempo","Compromiso y organización promedio","Bajo compromiso organizacional y manejo del tiempo deficiente");
  }
  else if(puesto==='gerencial'){
    check(s.reasoning||0,"Estratégico",78,58,"Pensamiento estratégico sólido. Capacidad para evaluar escenarios complejos","Pensamiento estratégico promedio. Requiere mentoría","Pensamiento estratégico insuficiente para nivel gerencial");
    check(s.leadership||0,"Liderazgo",78,58,"Estilo de liderazgo efectivo. Capacidad para dirigir, motivar y desarrollar equipos","Liderazgo con áreas de desarrollo. Capacitación en gestión de personas recomendada","Estilo de liderazgo deficiente. No recomendable para posiciones de mando");
    check(s.emotional_iq||0,"IE",78,58,"Alta inteligencia emocional directiva","Inteligencia emocional promedio para nivel gerencial","Inteligencia emocional insuficiente para gestión de equipos");
    check(s.decisions||0,"Decisiones",78,58,"Excelente capacidad de toma de decisiones bajo incertidumbre","Toma de decisiones promedio. Requiere estructura de soporte","Deficiente en toma de decisiones. Riesgo en posiciones con autonomía");
  }

  // Personality common
  if(s.personality){
    if(s.personality.C>=75)apt.push(`Personalidad responsable y metódica (${s.personality.C}%).`);
    else if(s.personality.C<45)warns.push(`Baja Responsabilidad (${s.personality.C}%). Supervisión recomendada.`);
    if(s.personality.N>=70)warns.push(`Neuroticismo elevado (${s.personality.N}%). Ansiedad que podría afectar desempeño.`);
    else if(s.personality.N<=35)apt.push(`Alta estabilidad emocional (Neuroticismo: ${s.personality.N}%).`);
  }

  // Verdict
  const isApt=noApt.length===0&&warns.length<=2;
  let verdict,vc,vd;
  const puestoLabel={transporte:"operador de transporte de hidrocarburos",operativo:"puesto operativo",administrativo:"puesto administrativo",gerencial:"puesto gerencial"}[puesto]||puesto;

  if(isApt&&noApt.length===0){
    verdict="APTO";vc="grn";
    vd=`${cn.nombre} ${cn.apellidos} presenta un perfil compatible con las exigencias del ${puestoLabel}. Se recomienda proceder con el proceso de contratación.`;
  }else if(noApt.length===0){
    verdict="APTO CON RESERVAS";vc="ylw";
    vd=`${cn.nombre} ${cn.apellidos} presenta áreas de oportunidad. Se recomienda entrevista profunda, verificación de referencias y período de prueba de 90 días.`;
  }else{
    verdict="NO APTO";vc="red";
    vd=`${cn.nombre} ${cn.apellidos} presenta indicadores de riesgo que lo hacen NO RECOMENDABLE para el ${puestoLabel}. Ver motivos específicos.`;
  }

  const riskLv=noApt.length>0?"ALTO":warns.length>2?"MEDIO":"BAJO";
  return{apt,noApt,warns,verdict,vc,vd,riskLv};
}
