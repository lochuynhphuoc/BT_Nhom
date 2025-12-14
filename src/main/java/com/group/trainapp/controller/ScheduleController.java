package com.group.trainapp.controller;

import com.group.trainapp.dao.ScheduleDAO;
import com.group.trainapp.dao.StationDAO;
import com.group.trainapp.dao.TrainDAO;
import com.group.trainapp.model.Schedule;
import com.group.trainapp.util.ToastUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Timestamp;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.List;

@WebServlet("/admin/schedules")
public class ScheduleController extends HttpServlet {
    private ScheduleDAO scheduleDAO;
    private TrainDAO trainDAO;
    private StationDAO stationDAO;

    @Override
    public void init() {
        scheduleDAO = new ScheduleDAO();
        trainDAO = new TrainDAO();
        stationDAO = new StationDAO();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        if (action == null)
            action = "list";

        if ("delete".equals(action)) {
            try {
                int id = Integer.parseInt(req.getParameter("id"));
                scheduleDAO.deleteSchedule(id);
                ToastUtil.setFlash(req, "Schedule deleted successfully", "success");
            } catch (Exception e) {
                ToastUtil.setFlash(req, "Failed to delete schedule", "error");
            }
            resp.sendRedirect(req.getContextPath() + "/admin/schedules");
        } else {
            String search = req.getParameter("search");
            List<Schedule> schedules;
            if (search != null && !search.trim().isEmpty()) {
                schedules = scheduleDAO.searchSchedulesByKeyword(search.trim());
            } else {
                schedules = scheduleDAO.getAllSchedules();
            }

            req.setAttribute("schedules", schedules);
            req.setAttribute("trains", trainDAO.getAllTrains());
            req.setAttribute("stations", stationDAO.getAllStations());
            req.getRequestDispatcher("/views/admin/schedules.jsp").forward(req, resp);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            int trainId = Integer.parseInt(req.getParameter("trainId"));
            int depId = Integer.parseInt(req.getParameter("depId"));
            int arrId = Integer.parseInt(req.getParameter("arrId"));
            double price = Double.parseDouble(req.getParameter("price"));

            // Format: yyyy-MM-dd'T'HH:mm (HTML5 datetime-local)
            String depStr = req.getParameter("depTime");
            String arrStr = req.getParameter("arrTime");

            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm");
            Timestamp depTime = new Timestamp(sdf.parse(depStr).getTime());
            Timestamp arrTime = new Timestamp(sdf.parse(arrStr).getTime());

            Schedule s = new Schedule();
            s.setTrainId(trainId);
            s.setDepartureStationId(depId);
            s.setArrivalStationId(arrId);
            s.setDepartureTime(depTime);
            s.setArrivalTime(arrTime);
            s.setPrice(price);

            scheduleDAO.addSchedule(s);
            ToastUtil.setFlash(req, "Schedule added successfully", "success");

        } catch (ParseException | NumberFormatException e) {
            e.printStackTrace();
            ToastUtil.setFlash(req, "Error creating schedule. Check inputs.", "error");
        }

        resp.sendRedirect(req.getContextPath() + "/admin/schedules");
    }
}
