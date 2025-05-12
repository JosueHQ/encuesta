<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%
    // Obtener tipo de encuesta (valor por defecto = 1)
    String idEncuesta = request.getParameter("idEncuesta");
    if (idEncuesta == null || idEncuesta.trim().isEmpty()) {
    idEncuesta = "1"; // valor por defecto
}

    // Leer si fue exitoso el registro (ej. ?exito=true)
    String exitoParam = request.getParameter("exito");
    boolean exito = "true".equalsIgnoreCase(exitoParam);

    // Invalida sesión para evitar que vuelva a usar el token
    session.invalidate();

    // Evita que la página se cachee (mejor protección)
    response.setHeader("Cache-Control", "no-store, no-cache, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);
%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Gracias por participar</title>
    <link rel="stylesheet" href="../css/estilo.css">
    <link rel="stylesheet" href="../css/prueba.css">
</head>
<body>
    <div class="container">
        <div class="left">
            <div class="icono">
                <img src="../img/verificar.png" alt="Verificado" class="icono-img">
            </div>

            <% if (exito) { %>
                <h2 class="titulo">&iexcl;Gracias por tu participaci&oacute;n!</h2>
                <p class="subtitulo" style="text-align: center;">
                    Tus respuestas han sido registradas correctamente.<br>
                    Agradecemos tu tiempo y compromiso.
                </p>
            <% } else { %>
                <h2 class="titulo" style="color:red;">Hubo un problema</h2>
                <p class="subtitulo" style="text-align: center;">
                    ❌ Lo sentimos, no pudimos registrar tus respuestas.<br>
                    Por favor, intenta de nuevo más tarde.
                </p>
            <% } %>

            <div class="boton-centro" style="margin-top: 30px;">
                <a href="../inicio.jsp?idEncuesta=<%= idEncuesta %>" class="boton">Ir al inicio</a>
            </div>
        </div>
        <%
            String nombreImagen = "encuesta" + idEncuesta + ".png";
        %>
        <div class="right">
            <img src="../img/<%= nombreImagen %>" alt="Logo de agradecimiento" class="logo-img">
        </div>
    </div>

    <!-- Bloquear botón "Atrás" del navegador -->
    <script>
        if (window.history && window.history.pushState) {
            window.history.pushState(null, "", window.location.href);
            window.onpopstate = function () {
                alert("🚫 No puedes regresar al formulario.");
                window.history.pushState(null, "", window.location.href);
            };
        }
    </script>
</body>
</html>
