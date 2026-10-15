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

@WebServlet("/searchStudent")
public class SearchStudentServlet extends HttpServlet {

    private final StudentRepository repo = StudentRepository.getInstance();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processSearch(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processSearch(request, response);
    }

    private void processSearch(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if (!DashboardServlet.isAuthenticated(request)) {
            response.sendRedirect(request.getContextPath() + "/login?expired=true");
            return;
        }

        String query = request.getParameter("query");
        String field = request.getParameter("field");

        if (query == null) query = "";
        if (field == null || field.trim().isEmpty()) field = "all";

        List<StudentBean> results = repo.search(query.trim(), field.trim());

        request.setAttribute("results",         results);
        request.setAttribute("searchQuery",     query);
        request.setAttribute("searchField",     field);
        request.setAttribute("resultCount",     results.size());
        request.setAttribute("searchPerformed", true);

        request.getRequestDispatcher("/searchStudent.jsp").forward(request, response);
    }
}
