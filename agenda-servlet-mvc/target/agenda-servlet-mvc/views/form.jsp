<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${empty contacto ? 'Nuevo' : 'Editar'} Contacto</title>
    <style>
        * { box-sizing: border-box; }
        body { font-family: Arial, sans-serif; margin: 20px; background: #f5f5f5; }
        .container { max-width: 500px; margin: 0 auto; background: white; padding: 30px; border-radius: 8px; box-shadow: 0 2px 4px rgba(0,0,0,0.1); }
        h1 { color: #333; border-bottom: 2px solid #007bff; padding-bottom: 10px; margin-top: 0; }
        .form-group { margin-bottom: 20px; }
        label { display: block; margin-bottom: 5px; font-weight: bold; color: #555; }
        input[type="text"], input[type="email"], input[type="tel"] {
            width: 100%; padding: 10px; border: 1px solid #ddd; border-radius: 4px; font-size: 16px;
        }
        input:focus { outline: none; border-color: #007bff; box-shadow: 0 0 0 2px rgba(0,123,255,0.25); }
        .btn { display: inline-block; padding: 10px 20px; text-decoration: none; border-radius: 4px; cursor: pointer; border: none; font-size: 16px; }
        .btn-primary { background: #007bff; color: white; }
        .btn-secondary { background: #6c757d; color: white; }
        .btn:hover { opacity: 0.8; }
        .actions { margin-top: 20px; display: flex; gap: 10px; }
        .mensaje { padding: 10px 15px; border-radius: 4px; margin-bottom: 15px; display: none; }
        .mensaje.exito { background: #d4edda; color: #155724; display: block; }
        .mensaje.error { background: #f8d7da; color: #721c24; display: block; }
    </style>
</head>
<body>
<div class="container">
    <h1>${empty contacto ? '➕ Nuevo' : '✏️ Editar'} Contacto</h1>

    <div id="mensaje" class="mensaje"></div>

    <form id="formContacto">
        <c:if test="${not empty contacto}">
            <input type="hidden" id="id" name="id" value="${contacto.id}">
        </c:if>

        <div class="form-group">
            <label for="nombre">Nombre:</label>
            <input type="text" id="nombre" name="nombre"
                   value="${contacto.nombre}" required
                   placeholder="Ingrese el nombre">
        </div>

        <div class="form-group">
            <label for="email">Email:</label>
            <input type="email" id="email" name="email"
                   value="${contacto.email}"
                   placeholder="ejemplo@correo.com">
        </div>

        <div class="form-group">
            <label for="telefono">Teléfono:</label>
            <input type="tel" id="telefono" name="telefono"
                   value="${contacto.telefono}"
                   placeholder="(123) 456-7890">
        </div>

        <div class="actions">
            <button type="submit" class="btn btn-primary">
                ${empty contacto ? 'Guardar' : 'Actualizar'}
            </button>
            <a href="${pageContext.request.contextPath}/contactos" class="btn btn-secondary">
                Cancelar
            </a>
        </div>
    </form>
</div>

<script>
    document.getElementById('formContacto').addEventListener('submit', function(e) {
        e.preventDefault();

        const idField = document.getElementById('id');
        const esEdicion = idField !== null;

        const datos = new URLSearchParams();
        if (esEdicion) datos.append('id', idField.value);
        datos.append('nombre', document.getElementById('nombre').value);
        datos.append('email', document.getElementById('email').value);
        datos.append('telefono', document.getElementById('telefono').value);

        fetch('${pageContext.request.contextPath}/contactos', {
            method: esEdicion ? 'PUT' : 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded'
            },
            body: datos.toString()
        })
            .then(response => response.json())
            .then(data => {
                const msg = document.getElementById('mensaje');
                if (data.success) {
                    msg.className = 'mensaje exito';
                    msg.textContent = data.message;
                    // Redirigir después de 1 segundo
                    setTimeout(() => {
                        window.location.href = '${pageContext.request.contextPath}/contactos';
                    }, 1000);
                } else {
                    msg.className = 'mensaje error';
                    msg.textContent = data.message;
                }
            })
            .catch(error => {
                console.error('Error:', error);
                alert('Error al procesar la solicitud');
            });
    });
</script>
</body>
</html>