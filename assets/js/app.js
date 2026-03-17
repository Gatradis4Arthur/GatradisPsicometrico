document.addEventListener("DOMContentLoaded", () => {

    const form = document.getElementById("formCodigo");
    const inputCodigo = document.getElementById("codigo");

    form.addEventListener("submit", (e) => {

        e.preventDefault();

        const codigo = inputCodigo.value.trim();

        if (codigo.length < 4) {
            Swal.fire({
                icon: "warning",
                title: "Código inválido",
                text: "El código que ingresaste no existe. Verifica e intenta nuevamente."
            });
            return;
        }

        Swal.fire({
            icon: "success",
            title: "¡Bienvenido!",
            text: "La evaluación está por comenzar.",
            timer: 4500,
            showConfirmButton: false
        }).then(() => {

            // guardar código en sesión del navegador
            sessionStorage.setItem("codigoEvaluacion", codigo);

            // redirección
            window.location.href = "evaluacion.php";

        });

    });

});