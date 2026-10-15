<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.studentmanagement.beans.UserBean" %>
<%
    UserBean existingUser = (UserBean) session.getAttribute("loggedInUser");
    if (existingUser != null) {
        response.sendRedirect(request.getContextPath() + "/dashboard");
        return;
    }

    String errorMessage    = (String) request.getAttribute("errorMessage");
    String enteredUsername = (String) request.getAttribute("enteredUsername");
    String loggedOutParam  = request.getParameter("loggedOut");
    String expiredParam    = request.getParameter("expired");

    String safeUsername = (enteredUsername != null)
        ? enteredUsername.replace("&","&amp;").replace("<","&lt;").replace(">","&gt;")
        : "";
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login — Student Management System</title>
    <meta name="description" content="Administrator login for the Student Management System.">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
</head>
<body>

<div class="login-wrapper">
    <div class="login-card">

        <div class="login-title">Student Management System</div>
        <div class="login-subtitle">Sign in to the administrator panel</div>

        <% if ("true".equals(loggedOutParam)) {
%>
            <div class="alert alert-info">You have been signed out successfully.</div>
        <% } else if ("true".equals(expiredParam)) {
%>
            <div class="alert alert-error">Your session has expired. Please sign in again.</div>
        <% }
%>

        <% if (errorMessage != null && !errorMessage.isEmpty()) {
%>
            <div class="alert alert-error"><%= errorMessage %></div>
        <% }
%>

        <form id="loginForm"
              action="<%= request.getContextPath() %>/login"
              method="post"
              onsubmit="return validateLoginForm()">

            <div class="form-group" style="margin-bottom:0.9rem;">
                <label for="username">Username <span class="req">*</span></label>
                <input type="text"
                       id="username"
                       name="username"
                       value="<%= safeUsername %>"
                       placeholder="Enter username"
                       autocomplete="username"
                       required>
            </div>

            <div class="form-group" style="margin-bottom:1.25rem;">
                <label for="password">Password <span class="req">*</span></label>
                <input type="password"
                       id="password"
                       name="password"
                       placeholder="Enter password"
                       autocomplete="current-password"
                       required>
            </div>

            <button type="submit" class="btn btn-primary" id="loginBtn"
                    style="width:100%;">Sign In</button>
        </form>

        <p style="margin-top:1.25rem; font-size:0.75rem; color:#627D98; text-align:center;">
            Demo: <strong>admin</strong> / <strong>admin123</strong>
        </p>

    </div>
</div>

<script src="<%= request.getContextPath() %>/js/validation.js"></script>
<script>
function validateLoginForm() {
    var u = document.getElementById('username').value.trim();
    var p = document.getElementById('password').value.trim();
    if (!u || !p) {
        alert('Please enter both username and password.');
        return false;
    }
    return true;
}
</script>
</body>
</html>
