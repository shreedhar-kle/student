<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.studentmanagement.beans.UserBean, com.studentmanagement.beans.StudentBean" %>
<%
    UserBean loggedInUser = (UserBean) session.getAttribute("loggedInUser");
    if (loggedInUser == null) {
        response.sendRedirect(request.getContextPath() + "/login?expired=true");
        return;
    }

    StudentBean student    = (StudentBean) request.getAttribute("student");
    String      errorMessage = (String) request.getAttribute("errorMessage");

    if (student == null) {
        response.sendRedirect(request.getContextPath() + "/viewStudents?error=Student+not+found");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit Student — Student Management System</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
</head>
<body>

<header class="navbar">
    <span class="brand">SMS</span>
    <nav>
        <a href="<%= request.getContextPath() %>/dashboard">Dashboard</a>
        <a href="<%= request.getContextPath() %>/viewStudents" class="active">Students</a>
        <a href="<%= request.getContextPath() %>/addStudent">Add Student</a>
        <a href="<%= request.getContextPath() %>/searchStudent">Search</a>
    </nav>
    <form action="<%= request.getContextPath() %>/logout" method="get" style="margin:0;">
        <button type="submit" class="logout-btn">Sign Out</button>
    </form>
</header>

<main class="page">
    <div class="page-header">
        <h1>Edit Student</h1>
        <p>Editing record for <strong><%= student.getName() %></strong>
           (<%= student.getStudentId() %>)</p>
    </div>

    <% if (errorMessage != null && !errorMessage.isEmpty()) {
%>
        <div class="alert alert-error"><%= errorMessage %></div>
    <% }
%>

    <div class="card">
        <form id="editStudentForm"
              action="<%= request.getContextPath() %>/updateStudent"
              method="post"
              onsubmit="return validateStudentForm('editStudentForm')">

            <div class="form-grid">

                <div class="form-group">
                    <label for="studentId">Student ID</label>

                    <input type="text" id="studentId" name="studentId"
                           value="<%= student.getStudentId() %>"
                           readonly>
                </div>

                <div class="form-group">
                    <label for="name">Full Name <span class="req">*</span></label>
                    <input type="text" id="name" name="name"
                           value="<%= student.getName() %>"
                           maxlength="100" required>
                </div>

                <div class="form-group">
                    <label for="email">Email <span class="req">*</span></label>
                    <input type="email" id="email" name="email"
                           value="<%= student.getEmail() %>"
                           maxlength="100" required>
                </div>

                <div class="form-group">
                    <label for="phone">Phone Number <span class="req">*</span></label>
                    <input type="tel" id="phone" name="phone"
                           value="<%= student.getPhone() %>"
                           maxlength="10" pattern="\d{10}" required>
                </div>

                <div class="form-group">
                    <label for="department">Department <span class="req">*</span></label>
                    <select id="department" name="department" required>
                        <option value="">-- Select Department --</option>
                        <%
                            String[] depts = {"Computer Science","Electronics","Mechanical",
                                              "Civil","Electrical","Information Technology",
                                              "Chemical","Biotechnology","Physics","Mathematics"};
                            for (String d : depts) {
                                String sel = d.equals(student.getDepartment()) ? "selected" : "";

%>
                            <option value="<%= d %>" <%= sel %>><%= d %></option>
                        <%  }
%>
                    </select>
                </div>

                <div class="form-group">
                    <label for="semester">Semester <span class="req">*</span></label>
                    <select id="semester" name="semester" required>
                        <option value="">-- Select Semester --</option>
                        <%
                            for (int i = 1; i <= 8; i++) {
                                String sel = (i == student.getSemester()) ? "selected" : "";

%>
                            <option value="<%= i %>" <%= sel %>>Semester <%= i %></option>
                        <%  }
%>
                    </select>
                </div>

                <div class="form-group">
                    <label for="gender">Gender <span class="req">*</span></label>
                    <select id="gender" name="gender" required>
                        <option value="">-- Select Gender --</option>
                        <option value="Male"   <%= "Male".equals(student.getGender())   ? "selected":"" %>>Male</option>
                        <option value="Female" <%= "Female".equals(student.getGender()) ? "selected":"" %>>Female</option>
                        <option value="Other"  <%= "Other".equals(student.getGender())  ? "selected":"" %>>Other</option>
                    </select>
                </div>

                <div class="form-group full-width">
                    <label for="address">Address</label>
                    <textarea id="address" name="address"
                              maxlength="300"><%= student.getAddress() %></textarea>
                </div>

            </div>

            <div class="form-actions">
                <button type="submit" class="btn btn-primary" id="updateBtn">Update Student</button>
                <a href="<%= request.getContextPath() %>/viewStudents"
                   class="btn btn-secondary">Cancel</a>
            </div>

        </form>
    </div>
</main>

<script src="<%= request.getContextPath() %>/js/validation.js"></script>
</body>
</html>
