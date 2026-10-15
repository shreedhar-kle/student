package com.studentmanagement.servlets;

import com.studentmanagement.beans.StudentBean;
import com.studentmanagement.dao.StudentRepository;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet("/viewStudents")
public class ViewStudentsServlet extends HttpServlet {

    private final StudentRepository repo = StudentRepository.getInstance();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if (!DashboardServlet.isAuthenticated(request)) {
            response.sendRedirect(request.getContextPath() + "/login?expired=true");
            return;
        }

        String query = request.getParameter("query");
        List<StudentBean> students;
        if (query != null && !query.trim().isEmpty()) {
            students = repo.search(query.trim(), "all");
        } else {
            students = repo.getAllStudents();
        }

        request.setAttribute("students", students);
        request.setAttribute("studentCount", repo.getStudentCount());
        request.setAttribute("filteredCount", students.size());
        request.setAttribute("query", query != null ? query : "");

        request.getRequestDispatcher("/viewStudents.jsp").forward(request, response);
    }
}
