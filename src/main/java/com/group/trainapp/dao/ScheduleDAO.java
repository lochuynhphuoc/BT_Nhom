package com.group.trainapp.dao;

import com.group.trainapp.model.Schedule;
import com.group.trainapp.model.Station;
import com.group.trainapp.model.Train;
import com.group.trainapp.util.DatabaseConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ScheduleDAO {

    public List<Schedule> getAllSchedules() {
        List<Schedule> schedules = new ArrayList<>();
        String sql = "SELECT s.*, " +
                "t.name as train_name, t.code as train_code, t.total_seats, " +
                "(SELECT COALESCE(SUM(quantity), 0) FROM bookings WHERE schedule_id = s.id AND status != 'CANCELLED') as booked_seats, "
                +
                "st1.name as dep_name, st1.city as dep_city, " +
                "st2.name as arr_name, st2.city as arr_city " +
                "FROM schedules s " +
                "JOIN trains t ON s.train_id = t.id " +
                "JOIN stations st1 ON s.departure_station_id = st1.id " +
                "JOIN stations st2 ON s.arrival_station_id = st2.id " +
                "ORDER BY s.departure_time ASC";

        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                schedules.add(mapResultSetToSchedule(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return schedules;
    }

    public List<Schedule> searchSchedulesByKeyword(String keyword) {
        List<Schedule> schedules = new ArrayList<>();
        // Search by Train Name, Train Code, Route (Dep/Arr Station Name/City), Price
        String sql = "SELECT s.*, " +
                "t.name as train_name, t.code as train_code, t.total_seats, " +
                "(SELECT COALESCE(SUM(quantity), 0) FROM bookings WHERE schedule_id = s.id AND status != 'CANCELLED') as booked_seats, "
                +
                "st1.name as dep_name, st1.city as dep_city, " +
                "st2.name as arr_name, st2.city as arr_city " +
                "FROM schedules s " +
                "JOIN trains t ON s.train_id = t.id " +
                "JOIN stations st1 ON s.departure_station_id = st1.id " +
                "JOIN stations st2 ON s.arrival_station_id = st2.id " +
                "WHERE t.name LIKE ? OR t.code LIKE ? " +
                "OR st1.name LIKE ? OR st2.name LIKE ? " +
                "OR s.price LIKE ? " +
                "ORDER BY s.departure_time ASC";

        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            String query = "%" + keyword + "%";
            for (int i = 1; i <= 5; i++)
                ps.setString(i, query);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    schedules.add(mapResultSetToSchedule(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return schedules;
    }

    public List<Schedule> searchSchedules(String fromCity, String toCity, String date) {
        List<Schedule> schedules = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
                "SELECT s.*, " +
                        "t.name as train_name, t.code as train_code, t.total_seats, " +
                        "(SELECT COALESCE(SUM(quantity), 0) FROM bookings WHERE schedule_id = s.id AND status != 'CANCELLED') as booked_seats, "
                        +
                        "st1.name as dep_name, st1.city as dep_city, " +
                        "st2.name as arr_name, st2.city as arr_city " +
                        "FROM schedules s " +
                        "JOIN trains t ON s.train_id = t.id " +
                        "JOIN stations st1 ON s.departure_station_id = st1.id " +
                        "JOIN stations st2 ON s.arrival_station_id = st2.id " +
                        "WHERE 1=1 ");

        List<Object> params = new ArrayList<>();

        if (fromCity != null && !fromCity.isEmpty()) {
            sql.append("AND st1.city LIKE ? ");
            params.add("%" + fromCity + "%");
        }
        if (toCity != null && !toCity.isEmpty()) {
            sql.append("AND st2.city LIKE ? ");
            params.add("%" + toCity + "%");
        }
        if (date != null && !date.isEmpty()) {
            // Assumes date format YYYY-MM-DD
            sql.append("AND DATE(s.departure_time) = ? ");
            params.add(date);
        }

        sql.append("ORDER BY s.departure_time ASC");

        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql.toString())) {

            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    schedules.add(mapResultSetToSchedule(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return schedules;
    }

    private Schedule mapResultSetToSchedule(ResultSet rs) throws SQLException {
        Schedule s = new Schedule();
        s.setId(rs.getInt("id"));
        s.setTrainId(rs.getInt("train_id"));
        s.setDepartureStationId(rs.getInt("departure_station_id"));
        s.setArrivalStationId(rs.getInt("arrival_station_id"));
        s.setDepartureTime(rs.getTimestamp("departure_time"));
        s.setArrivalTime(rs.getTimestamp("arrival_time"));
        s.setPrice(rs.getDouble("price"));
        s.setBookedSeats(rs.getInt("booked_seats"));

        Train t = new Train();
        t.setId(rs.getInt("train_id"));
        t.setName(rs.getString("train_name"));
        t.setCode(rs.getString("train_code"));
        t.setTotalSeats(rs.getInt("total_seats"));
        s.setTrain(t);

        Station dep = new Station();
        dep.setId(rs.getInt("departure_station_id"));
        dep.setName(rs.getString("dep_name"));
        dep.setCity(rs.getString("dep_city"));
        s.setDepartureStation(dep);

        Station arr = new Station();
        arr.setId(rs.getInt("arrival_station_id"));
        arr.setName(rs.getString("arr_name"));
        arr.setCity(rs.getString("arr_city"));
        s.setArrivalStation(arr);

        return s;
    }

    public void addSchedule(Schedule s) {
        String sql = "INSERT INTO schedules (train_id, departure_station_id, arrival_station_id, departure_time, arrival_time, price) VALUES (?, ?, ?, ?, ?, ?)";
        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, s.getTrainId());
            ps.setInt(2, s.getDepartureStationId());
            ps.setInt(3, s.getArrivalStationId());
            ps.setTimestamp(4, s.getDepartureTime());
            ps.setTimestamp(5, s.getArrivalTime());
            ps.setDouble(6, s.getPrice());
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public void deleteSchedule(int id) {
        String sql = "DELETE FROM schedules WHERE id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public Schedule getScheduleById(int id) {
        String sql = "SELECT s.*, " +
                "t.name as train_name, t.code as train_code, t.total_seats, " +
                "(SELECT COALESCE(SUM(quantity), 0) FROM bookings WHERE schedule_id = s.id AND status != 'CANCELLED') as booked_seats, "
                +
                "st1.name as dep_name, st1.city as dep_city, " +
                "st2.name as arr_name, st2.city as arr_city " +
                "FROM schedules s " +
                "JOIN trains t ON s.train_id = t.id " +
                "JOIN stations st1 ON s.departure_station_id = st1.id " +
                "JOIN stations st2 ON s.arrival_station_id = st2.id " +
                "WHERE s.id = ?";

        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToSchedule(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
}
