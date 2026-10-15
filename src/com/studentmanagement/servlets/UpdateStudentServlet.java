package com.studentmanagement.servlets;

import com.studentmanagement.beans.StudentBean;
import com.studentmanagement.dao.StudentRepository;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/updateStudent")
public class UpdateStudentServlet extends HttpServlet {

    private final StudentRepository repo = StudentRepository.getInstance();

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

        if (studentId.isEmpty()) errors.append("Student ID is missing. ");

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
                if (semester < 1 || semester > 8) errors.append("Semester must be 1–8. ");
            } catch (NumberFormatException e) {
                errors.append("Semester must be a number. ");
            }
        }

        if (!studentId.isEmpty() && repo.findById(studentId) == null) {
            errors.append("Student with ID '" + studentId + "' was not found. ");
        }

        if (errors.length() > 0) {

            StudentBean partial = new StudentBean(studentId, name, email, phone,
                    department, semester, gender, address);
            request.setAttribute("student", partial);
            request.setAttribute("errorMessage", errors.toString().trim());
            request.getRequestDispatcher("/editStudent.jsp").forward(request, response);
            return;
        }

        StudentBean updated = new StudentBean(studentId, name, email, phone,
                department, semester, gender, address);
        boolean success = repo.updateStudent(updated);

        if (success) {
            response.sendRedirect(request.getContextPath()
                    + "/viewStudents?success=Student+updated+successfully");
        } else {
            request.setAttribute("student", updated);
            request.setAttribute("errorMessage", "Update failed — student not found.");
            request.getRequestDispatcher("/editStudent.jsp").forward(request, response);
        }
    }

    private boolean isValidEmail(String email) {
        return email.matches("^[\\w.%+\\-]+@[\\w.\\-]+\\.[a-zA-Z]{2,}$");
    }

    private String trim(String v) { return (v == null) ? "" : v.trim(); }
}
