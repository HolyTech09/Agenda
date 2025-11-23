package com.ejemplo.agenda.dao;

import com.ejemplo.agenda.model.Contacto;
import com.ejemplo.agenda.util.DB;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ContactoDAO {

    public List<Contacto> listar() {
        List<Contacto> contactos = new ArrayList<>();
        String sql = "SELECT * FROM contactos ORDER BY nombre";
        
        try (Connection con = DB.getConnection();
             Statement stmt = con.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                contactos.add(mapear(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return contactos;
    }

    public Contacto buscarPorId(int id) {
        String sql = "SELECT * FROM contactos WHERE id = ?";
        
        try (Connection con = DB.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapear(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean insertar(Contacto c) {
        String sql = "INSERT INTO contactos (nombre, email, telefono) VALUES (?, ?, ?)";
        
        try (Connection con = DB.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setString(1, c.getNombre());
            ps.setString(2, c.getEmail());
            ps.setString(3, c.getTelefono());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean actualizar(Contacto c) {
        String sql = "UPDATE contactos SET nombre=?, email=?, telefono=? WHERE id=?";
        
        try (Connection con = DB.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setString(1, c.getNombre());
            ps.setString(2, c.getEmail());
            ps.setString(3, c.getTelefono());
            ps.setInt(4, c.getId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean eliminar(int id) {
        String sql = "DELETE FROM contactos WHERE id = ?";
        
        try (Connection con = DB.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    private Contacto mapear(ResultSet rs) throws SQLException {
        return new Contacto(
            rs.getInt("id"),
            rs.getString("nombre"),
            rs.getString("email"),
            rs.getString("telefono")
        );
    }
}