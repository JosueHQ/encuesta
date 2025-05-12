<%@ page import="java.sql.*" %>
<%@ include file="../modelo/conexion.jsp" %>

<%
String idEncuestaStr = request.getParameter("idEncuesta");

// Si no viene idEncuesta, intenta recuperar idEncuesta
if (idEncuestaStr == null || idEncuestaStr.trim().isEmpty()) {
    idEncuestaStr = request.getParameter("idEncuesta");

    // Redirigir a versión uniforme con idEncuesta
    if (idEncuestaStr != null && !idEncuestaStr.trim().isEmpty()) {
        response.sendRedirect("inicio.jsp?idEncuesta=" + idEncuestaStr);
        return;
    }

    // Si no hay ningún parámetro válido, usar 1 por defecto
    idEncuestaStr = "1";
}

int idEncuesta = Integer.parseInt(idEncuestaStr);

// Variables por defecto
String titulo = "Encuesta";
String descripcion = "Gracias por participar.";

PreparedStatement stmt = null;
ResultSet rs = null;
Connection conn = (Connection) request.getAttribute("conn");

try {
    String sql = "SELECT \"s_nombre\", \"s_descripcion\" FROM \"tc_encuesta\" WHERE \"n_idencuesta\" = ?";
    stmt = conn.prepareStatement(sql);
    stmt.setInt(1, idEncuesta);
    rs = stmt.executeQuery();

    if (rs.next()) {
        titulo = rs.getString("s_nombre");
        descripcion = rs.getString("s_descripcion");
    }
} catch (Exception e) {
    out.println("<p style='color:red;'>❌ Error al cargar título: " + e.getMessage() + "</p>");
} finally {
    try { if (rs != null) rs.close(); } catch (Exception ignored) {}
    try { if (stmt != null) stmt.close(); } catch (Exception ignored) {}
}

// Asignar los atributos para que inicio.jsp los pueda usar
request.setAttribute("titulo", titulo);
request.setAttribute("descripcion", descripcion);
request.setAttribute("idEncuesta", idEncuesta);
%>
