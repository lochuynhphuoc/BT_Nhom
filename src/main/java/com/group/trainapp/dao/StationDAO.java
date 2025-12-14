package com.group.trainapp.dao;

import com.group.trainapp.model.Station;
import com.group.trainapp.util.DatabaseConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class StationDAO {

    public List<Station> getAllStations() {
        List<Station> stations = new ArrayList<>();
        String sql = "SELECT * FROM stations";

        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                stations.add(new Station(
                        rs.getInt("id"),
                        rs.getString("name"),
                        rs.getString("city")));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return stations;
    }

    public List<Station> searchStations(String keyword) {
        List<Station> stations = new ArrayList<>();
        String sql = "SELECT * FROM stations WHERE id LIKE ? OR name LIKE ? OR city LIKE ?";

        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            String query = "%" + keyword + "%";
            ps.setString(1, query);
            ps.setString(2, query);
            ps.setString(3, query);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    stations.add(new Station(
                            rs.getInt("id"),
                            rs.getString("name"),
                            rs.getString("city")));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return stations;
    }

    public Station getStationById(int id) {
        String sql = "SELECT * FROM stations WHERE id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return new Station(
                            rs.getInt("id"),
                            rs.getString("name"),
                            rs.getString("city"));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public void addStation(Station station) {
        String sql = "INSERT INTO stations (name, city) VALUES (?, ?)";
        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, station.getName());
            ps.setString(2, station.getCity());
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public void updateStation(Station station) {
        String sql = "UPDATE stations SET name = ?, city = ? WHERE id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, station.getName());
            ps.setString(2, station.getCity());
            ps.setInt(3, station.getId());
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public void deleteStation(int id) {
        String sql = "DELETE FROM stations WHERE id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
