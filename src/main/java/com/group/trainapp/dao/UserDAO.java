package com.group.trainapp.dao;

import com.group.trainapp.model.Role;
import com.group.trainapp.model.User;
import com.group.trainapp.util.DatabaseConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class UserDAO {

    public User checkLogin(String username, String password) {
        String sql = "SELECT u.*, r.name as role_name FROM users u " +
                "JOIN roles r ON u.role_id = r.id " +
                "WHERE u.username = ? AND u.password = ?";

        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, username);
            ps.setString(2, password); // Note: Plain text password as per initial setup. Should be hashed in
                                       // production.

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    User user = new User();
                    user.setId(rs.getInt("id"));
                    user.setUsername(rs.getString("username"));
                    user.setFullName(rs.getString("full_name"));
                    user.setRoleId(rs.getInt("role_id"));

                    Role role = new Role();
                    role.setId(rs.getInt("role_id"));
                    role.setName(rs.getString("role_name"));
                    user.setRole(role);

                    return user;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
}
