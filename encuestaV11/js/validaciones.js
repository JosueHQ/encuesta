

// Validación de campo edad
function aplicarValidacionEdad() {
    const camposEdad = document.querySelectorAll(".campo-edad");
    camposEdad.forEach(input => {
        input.setAttribute("pattern", "[0-9]{1,3}");
        input.setAttribute("maxlength", "3");
        input.setAttribute("inputmode", "numeric");
        input.setAttribute("required", "required");
        input.setAttribute("title", "Por favor, introduce solo números del 0 al 120");

        input.oninvalid = function () {
            this.setCustomValidity("❌ Solo números del 0 al 120");
        };
        input.oninput = function () {
            this.setCustomValidity("");
        };

        input.addEventListener("blur", function () {
            const valor = parseInt(this.value);
            if (!isNaN(valor) && (valor < 0 || valor > 120)) {
                this.setCustomValidity("❌ El número debe estar entre 0 y 120");
                this.reportValidity();
            } else {
                this.setCustomValidity("");
            }
        });
    });
}

document.addEventListener("DOMContentLoaded", aplicarValidacionEdad);

// Mayúsculas en textarea
function aplicarMayusculasTextarea() {
    const areas = document.querySelectorAll("textarea.mayuscula");
    areas.forEach(textarea => {
        textarea.addEventListener("input", function () {
            this.value = this.value.toUpperCase();
        });
    });
}

document.addEventListener("DOMContentLoaded", aplicarMayusculasTextarea);

// Mostrar campo "Otros"
function normalizarTexto(texto) {
    return texto
        .normalize("NFD")                          // separa acentos
        .replace(/[\u0300-\u036f]/g, "")           // elimina acentos
        .replace(/\s+/g, " ")                      // colapsa espacios/saltos
        .trim()
        .toLowerCase();
}

function mostrarCampoOtro(idPregunta, esOtros, esCheckbox) {
    const campo = document.getElementById("otro_" + idPregunta);
    if (!campo) return;

    let mostrar = false;

    if (esCheckbox) {
        const checkboxes = document.querySelectorAll(`input[name='idOpcion_${idPregunta}[]']`);
        checkboxes.forEach(cb => {
            const texto = normalizarTexto(cb.parentNode.textContent);
            if (
                cb.checked &&
                (
                    texto === "si" ||
                    texto === "otro" ||
                    texto === "otros" ||
                    texto === "otro grupo" ||
                    texto === "no me identifico con ninguno de los dos" ||
                    texto === "prefiero no decirlo"
                    //texto === "indigena" 
                )
            ) {
                mostrar = true;
            }
        });
    } else {
        mostrar = (esOtros === "si");
    }

    campo.style.display = mostrar ? "block" : "none";

    const textarea = campo.querySelector("textarea");
    if (textarea) {
        if (mostrar) {
            textarea.setAttribute("required", "required");
        } else {
            textarea.removeAttribute("required");
            textarea.value = "";
        }
    }
}




