package com.group.trainapp.controller;

import com.group.trainapp.dao.StationDAO;
import com.group.trainapp.model.Station;
import com.group.trainapp.util.ToastUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet("/admin/stations")
public class StationController extends HttpServlet {
    private StationDAO stationDAO;

    @Override
    public void init() {
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
                stationDAO.deleteStation(id);
                ToastUtil.setFlash(req, "Station deleted successfully", "success");
            } catch (Exception e) {
                ToastUtil.setFlash(req, "Failed to delete station", "error");
            }
            resp.sendRedirect(req.getContextPath() + "/admin/stations");
        } else {
            String search = req.getParameter("search");
            List<Station> stations;
            if (search != null && !search.trim().isEmpty()) {
                stations = stationDAO.searchStations(search.trim());
            } else {
                stations = stationDAO.getAllStations();
            }
            req.setAttribute("stations", stations);
            req.getRequestDispatcher("/views/admin/stations.jsp").forward(req, resp);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        try {
            if ("add".equals(action)) {
                String name = req.getParameter("name");
                String city = req.getParameter("city");

                Station s = new Station(0, name, city);
                stationDAO.addStation(s);
                ToastUtil.setFlash(req, "Station added successfully", "success");
            } else if ("update".equals(action)) {
                int id = Integer.parseInt(req.getParameter("id"));
                String name = req.getParameter("name");
                String city = req.getParameter("city");

                Station s = new Station(id, name, city);
                stationDAO.updateStation(s);
                ToastUtil.setFlash(req, "Station updated successfully", "success");
            }
        } catch (Exception e) {
            e.printStackTrace();
            ToastUtil.setFlash(req, "Error processing station", "error");
        }
        resp.sendRedirect(req.getContextPath() + "/admin/stations");
    }
}
