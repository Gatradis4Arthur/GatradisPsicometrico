const codigo = sessionStorage.getItem("codigoEvaluacion");

if(!codigo){
    window.location.href = "index.php";
}

console.log(codigo);