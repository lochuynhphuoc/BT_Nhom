package com.group.trainapp.controller;

import com.group.trainapp.dao.TrainDAO;
import com.group.trainapp.model.Train;
import com.group.trainapp.util.ToastUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet("/admin/trains")
public class TrainController extends HttpServlet {
    private TrainDAO trainDAO;

    @Override
    public void init() {
        trainDAO = new TrainDAO();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        if (action == null)
            action = "list";

        if ("delete".equals(action)) {
            try {
                int id = Integer.parseInt(req.getParameter("id"));
                trainDAO.deleteTrain(id);
                ToastUtil.setFlash(req, "Train deleted successfully", "success");
            } catch (Exception e) {
                ToastUtil.setFlash(req, "Failed to delete train", "error");
            }
            resp.sendRedirect(req.getContextPath() + "/admin/trains");
        } else {
            String search = req.getParameter("search");
            List<Train> trains;
            if (search != null && !search.trim().isEmpty()) {
                trains = trainDAO.searchTrains(search.trim());
            } else {
                trains = trainDAO.getAllTrains();
            }
            req.setAttribute("trains", trains);
            req.getRequestDispatcher("/views/admin/trains.jsp").forward(req, resp);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        try {
            if ("add".equals(action)) {
                String code = req.getParameter("code");
                String name = req.getParameter("name");
                int seats = Integer.parseInt(req.getParameter("seats"));

                Train train = new Train(0, code, name, seats);
                trainDAO.addTrain(train);
                ToastUtil.setFlash(req, "Train added successfully", "success");
            } else if ("update".equals(action)) {
                int id = Integer.parseInt(req.getParameter("id"));
                String code = req.getParameter("code");
                String name = req.getParameter("name");
                int seats = Integer.parseInt(req.getParameter("seats"));

                Train train = new Train(id, code, name, seats);
                trainDAO.updateTrain(train);
                ToastUtil.setFlash(req, "Train updated successfully", "success");
            }
        } catch (Exception e) {
            e.printStackTrace();
            ToastUtil.setFlash(req, "Error processing train", "error");
        }
        resp.sendRedirect(req.getContextPath() + "/admin/trains");
    }
}
