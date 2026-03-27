 

SELECT
    bs.id              AS seccion_id,
    bs.code            AS seccion_code,
    bs.name            AS seccion_nombre,
    bs.time_minutes    AS tiempo_min,
    bs.sort_order      AS seccion_orden,

    q.id               AS pregunta_id,
    q.sort_order       AS pregunta_orden,
    q.question_type    AS tipo,
    q.text             AS pregunta,
    q.trait            AS rasgo_bf,
    q.direction        AS direccion_bf,
    q.has_check        AS es_verificacion,

    qo.id              AS opcion_id,
    qo.sort_order      AS opcion_orden,
    qo.text            AS opcion_texto,
    qo.score           AS puntaje

FROM battery_types bt
    INNER JOIN battery_sections bs  ON bs.battery_type_id = bt.id
    INNER JOIN questions        q   ON q.section_id       = bs.id
    INNER JOIN question_options qo  ON qo.question_id     = q.id

WHERE bt.clave = 1040

ORDER BY
    bs.sort_order,
    q.sort_order,
    qo.sort_order;

 
DROP PROCEDURE IF EXISTS sp_get_battery;
CREATE PROCEDURE sp_get_battery(
    IN p_json JSON
)
BEGIN
    DECLARE v_clave INT;

    SET v_clave = JSON_VALUE(p_json, '$.clave');

    IF v_clave IS NULL THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'El parámetro "clave" es requerido';
    END IF;

    SELECT
      bs.time_minutes    AS tiempo_min,
      q.id               AS pregunta_id,
      q.question_type    AS tipo,
      q.text             AS pregunta,
      qo.id              AS opcion_id,
      qo.text            AS opcion_texto,
      qo.score           AS puntaje
    FROM battery_types bt
        INNER JOIN battery_sections bs  ON bs.battery_type_id = bt.id
        INNER JOIN questions        q   ON q.section_id       = bs.id
        INNER JOIN question_options qo  ON qo.question_id     = q.id

    WHERE bt.clave = v_clave

    ORDER BY
        bs.sort_order,
        q.sort_order,
        qo.sort_order;

END;

 
DROP PROCEDURE IF EXISTS almacenaRespuestas;
CREATE PROCEDURE almacenaRespuestas(IN p_json JSON)
BEGIN
    DECLARE v_error BOOL DEFAULT FALSE;

    -- Manejo de errores
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
    SET v_error = TRUE;

    -- Insert masivo desde JSON
    INSERT INTO candidate_answers (
        candidato_id,
        battery_code,
        pregunta_id,
        opcion_id,
        puntaje
    )
    SELECT 
        jt.candidato_id,
        jt.battery_code,
        jt.pregunta_id,
        jt.opcion_id,
        jt.puntaje
    FROM JSON_TABLE(p_json, '$[*]'
        COLUMNS (
            candidato_id INT PATH '$.candidato_id',
            battery_code INT PATH '$.battery_code',
            pregunta_id INT PATH '$.pregunta_id',
            opcion_id INT PATH '$.opcion_id',
            puntaje INT PATH '$.puntaje'
        )
    ) AS jt;

    -- Resultado
    IF v_error THEN
        SELECT 0 AS ok, 'Error al insertar respuestas' AS mensaje;
    ELSE
        SELECT 1 AS ok, 'Todo bien' AS mensaje;
    END IF;

END;


 