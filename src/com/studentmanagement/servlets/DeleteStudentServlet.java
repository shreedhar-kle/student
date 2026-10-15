package com.studentmanagement.servlets;

import com.studentmanagement.dao.StudentRepository;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/deleteStudent")
public class DeleteStudentServlet extends HttpServlet {

    private final StudentRepository repo = StudentRepository.getInstance();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if (!DashboardServlet.isAuthenticated(request)) {
            response.sendRedirect(request.getContextPath() + "/login?expired=true");
            return;
        }

        String studentId = request.getParameter("id");
        if (studentId == null || studentId.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath()
                    + "/viewStudents?error=No+student+ID+provided+for+deletion");
            return;
        }

        boolean deleted = repo.deleteStudent(studentId.trim());

        if (deleted) {
            response.sendRedirect(request.getContextPath()
                    + "/viewStudents?success=Student+deleted+successfully");
        } else {
            response.sendRedirect(request.getContextPath()
                    + "/viewStudents?error=Student+not+found");
        }
    }
}
