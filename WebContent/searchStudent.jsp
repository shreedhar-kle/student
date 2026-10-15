<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.studentmanagement.beans.UserBean, com.studentmanagement.beans.StudentBean, java.util.List" %>
<%
    UserBean loggedInUser = (UserBean) session.getAttribute("loggedInUser");
    if (loggedInUser == null) {
        response.sendRedirect(request.getContextPath() + "/login?expired=true");
        return;
    }

    List<StudentBean> results   = (List<StudentBean>) request.getAttribute("results");
    String searchQuery           = (String) request.getAttribute("searchQuery");
    String searchField           = (String) request.getAttribute("searchField");
    Integer resultCount          = (Integer) request.getAttribute("resultCount");
    Boolean searchPerformed      = (Boolean) request.getAttribute("searchPerformed");

    if (searchQuery == null)  searchQuery  = "";
    if (searchField == null)  searchField  = "all";
    if (resultCount == null)  resultCount  = 0;
    if (searchPerformed == null) searchPerformed = false;
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Search Students — Student Management System</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
</head>
<body>

<header class="navbar">
    <span class="brand">SMS</span>
    <nav>
        <a href="<%= request.getContextPath() %>/dashboard">Dashboard</a>
        <a href="<%= request.getContextPath() %>/viewStudents">Students</a>
        <a href="<%= request.getContextPath() %>/addStudent">Add Student</a>
        <a href="<%= request.getContextPath() %>/searchStudent" class="active">Search</a>
    </nav>
    <form action="<%= request.getContextPath() %>/logout" method="get" style="margin:0;">
        <button type="submit" class="logout-btn">Sign Out</button>
    </form>
</header>

<main class="page">
    <div class="page-header">
        <h1>Search Students</h1>
        <p>Find students by ID, name, email, phone, department, semester, etc.</p>
    </div>

    <div class="card" style="margin-bottom:1.5rem;">
        <form action="<%= request.getContextPath() %>/searchStudent" method="get" id="searchForm">
            <div class="search-bar">
                <select name="field" id="searchField">
                    <option value="all"        <%= "all".equals(searchField)        ? "selected":"" %>>All Fields</option>
                    <option value="id"         <%= "id".equals(searchField)         ? "selected":"" %>>Student ID</option>
                    <option value="name"       <%= "name".equals(searchField)       ? "selected":"" %>>Name</option>
                    <option value="email"      <%= "email".equals(searchField)      ? "selected":"" %>>Email</option>
                    <option value="phone"      <%= "phone".equals(searchField)      ? "selected":"" %>>Phone</option>
                    <option value="department" <%= "department".equals(searchField) ? "selected":"" %>>Department</option>
                    <option value="semester"   <%= "semester".equals(searchField)   ? "selected":"" %>>Semester</option>
                </select>
                <input type="text"
                       name="query"
                       id="searchQuery"
                       value="<%= searchQuery %>"
                       placeholder="Search by ID, name, email, phone, department…"
                       autocomplete="off">
                <button type="submit" class="btn btn-primary" id="searchBtn">Search</button>
                <% if (!searchQuery.isEmpty()) { %>
                    <a href="<%= request.getContextPath() %>/searchStudent"
                       class="btn btn-secondary" id="clearBtn">Clear</a>
                <% } %>
            </div>
        </form>
    </div>

    <% if (searchPerformed) { %>

        <% if (results == null || results.isEmpty()) { %>
            <div class="table-wrapper">
                <div class="empty-state">
                    <strong>No students found</strong>
                    <p>
                        <% if (!searchQuery.isEmpty()) { %>
                            No results matched "<em><%= searchQuery %></em>"
                            <% if (!"all".equals(searchField)) { %> in field "<em><%= searchField %></em>"<% } %>.
                        <% } else { %>
                            No students are registered yet.
                        <% } %>
                    </p>
                    <% if (!searchQuery.isEmpty()) { %>
                        <div style="margin-top:1rem;">
                            <a href="<%= request.getContextPath() %>/searchStudent" class="btn btn-secondary btn-sm">Show All Students</a>
                        </div>
                    <% } %>
                </div>
            </div>
        <% } else { %>

            <div style="margin-bottom:0.75rem; font-size:0.875rem; color:#627D98;" id="resultCountInfo">
                <% if (!searchQuery.isEmpty()) { %>
                    Found <strong><%= resultCount %></strong>
                    <%= resultCount == 1 ? "student" : "students" %>
                    matching "<strong><%= searchQuery %></strong>"
                    <% if (!"all".equals(searchField)) { %> in field "<strong><%= searchField %></strong>"<% } %>
                <% } else { %>
                    Showing all <strong><%= resultCount %></strong> <%= resultCount == 1 ? "student" : "students" %>
                <% } %>
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
                    <% for (StudentBean s : results) {
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
                                        <input type="hidden" name="id" value="<%= s.getStudentId() %>">
                                        <button type="submit" class="btn btn-danger btn-sm">Delete</button>
                                    </form>
                                </div>
                            </td>
                        </tr>
                    <% } %>
                    </tbody>
                </table>
            </div>

        <% } %>
    <% } %>

</main>

<script src="<%= request.getContextPath() %>/js/validation.js"></script>
<script>
document.addEventListener('DOMContentLoaded', function () {
    var queryInput  = document.getElementById('searchQuery');
    var fieldSelect = document.getElementById('searchField');
    var table       = document.getElementById('studentsTable');
    var countInfo   = document.getElementById('resultCountInfo');

    if (!queryInput || !table) return;

    var tbody = table.querySelector('tbody');
    if (!tbody) return;

    var rows = Array.from(tbody.querySelectorAll('tr'));
    var totalRows = rows.length;

    function applyFilter() {
        var q = queryInput.value.trim().toLowerCase();
        var field = fieldSelect ? fieldSelect.value : 'all';
        var visibleCount = 0;

        rows.forEach(function (row) {
            var idCell    = row.cells[0] ? row.cells[0].textContent.toLowerCase() : '';
            var nameCell  = row.cells[1] ? row.cells[1].textContent.toLowerCase() : '';
            var emailCell = row.cells[2] ? row.cells[2].textContent.toLowerCase() : '';
            var phoneCell = row.cells[3] ? row.cells[3].textContent.toLowerCase() : '';
            var deptCell  = row.cells[4] ? row.cells[4].textContent.toLowerCase() : '';
            var semCell   = row.cells[5] ? row.cells[5].textContent.toLowerCase() : '';

            var match = false;
            if (!q) {
                match = true;
            } else if (field === 'id') {
                match = idCell.indexOf(q) !== -1;
            } else if (field === 'name') {
                match = nameCell.indexOf(q) !== -1;
            } else if (field === 'email') {
                match = emailCell.indexOf(q) !== -1;
            } else if (field === 'phone') {
                match = phoneCell.indexOf(q) !== -1;
            } else if (field === 'department') {
                match = deptCell.indexOf(q) !== -1;
            } else if (field === 'semester') {
                match = semCell.indexOf(q) !== -1;
            } else {
                // all fields: check if full query matches any cell, or all words match
                var combined = idCell + ' ' + nameCell + ' ' + emailCell + ' ' + phoneCell + ' ' + deptCell + ' ' + semCell;
                if (combined.indexOf(q) !== -1) {
                    match = true;
                } else {
                    var words = q.split(/\s+/);
                    match = words.length > 1 && words.every(function (w) { return combined.indexOf(w) !== -1; });
                }
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
                countInfo.innerHTML = 'Showing <strong>' + visibleCount + '</strong> matching ' + (visibleCount === 1 ? 'student' : 'students');
            } else {
                countInfo.innerHTML = 'Showing all <strong>' + visibleCount + '</strong> ' + (visibleCount === 1 ? 'student' : 'students');
            }
        }
    }

    queryInput.addEventListener('input', applyFilter);
    if (fieldSelect) {
        fieldSelect.addEventListener('change', applyFilter);
    }
});
</script>
</body>
</html>
