package com.ejemplo.agenda.web;

import com.ejemplo.agenda.dao.ContactoDAO;
import com.ejemplo.agenda.model.Contacto;
import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.WebServlet;
import java.io.IOException;
import java.io.BufferedReader;
import java.util.List;

@WebServlet("/contactos/*")
public class ContactoServlet extends HttpServlet {

    private ContactoDAO dao;

    @Override
    public void init() throws ServletException {
        dao = new ContactoDAO();
    }


    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String accion = req.getParameter("accion");
        if (accion == null) accion = "listar";

        switch (accion) {
            case "nuevo":
                mostrarFormulario(req, resp, null);
                break;
            case "editar":
                int id = Integer.parseInt(req.getParameter("id"));
                Contacto contacto = dao.buscarPorId(id);
                mostrarFormulario(req, resp, contacto);
                break;
            default:
                listar(req, resp);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");

        String nombre = req.getParameter("nombre");
        String email = req.getParameter("email");
        String telefono = req.getParameter("telefono");

        Contacto nuevo = new Contacto(nombre, email, telefono);
        boolean exito = dao.insertar(nuevo);

        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");
        resp.getWriter().write("{\"success\": " + exito + ", \"message\": \"" +
                (exito ? "Contacto creado" : "Error al crear") + "\"}");
    }

    // PUT - Actualizar contacto existente
    @Override
    protected void doPut(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");

        // Leer el cuerpo de la petición
        String body = leerBody(req);

        // Parsear parámetros manualmente (formato: id=1&nombre=Juan&...)
        int id = Integer.parseInt(obtenerParametro(body, "id"));
        String nombre = obtenerParametro(body, "nombre");
        String email = obtenerParametro(body, "email");
        String telefono = obtenerParametro(body, "telefono");

        Contacto contacto = new Contacto(id, nombre, email, telefono);
        boolean exito = dao.actualizar(contacto);

        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");
        resp.getWriter().write("{\"success\": " + exito + ", \"message\": \"" +
                (exito ? "Contacto actualizado" : "Error al actualizar") + "\"}");
    }


    @Override
    protected void doDelete(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {


        String pathInfo = req.getPathInfo();
        int id;

        if (pathInfo != null && pathInfo.length() > 1) {
            id = Integer.parseInt(pathInfo.substring(1));
        } else {
            id = Integer.parseInt(req.getParameter("id"));
        }

        boolean exito = dao.eliminar(id);

        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");
        resp.getWriter().write("{\"success\": " + exito + ", \"message\": \"" +
                (exito ? "Contacto eliminado" : "Error al eliminar") + "\"}");
    }


    private void listar(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        List<Contacto> contactos = dao.listar();
        req.setAttribute("contactos", contactos);
        req.getRequestDispatcher("/views/lista.jsp").forward(req, resp);
    }

    private void mostrarFormulario(HttpServletRequest req, HttpServletResponse resp,
                                   Contacto contacto) throws ServletException, IOException {
        req.setAttribute("contacto", contacto);
        req.getRequestDispatcher("/views/form.jsp").forward(req, resp);
    }

    private String leerBody(HttpServletRequest req) throws IOException {
        StringBuilder sb = new StringBuilder();
        try (BufferedReader reader = req.getReader()) {
            String linea;
            while ((linea = reader.readLine()) != null) {
                sb.append(linea);
            }
        }
        return sb.toString();
    }

    private String obtenerParametro(String body, String nombre) {
        for (String par : body.split("&")) {
            String[] kv = par.split("=");
            if (kv.length == 2 && kv[0].equals(nombre)) {
                return java.net.URLDecoder.decode(kv[1], java.nio.charset.StandardCharsets.UTF_8);
            }
        }
        return "";
    }
}