package com.studentmanagement.servlets;

import com.studentmanagement.beans.UserBean;
import com.studentmanagement.dao.StudentRepository;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/dashboard")
public class DashboardServlet extends HttpServlet {

    private final StudentRepository repo = StudentRepository.getInstance();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if (!isAuthenticated(request)) {
            response.sendRedirect(request.getContextPath() + "/login?expired=true");
            return;
        }

        request.setAttribute("studentCount", repo.getStudentCount());
        request.getRequestDispatcher("/dashboard.jsp").forward(request, response);
    }

    public static boolean isAuthenticated(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null) return false;
        UserBean user = (UserBean) session.getAttribute("loggedInUser");
        return user != null;
    }
}
