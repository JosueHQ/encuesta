<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ include file="backend/consultas_titulo.jsp" %>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title><%= titulo %></title> <!-- ya existe -->
    <link rel="stylesheet" href="css/estilo.css">
</head>
<body>
    <div class="contenedor">
        <div class="icono">
            <img src="img/verificar.png" alt="Verificado" class="icono-img">
        </div>
        <h2><%= titulo %></h2>
        <p class="descripcion"><%= descripcion %></p>
        <a href="jsp/formulario.jsp?idEncuesta=<%= idEncuesta %>" class="boton">Iniciar Encuesta</a>
    </div>
</body>
</html>
