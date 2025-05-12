<%@ include file="parametro_url.jsp" %>
<%@ include file="parametro_user.jsp" %>
<%@ include file="parametro_pass.jsp" %>
<%@ page import="java.sql.*" %>

<%
if (request.getAttribute("conn") == null) {
    try {
        Connection conTemp = DriverManager.getConnection(
            (String) request.getAttribute("url"),
            (String) request.getAttribute("user"),
            (String) request.getAttribute("pass")
        );
        request.setAttribute("conn", conTemp);
    } catch (Exception e) {
        out.println("<p style='color:red;'>❌ Error al conectar: " + e.getMessage() + "</p>");
    }
}
%>
