<%@ page import="java.sql.*, java.util.*" %>
<%@ include file="../modelo/conexion.jsp" %>

<%
PreparedStatement stmtPreguntas = null;
ResultSet rsPreguntas = null;

List<Map<String, Object>> listaPreguntas = new ArrayList<>();

try {
    String sql = "SELECT * FROM \"tc_pregunta\" WHERE \"n_estatus\" = 1 AND \"n_idencuesta\" = ? ORDER BY \"n_orden\"";
    stmtPreguntas = conn.prepareStatement(sql);
    stmtPreguntas.setInt(1, ((Integer) request.getAttribute("idEncuesta"))); // ✅ Sin declarar otra vez
    rsPreguntas = stmtPreguntas.executeQuery();

    while (rsPreguntas.next()) {
        Map<String, Object> pregunta = new HashMap<>();
        int idPregunta = rsPreguntas.getInt("n_idpregunta");
        String textoPregunta = rsPreguntas.getString("s_pregunta");
        int tipo = rsPreguntas.getInt("n_idtipopregunta");

        pregunta.put("idPregunta", idPregunta);
        pregunta.put("textoPregunta", textoPregunta);
        pregunta.put("tipo", tipo);

        List<Map<String, Object>> opciones = new ArrayList<>();
        if (tipo == 2 || tipo == 3) {
            PreparedStatement stmtResp = conn.prepareStatement("SELECT * FROM \"tc_respuesta\" WHERE \"n_idpregunta\" = ?");
            stmtResp.setInt(1, idPregunta);
            ResultSet rsResp = stmtResp.executeQuery();
            while (rsResp.next()) {
                Map<String, Object> opcion = new HashMap<>();
                opcion.put("idOpcion", rsResp.getInt("n_idrespuesta"));
                opcion.put("textoOpcion", rsResp.getString("s_respuesta"));
                opciones.add(opcion);
            }
            rsResp.close();
            stmtResp.close();
        }

        pregunta.put("opciones", opciones);
        listaPreguntas.add(pregunta);
    }
} catch (Exception e) {
    out.println("<p style='color:red;'>❌ Error al cargar preguntas: " + e.getMessage() + "</p>");
} finally {
    if (rsPreguntas != null) rsPreguntas.close();
    if (stmtPreguntas != null) stmtPreguntas.close();
}

request.setAttribute("listaPreguntas", listaPreguntas);
%>
