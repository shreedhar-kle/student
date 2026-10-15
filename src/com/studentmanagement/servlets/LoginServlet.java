package com.studentmanagement.servlets;

import com.studentmanagement.beans.UserBean;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    private static final String DEMO_USERNAME = "admin";
    private static final String DEMO_PASSWORD = "admin123";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("loggedInUser") != null) {

            response.sendRedirect(request.getContextPath() + "/dashboard");
            return;
        }

        request.getRequestDispatcher("/login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String username = trim(request.getParameter("username"));
        String password = trim(request.getParameter("password"));

        if (username.isEmpty() || password.isEmpty()) {
            request.setAttribute("errorMessage", "Username and password are required.");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
            return;
        }

        if (DEMO_USERNAME.equals(username) && DEMO_PASSWORD.equals(password)) {

            HttpSession existingSession = request.getSession(false);
            if (existingSession != null) {
                existingSession.invalidate();
            }

            HttpSession session = request.getSession(true);
            UserBean user = new UserBean(username, "", "ADMIN");
            session.setAttribute("loggedInUser", user);
            session.setMaxInactiveInterval(30 * 60);

            response.sendRedirect(request.getContextPath() + "/dashboard");

        } else {

            request.setAttribute("errorMessage", "Invalid username or password. Please try again.");
            request.setAttribute("enteredUsername", username);
            request.getRequestDispatcher("/login.jsp").forward(request, response);
        }
    }

    private String trim(String value) {
        return (value == null) ? "" : value.trim();
    }
}
