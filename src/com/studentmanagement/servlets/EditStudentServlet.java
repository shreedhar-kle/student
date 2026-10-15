package com.studentmanagement.servlets;

import com.studentmanagement.beans.StudentBean;
import com.studentmanagement.dao.StudentRepository;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/editStudent")
public class EditStudentServlet extends HttpServlet {

    private final StudentRepository repo = StudentRepository.getInstance();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if (!DashboardServlet.isAuthenticated(request)) {
            response.sendRedirect(request.getContextPath() + "/login?expired=true");
            return;
        }

        String studentId = request.getParameter("id");
        if (studentId == null || studentId.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath()
                    + "/viewStudents?error=No+student+ID+provided");
            return;
        }

        StudentBean student = repo.findById(studentId.trim());
        if (student == null) {
            response.sendRedirect(request.getContextPath()
                    + "/viewStudents?error=Student+not+found");
            return;
        }

        request.setAttribute("student", student);
        request.getRequestDispatcher("/editStudent.jsp").forward(request, response);
    }
}
