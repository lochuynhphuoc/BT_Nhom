package com.group.trainapp.model;

import java.sql.Timestamp;

public class Booking {
    private int id;
    private int userId;
    private int scheduleId;
    private Timestamp bookingTime;
    private String status; // BOOKED, CANCELLED

    // New Fields
    private String fullName;
    private String idCard;
    private String phone;
    private String email;
    private int quantity;
    private String notes;
    private String paymentMethod;
    private double totalPrice;

    // Relationships
    private User user;
    private Schedule schedule;

    public Booking() {
    }

    public Booking(int id, int userId, int scheduleId, Timestamp bookingTime, String status) {
        this.id = id;
        this.userId = userId;
        this.scheduleId = scheduleId;
        this.bookingTime = bookingTime;
        this.status = status;
    }

    // New Constructor including all fields
    public Booking(int userId, int scheduleId, String fullName, String idCard, String phone, String email, int quantity,
            String notes, String paymentMethod, double totalPrice) {
        this.userId = userId;
        this.scheduleId = scheduleId;
        this.fullName = fullName;
        this.idCard = idCard;
        this.phone = phone;
        this.email = email;
        this.quantity = quantity;
        this.notes = notes;
        this.paymentMethod = paymentMethod;
        this.totalPrice = totalPrice;
        this.status = "BOOKED";
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public int getScheduleId() {
        return scheduleId;
    }

    public void setScheduleId(int scheduleId) {
        this.scheduleId = scheduleId;
    }

    public Timestamp getBookingTime() {
        return bookingTime;
    }

    public void setBookingTime(Timestamp bookingTime) {
        this.bookingTime = bookingTime;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    // New Getters and Setters
    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public String getIdCard() {
        return idCard;
    }

    public void setIdCard(String idCard) {
        this.idCard = idCard;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public String getNotes() {
        return notes;
    }

    public void setNotes(String notes) {
        this.notes = notes;
    }

    public String getPaymentMethod() {
        return paymentMethod;
    }

    public void setPaymentMethod(String paymentMethod) {
        this.paymentMethod = paymentMethod;
    }

    public double getTotalPrice() {
        return totalPrice;
    }

    public void setTotalPrice(double totalPrice) {
        this.totalPrice = totalPrice;
    }

    public User getUser() {
        return user;
    }

    public void setUser(User user) {
        this.user = user;
    }

    public Schedule getSchedule() {
        return schedule;
    }

    public void setSchedule(Schedule schedule) {
        this.schedule = schedule;
    }
}
