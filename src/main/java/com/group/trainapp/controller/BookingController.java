package com.group.trainapp.controller;

import com.group.trainapp.dao.BookingDAO;
import com.group.trainapp.model.Booking;
import com.group.trainapp.model.User;
import com.group.trainapp.util.ToastUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet("/bookings")
public class BookingController extends HttpServlet {
    private BookingDAO bookingDAO;

    @Override
    public void init() {
        bookingDAO = new BookingDAO();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;

        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        List<Booking> bookings = bookingDAO.getBookingsByUserId(user.getId());
        req.setAttribute("bookings", bookings);
        req.getRequestDispatcher("/views/client/bookings.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;

        if (user == null) {
            // Redirect to login if trying to book without auth
            ToastUtil.setFlash(req, "Please login to book tickets", "error");
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        try {
            String action = req.getParameter("action");
            if ("cancel".equals(action)) {
                int bookingId = Integer.parseInt(req.getParameter("bookingId"));
                String refundMethod = req.getParameter("refundMethod");

                bookingDAO.updateStatus(bookingId, "CANCELLED");

                String msg = "Booking cancelled successfully.";
                if (refundMethod != null && !refundMethod.isEmpty()) {
                    String methodDisplay = "original payment method";
                    if ("wallet".equals(refundMethod))
                        methodDisplay = "wallet credit";
                    if ("bank".equals(refundMethod))
                        methodDisplay = "bank transfer";
                    msg += " Refund will be processed via " + methodDisplay + ".";
                }

                ToastUtil.setFlash(req, msg, "success");
                resp.sendRedirect(req.getContextPath() + "/bookings");
                return;
            }

            int scheduleId = Integer.parseInt(req.getParameter("scheduleId"));

            // Retrieve Form Data
            String fullName = req.getParameter("fullName");
            String idCard = req.getParameter("idCard");
            String phone = req.getParameter("phone");
            String email = req.getParameter("email");
            int quantity = Integer.parseInt(req.getParameter("quantity"));
            String notes = req.getParameter("notes");
            String paymentMethod = req.getParameter("paymentInfo");

            // Calculate Total Price (fetching schedule to be safe)
            // Ideally should fetch Schedule from DAO, but to keep it simple and avoid extra
            // DAO call if not strictly needed
            // we can rely on the fact that we need the price.
            // Let's create a stub or just parse from request if we passed it hidden?
            // The modal didn't pass price as hidden. So I need to fetch schedule or pass
            // price.
            // Wait, for security, price should be server-side.
            // I need ScheduleDAO here.

            com.group.trainapp.dao.ScheduleDAO scheduleDAO = new com.group.trainapp.dao.ScheduleDAO();
            com.group.trainapp.model.Schedule schedule = scheduleDAO.getScheduleById(scheduleId);

            if (schedule != null) {
                double totalPrice = schedule.getPrice() * quantity;

                Booking booking = new Booking(user.getId(), scheduleId, fullName, idCard, phone, email, quantity, notes,
                        paymentMethod, totalPrice);
                bookingDAO.createBooking(booking);

                ToastUtil.setFlash(req,
                        "Ticket booked successfully! Total: " + String.format("%,.0f", totalPrice) + " VND", "success");
            } else {
                ToastUtil.setFlash(req, "Schedule not found.", "error");
            }

        } catch (Exception e) {
            e.printStackTrace();
            ToastUtil.setFlash(req, "Failed to booking ticket: " + e.getMessage(), "error");
        }

        resp.sendRedirect(req.getContextPath() + "/bookings");
    }
}
