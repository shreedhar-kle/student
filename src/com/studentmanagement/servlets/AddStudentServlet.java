package com.studentmanagement.servlets;

import com.studentmanagement.beans.StudentBean;
import com.studentmanagement.dao.StudentRepository;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/addStudent")
public class AddStudentServlet extends HttpServlet {

    private final StudentRepository repo = StudentRepository.getInstance();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if (!DashboardServlet.isAuthenticated(request)) {
            response.sendRedirect(request.getContextPath() + "/login?expired=true");
            return;
        }
        request.getRequestDispatcher("/addStudent.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if (!DashboardServlet.isAuthenticated(request)) {
            response.sendRedirect(request.getContextPath() + "/login?expired=true");
            return;
        }

        String studentId   = trim(request.getParameter("studentId"));
        String name        = trim(request.getParameter("name"));
        String email       = trim(request.getParameter("email"));
        String phone       = trim(request.getParameter("phone"));
        String department  = trim(request.getParameter("department"));
        String semesterStr = trim(request.getParameter("semester"));
        String gender      = trim(request.getParameter("gender"));
        String address     = trim(request.getParameter("address"));

        StringBuilder errors = new StringBuilder();

        if (studentId.isEmpty())  errors.append("Student ID is required. ");
        if (name.isEmpty())       errors.append("Full Name is required. ");
        if (email.isEmpty())      errors.append("Email is required. ");
        else if (!isValidEmail(email)) errors.append("Email format is invalid. ");
        if (phone.isEmpty())      errors.append("Phone number is required. ");
        else if (!phone.matches("\\d{10}")) errors.append("Phone must be 10 digits. ");
        if (department.isEmpty()) errors.append("Department is required. ");
        if (gender.isEmpty())     errors.append("Gender is required. ");

        int semester = 0;
        if (semesterStr.isEmpty()) {
            errors.append("Semester is required. ");
        } else {
            try {
                semester = Integer.parseInt(semesterStr);
                if (semester < 1 || semester > 8) errors.append("Semester must be between 1 and 8. ");
            } catch (NumberFormatException e) {
                errors.append("Semester must be a number. ");
            }
        }

        if (!studentId.isEmpty() && repo.findById(studentId) != null) {
            errors.append("Student ID '" + escapeHtml(studentId) + "' is already registered. ");
        }

        if (errors.length() > 0) {

            request.setAttribute("errorMessage", errors.toString().trim());
            request.setAttribute("formData", buildBean(studentId, name, email, phone,
                    department, semester, gender, address));
            request.getRequestDispatcher("/addStudent.jsp").forward(request, response);
            return;
        }

        StudentBean student = buildBean(studentId, name, email, phone, department, semester, gender, address);
        repo.addStudent(student);

        response.sendRedirect(request.getContextPath()
                + "/viewStudents?success=Student+added+successfully");
    }

    private StudentBean buildBean(String id, String name, String email, String phone,
                                  String dept, int sem, String gender, String address) {
        return new StudentBean(id, name, email, phone, dept, sem, gender, address);
    }

    private boolean isValidEmail(String email) {

        return email.matches("^[\\w.%+\\-]+@[\\w.\\-]+\\.[a-zA-Z]{2,}$");
    }

    private String trim(String v) { return (v == null) ? "" : v.trim(); }

    private String escapeHtml(String s) {
        return s.replace("&", "&amp;").replace("<", "&lt;").replace(">", "&gt;");
    }
}
