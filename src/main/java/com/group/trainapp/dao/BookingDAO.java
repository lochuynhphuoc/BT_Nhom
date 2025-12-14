package com.group.trainapp.dao;

import com.group.trainapp.model.Booking;
import com.group.trainapp.model.Schedule;
import com.group.trainapp.model.Station;
import com.group.trainapp.model.Train;
import com.group.trainapp.util.DatabaseConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class BookingDAO {

    public void createBooking(Booking booking) {
        String sql = "INSERT INTO bookings (user_id, schedule_id, status, full_name, id_card, phone, email, quantity, notes, payment_method, total_price) "
                +
                "VALUES (?, ?, 'BOOKED', ?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, booking.getUserId());
            ps.setInt(2, booking.getScheduleId());
            ps.setString(3, booking.getFullName());
            ps.setString(4, booking.getIdCard());
            ps.setString(5, booking.getPhone());
            ps.setString(6, booking.getEmail());
            ps.setInt(7, booking.getQuantity());
            ps.setString(8, booking.getNotes());
            ps.setString(9, booking.getPaymentMethod());
            ps.setDouble(10, booking.getTotalPrice());
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public void updateStatus(int bookingId, String status) {
        String sql = "UPDATE bookings SET status = ? WHERE id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, bookingId);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public List<Booking> getBookingsByUserId(int userId) {
        List<Booking> bookings = new ArrayList<>();
        // Complex join to get everything needed for the UI ticket view
        String sql = "SELECT b.*, " +
                "s.departure_time, s.arrival_time, s.price, " +
                "t.code as train_code, t.name as train_name, " +
                "st1.name as dep_name, st2.name as arr_name " +
                "FROM bookings b " +
                "JOIN schedules s ON b.schedule_id = s.id " +
                "JOIN trains t ON s.train_id = t.id " +
                "JOIN stations st1 ON s.departure_station_id = st1.id " +
                "JOIN stations st2 ON s.arrival_station_id = st2.id " +
                "WHERE b.user_id = ? " +
                "ORDER BY b.booking_time DESC";

        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Booking b = new Booking();
                    b.setId(rs.getInt("id"));
                    b.setUserId(rs.getInt("user_id"));
                    b.setScheduleId(rs.getInt("schedule_id"));
                    b.setBookingTime(rs.getTimestamp("booking_time"));
                    b.setStatus(rs.getString("status"));

                    // Map new fields
                    b.setFullName(rs.getString("full_name"));
                    b.setIdCard(rs.getString("id_card"));
                    b.setPhone(rs.getString("phone"));
                    b.setEmail(rs.getString("email"));
                    b.setQuantity(rs.getInt("quantity"));
                    b.setNotes(rs.getString("notes"));
                    b.setPaymentMethod(rs.getString("payment_method"));
                    b.setTotalPrice(rs.getDouble("total_price"));

                    // Reconstruct Schedule object partly for display
                    Schedule s = new Schedule();
                    s.setDepartureTime(rs.getTimestamp("departure_time"));
                    s.setArrivalTime(rs.getTimestamp("arrival_time"));
                    s.setPrice(rs.getDouble("price"));

                    Train t = new Train();
                    t.setCode(rs.getString("train_code"));
                    t.setName(rs.getString("train_name"));
                    s.setTrain(t);

                    Station dep = new Station();
                    dep.setName(rs.getString("dep_name"));
                    s.setDepartureStation(dep);

                    Station arr = new Station();
                    arr.setName(rs.getString("arr_name"));
                    s.setArrivalStation(arr);

                    b.setSchedule(s);
                    bookings.add(b);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return bookings;
    }
}
