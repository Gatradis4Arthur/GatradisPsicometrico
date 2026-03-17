<!DOCTYPE html>
<html lang="es">

<head>

<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">

<title>Evaluación Psicométrica</title>

<script src="https://cdn.jsdelivr.net/npm/@tailwindcss/browser@4"></script>
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

</head>

<body class="min-h-screen flex items-center justify-center bg-gray-100">

<div class="bg-white shadow-lg rounded-xl p-6 
            w-[80%] md:w-[70%] lg:w-[60%] 
            h-[85vh] md:h-[70vh] lg:h-[70vh] 
            flex flex-col justify-start text-center">

    <!-- LOGO 20% -->
    <div class="h-[20%] flex justify-center items-center">
        <img 
            src="assets/img/GatradisLogoFondoBlanco.png"
            class="h-full object-contain"
            alt="Logo">
    </div>

 
    <!-- INDICACIONES 65% -->
    <div id="indicaciones"
        class="h-[65%] overflow-hidden flex items-center justify-center px-6 w-[100%] md:w-[80%] lg:w-[80%] mx-auto">

        <div class="space-y-3 text-gray-700 text-sm md:text-base">

            <div class="flex items-start gap-3">
                <span class="text-lg">📵</span>
                <span>Silencia tu teléfono y busca un lugar tranquilo sin distracciones.</span>
            </div>

            <div class="flex items-start gap-3">
                <span class="text-lg">🖥</span>
                <span>Asegúrate de tener una conexión estable a internet durante toda la prueba.</span>
            </div>

            <div class="flex items-start gap-3">
                <span class="text-lg">✅</span>
                <span>Responde con sinceridad. <strong>No hay respuestas correctas ni incorrectas</strong>.</span>
            </div>

            <div class="flex items-start gap-3">
                <span class="text-lg">⛔</span>
                <span>No cierres ni recargues el navegador una vez iniciada la evaluación.</span>
            </div>

            <div class="flex items-start gap-3">
                <span class="text-lg">🔂</span>
                <span>Cada pregunta debe responderse una sola vez. <strong>No podrás regresar.</strong></span>
            </div>

        </div>

    </div>


    <div class="h-[15%] w-full flex justify-center items-center">
        
        <form id="formCodigo" autocomplete="off"
        class="w-[60%] md:w-[50%] lg:w-[40%] flex flex-col justify-center items-center space-y-4">

            <button 
                type="submit"
                id="btn_ingresar"
                class="w-full bg-gray-900 text-white py-3 rounded-lg text-lg hover:bg-black transition">
                Continuar
            </button>

        </form>

    </div>

</div>

<script src="assets/js/evaluacion.js"></script>

<script>
    function ajustarFuente(id, tamanoInicial, tamanoMinimo) {
        const el = document.getElementById(id);
        let size = tamanoInicial;
        el.style.fontSize = size + 'px';
        while (el.scrollHeight > el.clientHeight && size > tamanoMinimo) {
            size--;
            el.style.fontSize = size + 'px';
        }
    }

    function getTamano(movil, tablet, desktop) {
        if (window.innerWidth < 768)  return movil;
        if (window.innerWidth < 1024) return tablet;
        return desktop;
    }

    function ajustarTodo() {
        ajustarFuente('indicaciones', getTamano(10, 12, 15), 8);
    }

    window.addEventListener('load',   ajustarTodo);
    window.addEventListener('resize', ajustarTodo);
</script>

</body>
</html>