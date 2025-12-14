package com.group.trainapp.filter;

import com.group.trainapp.model.User;

import javax.servlet.*;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebFilter("/*")
public class AuthFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;
        HttpSession session = req.getSession(false);

        String path = req.getRequestURI().substring(req.getContextPath().length());

        // CSS, JS, Images, Auth pages should be accessible
        if (path.startsWith("/assets/") || path.startsWith("/login") || path.equals("/")
                || path.startsWith("/index.jsp")) {
            chain.doFilter(request, response);
            return;
        }

        boolean isLoggedIn = (session != null && session.getAttribute("user") != null);

        if (path.startsWith("/admin")) {
            if (isLoggedIn) {
                User user = (User) session.getAttribute("user");
                if (user.getRoleId() == 1) { // 1 is ADMIN
                    chain.doFilter(request, response);
                    return;
                } else {
                    res.sendError(HttpServletResponse.SC_FORBIDDEN, "Access Denied");
                    return;
                }
            } else {
                res.sendRedirect(req.getContextPath() + "/login");
                return;
            }
        }

        // Allow other paths (public view for schedules etc)
        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {
    }
}
