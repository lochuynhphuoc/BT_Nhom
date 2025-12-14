package com.group.trainapp.controller;

import com.group.trainapp.dao.UserDAO;
import com.group.trainapp.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/login")
public class LoginController extends HttpServlet {
    private UserDAO userDAO;

    @Override
    public void init() {
        userDAO = new UserDAO();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session != null && session.getAttribute("user") != null) {
            User user = (User) session.getAttribute("user");
            if (user.getRoleId() == 1) {
                resp.sendRedirect(req.getContextPath() + "/admin/dashboard");
            } else {
                resp.sendRedirect(req.getContextPath() + "/");
            }
        } else {
            req.getRequestDispatcher("/views/auth/login.jsp").forward(req, resp);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String username = req.getParameter("username");
        String pass = req.getParameter("password");

        User user = userDAO.checkLogin(username, pass);

        if (user != null) {
            HttpSession session = req.getSession();
            session.setAttribute("user", user);

            if (user.getRoleId() == 1) { // ADMIN
                resp.sendRedirect(req.getContextPath() + "/admin/dashboard");
            } else { // USER
                resp.sendRedirect(req.getContextPath() + "/");
            }
        } else {
            req.setAttribute("error", "Invalid username or password");
            req.getRequestDispatcher("/views/auth/login.jsp").forward(req, resp);
        }
    }
}
