<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="java.util.*" %>
<%@ page import="java.text.Normalizer" %>
<%@ include file="../backend/consultas_titulo.jsp" %>
<%@ include file="../backend/consultas_preguntas.jsp" %>

<%!
public static String normalizar(String texto) {
    if (texto == null) return "";
    return Normalizer.normalize(texto, Normalizer.Form.NFD)
                     .replaceAll("[^\\p{ASCII}]", "")
                     .toLowerCase()
                     .replaceAll("\\s+", "");
}

public static boolean esOpcionOtro(String textoOpcion) {
    if (textoOpcion == null) return false;
    String texto = Normalizer.normalize(textoOpcion, Normalizer.Form.NFD)
                  .replaceAll("[^\\p{ASCII}]", "")
                  .toLowerCase()
                  .replaceAll("\\s+", " ")
                  .trim();

    return texto.equals("si") ||
           texto.equals("otro") ||
           texto.equals("otros") ||
           texto.equals("otro grupo") ||
           texto.equals("no me identifico con ninguno de los dos") ||
           texto.equals("prefiero no decirlo");
}
%>

<%
    String idEncuestaParam = request.getParameter("idEncuesta");
    if (idEncuestaParam == null || idEncuestaParam.trim().isEmpty()) {
        Object attr = request.getAttribute("idEncuesta");
        if (attr != null) {
            idEncuestaParam = attr.toString();
        } else {
            idEncuestaParam = "1"; // valor por defecto
        }
    }

    String token = (String) session.getAttribute("tokenEncuesta");
    if (token == null || token.trim().isEmpty()) {
        token = UUID.randomUUID().toString();
        session.setAttribute("tokenEncuesta", token);
    }

    if (session.getAttribute("tokenEncuesta") == null) {
        response.sendRedirect("inicio.jsp?idEncuesta=" + idEncuestaParam);
        return;
    }
%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title><%= request.getAttribute("titulo") %></title>
    <link rel="stylesheet" href="../css/prueba.css">
    <script src="../js/validaciones.js" defer></script>
</head>
<body>

<form method="post" action="../backend/guardar_respuestas.jsp">
    <div class="container">
        <div class="left">
            <h2 class="titulo"><%= request.getAttribute("titulo") %></h2>
            <p class="descripcion"><%= request.getAttribute("descripcion") %></p>

            <input type="hidden" name="idEncuesta" value="<%= idEncuestaParam %>"/>
            <input type="hidden" name="token" value="<%= token %>"/>

            <%
            List<Map<String, Object>> preguntas = (List<Map<String, Object>>) request.getAttribute("listaPreguntas");
            if (preguntas != null) {
                for (Map<String, Object> pregunta : preguntas) {
                    int idPregunta = (Integer) pregunta.get("idPregunta");
                    String textoPregunta = (String) pregunta.get("textoPregunta");
                    int tipo = (Integer) pregunta.get("tipo");
            %>
            <div class="pregunta">
                <%= textoPregunta %>
            </div>
            <input type="hidden" name="idPregunta" value="<%= idPregunta %>"/>
            <input type="hidden" name="textoPregunta_<%= idPregunta %>" value="<%= textoPregunta %>"/>

            <%
            String textoPreguntaMin = normalizar(textoPregunta);
            if (tipo == 1) {
                if (textoPreguntaMin.contains("cuantosanostienes") || textoPreguntaMin.contains("edad")) {
            %>
                <input type="text" name="idRespuesta_<%= idPregunta %>" 
                       class="campo-edad mayuscula"
                       placeholder="Solo n&uacute;meros (0-120)"
                       pattern="[0-9]{1,3}" maxlength="3"
                       inputmode="numeric" required
                       title="Por favor, introduce solo números del 0 al 120">
            <%
                } else {
            %>
                <textarea name="idRespuesta_<%= idPregunta %>" rows="3" cols="50" class="mayuscula" required></textarea>
            <%
                }
            } else {
                List<Map<String, Object>> opciones = (List<Map<String, Object>>) pregunta.get("opciones");
                for (Map<String, Object> opcion : opciones) {
                    int idOpcion = (Integer) opcion.get("idOpcion");
                    String textoOpcion = (String) opcion.get("textoOpcion");

                    boolean mostrarCampo = esOpcionOtro(textoOpcion);
                    String mostrarComoTexto = mostrarCampo ? "si" : "no";
            %>
                <label>
                    <input type="<%= tipo == 2 ? "radio" : "checkbox" %>"
                           name="idOpcion_<%= idPregunta %><%= tipo == 3 ? "[]" : "" %>"
                           value="<%= idOpcion %>"
                           <%= tipo == 2 ? "required" : "" %>
                           onclick="mostrarCampoOtro(<%= idPregunta %>, '<%= mostrarComoTexto %>', <%= tipo == 3 %>)" />
                    <%= textoOpcion %>
                </label><br>
                <% if (mostrarCampo) { %>
                    <div id="otro_<%= idPregunta %>" style="display:none; margin-top: 5px;">
                        <textarea name="otro_<%= idPregunta %>" rows="2" cols="50" placeholder="Especifique otro..." class="mayuscula"></textarea>
                    </div>
                <% } %>
            <%
                }
            }
                }
            }
            %>

            <br>
            <div class="boton-centro">
                <button type="submit" class="boton">Enviar respuestas</button>
            </div>
        </div>

        <%
            String nombreImagen = "encuesta" + idEncuestaParam + ".png";  
        %>
        <div class="right">
            <img src="../img/<%= nombreImagen %>" alt="Imagen encuesta" class="logo-img" />
        </div>

        <div id="bloqueo-mensaje" style="display:none; background-color: #f8d7da; color: #721c24; border: 1px solid #f5c6cb; padding: 15px; margin: 20px; border-radius: 5px;">
            <h2>No puedes regresar al inicio.</h2>
            <p>El bot&oacute;n "Atr&aacute;s" del navegador est&aacute; bloqueado <br>para evitar el reenv&iacute;o de datos.</p>
        </div>
    </div>
</form>

<script>
    if (window.history && window.history.pushState) {
        window.history.pushState(null, "", window.location.href);
        window.onpopstate = function () {
            const mensaje = document.getElementById("bloqueo-mensaje");
            if (mensaje) mensaje.style.display = "block";
            window.history.pushState(null, "", window.location.href);
        };
    }

    const form = document.querySelector("form");
    form.addEventListener("submit", function (e) {
        if (!form.checkValidity()) {
            e.preventDefault();
            alert("Por favor, completa todos los campos correctamente.");
        }
    });
</script>

</body>
</html>
