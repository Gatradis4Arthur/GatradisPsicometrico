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

    <!-- TÍTULO 10% -->
    <h5 id="titulo"
        class="h-[10%] overflow-hidden flex items-center justify-center text-gray-600 font-semibold">
        EVALUACIÓN PSICOMÉTRICA
    </h5>

    <!-- INDICACIONES 25% -->
    <div id="indicaciones"
        class="h-[25%] overflow-hidden flex items-center justify-center px-6 w-[100%] md:w-[80%] lg:w-[70%] mx-auto">
        <p class="text-gray-500 text-justify leading-relaxed">
            Bienvenido al portal de evaluaciones psicométricas. Para acceder a tu evaluación, 
            ingresa el <span class="text-gray-700 font-semibold">código proporcionado</span> por 
            el departamento de <span class="text-gray-700 font-semibold">Recursos Humanos</span> 
            y presiona el botón <span class="text-gray-700 font-semibold">Ingresar</span>.
        </p>
    </div>

    <!-- SUBTÍTULO 15% -->
    <p id="subtitulo"
    class="h-[15%] overflow-hidden flex items-center justify-center text-gray-400 text-center italic px-6 leading-relaxed">
        🔒 La información ingresada es estrictamente confidencial y será utilizada 
        únicamente con fines de evaluación.
    </p>

    <div class="h-[30%] w-full flex justify-center items-center">
        
        <form id="formCodigo" autocomplete="off"
        class="w-[60%] md:w-[50%] lg:w-[40%] flex flex-col justify-center items-center space-y-4">

            <input
                type="text"
                id="codigo"
                name="codigo"
                placeholder="Código"
                maxlength="4"
                autocomplete="off"
                class="w-full border border-gray-300 rounded-lg p-3 text-center text-lg focus:outline-none focus:ring-2 focus:ring-gray-800"
            >

            <button 
                type="submit"
                id="btn_ingresar"
                class="w-full bg-gray-900 text-white py-3 rounded-lg text-lg hover:bg-black transition">
                Ingresar
            </button>

        </form>

    </div>

</div>

<script src="assets/js/app.js"></script>

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
        ajustarFuente('titulo',       getTamano(17, 16, 17), 7);
        ajustarFuente('indicaciones', getTamano(14, 12, 15), 8);
        ajustarFuente('subtitulo',    getTamano(12, 12, 14), 8);
    }

    window.addEventListener('load',   ajustarTodo);
    window.addEventListener('resize', ajustarTodo);
</script>

</body>
</html>

 