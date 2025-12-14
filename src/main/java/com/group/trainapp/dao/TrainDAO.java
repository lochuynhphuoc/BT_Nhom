package com.group.trainapp.dao;

import com.group.trainapp.model.Train;
import com.group.trainapp.util.DatabaseConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class TrainDAO {

    public List<Train> getAllTrains() {
        List<Train> trains = new ArrayList<>();
        String sql = "SELECT * FROM trains";

        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                trains.add(new Train(
                        rs.getInt("id"),
                        rs.getString("code"),
                        rs.getString("name"),
                        rs.getInt("total_seats")));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return trains;
    }

    public List<Train> searchTrains(String keyword) {
        List<Train> trains = new ArrayList<>();
        String sql = "SELECT * FROM trains WHERE id LIKE ? OR code LIKE ? OR name LIKE ? OR total_seats LIKE ?";

        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            String query = "%" + keyword + "%";
            ps.setString(1, query);
            ps.setString(2, query);
            ps.setString(3, query);
            ps.setString(4, query);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    trains.add(new Train(
                            rs.getInt("id"),
                            rs.getString("code"),
                            rs.getString("name"),
                            rs.getInt("total_seats")));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return trains;
    }

    public Train getTrainById(int id) {
        String sql = "SELECT * FROM trains WHERE id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return new Train(
                            rs.getInt("id"),
                            rs.getString("code"),
                            rs.getString("name"),
                            rs.getInt("total_seats"));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public void addTrain(Train train) {
        String sql = "INSERT INTO trains (code, name, total_seats) VALUES (?, ?, ?)";
        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, train.getCode());
            ps.setString(2, train.getName());
            ps.setInt(3, train.getTotalSeats());
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public void updateTrain(Train train) {
        String sql = "UPDATE trains SET code = ?, name = ?, total_seats = ? WHERE id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, train.getCode());
            ps.setString(2, train.getName());
            ps.setInt(3, train.getTotalSeats());
            ps.setInt(4, train.getId());
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public void deleteTrain(int id) {
        String sql = "DELETE FROM trains WHERE id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
