<%@ page import="java.sql.*" %>
<%@ include file="../modelo/conexion.jsp" %>

<%
Connection conn = (Connection) request.getAttribute("conn");
PreparedStatement stmtInsert = null;
boolean exito = false;

try {
    int idEncuesta = Integer.parseInt(request.getParameter("idEncuesta"));
    String token = request.getParameter("token");
    String sessionToken = (String) session.getAttribute("tokenEncuesta");

    // Validar token (evitar reenvío)
    if (sessionToken == null || !sessionToken.equals(token)) {
        response.sendRedirect("../jsp/gracias.jsp?idEncuesta=" + idEncuesta + "&exito=false");
        return;
    }

    // Invalidar token
    session.removeAttribute("tokenEncuesta");

    String[] preguntas = request.getParameterValues("idPregunta");

    if (preguntas != null && token != null && !token.trim().isEmpty()) {
        for (String pregunta : preguntas) {
            int idPregunta = Integer.parseInt(pregunta);
            String[] idOpciones = request.getParameterValues("idOpcion_" + idPregunta);
            String respuestaAbierta = request.getParameter("idRespuesta_" + idPregunta);
            String respuestaOtro = request.getParameter("otro_" + idPregunta);

            // Si es múltiple selección
            if (idOpciones != null && idOpciones.length > 0) {
                for (String idOpcionStr : idOpciones) {
                    stmtInsert = conn.prepareStatement(
                        "INSERT INTO \"tw_resultados\" (\"n_idencuesta\", \"n_idpregunta\", \"n_idrespuesta\", \"s_respuestaabierta\", \"s_sesion\") VALUES (?, ?, ?, ?, ?)"
                    );
                    stmtInsert.setInt(1, idEncuesta);
                    stmtInsert.setInt(2, idPregunta);
                    stmtInsert.setInt(3, Integer.parseInt(idOpcionStr));
                    stmtInsert.setString(4, (respuestaOtro != null && !respuestaOtro.trim().isEmpty()) ? respuestaOtro.trim() : null);
                    stmtInsert.setString(5, token);
                    stmtInsert.executeUpdate();
                    stmtInsert.close();
                }
            } else {
                stmtInsert = conn.prepareStatement(
                    "INSERT INTO \"tw_resultados\" (\"n_idencuesta\", \"n_idpregunta\", \"n_idrespuesta\", \"s_respuestaabierta\", \"s_sesion\") VALUES (?, ?, ?, ?, ?)"
                );
                stmtInsert.setInt(1, idEncuesta);
                stmtInsert.setInt(2, idPregunta);
                stmtInsert.setNull(3, java.sql.Types.INTEGER);
                stmtInsert.setString(4, (respuestaAbierta != null && !respuestaAbierta.trim().isEmpty()) ? respuestaAbierta.trim() : null);
                stmtInsert.setString(5, token);
                stmtInsert.executeUpdate();
                stmtInsert.close();
            }
        }

        exito = true;
    }
} catch (Exception e) {
    e.printStackTrace();
    exito = false;
} finally {
    try { if (stmtInsert != null) stmtInsert.close(); } catch (Exception ignored) {}
    try { if (conn != null) conn.close(); } catch (Exception ignored) {}
}

// Redirigir al final
response.sendRedirect("../jsp/gracias.jsp?idEncuesta=" + request.getParameter("idEncuesta") + "&exito=" + exito);
%>
