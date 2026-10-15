<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.studentmanagement.beans.UserBean" %>
<%
    UserBean loggedInUser = (UserBean) session.getAttribute("loggedInUser");
    if (loggedInUser == null) {
        response.sendRedirect(request.getContextPath() + "/login?expired=true");
        return;
    }

    Integer studentCount = (Integer) request.getAttribute("studentCount");
    if (studentCount == null) studentCount = 0;

    String successMsg = request.getParameter("success");
    String errorMsg   = request.getParameter("error");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard — Student Management System</title>
    <meta name="description" content="Administrator dashboard for the Student Management System.">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
</head>
<body>

<header class="navbar">
    <span class="brand">SMS</span>
    <nav>
        <a href="<%= request.getContextPath() %>/dashboard" class="active">Dashboard</a>
        <a href="<%= request.getContextPath() %>/viewStudents">Students</a>
        <a href="<%= request.getContextPath() %>/addStudent">Add Student</a>
        <a href="<%= request.getContextPath() %>/searchStudent">Search</a>
    </nav>
    <form action="<%= request.getContextPath() %>/logout" method="get" style="margin:0;">
        <button type="submit" class="logout-btn" id="logoutBtn">Sign Out</button>
    </form>
</header>

<main class="page">
    <div class="page-header">
        <h1>Dashboard</h1>
        <p>Welcome back, <strong><%= loggedInUser.getUsername() %></strong></p>
    </div>

    <% if (successMsg != null) {
%><div class="alert alert-success"><%= successMsg %></div><% }
%>
    <% if (errorMsg   != null) {
%><div class="alert alert-error"><%= errorMsg %></div><% }
%>

    <div class="stats-row">
        <div class="stat-card">
            <span class="stat-label">Total Students</span>
            <span class="stat-value"><%= studentCount %></span>
        </div>
        <div class="stat-card">
            <span class="stat-label">Logged in as</span>
            <span class="stat-value" style="font-size:1.1rem; margin-top:0.3rem;">
                <%= loggedInUser.getUsername() %>
            </span>
        </div>
    </div>

    <h2 style="margin-bottom:0.75rem; color:#627D98; font-size:0.8rem;
               text-transform:uppercase; letter-spacing:0.06em;">Quick Actions</h2>

    <div class="quick-links">
        <a class="quick-link-card"
           href="<%= request.getContextPath() %>/viewStudents">
            <span class="ql-title">View Students</span>
            <span class="ql-desc">Browse all registered student records</span>
        </a>
        <a class="quick-link-card"
           href="<%= request.getContextPath() %>/addStudent">
            <span class="ql-title">Add Student</span>
            <span class="ql-desc">Register a new student</span>
        </a>
        <a class="quick-link-card"
           href="<%= request.getContextPath() %>/searchStudent">
            <span class="ql-title">Search Students</span>
            <span class="ql-desc">Find students by ID, name, or department</span>
        </a>
    </div>

    <div class="card" style="margin-top:0.5rem;">
        <h3 style="margin-bottom:0.5rem;">About This System</h3>
        <p style="font-size:0.875rem; color:#627D98; line-height:1.7;">
            This Student Management System is built with <strong>Java Servlets</strong>,
            <strong>JSP</strong>, <strong>HttpSession</strong>, and <strong>JavaBeans</strong>
            as a college mini project. Student data is stored in memory and will be
            lost when the server restarts — this is an expected limitation of the
            in-memory design.
        </p>
    </div>
</main>

<script src="<%= request.getContextPath() %>/js/validation.js"></script>
</body>
</html>
