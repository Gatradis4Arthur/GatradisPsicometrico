let adminToken=null,adminResults=[];
const PUESTO_ICONS={transporte:"🚛",operativo:"⚙️",administrativo:"📋",gerencial:"👔"};

async function adminLogin(){const u=$('admin-user').value,p=$('admin-pass').value;$('admin-error').textContent='';
try{const res=await fetch('api/admin_login.php',{method:'POST',headers:{'Content-Type':'application/json'},body:JSON.stringify({username:u,password:p})});const d=await res.json();
if(d.success){adminToken=d.token;showView('admin-dash');adminTab('results');}else $('admin-error').textContent=d.error||'Error';}catch(e){$('admin-error').textContent='Error de conexión';}}

function adminTab(tab){document.querySelectorAll('.admin-tab-content').forEach(el=>el.classList.add('hidden'));document.querySelectorAll('.tab-btn').forEach(el=>el.classList.remove('active'));
$('tab-'+tab)?.classList.remove('hidden');document.querySelector('[data-tab="'+tab+'"]')?.classList.add('active');if(tab==='results')loadResults();if(tab==='codes')loadCodes();}

async function loadResults(filter,puesto){filter=filter||'all';puesto=puesto||'';const params=new URLSearchParams();if(filter!=='all')params.set('filter',filter);if(puesto)params.set('puesto',puesto);
try{const res=await fetch('api/get_results.php?'+params,{headers:{'Authorization':'Bearer '+adminToken}});const d=await res.json();adminResults=d.results||[];renderList(filter,puesto);}catch(e){console.error(e);}}

function renderList(af,ap){af=af||'all';ap=ap||'';const TN={E:"Extraversión",A:"Amabilidad",C:"Responsabilidad",N:"Neuroticismo",O:"Apertura"};
const fs=[{v:'all',l:'Todos'},{v:'APTO',l:'Aptos',c:'grn'},{v:'APTO CON RESERVAS',l:'Reservas',c:'ylw'},{v:'NO APTO',l:'No aptos',c:'red'}];
const ps=[{v:'',l:'Todos'},{v:'transporte',l:'🚛 Transp.'},{v:'operativo',l:'⚙️ Oper.'},{v:'administrativo',l:'📋 Admin.'},{v:'gerencial',l:'👔 Ger.'}];
$('r-filters').innerHTML=fs.map(f=>`<button class="filter-btn ${af===f.v?(f.c?'active-'+f.c:'active'):''}" onclick="loadResults('${f.v}','${ap}')">${f.l}</button>`).join('');
$('r-puesto-filters').innerHTML=ps.map(p=>`<button class="filter-btn ${ap===p.v?'active':''}" onclick="loadResults('${af}','${p.v}')">${p.l}</button>`).join('');
$('r-count').textContent=adminResults.length+' evaluaciones';
if(!adminResults.length){$('r-list').innerHTML='<div class="center" style="padding:40px;color:var(--dm)">Sin evaluaciones</div>';return;}
$('r-list').innerHTML=adminResults.map(r=>{const bc=r.verdict==='APTO'?'badge-apto':r.verdict==='NO APTO'?'badge-no-apto':'badge-reservas';const ic=PUESTO_ICONS[r.puesto_id]||'📋';const f=new Date(r.fecha_evaluacion).toLocaleDateString('es-MX');
return`<div class="result-item" onclick="loadDetail(${r.id})"><div><div style="font-size:13px;font-weight:600">${ic} ${r.nombre} ${r.apellidos}</div><div style="font-size:9px;color:var(--dm);margin-top:2px">${r.puesto_nombre} · ${f}</div></div><span class="badge ${bc}">${r.verdict}</span></div>`;}).join('');}

async function loadDetail(id){try{const res=await fetch('api/get_results.php?id='+id,{headers:{'Authorization':'Bearer '+adminToken}});const d=await res.json();if(d.error){alert(d.error);return;}renderDetail(d);}catch(e){console.error(e);}}

function renderDetail(data){const e=data.evaluacion,c=data.candidato,s=e.scores;const TN={E:"Extraversión",A:"Amabilidad",C:"Responsabilidad",N:"Neuroticismo",O:"Apertura"};
const vc=e.verdict==='APTO'?'apto':e.verdict==='NO APTO'?'no-apto':'reservas';const bc=e.verdict==='APTO'?'badge-apto':e.verdict==='NO APTO'?'badge-no-apto':'badge-reservas';
const bar=(n,v)=>{const cl=v>=75?'grn':v>=55?'ylw':'red';return`<div class="score-row"><div class="score-header"><span class="score-name">${n}</span><span class="score-value">${v}%</span></div><div class="score-bar"><div class="score-fill ${cl}" style="width:${v}%"></div></div></div>`;};
const gauge=(v,l)=>{const c2=v>=78?'var(--grn)':v>=58?'var(--ylw)':'var(--red)';const ci=2*Math.PI*26,off=ci-(v/100)*ci;return`<div style="text-align:center"><svg width="64" height="64" viewBox="0 0 60 60"><circle cx="30" cy="30" r="26" fill="none" stroke="var(--br-l)" stroke-width="3"/><circle cx="30" cy="30" r="26" fill="none" stroke="${c2}" stroke-width="3" stroke-dasharray="${ci}" stroke-dashoffset="${off}" stroke-linecap="round" transform="rotate(-90 30 30)"/><text x="30" y="28" text-anchor="middle" fill="var(--tx)" font-size="12" font-weight="600">${v}</text><text x="30" y="38" text-anchor="middle" fill="var(--dm)" font-size="6">/100</text></svg><div class="gauge-label">${l}</div></div>`;};
const narrB=(t,items,cl)=>!items?.length?'':`<div class="card narr-block"><h4 class="${cl}">${t}</h4>${items.map(a=>`<p class="narr-item ${cl}">${a}</p>`).join('')}</div>`;

let gh='';const sk=Object.keys(s).filter(k=>k!=='personality'&&k!=='corruption');
if(s.corruption?.total!==undefined)gh+=gauge(s.corruption.total,'Anti-Corrup.');
sk.forEach(k=>{if(typeof s[k]==='number')gh+=gauge(s[k],k.charAt(0).toUpperCase()+k.slice(1));});
let ch='';if(s.corruption)ch=`<div class="card"><h4 style="font-size:10px;font-weight:600;color:var(--azul);margin-bottom:10px">Corrupción</h4>${bar('Soborno',s.corruption.soborno||0)}${bar('Crimen',s.corruption.crimen||0)}${bar('Racionalización',s.corruption.racionalizacion||0)}${bar('Historial',s.corruption.historial||0)}</div>`;
let ph='';if(s.personality&&Object.keys(s.personality).length)ph=`<div class="card"><h4 style="font-size:10px;font-weight:600;color:var(--azul);margin-bottom:10px">Personalidad</h4>${Object.entries(s.personality).map(([k,v])=>bar(TN[k]||k,v)).join('')}</div>`;

$('r-list-area').classList.add('hidden');$('r-detail').classList.remove('hidden');
$('r-detail').innerHTML=`<button class="btn-ghost" onclick="backList()">← Volver</button>
<div class="card" style="margin-top:8px"><div style="display:flex;justify-content:space-between;align-items:flex-start;flex-wrap:wrap;gap:8px">
<div><h2 style="font-size:16px;font-weight:600">${c.nombre} ${c.apellidos}</h2><p style="font-size:10px;color:var(--dm);margin-top:3px">${e.puesto} · ${c.edad} años · ${c.telefono}</p>
<p style="font-size:9px;color:var(--dm-l)">${new Date(e.fecha).toLocaleString('es-MX')} · ${e.duracion||'?'} min</p></div>
<span class="badge ${bc}" style="font-size:12px;padding:6px 16px">${e.verdict}</span></div></div>
<div class="email-bar"><span style="font-size:10px;color:var(--dm)">📧</span><input type="email" id="resend-email" class="form-input" value="rh@gatradis.com, direccion@gatradis.org" style="font-size:11px;padding:7px 10px">
<button class="btn btn-azul btn-sm" onclick="resendEmail(${e.id})">Enviar</button></div>
<div class="verdict-box ${vc}"><div class="verdict-title" style="color:${e.verdict==='APTO'?'var(--grn)':e.verdict==='NO APTO'?'var(--red)':'var(--ylw)'}">${e.verdict}</div><p class="verdict-text">${e.verdict_detail}</p></div>
${narrB('Fortalezas',e.strengths,'grn')}${narrB('No aptitud',e.weaknesses,'red')}${narrB('Atención',e.warnings,'ylw')}
<div class="card"><div class="gauges">${gh}</div></div>${ch}${ph}`;}

function backList(){$('r-detail').classList.add('hidden');$('r-detail').innerHTML='';$('r-list-area').classList.remove('hidden');}
async function resendEmail(id){try{const res=await fetch('api/resend_email.php',{method:'POST',headers:{'Content-Type':'application/json'},body:JSON.stringify({evaluacion_id:id,email:$('resend-email')?.value||''})});const d=await res.json();alert(d.success?'Enviado: '+d.sent_to:'Error');}catch(e){alert('Error');}}

async function loadCodes(){try{const res=await fetch('api/get_results.php?action=codes',{headers:{'Authorization':'Bearer '+adminToken}});const d=await res.json();renderCodes(d.codes||[]);}catch(e){console.error(e);}}
function renderCodes(codes){const un=codes.filter(c=>!c.usado),us=codes.filter(c=>c.usado);
$('codes-list').innerHTML=`<h4 style="font-size:12px;color:var(--azul);margin-bottom:8px">Activos (${un.length})</h4>
${un.length?un.map(c=>`<div class="result-item" style="cursor:default"><div><div style="font-size:14px;font-weight:700;font-family:'JetBrains Mono';letter-spacing:2px">${c.codigo}</div>
<div style="font-size:9px;color:var(--dm)">${c.puesto_nombre} · Exp: ${c.fecha_expiracion?new Date(c.fecha_expiracion).toLocaleDateString('es-MX'):'N/A'}</div></div>
<button class="btn btn-outline btn-sm" onclick="navigator.clipboard?.writeText('${c.codigo}');this.textContent='✓'">Copiar</button></div>`).join(''):'<p style="font-size:11px;color:var(--dm);padding:16px">Sin códigos activos</p>'}
${us.length?`<h4 style="font-size:11px;color:var(--dm);margin:12px 0 6px">Usados (${us.length})</h4>${us.slice(0,15).map(c=>`<div style="font-size:9px;color:var(--dm-l);padding:3px 0">${c.codigo} — ${c.puesto_nombre} — ${new Date(c.fecha_uso||c.fecha_creacion).toLocaleDateString('es-MX')}</div>`).join('')}`:''}`;}
async function generateCodes(){const p=$('gen-puesto').value,n=parseInt($('gen-cantidad').value)||5,e=parseInt($('gen-exp').value)||30;
try{const res=await fetch('api/save_result.php?action=generate_codes',{method:'POST',headers:{'Content-Type':'application/json'},body:JSON.stringify({puesto_id:p,cantidad:n,expiracion_dias:e,notas:$('gen-notas')?.value||''})});
const d=await res.json();if(d.success){alert(d.codes.length+' códigos generados:\n\n'+d.codes.join('\n'));loadCodes();}else alert(d.error||'Error');}catch(e){alert('Error');}}
function adminLogout(){adminToken=null;showView('home');}
