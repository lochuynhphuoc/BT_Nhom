package com.group.trainapp.controller;

import com.group.trainapp.dao.ScheduleDAO;
import com.group.trainapp.model.Schedule;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet("")
public class HomeController extends HttpServlet {
    private ScheduleDAO scheduleDAO;

    @Override
    public void init() {
        scheduleDAO = new ScheduleDAO();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String from = req.getParameter("from");
        String to = req.getParameter("to");
        String date = req.getParameter("date");

        List<Schedule> schedules;
        if (from != null || to != null || date != null) {
            schedules = scheduleDAO.searchSchedules(from, to, date);
            req.setAttribute("searchPerformed", true);
        } else {
            // Show upcoming schedules or just nothing initially
            schedules = scheduleDAO.getAllSchedules();
        }

        req.setAttribute("schedules", schedules);
        req.getRequestDispatcher("/views/client/home.jsp").forward(req, resp);
    }
}
