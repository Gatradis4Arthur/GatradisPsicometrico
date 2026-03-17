// ═══ PSICOTRANSPORT MULTI-PERFIL — MAIN APP ═════════════════
const $=id=>document.getElementById(id);
let ST={view:"home",puesto:null,puestoNombre:"",codigoId:null,candidate:null,secIdx:0,allAns:{},qi:0,ans:{},startTime:null};

const PUESTO_LABELS={transporte:"Operador de Transporte MatPel",operativo:"Puesto Operativo",administrativo:"Puesto Administrativo",gerencial:"Puesto Gerencial"};
const PUESTO_ICONS={transporte:"🚛",operativo:"⚙️",administrativo:"📋",gerencial:"👔"};

// ─── VIEWS ───────────────────────────────────────────────────
function showView(v){document.querySelectorAll('.view').forEach(el=>el.classList.add('hidden'));$(v)?.classList.remove('hidden');ST.view=v;renderHeader();}
function renderHeader(){
  const h=$('header');
  if(['admin-login','admin-dash'].includes(ST.view)){h.classList.add('hidden');return;}
  h.classList.remove('hidden');
  $('header-admin-btn').classList.toggle('hidden',ST.view!=='home');
  $('header-dots').classList.toggle('hidden',ST.view!=='test');
  $('header-dots').innerHTML='';
  if(ST.view==='test'&&ST.puesto){
    const bank=getQBank(ST.puesto);
    if(bank)$('header-dots').innerHTML=bank.secs.map((_,i)=>`<div class="section-dot ${i<ST.secIdx?'done':i===ST.secIdx?'active':''}"></div>`).join('');
  }
}

// ─── ACCESS CODE ─────────────────────────────────────────────
async function validateCode(){
  const code=$('access-code').value.trim().toUpperCase();
  $('code-error').textContent='';
  if(!code){$('code-error').textContent='Ingrese su código de acceso';return;}

  try{
    const res=await fetch('api/save_result.php?action=validate_code',{method:'POST',headers:{'Content-Type':'application/json'},body:JSON.stringify({codigo:code})});
    const data=await res.json();
    if(data.success){
      ST.puesto=data.puesto_id;
      ST.puestoNombre=data.puesto_nombre;
      ST.codigoId=data.codigo_id;
      $('reg-puesto-label').textContent=`${PUESTO_ICONS[ST.puesto]||''} ${PUESTO_LABELS[ST.puesto]||data.puesto_nombre}`;
      $('reg-info').textContent=`${data.preguntas} preguntas · ${data.duracion}`;
      // Show/hide transport-specific fields
      const isTr=ST.puesto==='transporte';
      document.querySelectorAll('.field-transport').forEach(el=>el.classList.toggle('hidden',!isTr));
      document.querySelectorAll('.field-general').forEach(el=>el.classList.toggle('hidden',isTr));
      showView('register');
    }else{
      $('code-error').textContent=data.error||'Código no válido';
    }
  }catch(e){$('code-error').textContent='Error de conexión';}
}

// ─── REGISTRATION ────────────────────────────────────────────
function submitReg(){
  const fields=['nombre','apellidos','edad','telefono','email'];
  const form={puesto_id:ST.puesto};let valid=true;
  document.querySelectorAll('.form-error').forEach(e=>e.textContent='');
  document.querySelectorAll('.form-input.error').forEach(e=>e.classList.remove('error'));

  fields.forEach(f=>{form[f]=$('f-'+f)?.value?.trim()||'';});
  if(ST.puesto==='transporte'){
    form.licencia=$('f-licencia')?.value?.trim()||'';
    form.tipo_licencia=$('f-tipo_licencia')?.value||'E';
    form.experiencia=$('f-experiencia')?.value||'';
    if(!form.licencia){$('e-licencia').textContent='Requerido';valid=false;}
  }else{
    form.puesto_solicita=$('f-puesto_solicita')?.value?.trim()||'';
    form.area=$('f-area')?.value?.trim()||'';
    form.escolaridad=$('f-escolaridad')?.value||'';
  }

  if(!form.nombre){$('e-nombre').textContent='Requerido';valid=false;}
  if(!form.apellidos){$('e-apellidos').textContent='Requerido';valid=false;}
  if(!form.edad||form.edad<18||form.edad>70){$('e-edad').textContent='18-70 años';valid=false;}
  if(!form.telefono||form.telefono.length<10){$('e-telefono').textContent='10 dígitos';valid=false;}

  if(!valid)return;
  ST.candidate=form;ST.secIdx=0;ST.allAns={};ST.startTime=Date.now();
  startSection();
}

// ─── TEST ENGINE ─────────────────────────────────────────────
function startSection(){showView('test');ST.qi=0;ST.ans={};renderIntro();}

function renderIntro(){
  const bank=getQBank(ST.puesto);
  const sec=bank.secs[ST.secIdx];
  const qs=bank.q[sec.id];
  $('test-content').innerHTML=`
    <div class="section-intro fi">
      <div class="section-num">Sección ${ST.secIdx+1} de ${bank.secs.length}</div>
      <h2>${sec.name}</h2>
      <div class="section-meta">${qs.length} preguntas · ${sec.time}</div>
      <div class="section-desc">${sec.desc}</div>
      <button class="btn btn-azul" onclick="beginQs()">Comenzar</button>
    </div>`;
  renderHeader();
}

function beginQs(){renderQ();}

function renderQ(){
  const bank=getQBank(ST.puesto);
  const sec=bank.secs[ST.secIdx];
  const qs=bank.q[sec.id];
  const q=qs[ST.qi];
  // Determine question type
  const isLikert=q.tr!==undefined||(q.s&&!q.o&&!q.ch);
  const isChoice=!isLikert;
  const opts=isLikert?LK:(q.o||[]);
  const prog=((ST.qi+1)/qs.length*100).toFixed(1);

  let optsHtml=opts.map((op,i)=>{
    const sel=ST.ans[ST.qi]===i;
    return `<button class="option-btn ${sel?'selected':''}" onclick="pick(${i})">
      ${isChoice?`<span class="option-letter">${String.fromCharCode(65+i)}</span>`:`<span class="option-radio"><span class="option-radio-dot"></span></span>`}
      <span>${op}</span></button>`;
  }).join('');

  $('test-content').innerHTML=`
    <div class="fi" id="q-${ST.qi}">
      <div class="test-header">
        <div style="display:flex;justify-content:space-between;align-items:center;margin-bottom:8px">
          <span class="test-section-name">${sec.name}</span>
          <span class="test-counter">${ST.qi+1}/${qs.length}</span>
        </div>
        <div class="progress-bar"><div class="progress-fill" style="width:${prog}%"></div></div>
      </div>
      <div class="question-card"><p class="question-text">${q.t}</p></div>
      <div>${optsHtml}</div>
      <div class="test-nav">
        <button class="btn btn-outline btn-sm" onclick="prevQ()" ${ST.qi===0?'disabled':''}>← Anterior</button>
        ${ST.ans[ST.qi]!==undefined?`<button class="btn btn-azul btn-sm" onclick="nextQ()">${ST.qi===qs.length-1?'Finalizar →':'Siguiente →'}</button>`:''}
      </div>
    </div>`;
}

function pick(i){ST.ans[ST.qi]=i;const bank=getQBank(ST.puesto);const qs=bank.q[bank.secs[ST.secIdx].id];
  setTimeout(()=>{if(ST.qi<qs.length-1){ST.qi++;renderQ();}else finishSec();},200);renderQ();}
function prevQ(){if(ST.qi>0){ST.qi--;renderQ();}}
function nextQ(){const bank=getQBank(ST.puesto);const qs=bank.q[bank.secs[ST.secIdx].id];
  if(ST.qi<qs.length-1){ST.qi++;renderQ();}else finishSec();}

function finishSec(){
  const bank=getQBank(ST.puesto);
  ST.allAns[bank.secs[ST.secIdx].id]={...ST.ans};
  if(ST.secIdx<bank.secs.length-1){ST.secIdx++;startSection();}
  else submitResults();
}

// ─── SUBMIT ──────────────────────────────────────────────────
async function submitResults(){
  showView('complete');
  $('email-status').className='email-status sending';
  $('email-status').textContent='⏳ Enviando resultados...';

  const scores=scoreAll(ST.puesto,ST.allAns);
  const narr=genNarr(ST.puesto,scores,ST.candidate);
  const dur=Math.round((Date.now()-ST.startTime)/60000);

  try{
    const res=await fetch('api/save_result.php',{method:'POST',headers:{'Content-Type':'application/json'},
      body:JSON.stringify({candidate:ST.candidate,scores,answers:ST.allAns,narrative:narr,puesto_nombre:PUESTO_LABELS[ST.puesto]||'',codigo_id:ST.codigoId,duracion:dur})});
    const data=await res.json();
    if(data.success){
      $('email-status').className='email-status success';
      $('email-status').textContent=data.email_sent?'✓ Resultados enviados a RH.':'✓ Resultados guardados correctamente.';
    }else throw new Error(data.error);
  }catch(e){
    $('email-status').className='email-status error';
    $('email-status').textContent='⚠ Error al guardar. Contacte a RH.';
  }
}

document.addEventListener('DOMContentLoaded',()=>{showView('home');});
