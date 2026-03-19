-- ═══════════════════════════════════════════════════════════════════════════════
--  SISTEMA DE EVALUACIONES PSICOMÉTRICAS
--  Motor: MariaDB 10.5+
--  Codificación: utf8mb4
--  Autor: generado automáticamente
-- ═══════════════════════════════════════════════════════════════════════════════

CREATE DATABASE IF NOT EXISTS psicometria
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;

USE psicometria;

SET FOREIGN_KEY_CHECKS = 0;
SET SQL_MODE = 'STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,ERROR_FOR_DIVISION_BY_ZERO';

-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
--  BLOQUE 1 ▸ USUARIOS DEL SISTEMA (administradores / reclutadores)
-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

CREATE TABLE users (
    id            INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    full_name     VARCHAR(150)        NOT NULL,
    email         VARCHAR(150)        NOT NULL UNIQUE,
    password_hash VARCHAR(255)        NOT NULL,
    role          ENUM('admin','recruiter','viewer') NOT NULL DEFAULT 'recruiter',
    is_active     TINYINT(1)          NOT NULL DEFAULT 1,
    created_at    TIMESTAMP           NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at    TIMESTAMP           NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB COMMENT='Usuarios internos del sistema (reclutadores / administradores)';

-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
--  BLOQUE 2 ▸ CANDIDATOS (personas que responden la evaluación)
-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

CREATE TABLE candidates (
    id            INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    full_name     VARCHAR(200)        NOT NULL,
    email         VARCHAR(150)        NOT NULL,
    phone         VARCHAR(20)         NULL,
    position      VARCHAR(150)        NULL  COMMENT 'Puesto al que aplica',
    notes         TEXT                NULL  COMMENT 'Observaciones del reclutador',
    created_by    INT UNSIGNED        NULL  COMMENT 'Usuario que registró al candidato',
    created_at    TIMESTAMP           NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at    TIMESTAMP           NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (created_by) REFERENCES users(id) ON DELETE SET NULL
) ENGINE=InnoDB COMMENT='Candidatos que realizan las evaluaciones psicométricas';

-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
--  BLOQUE 3 ▸ CATÁLOGO DE BATERÍAS
-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

CREATE TABLE battery_types (
    id          TINYINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    code        VARCHAR(20)         NOT NULL UNIQUE COMMENT 'ADM | GER | OPR | TRP',
    name        VARCHAR(120)        NOT NULL,
    description TEXT                NULL,
    created_at  TIMESTAMP           NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB COMMENT='Tipos de batería: Administrativo, Gerencial, Operativo, Transporte';

-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
--  BLOQUE 4 ▸ SECCIONES / SUB-TESTS
-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

CREATE TABLE battery_sections (
    id              SMALLINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    battery_type_id TINYINT UNSIGNED    NOT NULL,
    code            VARCHAR(40)         NOT NULL COMMENT 'Clave JS: reasoning_adm, admin_apt, …',
    name            VARCHAR(120)        NOT NULL,
    time_minutes    TINYINT UNSIGNED    NOT NULL DEFAULT 5,
    description     TEXT                NULL,
    sort_order      TINYINT UNSIGNED    NOT NULL DEFAULT 0,
    UNIQUE KEY uq_section (battery_type_id, code),
    FOREIGN KEY (battery_type_id) REFERENCES battery_types(id)
) ENGINE=InnoDB COMMENT='Secciones / sub-tests dentro de cada batería';

-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
--  BLOQUE 5 ▸ PREGUNTAS
--
--  question_type:
--    MC   = Multiple Choice clásica (opciones con score numérico)
--    LK   = Likert  (escala 5 pts, el score array está en la tabla de opciones)
--    BF   = Big Five / Personalidad (Likert con rasgo + dirección)
--    BOOL = Sí/No con score
-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

CREATE TABLE questions (
    id              INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    section_id      SMALLINT UNSIGNED   NOT NULL,
    question_type   ENUM('MC','LK','BF') NOT NULL DEFAULT 'MC'
                    COMMENT 'MC=Multiple Choice, LK=Likert, BF=Big Five',
    sort_order      SMALLINT UNSIGNED   NOT NULL DEFAULT 0,
    text            TEXT                NOT NULL COMMENT 'Enunciado de la pregunta',
    -- Sólo para preguntas BF (Big Five)
    trait           CHAR(1)             NULL COMMENT 'C=Conscientiousness E=Extraversion O=Openness A=Agreeableness N=Neuroticism',
    direction       TINYINT(1)          NULL COMMENT '1=positivo -1=inverso (para BF)',
    -- Sólo para sección corruption de Transporte
    corruption_cat  VARCHAR(10)         NULL COMMENT 'sob|cri|rac|his',
    has_check       TINYINT(1)          NOT NULL DEFAULT 0 COMMENT '1=pregunta de verificación (ch:true)',
    created_at      TIMESTAMP           NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (section_id) REFERENCES battery_sections(id)
) ENGINE=InnoDB COMMENT='Preguntas de todas las baterías';

-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
--  BLOQUE 6 ▸ OPCIONES DE RESPUESTA
--
--  Para MC: texto de la opción + score
--  Para LK: texto de nivel ("Totalmente de acuerdo"…) + score
--  Para BF: los niveles del Likert también se almacenan aquí (score 1-5)
-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

CREATE TABLE question_options (
    id          INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    question_id INT UNSIGNED        NOT NULL,
    sort_order  TINYINT UNSIGNED    NOT NULL DEFAULT 0 COMMENT 'Posición de la opción (0-based)',
    text        VARCHAR(400)        NOT NULL COMMENT 'Texto visible de la opción',
    score       TINYINT             NOT NULL DEFAULT 0 COMMENT 'Puntos que otorga esta opción',
    FOREIGN KEY (question_id) REFERENCES questions(id) ON DELETE CASCADE
) ENGINE=InnoDB COMMENT='Opciones de respuesta y su puntuación';

-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
--  BLOQUE 7 ▸ SESIONES DE EVALUACIÓN
--
--  Una sesión vincula un candidato con una batería en un momento dado.
--  status: pending | in_progress | completed | expired
-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

CREATE TABLE evaluation_sessions (
    id              INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    candidate_id    INT UNSIGNED        NOT NULL,
    battery_type_id TINYINT UNSIGNED    NOT NULL,
    assigned_by     INT UNSIGNED        NULL COMMENT 'Usuario que asignó la batería',
    token           VARCHAR(80)         NOT NULL UNIQUE COMMENT 'Token único para acceso del candidato',
    status          ENUM('pending','in_progress','completed','expired')
                    NOT NULL DEFAULT 'pending',
    started_at      DATETIME            NULL,
    completed_at    DATETIME            NULL,
    expires_at      DATETIME            NULL COMMENT 'Fecha límite para completar',
    created_at      TIMESTAMP           NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (candidate_id)    REFERENCES candidates(id),
    FOREIGN KEY (battery_type_id) REFERENCES battery_types(id),
    FOREIGN KEY (assigned_by)     REFERENCES users(id) ON DELETE SET NULL
) ENGINE=InnoDB COMMENT='Sesión de evaluación de un candidato para una batería específica';

-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
--  BLOQUE 8 ▸ RESPUESTAS DEL CANDIDATO
-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

CREATE TABLE candidate_answers (
    id              BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    session_id      INT UNSIGNED        NOT NULL,
    question_id     INT UNSIGNED        NOT NULL,
    option_id       INT UNSIGNED        NULL  COMMENT 'NULL si la pregunta es numérica directa',
    score_obtained  TINYINT             NOT NULL DEFAULT 0 COMMENT 'Score copiado al momento de responder',
    answered_at     DATETIME            NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UNIQUE KEY uq_answer (session_id, question_id),
    FOREIGN KEY (session_id)  REFERENCES evaluation_sessions(id) ON DELETE CASCADE,
    FOREIGN KEY (question_id) REFERENCES questions(id),
    FOREIGN KEY (option_id)   REFERENCES question_options(id) ON DELETE SET NULL
) ENGINE=InnoDB COMMENT='Respuestas individuales de cada candidato por sesión';

-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
--  BLOQUE 9 ▸ RESULTADOS POR SECCIÓN
--
--  Resumen calculado por sección al terminar la evaluación.
-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

CREATE TABLE section_results (
    id              INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    session_id      INT UNSIGNED        NOT NULL,
    section_id      SMALLINT UNSIGNED   NOT NULL,
    raw_score       DECIMAL(8,2)        NOT NULL DEFAULT 0 COMMENT 'Suma de scores obtenidos',
    max_score       DECIMAL(8,2)        NOT NULL DEFAULT 0 COMMENT 'Suma de scores máximos posibles',
    percentage      DECIMAL(5,2)        NOT NULL DEFAULT 0 COMMENT 'raw_score / max_score * 100',
    level           ENUM('Bajo','Medio-Bajo','Medio','Medio-Alto','Alto') NULL,
    UNIQUE KEY uq_result (session_id, section_id),
    FOREIGN KEY (session_id) REFERENCES evaluation_sessions(id) ON DELETE CASCADE,
    FOREIGN KEY (section_id) REFERENCES battery_sections(id)
) ENGINE=InnoDB COMMENT='Puntaje por sección calculado al finalizar la sesión';

-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
--  BLOQUE 10 ▸ RESULTADO GLOBAL / REPORTE FINAL
-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

CREATE TABLE evaluation_results (
    id                  INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    session_id          INT UNSIGNED        NOT NULL UNIQUE,
    total_raw_score     DECIMAL(8,2)        NOT NULL DEFAULT 0,
    total_max_score     DECIMAL(8,2)        NOT NULL DEFAULT 0,
    total_percentage    DECIMAL(5,2)        NOT NULL DEFAULT 0,
    overall_level       ENUM('Bajo','Medio-Bajo','Medio','Medio-Alto','Alto') NULL,
    -- Big Five scores (sólo para baterías que incluyen sección BF)
    bf_conscientiousness    DECIMAL(5,2)    NULL,
    bf_extraversion         DECIMAL(5,2)    NULL,
    bf_openness             DECIMAL(5,2)    NULL,
    bf_agreeableness        DECIMAL(5,2)    NULL,
    bf_neuroticism          DECIMAL(5,2)    NULL,
    -- Score de corrupción (sólo batería Transporte)
    corruption_score        DECIMAL(5,2)    NULL,
    -- Notas del evaluador
    evaluator_notes     TEXT                NULL,
    recommendation      ENUM('Recomendado','Recomendado con reservas','No recomendado') NULL,
    reviewed_by         INT UNSIGNED        NULL,
    reviewed_at         DATETIME            NULL,
    generated_at        TIMESTAMP           NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (session_id)  REFERENCES evaluation_sessions(id) ON DELETE CASCADE,
    FOREIGN KEY (reviewed_by) REFERENCES users(id) ON DELETE SET NULL
) ENGINE=InnoDB COMMENT='Resultado global consolidado de cada sesión de evaluación';

SET FOREIGN_KEY_CHECKS = 1;

-- ═══════════════════════════════════════════════════════════════════════════════
--  BLOQUE 11 ▸ DATOS SEMILLA — TIPOS DE BATERÍA
-- ═══════════════════════════════════════════════════════════════════════════════

INSERT INTO battery_types (id, code, name, description) VALUES
(1, 'ADM', 'Puestos Administrativos',
 'Batería para evaluar personal administrativo: Razonamiento Analítico, Aptitudes Administrativas, Personalidad Laboral, Inteligencia Emocional y Estilo de Trabajo.'),
(2, 'GER', 'Puestos Gerenciales',
 'Batería para evaluar nivel gerencial: Razonamiento Estratégico, Liderazgo, Perfil Directivo, Inteligencia Emocional y Toma de Decisiones.'),
(3, 'OPR', 'Puestos Operativos',
 'Batería para personal operativo: Atención y Concentración, Razonamiento Lógico, Personalidad Laboral, Honestidad e Integridad y Trabajo Bajo Presión.'),
(4, 'TRP', 'Transporte de Material Peligroso',
 'Batería especializada para operadores de autotanque: Personalidad, Integridad, Resistencia a Corrupción, Manejo de Estrés, Juicio Técnico y Confiabilidad Operativa.');

-- ═══════════════════════════════════════════════════════════════════════════════
--  BLOQUE 12 ▸ DATOS SEMILLA — SECCIONES
-- ═══════════════════════════════════════════════════════════════════════════════

INSERT INTO battery_sections (id, battery_type_id, code, name, time_minutes, description, sort_order) VALUES
-- ── Administrativo ──────────────────────────────────────────────────────────
(1,  1, 'reasoning_adm', 'Razonamiento Analítico',          6, 'Evalúa capacidad de análisis y resolución de problemas.',                                       1),
(2,  1, 'admin_apt',     'Aptitudes Administrativas',        6, 'Evalúa organización, planeación y manejo de información.',                                      2),
(3,  1, 'personality_adm','Personalidad Laboral',            5, 'Indique qué tan de acuerdo está con cada afirmación.',                                          3),
(4,  1, 'emotional_iq',  'Inteligencia Emocional',           6, 'Evalúa manejo de emociones y relaciones interpersonales.',                                      4),
(5,  1, 'work_style',    'Estilo de Trabajo',                5, 'Sobre su compromiso, organización y manejo del tiempo.',                                        5),
-- ── Gerencial ───────────────────────────────────────────────────────────────
(6,  2, 'reasoning_ger', 'Razonamiento Estratégico',         7, 'Evalúa capacidad analítica y resolución de problemas complejos.',                               1),
(7,  2, 'leadership',    'Estilo de Liderazgo',              7, 'Evalúa su capacidad para dirigir equipos e influir positivamente.',                             2),
(8,  2, 'personality_ger','Perfil Directivo',                6, 'Indique qué tan de acuerdo está con cada afirmación.',                                          3),
(9,  2, 'emotional_ger', 'Inteligencia Emocional',           6, 'Evalúa manejo de emociones propias y de equipos.',                                              4),
(10, 2, 'decisions',     'Toma de Decisiones',               7, 'Seleccione la mejor decisión ante cada escenario gerencial.',                                   5),
-- ── Operativo ───────────────────────────────────────────────────────────────
(11, 3, 'attention',     'Atención y Concentración',         5, 'Evalúa su capacidad de atención sostenida y precisión.',                                        1),
(12, 3, 'reasoning',     'Razonamiento Lógico',              5, 'Identifique patrones y resuelva las secuencias presentadas.',                                   2),
(13, 3, 'personality_op','Personalidad Laboral',             5, 'Indique qué tan de acuerdo está con cada afirmación.',                                          3),
(14, 3, 'honesty',       'Honestidad e Integridad',          5, 'Evalúe cada situación con total honestidad.',                                                   4),
(15, 3, 'pressure',      'Trabajo Bajo Presión',             5, 'Seleccione cómo reaccionaría ante cada situación.',                                             5),
-- ── Transporte ──────────────────────────────────────────────────────────────
(16, 4, 'personality',   'Personalidad (Big Five)',          5, 'Indique qué tan de acuerdo está con cada afirmación.',                                          1),
(17, 4, 'integrity',     'Integridad y Honestidad',          4, 'Evalúe cada situación con honestidad.',                                                         2),
(18, 4, 'corruption',    'Resistencia a Corrupción',         7, 'Evalúa resistencia ante presión indebida, soborno y actividades ilícitas.',                     3),
(19, 4, 'stress',        'Manejo de Estrés',                 4, 'Seleccione cómo reaccionaría ante cada escenario.',                                             4),
(20, 4, 'situational',   'Juicio Técnico',                   5, 'Procedimientos y normatividad de transporte de hidrocarburos.',                                 5),
(21, 4, 'reliability',   'Confiabilidad Operativa',          3, 'Sobre su comportamiento habitual en el trabajo.',                                               6);

-- ═══════════════════════════════════════════════════════════════════════════════
--  BLOQUE 13 ▸ PREGUNTAS E OPCIONES
--
--  Convenciones:
--   • MC  → text de pregunta + opciones (o) con scores (s)
--   • LK  → escala 1-5 ("Totalmente de acuerdo" … "Totalmente en desacuerdo")
--   • BF  → Likert con trait + direction
-- ═══════════════════════════════════════════════════════════════════════════════

-- ───────────────────────────────────────────────────────────────────────────
--  SEC 1 | reasoning_adm | Razonamiento Analítico (ADM)
-- ───────────────────────────────────────────────────────────────────────────
INSERT INTO questions (id, section_id, question_type, sort_order, text) VALUES
(1,  1, 'MC', 1,  'Serie: 2, 6, 18, 54, __'),
(2,  1, 'MC', 2,  'Si el presupuesto de un proyecto es $100,000 y se ha gastado el 35%, ¿cuánto queda disponible?'),
(3,  1, 'MC', 3,  '\"Todo reporte debe ser revisado antes de enviarse. Juan envió un reporte.\" Entonces:'),
(4,  1, 'MC', 4,  'Si 4 personas completan un informe en 8 horas, ¿cuánto tardarán 8 personas?'),
(5,  1, 'MC', 5,  'Serie: A2, C4, E6, G8, __'),
(6,  1, 'MC', 6,  'Un departamento tiene 12 empleados. Si 25% está de vacaciones y 1/3 del resto en capacitación, ¿cuántos trabajan normalmente?'),
(7,  1, 'MC', 7,  '¿Cuál NO pertenece? Excel, Word, Chrome, PowerPoint'),
(8,  1, 'MC', 8,  'Si un proceso tiene 5 pasos y cada paso toma 15 minutos, pero los pasos 2 y 3 pueden hacerse simultáneamente, ¿cuánto toma todo?'),
(9,  1, 'MC', 9,  'Serie: 100, 95, 85, 70, __'),
(10, 1, 'MC', 10, 'En una base de datos de 1,000 registros, el 3% tiene errores. Si corriges 20 errores, ¿cuántos quedan?');

INSERT INTO question_options (question_id, sort_order, text, score) VALUES
(1,0,'108',1),(1,1,'162',5),(1,2,'72',1),(1,3,'96',1),
(2,0,'$55,000',1),(2,1,'$65,000',5),(2,2,'$75,000',1),(2,3,'$45,000',1),
(3,0,'Juan revisó su reporte',1),(3,1,'El reporte debió ser revisado',5),(3,2,'Juan no envió nada',1),(3,3,'No se puede saber',1),
(4,0,'16 horas',1),(4,1,'4 horas',5),(4,2,'6 horas',1),(4,3,'2 horas',1),
(5,0,'H10',2),(5,1,'I10',5),(5,2,'J12',1),(5,3,'I9',1),
(6,0,'4',1),(6,1,'5',1),(6,2,'6',5),(6,3,'8',1),
(7,0,'Excel',1),(7,1,'Word',1),(7,2,'Chrome',5),(7,3,'PowerPoint',1),
(8,0,'75 min',1),(8,1,'60 min',5),(8,2,'45 min',1),(8,3,'50 min',1),
(9,0,'60',1),(9,1,'55',1),(9,2,'50',5),(9,3,'45',1),
(10,0,'30',1),(10,1,'10',5),(10,2,'15',1),(10,3,'5',1);

-- ───────────────────────────────────────────────────────────────────────────
--  SEC 2 | admin_apt | Aptitudes Administrativas (ADM)
-- ───────────────────────────────────────────────────────────────────────────
INSERT INTO questions (id, section_id, question_type, sort_order, text) VALUES
(11, 2, 'MC', 1, 'Al organizar archivos, lo más efectivo es:'),
(12, 2, 'MC', 2, 'Para dar seguimiento a 15 pendientes con diferentes fechas de entrega, usarías:'),
(13, 2, 'MC', 3, 'Recibes un correo con instrucciones confusas de tu director. Lo mejor es:'),
(14, 2, 'MC', 4, 'Un proveedor te envía una factura con un monto diferente al cotizado. ¿Qué haces?'),
(15, 2, 'MC', 5, '¿Cuál es la mejor forma de preparar una reunión importante?'),
(16, 2, 'MC', 6, 'Si dos tareas urgentes tienen la misma fecha límite, priorizas por:'),
(17, 2, 'MC', 7, 'Un compañero te pide ayuda con un reporte pero tienes tus propios pendientes.'),
(18, 2, 'MC', 8, 'Encuentras un error en un reporte que ya fue enviado a dirección.');

INSERT INTO question_options (question_id, sort_order, text, score) VALUES
(11,0,'Apilarlos por fecha de llegada',2),(11,1,'Clasificarlos por categoría con nomenclatura estandarizada',5),(11,2,'Guardarlos como vayan llegando',1),(11,3,'Memorizar dónde está cada uno',1),
(12,0,'Memoria',1),(12,1,'Lista priorizada con fechas y estatus',5),(12,2,'Notas en papeles sueltos',1),(12,3,'Le pregunto a mi jefe cada mañana',1),
(13,0,'Hacer lo que entendí',1),(13,1,'Pedir aclaración antes de empezar',5),(13,2,'Ignorar el correo',1),(13,3,'Preguntarle a un compañero qué cree que dice',2),
(14,0,'La pago como está',1),(14,1,'Verifico contra la cotización y notifico la discrepancia',5),(14,2,'La rechazo sin explicación',1),(14,3,'Espero a que alguien más la revise',1),
(15,0,'Improvisar según el momento',1),(15,1,'Definir agenda, preparar información y enviarla previamente',5),(15,2,'Esperar a que el jefe diga qué hacer',1),(15,3,'Llevar notas generales',2),
(16,0,'La que me gusta más',1),(16,1,'Impacto en la operación y necesidades del área',5),(16,2,'La más fácil primero',1),(16,3,'La que me pidió mi jefe directo solamente',2),
(17,0,'Lo ayudo y dejo mis pendientes',1),(17,1,'Evalúo mi carga, y si puedo le ayudo; si no, le sugiero alternativa',5),(17,2,'Le digo que no sin explicar',1),(17,3,'Hago su trabajo mal para que no me vuelva a pedir',1),
(18,0,'No digo nada, ya se envió',1),(18,1,'Notifico el error, corrijo y reenvío la versión corregida',5),(18,2,'Espero a que alguien lo note',1),(18,3,'Le echo la culpa al sistema',1);

-- ───────────────────────────────────────────────────────────────────────────
--  SEC 3 | personality_adm | Big Five Administrativo (ADM)
-- ───────────────────────────────────────────────────────────────────────────
INSERT INTO questions (id, section_id, question_type, sort_order, text, trait, direction) VALUES
(19, 3, 'BF', 1,  'Me considero una persona organizada en mi trabajo y vida personal.', 'C', 1),
(20, 3, 'BF', 2,  'Disfruto trabajar en equipo más que de forma individual.', 'E', 1),
(21, 3, 'BF', 3,  'Me adapto fácilmente a nuevos sistemas o formas de trabajo.', 'O', 1),
(22, 3, 'BF', 4,  'Cuando algo me molesta en el trabajo, tiendo a guardármelo.', 'N', 1),
(23, 3, 'BF', 5,  'Me gusta proponer ideas y mejoras en los procesos.', 'O', 1),
(24, 3, 'BF', 6,  'Soy de las personas que siempre entrega a tiempo o antes.', 'C', 1),
(25, 3, 'BF', 7,  'Me cuesta delegar tareas porque prefiero hacerlas yo.', 'E', -1),
(26, 3, 'BF', 8,  'Mantengo la calma cuando hay cambios de última hora.', 'N', -1),
(27, 3, 'BF', 9,  'Me resulta fácil comunicar mis ideas de forma clara.', 'E', 1),
(28, 3, 'BF', 10, 'Reviso mi trabajo varias veces antes de entregarlo.', 'C', 1),
(29, 3, 'BF', 11, 'Los conflictos entre compañeros me generan mucha ansiedad.', 'N', 1),
(30, 3, 'BF', 12, 'Me interesa aprender habilidades nuevas aunque no sean de mi área.', 'O', 1);

-- Opciones Likert 1–5 para preguntas BF (direction=1): reutilizamos la misma escala
INSERT INTO question_options (question_id, sort_order, text, score) VALUES
-- Q19
(19,0,'Totalmente de acuerdo',5),(19,1,'De acuerdo',4),(19,2,'Neutral',3),(19,3,'En desacuerdo',2),(19,4,'Totalmente en desacuerdo',1),
-- Q20
(20,0,'Totalmente de acuerdo',5),(20,1,'De acuerdo',4),(20,2,'Neutral',3),(20,3,'En desacuerdo',2),(20,4,'Totalmente en desacuerdo',1),
-- Q21
(21,0,'Totalmente de acuerdo',5),(21,1,'De acuerdo',4),(21,2,'Neutral',3),(21,3,'En desacuerdo',2),(21,4,'Totalmente en desacuerdo',1),
-- Q22 (direction=1 → ansiedad/neurotic positiva)
(22,0,'Totalmente de acuerdo',5),(22,1,'De acuerdo',4),(22,2,'Neutral',3),(22,3,'En desacuerdo',2),(22,4,'Totalmente en desacuerdo',1),
-- Q23
(23,0,'Totalmente de acuerdo',5),(23,1,'De acuerdo',4),(23,2,'Neutral',3),(23,3,'En desacuerdo',2),(23,4,'Totalmente en desacuerdo',1),
-- Q24
(24,0,'Totalmente de acuerdo',5),(24,1,'De acuerdo',4),(24,2,'Neutral',3),(24,3,'En desacuerdo',2),(24,4,'Totalmente en desacuerdo',1),
-- Q25 (direction=-1 → score invertido en cálculo)
(25,0,'Totalmente de acuerdo',1),(25,1,'De acuerdo',2),(25,2,'Neutral',3),(25,3,'En desacuerdo',4),(25,4,'Totalmente en desacuerdo',5),
-- Q26 (direction=-1)
(26,0,'Totalmente de acuerdo',1),(26,1,'De acuerdo',2),(26,2,'Neutral',3),(26,3,'En desacuerdo',4),(26,4,'Totalmente en desacuerdo',5),
-- Q27
(27,0,'Totalmente de acuerdo',5),(27,1,'De acuerdo',4),(27,2,'Neutral',3),(27,3,'En desacuerdo',2),(27,4,'Totalmente en desacuerdo',1),
-- Q28
(28,0,'Totalmente de acuerdo',5),(28,1,'De acuerdo',4),(28,2,'Neutral',3),(28,3,'En desacuerdo',2),(28,4,'Totalmente en desacuerdo',1),
-- Q29 (direction=1 → neurotic)
(29,0,'Totalmente de acuerdo',5),(29,1,'De acuerdo',4),(29,2,'Neutral',3),(29,3,'En desacuerdo',2),(29,4,'Totalmente en desacuerdo',1),
-- Q30
(30,0,'Totalmente de acuerdo',5),(30,1,'De acuerdo',4),(30,2,'Neutral',3),(30,3,'En desacuerdo',2),(30,4,'Totalmente en desacuerdo',1);

-- ───────────────────────────────────────────────────────────────────────────
--  SEC 4 | emotional_iq | Inteligencia Emocional (ADM)
--  Preguntas 31-33 = MC  /  34-40 = Likert
-- ───────────────────────────────────────────────────────────────────────────
INSERT INTO questions (id, section_id, question_type, sort_order, text) VALUES
(31, 4, 'MC', 1, 'Un compañero está visiblemente frustrado por una tarea. Lo mejor es:'),
(32, 4, 'MC', 2, 'Tu jefe critica tu trabajo en una junta. Tu primera reacción debería ser:'),
(33, 4, 'MC', 3, 'Dos compañeros de tu equipo tienen un conflicto que afecta el trabajo.'),
(34, 4, 'LK', 4, 'Identifico cuándo mis emociones pueden afectar mis decisiones laborales.'),
(35, 4, 'LK', 5, 'Puedo mantener una actitud positiva aunque tenga problemas personales.'),
(36, 4, 'LK', 6, 'Me resulta fácil entender el punto de vista de personas con opiniones diferentes a las mías.'),
(37, 4, 'LK', 7, 'Cuando cometo un error, lo reconozco sin culpar a otros.'),
(38, 4, 'LK', 8, 'Sé manejar la frustración cuando un proyecto no sale como esperaba.'),
(39, 4, 'LK', 9, 'Puedo dar retroalimentación difícil a un compañero sin ofenderlo.'),
(40, 4, 'LK', 10,'Me considero bueno para motivar a otros en momentos difíciles.');

INSERT INTO question_options (question_id, sort_order, text, score) VALUES
(31,0,'Ignorarlo, es su problema',1),(31,1,'Preguntarle si necesita ayuda y escucharlo',5),(31,2,'Decirle que se calme',1),(31,3,'Reportarlo a RH por inestable',1),
(32,0,'Defenderme agresivamente',1),(32,1,'Escuchar con apertura y pedir ejemplos específicos',5),(32,2,'Quedarme callado y resentido',1),(32,3,'Llorar o salir de la sala',1),
(33,0,'No me meto',1),(33,1,'Facilito una conversación para que lleguen a un acuerdo',5),(33,2,'Tomo partido por uno',1),(33,3,'Lo reporto sin intentar resolver',2),
-- Likert 5-1 (positivo)
(34,0,'Totalmente de acuerdo',5),(34,1,'De acuerdo',4),(34,2,'Neutral',3),(34,3,'En desacuerdo',2),(34,4,'Totalmente en desacuerdo',1),
(35,0,'Totalmente de acuerdo',5),(35,1,'De acuerdo',4),(35,2,'Neutral',3),(35,3,'En desacuerdo',2),(35,4,'Totalmente en desacuerdo',1),
(36,0,'Totalmente de acuerdo',5),(36,1,'De acuerdo',4),(36,2,'Neutral',3),(36,3,'En desacuerdo',2),(36,4,'Totalmente en desacuerdo',1),
(37,0,'Totalmente de acuerdo',5),(37,1,'De acuerdo',4),(37,2,'Neutral',3),(37,3,'En desacuerdo',2),(37,4,'Totalmente en desacuerdo',1),
(38,0,'Totalmente de acuerdo',5),(38,1,'De acuerdo',4),(38,2,'Neutral',3),(38,3,'En desacuerdo',2),(38,4,'Totalmente en desacuerdo',1),
(39,0,'Totalmente de acuerdo',5),(39,1,'De acuerdo',4),(39,2,'Neutral',3),(39,3,'En desacuerdo',2),(39,4,'Totalmente en desacuerdo',1),
(40,0,'Totalmente de acuerdo',5),(40,1,'De acuerdo',4),(40,2,'Neutral',3),(40,3,'En desacuerdo',2),(40,4,'Totalmente en desacuerdo',1);

-- ───────────────────────────────────────────────────────────────────────────
--  SEC 5 | work_style | Estilo de Trabajo (ADM) — Likert
-- ───────────────────────────────────────────────────────────────────────────
INSERT INTO questions (id, section_id, question_type, sort_order, text) VALUES
(41, 5, 'LK', 1,  'Planifico mi semana laboral con anticipación.'),
(42, 5, 'LK', 2,  'Suelo dejar las tareas difíciles para el final.'),
(43, 5, 'LK', 3,  'Manejo múltiples tareas simultáneamente de forma efectiva.'),
(44, 5, 'LK', 4,  'Reviso periódicamente el avance de mis objetivos.'),
(45, 5, 'LK', 5,  'Me cuesta llegar puntual a reuniones o compromisos.'),
(46, 5, 'LK', 6,  'Busco formas de hacer mi trabajo más eficiente.'),
(47, 5, 'LK', 7,  'Cuando termino mis tareas, busco en qué más apoyar.'),
(48, 5, 'LK', 8,  'Necesito que me supervisen constantemente para cumplir.'),
(49, 5, 'LK', 9,  'Documento mis procesos para que otros puedan replicarlos.'),
(50, 5, 'LK', 10, 'Mi compromiso con la empresa va más allá de mi horario laboral.');

INSERT INTO question_options (question_id, sort_order, text, score) VALUES
-- Q41 positivo (5,4,3,2,1)
(41,0,'Totalmente de acuerdo',5),(41,1,'De acuerdo',4),(41,2,'Neutral',3),(41,3,'En desacuerdo',2),(41,4,'Totalmente en desacuerdo',1),
-- Q42 inverso (1,2,3,4,5)
(42,0,'Totalmente de acuerdo',1),(42,1,'De acuerdo',2),(42,2,'Neutral',3),(42,3,'En desacuerdo',4),(42,4,'Totalmente en desacuerdo',5),
(43,0,'Totalmente de acuerdo',5),(43,1,'De acuerdo',4),(43,2,'Neutral',3),(43,3,'En desacuerdo',2),(43,4,'Totalmente en desacuerdo',1),
(44,0,'Totalmente de acuerdo',5),(44,1,'De acuerdo',4),(44,2,'Neutral',3),(44,3,'En desacuerdo',2),(44,4,'Totalmente en desacuerdo',1),
-- Q45 inverso
(45,0,'Totalmente de acuerdo',1),(45,1,'De acuerdo',2),(45,2,'Neutral',3),(45,3,'En desacuerdo',4),(45,4,'Totalmente en desacuerdo',5),
(46,0,'Totalmente de acuerdo',5),(46,1,'De acuerdo',4),(46,2,'Neutral',3),(46,3,'En desacuerdo',2),(46,4,'Totalmente en desacuerdo',1),
(47,0,'Totalmente de acuerdo',5),(47,1,'De acuerdo',4),(47,2,'Neutral',3),(47,3,'En desacuerdo',2),(47,4,'Totalmente en desacuerdo',1),
-- Q48 inverso
(48,0,'Totalmente de acuerdo',1),(48,1,'De acuerdo',2),(48,2,'Neutral',3),(48,3,'En desacuerdo',4),(48,4,'Totalmente en desacuerdo',5),
(49,0,'Totalmente de acuerdo',5),(49,1,'De acuerdo',4),(49,2,'Neutral',3),(49,3,'En desacuerdo',2),(49,4,'Totalmente en desacuerdo',1),
(50,0,'Totalmente de acuerdo',5),(50,1,'De acuerdo',4),(50,2,'Neutral',3),(50,3,'En desacuerdo',2),(50,4,'Totalmente en desacuerdo',1);

-- ───────────────────────────────────────────────────────────────────────────
--  SEC 6 | reasoning_ger | Razonamiento Estratégico (GER)
-- ───────────────────────────────────────────────────────────────────────────
INSERT INTO questions (id, section_id, question_type, sort_order, text) VALUES
(51, 6, 'MC', 1,  'Una empresa tiene 3 líneas de negocio. La línea A genera 40% de ingresos con 60% de costos, B genera 35% con 25%, C genera 25% con 15%. ¿Cuál es más rentable?'),
(52, 6, 'MC', 2,  'Si la rotación de personal cuesta 3 meses de salario por empleado y tienes 20% de rotación anual en un equipo de 50 personas, con salario promedio de $15,000, ¿cuál es el costo anual de rotación?'),
(53, 6, 'MC', 3,  'Un proyecto se retrasará 3 semanas. Tienes opciones: A) Agregar 4 personas ($200K extra), B) Negociar extensión con cliente (riesgo de penalización de $500K), C) Reducir alcance. La penalización tiene 40% de probabilidad. ¿Cuál tiene menor costo esperado?'),
(54, 6, 'MC', 4,  'Serie compleja: 1, 4, 9, 16, 25, __'),
(55, 6, 'MC', 5,  'Un gerente tiene 6 reportes directos. Cada uno tiene en promedio 8 personas. ¿Cuál es el span of control total de la estructura?'),
(56, 6, 'MC', 6,  'Si la productividad cae 15% al cambiar de sistema y la curva de aprendizaje es de 3 meses, pero el nuevo sistema mejora 30% después, ¿en cuántos meses se recupera la inversión en productividad?'),
(57, 6, 'MC', 7,  'Tienes $1M de presupuesto. Proyecto X tiene 70% probabilidad de generar $2M. Proyecto Y tiene 90% probabilidad de generar $1.3M. ¿Cuál tiene mayor valor esperado?'),
(58, 6, 'MC', 8,  'En una negociación, tu BATNA (mejor alternativa) es un contrato de $800K. Te ofrecen $750K. Lo correcto es:'),
(59, 6, 'MC', 9,  'Tu equipo tiene 5 proyectos con deadline esta semana. Solo puedes completar 3. ¿Cómo priorizas?'),
(60, 6, 'MC', 10, 'Un KPI clave cayó 20% este trimestre. El primer paso debería ser:');

INSERT INTO question_options (question_id, sort_order, text, score) VALUES
(51,0,'Línea A',1),(51,1,'Línea B',2),(51,2,'Línea C',5),(51,3,'Todas igual',1),
(52,0,'$450,000',5),(52,1,'$150,000',1),(52,2,'$225,000',1),(52,3,'$300,000',1),
(53,0,'Opción A: $200K',5),(53,1,'Opción B: $200K esperado',4),(53,2,'Opción C: depende',2),(53,3,'Las tres son iguales',1),
(54,0,'30',1),(54,1,'36',5),(54,2,'42',1),(54,3,'49',1),
(55,0,'14',1),(55,1,'48',1),(55,2,'54',5),(55,3,'6',1),
(56,0,'3 meses',1),(56,1,'4.5 meses',5),(56,2,'6 meses',1),(56,3,'Nunca',1),
(57,0,'X: $1.4M',5),(57,1,'Y: $1.17M',1),(57,2,'Son iguales',1),(57,3,'Falta información',1),
(58,0,'Aceptar para cerrar rápido',1),(58,1,'Rechazar, tu BATNA es mejor',5),(58,2,'Pedir $900K',1),(58,3,'Aceptar con condiciones',2),
(59,0,'Los más fáciles primero',1),(59,1,'Por impacto en cliente y riesgo de cada uno',5),(59,2,'Los que me pidió el director',1),(59,3,'Los que llevan más avance',2),
(60,0,'Cambiar al responsable',1),(60,1,'Analizar causa raíz con datos antes de actuar',5),(60,2,'Implementar cambios inmediatos',1),(60,3,'Reportar y esperar instrucciones',1);

-- ───────────────────────────────────────────────────────────────────────────
--  SEC 7 | leadership | Estilo de Liderazgo (GER)
--  Q61-67 MC  /  Q68-70 Likert
-- ───────────────────────────────────────────────────────────────────────────
INSERT INTO questions (id, section_id, question_type, sort_order, text) VALUES
(61, 7, 'MC', 1, 'Un miembro de tu equipo comete un error grave frente a un cliente.'),
(62, 7, 'MC', 2, 'Dos miembros de tu equipo tienen un conflicto personal que afecta resultados.'),
(63, 7, 'MC', 3, 'Tu equipo debe implementar un cambio que genera resistencia.'),
(64, 7, 'MC', 4, 'Un colaborador talentoso te dice que está considerando irse a otra empresa.'),
(65, 7, 'MC', 5, 'Un empleado nuevo no está rindiendo como se esperaba después de 2 meses.'),
(66, 7, 'MC', 6, 'Tu equipo logra un resultado excepcional.'),
(67, 7, 'MC', 7, 'Debes reducir el presupuesto de tu área 20%. ¿Cómo comunicas?'),
(68, 7, 'LK', 8, 'Considero que mi estilo de liderazgo se adapta según la madurez de cada colaborador.'),
(69, 7, 'LK', 9, 'Invierto tiempo regularmente en desarrollar las habilidades de mi equipo.'),
(70, 7, 'LK', 10,'Delego no solo tareas sino también autoridad para tomar decisiones.');

INSERT INTO question_options (question_id, sort_order, text, score) VALUES
(61,0,'Lo reprendo públicamente para que aprenda',1),(61,1,'Asumo responsabilidad ante el cliente y luego doy retroalimentación en privado',5),(61,2,'Lo ignoro y yo corrijo el error',2),(61,3,'Lo despido',1),
(62,0,'Dejo que lo resuelvan solos',1),(62,1,'Hablo con ambos por separado, entiendo perspectivas y facilito acuerdo',5),(62,2,'Tomo partido por el que tiene razón',1),(62,3,'Separo sus responsabilidades sin hablar del tema',2),
(63,0,'Impongo el cambio por autoridad',1),(63,1,'Explico el por qué, involucro al equipo en el cómo e implemento gradualmente',5),(63,2,'Espero a que se acostumbren solos',1),(63,3,'Cancelo el cambio si hay resistencia',1),
(64,0,'Le digo que se vaya si quiere',1),(64,1,'Escucho sus razones, evalúo qué puedo ofrecer y diseño plan de retención',5),(64,2,'Le aumento sueldo inmediatamente',2),(64,3,'Le digo que nadie es indispensable',1),
(65,0,'Lo despido por bajo desempeño',1),(65,1,'Reviso su plan de inducción, doy retroalimentación clara y establezco metas a 30 días',5),(65,2,'Espero 6 meses más',1),(65,3,'Le asigno tareas más fáciles',2),
(66,0,'Me llevo el crédito como líder',1),(66,1,'Reconozco públicamente al equipo y comunico logro hacia arriba',5),(66,2,'No digo nada, es su trabajo',1),(66,3,'Solo reconozco al que más trabajó',2),
(67,0,'Por correo sin más explicación',1),(67,1,'Reúno al equipo, explico situación, presento plan y pido ideas de optimización',5),(67,2,'No digo nada y hago recortes',1),(67,3,'Le paso la responsabilidad a RH',1),
(68,0,'Totalmente de acuerdo',5),(68,1,'De acuerdo',4),(68,2,'Neutral',3),(68,3,'En desacuerdo',2),(68,4,'Totalmente en desacuerdo',1),
(69,0,'Totalmente de acuerdo',5),(69,1,'De acuerdo',4),(69,2,'Neutral',3),(69,3,'En desacuerdo',2),(69,4,'Totalmente en desacuerdo',1),
(70,0,'Totalmente de acuerdo',5),(70,1,'De acuerdo',4),(70,2,'Neutral',3),(70,3,'En desacuerdo',2),(70,4,'Totalmente en desacuerdo',1);

-- ───────────────────────────────────────────────────────────────────────────
--  SEC 8 | personality_ger | Big Five Directivo (GER)
-- ───────────────────────────────────────────────────────────────────────────
INSERT INTO questions (id, section_id, question_type, sort_order, text, trait, direction) VALUES
(71, 8, 'BF', 1,  'Tomo decisiones difíciles con rapidez cuando es necesario.', 'C', 1),
(72, 8, 'BF', 2,  'Genero confianza en mi equipo a través de mi ejemplo.', 'A', 1),
(73, 8, 'BF', 3,  'Me resulta difícil dar retroalimentación negativa.', 'A', -1),
(74, 8, 'BF', 4,  'Busco constantemente nuevas oportunidades de negocio o mejora.', 'O', 1),
(75, 8, 'BF', 5,  'Mantengo la calma en situaciones de crisis.', 'N', -1),
(76, 8, 'BF', 6,  'Me siento cómodo presentando ideas ante grupos grandes.', 'E', 1),
(77, 8, 'BF', 7,  'Considero múltiples perspectivas antes de tomar una decisión importante.', 'O', 1),
(78, 8, 'BF', 8,  'Mi equipo sabe exactamente qué espero de ellos.', 'C', 1),
(79, 8, 'BF', 9,  'Me cuesta trabajo confiar en las decisiones de otros.', 'A', -1),
(80, 8, 'BF', 10, 'Asumo la responsabilidad cuando las cosas salen mal en mi área.', 'C', 1),
(81, 8, 'BF', 11, 'Anticipo problemas antes de que ocurran.', 'C', 1),
(82, 8, 'BF', 12, 'Me adapto rápidamente a cambios en el mercado o la industria.', 'O', 1);

INSERT INTO question_options (question_id, sort_order, text, score) VALUES
(71,0,'Totalmente de acuerdo',5),(71,1,'De acuerdo',4),(71,2,'Neutral',3),(71,3,'En desacuerdo',2),(71,4,'Totalmente en desacuerdo',1),
(72,0,'Totalmente de acuerdo',5),(72,1,'De acuerdo',4),(72,2,'Neutral',3),(72,3,'En desacuerdo',2),(72,4,'Totalmente en desacuerdo',1),
-- Q73 direction=-1
(73,0,'Totalmente de acuerdo',1),(73,1,'De acuerdo',2),(73,2,'Neutral',3),(73,3,'En desacuerdo',4),(73,4,'Totalmente en desacuerdo',5),
(74,0,'Totalmente de acuerdo',5),(74,1,'De acuerdo',4),(74,2,'Neutral',3),(74,3,'En desacuerdo',2),(74,4,'Totalmente en desacuerdo',1),
-- Q75 direction=-1
(75,0,'Totalmente de acuerdo',1),(75,1,'De acuerdo',2),(75,2,'Neutral',3),(75,3,'En desacuerdo',4),(75,4,'Totalmente en desacuerdo',5),
(76,0,'Totalmente de acuerdo',5),(76,1,'De acuerdo',4),(76,2,'Neutral',3),(76,3,'En desacuerdo',2),(76,4,'Totalmente en desacuerdo',1),
(77,0,'Totalmente de acuerdo',5),(77,1,'De acuerdo',4),(77,2,'Neutral',3),(77,3,'En desacuerdo',2),(77,4,'Totalmente en desacuerdo',1),
(78,0,'Totalmente de acuerdo',5),(78,1,'De acuerdo',4),(78,2,'Neutral',3),(78,3,'En desacuerdo',2),(78,4,'Totalmente en desacuerdo',1),
-- Q79 direction=-1
(79,0,'Totalmente de acuerdo',1),(79,1,'De acuerdo',2),(79,2,'Neutral',3),(79,3,'En desacuerdo',4),(79,4,'Totalmente en desacuerdo',5),
(80,0,'Totalmente de acuerdo',5),(80,1,'De acuerdo',4),(80,2,'Neutral',3),(80,3,'En desacuerdo',2),(80,4,'Totalmente en desacuerdo',1),
(81,0,'Totalmente de acuerdo',5),(81,1,'De acuerdo',4),(81,2,'Neutral',3),(81,3,'En desacuerdo',2),(81,4,'Totalmente en desacuerdo',1),
(82,0,'Totalmente de acuerdo',5),(82,1,'De acuerdo',4),(82,2,'Neutral',3),(82,3,'En desacuerdo',2),(82,4,'Totalmente en desacuerdo',1);

-- ───────────────────────────────────────────────────────────────────────────
--  SEC 9 | emotional_ger | Inteligencia Emocional Gerencial (GER) — Likert
-- ───────────────────────────────────────────────────────────────────────────
INSERT INTO questions (id, section_id, question_type, sort_order, text) VALUES
(83,  9, 'LK', 1,  'Reconozco cómo mis emociones afectan mi estilo de liderazgo.'),
(84,  9, 'LK', 2,  'Puedo motivar a mi equipo incluso en momentos difíciles.'),
(85,  9, 'LK', 3,  'Identifico cuando un colaborador tiene problemas aunque no me lo diga.'),
(86,  9, 'LK', 4,  'Manejo la presión de los superiores sin descargarla en mi equipo.'),
(87,  9, 'LK', 5,  'En una negociación difícil, controlo mis emociones para obtener mejor resultado.'),
(88,  9, 'LK', 6,  'Cuando recibo una noticia mala, me tomo un momento antes de reaccionar.'),
(89,  9, 'LK', 7,  'Puedo comunicar malas noticias al equipo sin generar pánico.'),
(90,  9, 'LK', 8,  'Entiendo que diferentes personas necesitan diferentes estilos de comunicación.'),
(91,  9, 'LK', 9,  'Separo mis opiniones personales de las decisiones de negocio.'),
(92,  9, 'LK', 10, 'Celebro los logros de mi equipo con la misma importancia que analizo los fracasos.');

INSERT INTO question_options (question_id, sort_order, text, score) VALUES
(83,0,'Totalmente de acuerdo',5),(83,1,'De acuerdo',4),(83,2,'Neutral',3),(83,3,'En desacuerdo',2),(83,4,'Totalmente en desacuerdo',1),
(84,0,'Totalmente de acuerdo',5),(84,1,'De acuerdo',4),(84,2,'Neutral',3),(84,3,'En desacuerdo',2),(84,4,'Totalmente en desacuerdo',1),
(85,0,'Totalmente de acuerdo',5),(85,1,'De acuerdo',4),(85,2,'Neutral',3),(85,3,'En desacuerdo',2),(85,4,'Totalmente en desacuerdo',1),
(86,0,'Totalmente de acuerdo',5),(86,1,'De acuerdo',4),(86,2,'Neutral',3),(86,3,'En desacuerdo',2),(86,4,'Totalmente en desacuerdo',1),
(87,0,'Totalmente de acuerdo',5),(87,1,'De acuerdo',4),(87,2,'Neutral',3),(87,3,'En desacuerdo',2),(87,4,'Totalmente en desacuerdo',1),
(88,0,'Totalmente de acuerdo',5),(88,1,'De acuerdo',4),(88,2,'Neutral',3),(88,3,'En desacuerdo',2),(88,4,'Totalmente en desacuerdo',1),
(89,0,'Totalmente de acuerdo',5),(89,1,'De acuerdo',4),(89,2,'Neutral',3),(89,3,'En desacuerdo',2),(89,4,'Totalmente en desacuerdo',1),
(90,0,'Totalmente de acuerdo',5),(90,1,'De acuerdo',4),(90,2,'Neutral',3),(90,3,'En desacuerdo',2),(90,4,'Totalmente en desacuerdo',1),
(91,0,'Totalmente de acuerdo',5),(91,1,'De acuerdo',4),(91,2,'Neutral',3),(91,3,'En desacuerdo',2),(91,4,'Totalmente en desacuerdo',1),
(92,0,'Totalmente de acuerdo',5),(92,1,'De acuerdo',4),(92,2,'Neutral',3),(92,3,'En desacuerdo',2),(92,4,'Totalmente en desacuerdo',1);

-- ───────────────────────────────────────────────────────────────────────────
--  SEC 10 | decisions | Toma de Decisiones Gerenciales (GER)
-- ───────────────────────────────────────────────────────────────────────────
INSERT INTO questions (id, section_id, question_type, sort_order, text) VALUES
(93,  10, 'MC', 1, 'Un cliente importante amenaza con irse si no reduces precio 30%. Tu margen actual es 25%.'),
(94,  10, 'MC', 2, 'Tienes que elegir entre invertir en automatización ($2M, ahorra 40% costos en 3 años) o contratar más personal ($800K/año).'),
(95,  10, 'MC', 3, 'Descubres que un gerente de tu equipo comete una falta ética menor pero recurrente.'),
(96,  10, 'MC', 4, 'El mercado cambia y tu producto estrella pierde 15% de ventas en un trimestre.'),
(97,  10, 'MC', 5, 'Dos áreas de tu empresa tienen un conflicto por recursos compartidos.'),
(98,  10, 'MC', 6, 'Recibes una oportunidad de negocio grande pero con plazo de respuesta de 48 horas.'),
(99,  10, 'MC', 7, 'Tu plan estratégico a 3 años no va en línea con los resultados del primer año.'),
(100, 10, 'MC', 8, 'Ante una decisión estratégica, los datos apuntan en una dirección pero tu intuición en otra.');

INSERT INTO question_options (question_id, sort_order, text, score) VALUES
(93,0,'Acepto para no perder al cliente',1),(93,1,'Analizo su valor a largo plazo, negocio condiciones y ofrezco alternativas con valor agregado',5),(93,2,'Dejo que se vaya',1),(93,3,'Le subo el precio',1),
(94,0,'Personal, es más barato ahora',1),(94,1,'Automatización, el ROI a 3 años es mayor',5),(94,2,'No invierto en nada',1),(94,3,'Hago ambas a medias',1),
(95,0,'Lo ignoro porque da buenos resultados',1),(95,1,'Documento, confronto con evidencia y establezco consecuencias claras',5),(95,2,'Lo despido inmediatamente',2),(95,3,'Se lo comento informalmente',2),
(96,0,'Espero a que se recupere solo',1),(96,1,'Analizo tendencia, investigo causa y diseño estrategia de respuesta',5),(96,2,'Recorto presupuesto de marketing',1),(96,3,'Cambio de giro',1),
(97,0,'Tomo partido por la más importante',1),(97,1,'Facilito acuerdo basado en datos, prioridades estratégicas y métricas compartidas',5),(97,2,'Dejo que lo resuelvan entre ellos',1),(97,3,'Le paso el problema a mi jefe',1),
(98,0,'La rechazo por falta de tiempo para analizar',1),(98,1,'Reúno información clave, evalúo riesgo/beneficio y tomo decisión informada',5),(98,2,'La acepto sin analizar',1),(98,3,'Pido más tiempo sin evaluar',2),
(99,0,'Sigo el plan sin cambios',1),(99,1,'Reviso supuestos, ajusto estrategia manteniendo la visión de largo plazo',5),(99,2,'Desecho el plan completo',1),(99,3,'Culpo a factores externos',1),
(100,0,'Siempre sigo los datos',2),(100,1,'Profundizo en los datos, valido mi intuición con más información y luego decido',5),(100,2,'Siempre sigo mi intuición',1),(100,3,'Pido a alguien más que decida',1);

-- ───────────────────────────────────────────────────────────────────────────
--  SEC 11 | attention | Atención y Concentración (OPR)
-- ───────────────────────────────────────────────────────────────────────────
INSERT INTO questions (id, section_id, question_type, sort_order, text) VALUES
(101, 11, 'MC', 1,  'En la serie: 3, 6, 9, 12, __, ¿qué número sigue?'),
(102, 11, 'MC', 2,  '¿Cuál es diferente? Llave, Martillo, Destornillador, Manzana'),
(103, 11, 'MC', 3,  'Si "SEGURO" se escribe al revés, ¿cuál es la tercera letra?'),
(104, 11, 'MC', 4,  'En la serie: 2, 4, 8, 16, __, ¿qué número sigue?'),
(105, 11, 'MC', 5,  '¿Cuántos triángulos hay si un triángulo grande contiene una línea que va de un vértice al lado opuesto?'),
(106, 11, 'MC', 6,  '¿Cuál palabra NO pertenece al grupo? Diésel, Gasolina, Turbosina, Cemento'),
(107, 11, 'MC', 7,  'Si hoy es miércoles, ¿qué día será dentro de 5 días?'),
(108, 11, 'MC', 8,  'En la secuencia: A1, B2, C3, D__, ¿qué falta?'),
(109, 11, 'MC', 9,  'Un tanque de 10,000 litros está al 75%. ¿Cuántos litros tiene?'),
(110, 11, 'MC', 10, '¿Cuál es el opuesto de NEGLIGENTE?');

INSERT INTO question_options (question_id, sort_order, text, score) VALUES
(101,0,'14',1),(101,1,'15',5),(101,2,'16',1),(101,3,'18',1),
(102,0,'Llave',1),(102,1,'Martillo',1),(102,2,'Destornillador',1),(102,3,'Manzana',5),
(103,0,'U',1),(103,1,'G',1),(103,2,'R',5),(103,3,'O',1),
(104,0,'24',1),(104,1,'30',1),(104,2,'32',5),(104,3,'20',1),
(105,0,'1',1),(105,1,'2',5),(105,2,'3',1),(105,3,'4',1),
(106,0,'Diésel',1),(106,1,'Gasolina',1),(106,2,'Turbosina',1),(106,3,'Cemento',5),
(107,0,'Domingo',1),(107,1,'Lunes',5),(107,2,'Martes',1),(107,3,'Sábado',1),
(108,0,'5',1),(108,1,'D',1),(108,2,'4',5),(108,3,'E',1),
(109,0,'7,000',1),(109,1,'7,500',5),(109,2,'8,000',1),(109,3,'5,000',1),
(110,0,'Descuidado',1),(110,1,'Cuidadoso',5),(110,2,'Lento',1),(110,3,'Rápido',1);

-- ───────────────────────────────────────────────────────────────────────────
--  SEC 12 | reasoning | Razonamiento Lógico (OPR)
-- ───────────────────────────────────────────────────────────────────────────
INSERT INTO questions (id, section_id, question_type, sort_order, text) VALUES
(111, 12, 'MC', 1,  'Si todos los operadores usan casco y Juan es operador, entonces:'),
(112, 12, 'MC', 2,  'Serie: 5, 10, 20, 40, __'),
(113, 12, 'MC', 3,  'Si A es mayor que B, y B es mayor que C, entonces:'),
(114, 12, 'MC', 4,  '¿Qué número completa: 3, 5, 8, 12, __?'),
(115, 12, 'MC', 5,  'Un camión recorre 80 km/h. ¿Cuánto tardará en recorrer 240 km?'),
(116, 12, 'MC', 6,  'Si reorganizamos "DADIGURSE", obtenemos:'),
(117, 12, 'MC', 7,  'Serie: 1, 1, 2, 3, 5, 8, __'),
(118, 12, 'MC', 8,  'Si 3 operadores cargan un tanque en 6 horas, ¿cuánto tardarán 6 operadores?'),
(119, 12, 'MC', 9,  '¿Cuál figura NO encaja? Círculo, Cuadrado, Triángulo, Línea'),
(120, 12, 'MC', 10, 'Un reloj marca las 3:15. ¿Qué ángulo forman las manecillas?');

INSERT INTO question_options (question_id, sort_order, text, score) VALUES
(111,0,'Juan podría usar casco',1),(111,1,'Juan no necesita casco',1),(111,2,'Juan usa casco',5),(111,3,'No se puede saber',1),
(112,0,'60',1),(112,1,'70',1),(112,2,'80',5),(112,3,'50',1),
(113,0,'C es mayor que A',1),(113,1,'A es mayor que C',5),(113,2,'Son iguales',1),(113,3,'B es el mayor',1),
(114,0,'15',1),(114,1,'16',1),(114,2,'17',5),(114,3,'14',1),
(115,0,'2 horas',1),(115,1,'3 horas',5),(115,2,'4 horas',1),(115,3,'2.5 horas',1),
(116,0,'SEGURIDAD',5),(116,1,'DISGUSTAR',1),(116,2,'GUARIDAS',1),(116,3,'SALUDRIGE',1),
(117,0,'10',1),(117,1,'11',1),(117,2,'12',1),(117,3,'13',5),
(118,0,'12 horas',1),(118,1,'3 horas',5),(118,2,'2 horas',1),(118,3,'4 horas',1),
(119,0,'Círculo',1),(119,1,'Cuadrado',1),(119,2,'Triángulo',1),(119,3,'Línea',5),
(120,0,'90°',1),(120,1,'7.5°',5),(120,2,'0°',1),(120,3,'45°',1);

-- ───────────────────────────────────────────────────────────────────────────
--  SEC 13 | personality_op | Big Five Operativo (OPR)
-- ───────────────────────────────────────────────────────────────────────────
INSERT INTO questions (id, section_id, question_type, sort_order, text, trait, direction) VALUES
(121, 13, 'BF', 1,  'Sigo las instrucciones de mi supervisor aunque no esté de acuerdo.', 'C', 1),
(122, 13, 'BF', 2,  'Me adapto rápidamente cuando cambian mis tareas o mi área de trabajo.', 'O', 1),
(123, 13, 'BF', 3,  'Me cuesta trabajo aceptar cuando me equivoco.', 'A', -1),
(124, 13, 'BF', 4,  'Prefiero un trabajo con rutinas establecidas que uno que cambie constantemente.', 'O', -1),
(125, 13, 'BF', 5,  'Mis compañeros me consideran una persona confiable.', 'C', 1),
(126, 13, 'BF', 6,  'Me pongo nervioso cuando tengo que hacer algo nuevo.', 'N', 1),
(127, 13, 'BF', 7,  'Me gusta ayudar a los compañeros nuevos a integrarse.', 'A', 1),
(128, 13, 'BF', 8,  'Termino mis tareas antes de la fecha límite.', 'C', 1),
(129, 13, 'BF', 9,  'Me cuesta concentrarme cuando hay ruido o distracciones.', 'N', 1),
(130, 13, 'BF', 10, 'Me resulta fácil seguir instrucciones escritas paso a paso.', 'C', 1),
(131, 13, 'BF', 11, 'Cuando hay un conflicto con un compañero, busco resolverlo hablando.', 'A', 1),
(132, 13, 'BF', 12, 'Me considero una persona puntual y organizada.', 'C', 1);

INSERT INTO question_options (question_id, sort_order, text, score) VALUES
(121,0,'Totalmente de acuerdo',5),(121,1,'De acuerdo',4),(121,2,'Neutral',3),(121,3,'En desacuerdo',2),(121,4,'Totalmente en desacuerdo',1),
(122,0,'Totalmente de acuerdo',5),(122,1,'De acuerdo',4),(122,2,'Neutral',3),(122,3,'En desacuerdo',2),(122,4,'Totalmente en desacuerdo',1),
(123,0,'Totalmente de acuerdo',1),(123,1,'De acuerdo',2),(123,2,'Neutral',3),(123,3,'En desacuerdo',4),(123,4,'Totalmente en desacuerdo',5),
(124,0,'Totalmente de acuerdo',1),(124,1,'De acuerdo',2),(124,2,'Neutral',3),(124,3,'En desacuerdo',4),(124,4,'Totalmente en desacuerdo',5),
(125,0,'Totalmente de acuerdo',5),(125,1,'De acuerdo',4),(125,2,'Neutral',3),(125,3,'En desacuerdo',2),(125,4,'Totalmente en desacuerdo',1),
(126,0,'Totalmente de acuerdo',5),(126,1,'De acuerdo',4),(126,2,'Neutral',3),(126,3,'En desacuerdo',2),(126,4,'Totalmente en desacuerdo',1),
(127,0,'Totalmente de acuerdo',5),(127,1,'De acuerdo',4),(127,2,'Neutral',3),(127,3,'En desacuerdo',2),(127,4,'Totalmente en desacuerdo',1),
(128,0,'Totalmente de acuerdo',5),(128,1,'De acuerdo',4),(128,2,'Neutral',3),(128,3,'En desacuerdo',2),(128,4,'Totalmente en desacuerdo',1),
(129,0,'Totalmente de acuerdo',5),(129,1,'De acuerdo',4),(129,2,'Neutral',3),(129,3,'En desacuerdo',2),(129,4,'Totalmente en desacuerdo',1),
(130,0,'Totalmente de acuerdo',5),(130,1,'De acuerdo',4),(130,2,'Neutral',3),(130,3,'En desacuerdo',2),(130,4,'Totalmente en desacuerdo',1),
(131,0,'Totalmente de acuerdo',5),(131,1,'De acuerdo',4),(131,2,'Neutral',3),(131,3,'En desacuerdo',2),(131,4,'Totalmente en desacuerdo',1),
(132,0,'Totalmente de acuerdo',5),(132,1,'De acuerdo',4),(132,2,'Neutral',3),(132,3,'En desacuerdo',2),(132,4,'Totalmente en desacuerdo',1);

-- ───────────────────────────────────────────────────────────────────────────
--  SEC 14 | honesty | Honestidad e Integridad (OPR) — Likert
-- ───────────────────────────────────────────────────────────────────────────
INSERT INTO questions (id, section_id, question_type, sort_order, text) VALUES
(133, 14, 'LK', 1,  'Si encuentro herramienta de la empresa tirada, la regreso a su lugar.'),
(134, 14, 'LK', 2,  'Está bien tomar materiales sobrantes de la empresa si nadie los usa.'),
(135, 14, 'LK', 3,  'Reportaría a un compañero que roba material de trabajo.'),
(136, 14, 'LK', 4,  'Si llego tarde y nadie se da cuenta, no lo registro.'),
(137, 14, 'LK', 5,  'Nunca he mentido a un supervisor sobre mi trabajo.'),
(138, 14, 'LK', 6,  'Si cometo un error que nadie ve, lo corrijo sin decir nada.'),
(139, 14, 'LK', 7,  'Considero que la honestidad es más importante que caer bien.'),
(140, 14, 'LK', 8,  'A veces es necesario exagerar un poco para quedar bien con el jefe.'),
(141, 14, 'LK', 9,  'Si un compañero me pide cubrir una falta, lo haría por lealtad.'),
(142, 14, 'LK', 10, 'Me sentiría incómodo si tuviera que mentir por instrucción de un jefe.');

INSERT INTO question_options (question_id, sort_order, text, score) VALUES
-- Q133 positivo
(133,0,'Totalmente de acuerdo',5),(133,1,'De acuerdo',4),(133,2,'Neutral',3),(133,3,'En desacuerdo',2),(133,4,'Totalmente en desacuerdo',1),
-- Q134 inverso
(134,0,'Totalmente de acuerdo',1),(134,1,'De acuerdo',2),(134,2,'Neutral',3),(134,3,'En desacuerdo',4),(134,4,'Totalmente en desacuerdo',5),
(135,0,'Totalmente de acuerdo',5),(135,1,'De acuerdo',4),(135,2,'Neutral',3),(135,3,'En desacuerdo',2),(135,4,'Totalmente en desacuerdo',1),
-- Q136 inverso
(136,0,'Totalmente de acuerdo',1),(136,1,'De acuerdo',2),(136,2,'Neutral',3),(136,3,'En desacuerdo',4),(136,4,'Totalmente en desacuerdo',5),
(137,0,'Totalmente de acuerdo',5),(137,1,'De acuerdo',4),(137,2,'Neutral',3),(137,3,'En desacuerdo',2),(137,4,'Totalmente en desacuerdo',1),
-- Q138 parcialmente inverso (score original: 2,3,3,4,5)
(138,0,'Totalmente de acuerdo',2),(138,1,'De acuerdo',3),(138,2,'Neutral',3),(138,3,'En desacuerdo',4),(138,4,'Totalmente en desacuerdo',5),
(139,0,'Totalmente de acuerdo',5),(139,1,'De acuerdo',4),(139,2,'Neutral',3),(139,3,'En desacuerdo',2),(139,4,'Totalmente en desacuerdo',1),
-- Q140 inverso
(140,0,'Totalmente de acuerdo',1),(140,1,'De acuerdo',2),(140,2,'Neutral',3),(140,3,'En desacuerdo',4),(140,4,'Totalmente en desacuerdo',5),
-- Q141 inverso
(141,0,'Totalmente de acuerdo',1),(141,1,'De acuerdo',2),(141,2,'Neutral',3),(141,3,'En desacuerdo',4),(141,4,'Totalmente en desacuerdo',5),
(142,0,'Totalmente de acuerdo',5),(142,1,'De acuerdo',4),(142,2,'Neutral',3),(142,3,'En desacuerdo',2),(142,4,'Totalmente en desacuerdo',1);

-- ───────────────────────────────────────────────────────────────────────────
--  SEC 15 | pressure | Trabajo Bajo Presión (OPR)
-- ───────────────────────────────────────────────────────────────────────────
INSERT INTO questions (id, section_id, question_type, sort_order, text) VALUES
(143, 15, 'MC', 1, 'Tu supervisor te pide terminar un trabajo urgente en la mitad del tiempo habitual.'),
(144, 15, 'MC', 2, 'Dos supervisores te dan instrucciones diferentes al mismo tiempo.'),
(145, 15, 'MC', 3, 'Un equipo se descompone y no hay refacciones disponibles.'),
(146, 15, 'MC', 4, 'Llevas varios días trabajando horas extra y estás agotado.'),
(147, 15, 'MC', 5, 'Un compañero comete un error que afecta tu trabajo.'),
(148, 15, 'MC', 6, 'Te piden hacer una tarea que nunca has hecho antes.'),
(149, 15, 'MC', 7, 'Estás en medio de tu trabajo y se va la luz / falla el sistema.'),
(150, 15, 'MC', 8, 'Tu jefe te da retroalimentación negativa frente a tus compañeros.');

INSERT INTO question_options (question_id, sort_order, text, score) VALUES
(143,0,'Me estreso y no sé por dónde empezar',1),(143,1,'Priorizo tareas, me organizo y trabajo enfocado',5),(143,2,'Me quejo de que es imposible',1),(143,3,'Hago el trabajo rápido aunque quede mal',2),
(144,0,'Hago lo del que me caiga mejor',1),(144,1,'Pido aclaración para saber cuál es prioridad',5),(144,2,'Ignoro a los dos',1),(144,3,'Hago uno y dejo el otro',2),
(145,0,'Espero sin hacer nada',1),(145,1,'Busco alternativas, informo y propongo solución temporal',5),(145,2,'Me frusto y reclamo',1),(145,3,'Improviso una reparación peligrosa',1),
(146,0,'Bajo mi rendimiento sin avisar',1),(146,1,'Hablo con mi supervisor sobre mi carga',5),(146,2,'Me enfermo para descansar',1),(146,3,'Continúo hasta colapsar',1),
(147,0,'Lo confronto agresivamente',1),(147,1,'Lo hablo con calma y buscamos solución',5),(147,2,'Lo ignoro pero guardo rencor',1),(147,3,'Lo acuso con el jefe sin hablar con él',2),
(148,0,'Me niego porque no me corresponde',1),(148,1,'Pido capacitación o ayuda y la intento',5),(148,2,'La hago sin saber y espero que salga',1),(148,3,'Digo que ya la sé aunque no sea cierto',1),
(149,0,'Me desespero',1),(149,1,'Sigo protocolo de emergencia, notifico y espero instrucciones',5),(149,2,'Me voy a mi casa',1),(149,3,'Intento arreglar el problema yo solo',2),
(150,0,'Le respondo mal enfrente de todos',1),(150,1,'Lo escucho y después le pido hablar en privado',5),(150,2,'Me callo pero guardo resentimiento',2),(150,3,'Dejo de esforzarme en mi trabajo',1);

-- ───────────────────────────────────────────────────────────────────────────
--  SEC 16 | personality | Big Five Transporte (TRP)
-- ───────────────────────────────────────────────────────────────────────────
INSERT INTO questions (id, section_id, question_type, sort_order, text, trait, direction) VALUES
(151, 16, 'BF', 1,  'Me resulta fácil iniciar conversaciones con personas desconocidas.', 'E', 1),
(152, 16, 'BF', 2,  'Prefiero trabajar solo que en equipo.', 'E', -1),
(153, 16, 'BF', 3,  'Cuando un compañero tiene un problema, me ofrezco a ayudar.', 'A', 1),
(154, 16, 'BF', 4,  'Si alguien comete un error que me afecta, me cuesta no enojarme.', 'A', -1),
(155, 16, 'BF', 5,  'Siempre reviso mi unidad antes de cada viaje, aunque tenga prisa.', 'C', 1),
(156, 16, 'BF', 6,  'A veces dejo pendientes para después si no son urgentes.', 'C', -1),
(157, 16, 'BF', 7,  'Cumplo mis horarios de entrega con puntualidad.', 'C', 1),
(158, 16, 'BF', 8,  'Me mantengo tranquilo ante situaciones inesperadas en carretera.', 'N', -1),
(159, 16, 'BF', 9,  'Los cambios repentinos en mi ruta me generan mucha ansiedad.', 'N', 1),
(160, 16, 'BF', 10, 'Me interesa aprender nuevas tecnologías y procedimientos.', 'O', 1),
(161, 16, 'BF', 11, 'Prefiero hacer las cosas como siempre se han hecho.', 'O', -1),
(162, 16, 'BF', 12, 'Estoy abierto a recibir retroalimentación sobre mi trabajo.', 'O', 1);

INSERT INTO question_options (question_id, sort_order, text, score) VALUES
(151,0,'Totalmente de acuerdo',5),(151,1,'De acuerdo',4),(151,2,'Neutral',3),(151,3,'En desacuerdo',2),(151,4,'Totalmente en desacuerdo',1),
(152,0,'Totalmente de acuerdo',1),(152,1,'De acuerdo',2),(152,2,'Neutral',3),(152,3,'En desacuerdo',4),(152,4,'Totalmente en desacuerdo',5),
(153,0,'Totalmente de acuerdo',5),(153,1,'De acuerdo',4),(153,2,'Neutral',3),(153,3,'En desacuerdo',2),(153,4,'Totalmente en desacuerdo',1),
(154,0,'Totalmente de acuerdo',1),(154,1,'De acuerdo',2),(154,2,'Neutral',3),(154,3,'En desacuerdo',4),(154,4,'Totalmente en desacuerdo',5),
(155,0,'Totalmente de acuerdo',5),(155,1,'De acuerdo',4),(155,2,'Neutral',3),(155,3,'En desacuerdo',2),(155,4,'Totalmente en desacuerdo',1),
(156,0,'Totalmente de acuerdo',1),(156,1,'De acuerdo',2),(156,2,'Neutral',3),(156,3,'En desacuerdo',4),(156,4,'Totalmente en desacuerdo',5),
(157,0,'Totalmente de acuerdo',5),(157,1,'De acuerdo',4),(157,2,'Neutral',3),(157,3,'En desacuerdo',2),(157,4,'Totalmente en desacuerdo',1),
(158,0,'Totalmente de acuerdo',1),(158,1,'De acuerdo',2),(158,2,'Neutral',3),(158,3,'En desacuerdo',4),(158,4,'Totalmente en desacuerdo',5),
(159,0,'Totalmente de acuerdo',5),(159,1,'De acuerdo',4),(159,2,'Neutral',3),(159,3,'En desacuerdo',2),(159,4,'Totalmente en desacuerdo',1),
(160,0,'Totalmente de acuerdo',5),(160,1,'De acuerdo',4),(160,2,'Neutral',3),(160,3,'En desacuerdo',2),(160,4,'Totalmente en desacuerdo',1),
(161,0,'Totalmente de acuerdo',1),(161,1,'De acuerdo',2),(161,2,'Neutral',3),(161,3,'En desacuerdo',4),(161,4,'Totalmente en desacuerdo',5),
(162,0,'Totalmente de acuerdo',5),(162,1,'De acuerdo',4),(162,2,'Neutral',3),(162,3,'En desacuerdo',2),(162,4,'Totalmente en desacuerdo',1);

-- ───────────────────────────────────────────────────────────────────────────
--  SEC 17 | integrity | Integridad y Honestidad (TRP) — Likert
-- ───────────────────────────────────────────────────────────────────────────
INSERT INTO questions (id, section_id, question_type, sort_order, text) VALUES
(163, 17, 'LK', 1,  'Si encuentro un error a mi favor en el pago de combustible, lo reporto.'),
(164, 17, 'LK', 2,  'Si nadie me supervisa, mantengo los mismos estándares de trabajo.'),
(165, 17, 'LK', 3,  'Si me ofrecieran dinero por transportar algo no declarado, lo rechazaría.'),
(166, 17, 'LK', 4,  'Reportaría a un compañero si lo veo cometiendo una falta grave de seguridad.'),
(167, 17, 'LK', 5,  'Si tuviera un accidente menor sin testigos, lo reportaría.'),
(168, 17, 'LK', 6,  'Considero aceptable llevar pasajeros no autorizados si son familiares.'),
(169, 17, 'LK', 7,  'Las reglas de seguridad a veces son excesivas e innecesarias.'),
(170, 17, 'LK', 8,  'Es comprensible exceder el límite de velocidad si voy retrasado.'),
(171, 17, 'LK', 9,  'A veces es necesario omitir información en reportes para evitar problemas.'),
(172, 17, 'LK', 10, 'Me sentiría mal si mintiera en un reporte de incidentes.');

INSERT INTO question_options (question_id, sort_order, text, score) VALUES
(163,0,'Totalmente de acuerdo',5),(163,1,'De acuerdo',4),(163,2,'Neutral',3),(163,3,'En desacuerdo',2),(163,4,'Totalmente en desacuerdo',1),
(164,0,'Totalmente de acuerdo',5),(164,1,'De acuerdo',4),(164,2,'Neutral',3),(164,3,'En desacuerdo',2),(164,4,'Totalmente en desacuerdo',1),
(165,0,'Totalmente de acuerdo',5),(165,1,'De acuerdo',4),(165,2,'Neutral',3),(165,3,'En desacuerdo',2),(165,4,'Totalmente en desacuerdo',1),
(166,0,'Totalmente de acuerdo',5),(166,1,'De acuerdo',4),(166,2,'Neutral',3),(166,3,'En desacuerdo',2),(166,4,'Totalmente en desacuerdo',1),
(167,0,'Totalmente de acuerdo',5),(167,1,'De acuerdo',4),(167,2,'Neutral',3),(167,3,'En desacuerdo',2),(167,4,'Totalmente en desacuerdo',1),
-- Q168 inverso
(168,0,'Totalmente de acuerdo',1),(168,1,'De acuerdo',2),(168,2,'Neutral',3),(168,3,'En desacuerdo',4),(168,4,'Totalmente en desacuerdo',5),
-- Q169 inverso
(169,0,'Totalmente de acuerdo',1),(169,1,'De acuerdo',2),(169,2,'Neutral',3),(169,3,'En desacuerdo',4),(169,4,'Totalmente en desacuerdo',5),
-- Q170 inverso
(170,0,'Totalmente de acuerdo',1),(170,1,'De acuerdo',2),(170,2,'Neutral',3),(170,3,'En desacuerdo',4),(170,4,'Totalmente en desacuerdo',5),
-- Q171 inverso
(171,0,'Totalmente de acuerdo',1),(171,1,'De acuerdo',2),(171,2,'Neutral',3),(171,3,'En desacuerdo',4),(171,4,'Totalmente en desacuerdo',5),
(172,0,'Totalmente de acuerdo',5),(172,1,'De acuerdo',4),(172,2,'Neutral',3),(172,3,'En desacuerdo',2),(172,4,'Totalmente en desacuerdo',1);

-- ───────────────────────────────────────────────────────────────────────────
--  SEC 18 | corruption | Resistencia a Corrupción (TRP)
--  Sub-tipos: sc=escenario múltiple  lk=Likert actitudinal
-- ───────────────────────────────────────────────────────────────────────────
INSERT INTO questions (id, section_id, question_type, sort_order, text, corruption_cat) VALUES
-- escenarios MC
(173, 18, 'MC', 1,  'Una persona te ofrece $50,000 para no revisar bien tu carga y permitir bidones extra.',       'sob'),
(174, 18, 'MC', 2,  'Un despachador te dice que por $2,000 te carga primero. Otros lo hacen.',                     'sob'),
(175, 18, 'MC', 3,  'Tu supervisor te pide registrar 2,000 litros menos. Dice que es "orden de arriba".',          'sob'),
(176, 18, 'MC', 4,  'Un grupo te detiene y te dice que debes pagar "cuota" semanal para circular.',                'cri'),
(177, 18, 'MC', 5,  'Te ofrecen desviar tu ruta 2h para entregar combustible en ubicación no registrada. Pago: tu salario de un mes.','cri'),
(178, 18, 'MC', 6,  'Un compañero siempre llega con dinero de más. Sospechas actividades ilícitas.',              'cri');

INSERT INTO question_options (question_id, sort_order, text, score) VALUES
(173,0,'Acepto',1),(173,1,'Lo rechazo e informo a mi base y autoridades',5),(173,2,'Le digo que no pero no reporto',2),(173,3,'Le pido más dinero',1),
(174,0,'Pago, todos lo hacen',1),(174,1,'Me niego y espero',4),(174,2,'Lo reporto a la administración',5),(174,3,'Pago pero pido recibo',1),
(175,0,'Obedezco',1),(175,1,'Me niego y escalo a compliance',5),(175,2,'Lo hago pero guardo evidencia',2),(175,3,'Le pido que lo ponga por escrito',3),
(176,0,'Pago',1),(176,1,'Notifico a mi empresa y sigo protocolo',5),(176,2,'Dejo esa ruta sin decir nada',2),(176,3,'Negocio monto menor',1),
(177,0,'Acepto',1),(177,1,'Lo rechazo y reporto',5),(177,2,'Le digo que lo voy a pensar',2),(177,3,'Acepto solo una vez',1),
(178,0,'No es mi problema',1),(178,1,'Notifico confidencialmente',5),(178,2,'Le pregunto cómo le hace',1),(178,3,'Lo ignoro pero me alejo',3);

-- Likert actitudinal (BF-like, direction)
INSERT INTO questions (id, section_id, question_type, sort_order, text, corruption_cat, direction) VALUES
(179, 18, 'LK', 7,  'Cuando uno gana poco, es comprensible buscar ingresos extra aunque no sean legales.',  'rac', -1),
(180, 18, 'LK', 8,  'En México es imposible trabajar en transporte de combustible sin pagar mordidas.',      'rac', -1),
(181, 18, 'LK', 9,  'Si mi familia necesitara dinero urgentemente, podría considerar hacer algo indebido.',  'rac', -1),
(182, 18, 'LK', 10, 'Denunciar a un compañero que roba combustible es ser un soplón.',                       'rac', -1),
(183, 18, 'LK', 11, 'He rechazado ofertas que me parecieron sospechosas o ilegales.',                        'his', 1),
(184, 18, 'LK', 12, 'Estaría dispuesto a verificaciones de antecedentes periódicas.',                        'his', 1),
(185, 18, 'LK', 13, 'Tengo familiares que me han invitado a negocios de combustible fuera de la ley.',       'his', -1),
(186, 18, 'LK', 14, 'Me sentiría cómodo con monitoreo GPS en tiempo real.',                                  'his', 1);

INSERT INTO question_options (question_id, sort_order, text, score) VALUES
-- inversos (direction=-1)
(179,0,'Totalmente de acuerdo',1),(179,1,'De acuerdo',2),(179,2,'Neutral',3),(179,3,'En desacuerdo',4),(179,4,'Totalmente en desacuerdo',5),
(180,0,'Totalmente de acuerdo',1),(180,1,'De acuerdo',2),(180,2,'Neutral',3),(180,3,'En desacuerdo',4),(180,4,'Totalmente en desacuerdo',5),
(181,0,'Totalmente de acuerdo',1),(181,1,'De acuerdo',2),(181,2,'Neutral',3),(181,3,'En desacuerdo',4),(181,4,'Totalmente en desacuerdo',5),
(182,0,'Totalmente de acuerdo',1),(182,1,'De acuerdo',2),(182,2,'Neutral',3),(182,3,'En desacuerdo',4),(182,4,'Totalmente en desacuerdo',5),
-- positivos (direction=1)
(183,0,'Totalmente de acuerdo',5),(183,1,'De acuerdo',4),(183,2,'Neutral',3),(183,3,'En desacuerdo',2),(183,4,'Totalmente en desacuerdo',1),
(184,0,'Totalmente de acuerdo',5),(184,1,'De acuerdo',4),(184,2,'Neutral',3),(184,3,'En desacuerdo',2),(184,4,'Totalmente en desacuerdo',1),
-- inverso
(185,0,'Totalmente de acuerdo',1),(185,1,'De acuerdo',2),(185,2,'Neutral',3),(185,3,'En desacuerdo',4),(185,4,'Totalmente en desacuerdo',5),
-- positivo
(186,0,'Totalmente de acuerdo',5),(186,1,'De acuerdo',4),(186,2,'Neutral',3),(186,3,'En desacuerdo',2),(186,4,'Totalmente en desacuerdo',1);

-- ───────────────────────────────────────────────────────────────────────────
--  SEC 19 | stress | Manejo de Estrés (TRP)
-- ───────────────────────────────────────────────────────────────────────────
INSERT INTO questions (id, section_id, question_type, sort_order, text) VALUES
(187, 19, 'MC', 1, 'Se descompone el sistema de frenos en carretera.'),
(188, 19, 'MC', 2, 'Llevas 10 horas manejando, falta una hora. Estás muy cansado.'),
(189, 19, 'MC', 3, 'Detectas olor a combustible inusual durante la descarga.'),
(190, 19, 'MC', 4, 'Un automovilista te provoca con maniobras peligrosas.'),
(191, 19, 'MC', 5, 'En inspección el oficial encuentra detalle menor en documentación.'),
(192, 19, 'MC', 6, 'Se poncha llanta en zona solitaria de noche.'),
(193, 19, 'MC', 7, 'Te asignan ruta nueva, sales en 30 minutos.'),
(194, 19, 'MC', 8, 'Cambio de procedimiento que consideras innecesario.');

INSERT INTO question_options (question_id, sort_order, text, score) VALUES
(187,0,'Entro en pánico',1),(187,1,'Uso freno de motor y busco lugar seguro',5),(187,2,'Llamo a la base sin actuar',2),(187,3,'Sigo despacio',1),
(188,0,'Sigo',2),(188,1,'Me detengo a descansar',5),(188,2,'Tomo café',2),(188,3,'Aumento velocidad',1),
(189,0,'Continúo',1),(189,1,'Detengo operación y notifico',5),(189,2,'Espero a ver',1),(189,3,'Pido que verifiquen',3),
(190,0,'Respondo igual',1),(190,1,'Mantengo carril y reduzco velocidad',5),(190,2,'Lo persigo',1),(190,3,'Me detengo molesto',2),
(191,0,'Intento negociar',2),(191,1,'Coopero y sigo procedimiento',5),(191,2,'Discuto nervioso',1),(191,3,'Ofrezco dinero',1),
(192,0,'La cambio sin iluminación',2),(192,1,'Señalamientos, luces, pido apoyo',5),(192,2,'Abandono unidad',1),(192,3,'Espero',2),
(193,0,'No puedo',2),(193,1,'Estudio GPS, pregunto y salgo',5),(193,2,'Salgo sin preparación',1),(193,3,'Pido que manden a otro',2),
(194,0,'Me niego',1),(194,1,'Lo implemento y comunico observaciones',5),(194,2,'Lo ignoro',1),(194,3,'Me quejo con compañeros',2);

-- ───────────────────────────────────────────────────────────────────────────
--  SEC 20 | situational | Juicio Técnico (TRP)
-- ───────────────────────────────────────────────────────────────────────────
INSERT INTO questions (id, section_id, question_type, sort_order, text) VALUES
(195, 20, 'MC', 1, 'Presión de llanta bajo el mínimo en inspección pre-operacional.'),
(196, 20, 'MC', 2, '¿Primer paso al llegar a punto de descarga?'),
(197, 20, 'MC', 3, 'Se activa alarma de sobrellenado en terminal.'),
(198, 20, 'MC', 4, 'Cliente pide descargar en tanque diferente al de tu orden.'),
(199, 20, 'MC', 5, '¿Qué documento NO es indispensable para transporte de hidrocarburos?'),
(200, 20, 'MC', 6, 'Fuga menor en conexión del autotanque en carretera.'),
(201, 20, 'MC', 7, '¿Cada cuánto se verifica calibración del medidor de flujo?'),
(202, 20, 'MC', 8, 'Compañero pide firmar bitácora que no realizaste.');

INSERT INTO question_options (question_id, sort_order, text, score) VALUES
(195,0,'Salgo y la inflo después',2),(195,1,'No salgo hasta que se corrija',5),(195,2,'Salgo, no se ve tan baja',1),(195,3,'Pido medidor prestado',1),
(196,0,'Conectar manguera',1),(196,1,'Verificar área, conos, tierra física, documentación',5),(196,2,'Buscar encargado',2),(196,3,'Estacionar y esperar',3),
(197,0,'Cierro válvula y notifico',5),(197,1,'Espero que corrija',2),(197,2,'Desconecto alarma',1),(197,3,'Sigo cargando',1),
(198,0,'Lo hago',1),(198,1,'Verifico con centro de control',5),(198,2,'El cliente manda',1),(198,3,'Llamo a mi jefe',3),
(199,0,'Carta porte',1),(199,1,'Licencia tipo E',1),(199,2,'Tarjeta circulación personal',5),(199,3,'HDS',1),
(200,0,'Sigo al destino',1),(200,1,'Me detengo, cierro válvulas, activo protocolo',5),(200,2,'Aumento velocidad',1),(200,3,'Aprieto conexión en movimiento',1),
(201,0,'Cada 3 años',2),(201,1,'Cada año o cuando sea requerido',5),(201,2,'Solo cuando falla',1),(201,3,'Cada 5 años',1),
(202,0,'Lo ayudo',1),(202,1,'Me niego y explico riesgos legales',5),(202,2,'Lo hago una vez',1),(202,3,'Digo que no, sin reportar',3);

-- ───────────────────────────────────────────────────────────────────────────
--  SEC 21 | reliability | Confiabilidad Operativa (TRP)
--  Q203 MC con check / Q204-210 LK (direction implícito en score)
-- ───────────────────────────────────────────────────────────────────────────
INSERT INTO questions (id, section_id, question_type, sort_order, text, has_check) VALUES
(203, 21, 'MC', 1, '¿Cuántas veces llegaste tarde en los últimos 6 meses?', 1);

INSERT INTO questions (id, section_id, question_type, sort_order, text) VALUES
(204, 21, 'LK', 2, 'Si me comprometo a una fecha, la cumplo aunque implique esfuerzo extra.'),
(205, 21, 'LK', 3, 'A veces olvido completar la bitácora al finalizar una entrega.'),
(206, 21, 'LK', 4, 'Mis supervisores pueden contar conmigo para cubrir turnos extra.'),
(207, 21, 'LK', 5, 'He tenido problemas laborales por faltas injustificadas.'),
(208, 21, 'LK', 6, 'Cuando cometo un error, lo reconozco inmediatamente.'),
(209, 21, 'LK', 7, 'He tenido conflictos con empleadores anteriores por incumplimiento.'),
(210, 21, 'LK', 8, 'Si detecto un problema en la unidad, lo reporto aunque no sea urgente.');

INSERT INTO question_options (question_id, sort_order, text, score) VALUES
(203,0,'Nunca',5),(203,1,'1-2 veces',4),(203,2,'3-5 veces',2),(203,3,'Más de 5',1),
-- Q204 positivo
(204,0,'Totalmente de acuerdo',5),(204,1,'De acuerdo',4),(204,2,'Neutral',3),(204,3,'En desacuerdo',2),(204,4,'Totalmente en desacuerdo',1),
-- Q205 inverso
(205,0,'Totalmente de acuerdo',1),(205,1,'De acuerdo',2),(205,2,'Neutral',3),(205,3,'En desacuerdo',4),(205,4,'Totalmente en desacuerdo',5),
-- Q206 positivo
(206,0,'Totalmente de acuerdo',5),(206,1,'De acuerdo',4),(206,2,'Neutral',3),(206,3,'En desacuerdo',2),(206,4,'Totalmente en desacuerdo',1),
-- Q207 inverso
(207,0,'Totalmente de acuerdo',1),(207,1,'De acuerdo',2),(207,2,'Neutral',3),(207,3,'En desacuerdo',4),(207,4,'Totalmente en desacuerdo',5),
-- Q208 positivo
(208,0,'Totalmente de acuerdo',5),(208,1,'De acuerdo',4),(208,2,'Neutral',3),(208,3,'En desacuerdo',2),(208,4,'Totalmente en desacuerdo',1),
-- Q209 inverso
(209,0,'Totalmente de acuerdo',1),(209,1,'De acuerdo',2),(209,2,'Neutral',3),(209,3,'En desacuerdo',4),(209,4,'Totalmente en desacuerdo',5),
-- Q210 positivo
(210,0,'Totalmente de acuerdo',5),(210,1,'De acuerdo',4),(210,2,'Neutral',3),(210,3,'En desacuerdo',2),(210,4,'Totalmente en desacuerdo',1);

-- ═══════════════════════════════════════════════════════════════════════════════
--  BLOQUE 14 ▸ VISTAS ÚTILES
-- ═══════════════════════════════════════════════════════════════════════════════

-- Vista: todas las preguntas con su batería y sección
CREATE OR REPLACE VIEW v_questions_full AS
SELECT
    bt.code                 AS battery_code,
    bt.name                 AS battery_name,
    bs.code                 AS section_code,
    bs.name                 AS section_name,
    q.id                    AS question_id,
    q.sort_order,
    q.question_type,
    q.text                  AS question_text,
    q.trait,
    q.direction,
    q.corruption_cat,
    q.has_check
FROM questions q
JOIN battery_sections bs ON bs.id = q.section_id
JOIN battery_types    bt ON bt.id = bs.battery_type_id
ORDER BY bt.id, bs.sort_order, q.sort_order;

-- Vista: resultados de candidatos con datos de sesión
CREATE OR REPLACE VIEW v_candidate_results AS
SELECT
    c.id                    AS candidate_id,
    c.full_name             AS candidate_name,
    c.email,
    c.phone,
    c.position,
    bt.name                 AS battery_name,
    es.status               AS session_status,
    es.started_at,
    es.completed_at,
    er.total_percentage,
    er.overall_level,
    er.recommendation,
    er.bf_conscientiousness,
    er.bf_extraversion,
    er.bf_openness,
    er.bf_agreeableness,
    er.bf_neuroticism,
    er.corruption_score
FROM candidates c
JOIN evaluation_sessions es ON es.candidate_id = c.id
JOIN battery_types       bt ON bt.id = es.battery_type_id
LEFT JOIN evaluation_results er ON er.session_id = es.id
ORDER BY es.created_at DESC;

-- Vista: detalle de respuestas por sesión
CREATE OR REPLACE VIEW v_session_answers AS
SELECT
    es.id                   AS session_id,
    c.full_name             AS candidate_name,
    bs.name                 AS section_name,
    q.sort_order            AS question_order,
    q.text                  AS question_text,
    qo.text                 AS selected_option,
    ca.score_obtained,
    ca.answered_at
FROM candidate_answers ca
JOIN evaluation_sessions es ON es.id = ca.session_id
JOIN candidates          c  ON c.id  = es.candidate_id
JOIN questions           q  ON q.id  = ca.question_id
JOIN battery_sections    bs ON bs.id = q.section_id
LEFT JOIN question_options qo ON qo.id = ca.option_id
ORDER BY es.id, bs.sort_order, q.sort_order;

-- ═══════════════════════════════════════════════════════════════════════════════
--  FIN DEL SCRIPT
-- ═══════════════════════════════════════════════════════════════════════════════
