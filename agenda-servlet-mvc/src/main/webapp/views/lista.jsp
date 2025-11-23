<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Agenda de Contactos</title>
    <style>
        * { box-sizing: border-box; }
        body { font-family: Arial, sans-serif; margin: 20px; background: #f5f5f5; }
        .container { max-width: 800px; margin: 0 auto; background: white; padding: 20px; border-radius: 8px; box-shadow: 0 2px 4px rgba(0,0,0,0.1); }
        h1 { color: #333; border-bottom: 2px solid #007bff; padding-bottom: 10px; }
        .btn { display: inline-block; padding: 8px 16px; text-decoration: none; border-radius: 4px; margin: 2px; cursor: pointer; border: none; font-size: 14px; }
        .btn-primary { background: #007bff; color: white; }
        .btn-warning { background: #ffc107; color: #333; }
        .btn-danger { background: #dc3545; color: white; }
        .btn:hover { opacity: 0.8; }
        table { width: 100%; border-collapse: collapse; margin-top: 20px; }
        th, td { padding: 12px; text-align: left; border-bottom: 1px solid #ddd; }
        th { background: #007bff; color: white; }
        tr:hover { background: #f1f1f1; }
        .acciones { white-space: nowrap; }
        .empty { text-align: center; padding: 40px; color: #666; }
        .mensaje { padding: 10px 15px; border-radius: 4px; margin-bottom: 15px; display: none; }
        .mensaje.exito { background: #d4edda; color: #155724; display: block; }
        .mensaje.error { background: #f8d7da; color: #721c24; display: block; }
    </style>
</head>
<body>
<div class="container">
    <h1>📒 Agenda de Contactos</h1>

    <div id="mensaje" class="mensaje"></div>

    <a href="${pageContext.request.contextPath}/contactos?accion=nuevo" class="btn btn-primary">
        + Nuevo Contacto
    </a>

    <c:choose>
        <c:when test="${empty contactos}">
            <p class="empty">No hay contactos registrados.</p>
        </c:when>
        <c:otherwise>
            <table>
                <thead>
                <tr>
                    <th>ID</th>
                    <th>Nombre</th>
                    <th>Email</th>
                    <th>Teléfono</th>
                    <th>Acciones</th>
                </tr>
                </thead>
                <tbody id="tablaContactos">
                <c:forEach var="c" items="${contactos}">
                    <tr id="fila-${c.id}">
                        <td>${c.id}</td>
                        <td>${c.nombre}</td>
                        <td>${c.email}</td>
                        <td>${c.telefono}</td>
                        <td class="acciones">
                            <a href="${pageContext.request.contextPath}/contactos?accion=editar&id=${c.id}"
                               class="btn btn-warning">Editar</a>
                            <button class="btn btn-danger" onclick="eliminar(${c.id})">
                                Eliminar
                            </button>
                        </td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </c:otherwise>
    </c:choose>
</div>

<script>
    function eliminar(id) {
        if (!confirm('¿Está seguro de eliminar este contacto?')) {
            return;
        }

        fetch('${pageContext.request.contextPath}/contactos/' + id, {
            method: 'DELETE'
        })
            .then(response => response.json())
            .then(data => {
                const msg = document.getElementById('mensaje');
                if (data.success) {
                    // Eliminar fila de la tabla
                    document.getElementById('fila-' + id).remove();
                    msg.className = 'mensaje exito';
                    msg.textContent = data.message;
                } else {
                    msg.className = 'mensaje error';
                    msg.textContent = data.message;
                }
                // Ocultar mensaje después de 3 segundos
                setTimeout(() => msg.className = 'mensaje', 3000);
            })
            .catch(error => {
                console.error('Error:', error);
                alert('Error al eliminar el contacto');
            });
    }
</script>
</body>
</html>