<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.studentmanagement.beans.UserBean, com.studentmanagement.beans.StudentBean, java.util.List" %>
<%
    UserBean loggedInUser = (UserBean) session.getAttribute("loggedInUser");
    if (loggedInUser == null) {
        response.sendRedirect(request.getContextPath() + "/login?expired=true");
        return;
    }

    List<StudentBean> students = (List<StudentBean>) request.getAttribute("students");
    Integer studentCount       = (Integer) request.getAttribute("studentCount");
    if (studentCount == null) studentCount = 0;

    String successMsg = request.getParameter("success");
    String errorMsg   = request.getParameter("error");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Students — Student Management System</title>
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
    <div class="page-header" style="display:flex;align-items:center;justify-content:space-between;flex-wrap:wrap;gap:0.75rem;">
        <div>
            <h1>Students <span class="badge"><%= studentCount %></span></h1>
            <p>All registered student records</p>
        </div>
        <a href="<%= request.getContextPath() %>/addStudent"
           class="btn btn-primary">+ Add Student</a>
    </div>

    <% if (successMsg != null) {
%><div class="alert alert-success"><%= successMsg %></div><% }
%>
    <% if (errorMsg   != null) {
%><div class="alert alert-error"><%= errorMsg %></div><% }
%>

    <% if (students == null || students.isEmpty()) { %>
        <div class="table-wrapper">
            <div class="empty-state">
                <strong>No students registered yet.</strong>
                <p><a href="<%= request.getContextPath() %>/addStudent">Add the first student</a></p>
            </div>
        </div>
    <% } else { %>
        <div style="margin-bottom: 1rem; display: flex; gap: 0.75rem; align-items: center; justify-content: space-between; flex-wrap: wrap;">
            <div style="flex: 1; max-width: 420px;">
                <input type="text" id="quickFilter"
                       placeholder="Filter students by ID, name, email, department…"
                       style="width: 100%; padding: 0.55rem 0.85rem; border: 1px solid #CBD5E0; border-radius: 4px; font-size: 0.875rem; background: #fff;"
                       autocomplete="off">
            </div>
            <div id="filterCount" style="font-size: 0.875rem; color: #627D98;"></div>
        </div>

        <div class="table-wrapper">
            <table id="studentsTable">
                <thead>
                    <tr>
                        <th>Student ID</th>
                        <th>Full Name</th>
                        <th>Email</th>
                        <th>Phone</th>
                        <th>Department</th>
                        <th>Semester</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                <% for (StudentBean s : students) {
                       String safeId   = s.getStudentId().replace("'", "\\'");
                       String safeName = s.getName().replace("'", "\\'");
                %>
                    <tr>
                        <td><%= s.getStudentId() %></td>
                        <td><%= s.getName() %></td>
                        <td><%= s.getEmail() %></td>
                        <td><%= s.getPhone() %></td>
                        <td><%= s.getDepartment() %></td>
                        <td>Sem <%= s.getSemester() %></td>
                        <td>
                            <div class="actions">

                                <a href="<%= request.getContextPath() %>/editStudent?id=<%= s.getStudentId() %>"
                                   class="btn btn-accent btn-sm">Edit</a>

                                <form action="<%= request.getContextPath() %>/deleteStudent"
                                      method="post" style="display:inline;"
                                      onsubmit="return confirmDelete('<%= safeName %>')">
                                    <input type="hidden" name="id"
                                           value="<%= s.getStudentId() %>">
                                    <button type="submit"
                                            class="btn btn-danger btn-sm">Delete</button>
                                </form>
                            </div>
                        </td>
                    </tr>
                <% } %>
                </tbody>
            </table>
        </div>
    <% } %>
</main>

<script src="<%= request.getContextPath() %>/js/validation.js"></script>
<script>
document.addEventListener('DOMContentLoaded', function () {
    var filterInput = document.getElementById('quickFilter');
    var table       = document.getElementById('studentsTable');
    var countInfo   = document.getElementById('filterCount');

    if (!filterInput || !table) return;

    var tbody = table.querySelector('tbody');
    if (!tbody) return;

    var rows = Array.from(tbody.querySelectorAll('tr'));

    filterInput.addEventListener('input', function () {
        var q = filterInput.value.trim().toLowerCase();
        var visibleCount = 0;

        rows.forEach(function (row) {
            var text = row.textContent.toLowerCase();
            var match = !q;
            if (q) {
                var words = q.split(/\s+/);
                match = words.every(function (w) { return text.indexOf(w) !== -1; });
            }

            if (match) {
                row.style.display = '';
                visibleCount++;
            } else {
                row.style.display = 'none';
            }
        });

        if (countInfo) {
            if (q) {
                countInfo.innerHTML = 'Showing <strong>' + visibleCount + '</strong> of ' + rows.length;
            } else {
                countInfo.innerHTML = '';
            }
        }
    });
});
</script>
</body>
</html>
