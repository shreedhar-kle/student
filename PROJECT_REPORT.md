# Student Management System — Project Report

**Course:** Web Technology / Advanced Java  
**Technology Stack:** Java Servlets · JSP · HttpSession · JavaBeans  
**Server:** Apache Tomcat 9.x (Servlet 4.0)

---

## 1. Abstract

The Student Management System (SMS) is a web application developed as a college mini project using core Java web technologies. It allows an administrator to log in, manage student records (add, view, search, edit, delete), and log out securely. The project demonstrates the practical use of Java Servlets for request handling, JSP for dynamic page rendering, HttpSession for authentication state management, and JavaBeans as data transfer objects.

---

## 2. Problem Statement

Educational institutions need a simple, centralised tool to maintain student records. Manual methods such as spreadsheets are error-prone and hard to query. This project provides a web-based interface to perform CRUD (Create, Read, Update, Delete) operations on student data.

---

## 3. Objectives

- Implement a secure login system using HttpSession.
- Provide CRUD operations for student records.
- Display student data dynamically using JSP.
- Separate business logic (Servlets) from presentation (JSP).
- Use JavaBeans as structured data objects.
- Apply server-side and client-side input validation.

---

## 4. Scope

- Single administrator account (expandable to multiple users).
- In-memory data store (expandable to a database with JDBC).
- Core CRUD + search operations.
- Responsive, minimal web interface.

---

## 5. Software Requirements

| Component | Version |
|-----------|---------|
| Java (JDK) | 8 or above |
| Apache Tomcat | 9.x |
| IDE | Eclipse / IntelliJ IDEA / NetBeans |
| Browser | Any modern browser |

No external libraries or build tools are required.

---

## 6. Technologies Used

| Technology | Role |
|------------|------|
| Java Servlets | Handle HTTP requests, business logic, authentication |
| JSP | Dynamic HTML generation and display |
| HttpSession | Session management and authentication state |
| JavaBeans | Student and user data objects |
| HTML5 / CSS3 | Page structure and styling |
| JavaScript | Client-side validation and UX enhancements |

---

## 7. System Architecture (MVC)

```
Browser
  │
  │  HTTP Request
  ▼
Servlet (Controller)
  │  reads/writes
  ▼
StudentRepository (Model — in-memory ArrayList)
  │  sets attributes
  ▼
JSP (View — HTML response)
  │
  ▼
Browser
```

- **Model** — `StudentBean`, `UserBean`, `StudentRepository`
- **View** — JSP pages (`login.jsp`, `dashboard.jsp`, etc.)
- **Controller** — Servlet classes

---

## 8. Module Descriptions

### A. Login System (`LoginServlet`, `login.jsp`)
- Displays a login form.
- Validates username and password against demo credentials.
- Creates an `HttpSession` and stores a `UserBean` on success.
- Redirects unauthenticated users to the login page.

### B. Dashboard (`DashboardServlet`, `dashboard.jsp`)
- Shows the total student count and quick-action links.
- Contains a static `isAuthenticated()` helper used by every other Servlet.

### C. Add Student (`AddStudentServlet`, `addStudent.jsp`)
- Form with eight student fields.
- Validates required fields, email format, phone format, and duplicate IDs.
- Creates a `StudentBean` and adds it to `StudentRepository`.
- POST-Redirect-GET pattern on success.

### D. View Students (`ViewStudentsServlet`, `viewStudents.jsp`)
- Retrieves all students from `StudentRepository`.
- Renders a table with edit and delete actions.
- Shows an empty-state message when no records exist.

### E. Search Students (`SearchStudentServlet`, `searchStudent.jsp`)
- Accepts a search term and field selector (ID / Name / Department / All).
- Calls `StudentRepository.search()` and displays matching records.

### F. Edit Student (`EditStudentServlet`, `editStudent.jsp`)
- Loads the student by ID into the edit form with pre-filled values.
- Student ID is read-only.

### G. Update Student (`UpdateStudentServlet`)
- Processes the edit form POST with the same validations as Add.

### H. Delete Student (`DeleteStudentServlet`)
- Processes a POST request; JavaScript confirm() shown before submission.

### I. Logout (`LogoutServlet`)
- Calls `session.invalidate()` and redirects to login.

---

## 9. Data Flow — Key Operations

**Login:**
1. POST `/login` → `LoginServlet.doPost()`
2. Credentials valid → new session, store `UserBean`, redirect `/dashboard`
3. Credentials invalid → error attr set, forward to `login.jsp`

**Add Student:**
1. POST `/addStudent` → `AddStudentServlet.doPost()`
2. Validation passes → `StudentRepository.addStudent()` → redirect `/viewStudents`
3. Validation fails → error + formData forwarded back to `addStudent.jsp`

**Delete:**
1. JS confirm() → POST `/deleteStudent`
2. `DeleteStudentServlet` → `StudentRepository.deleteStudent()` → redirect `/viewStudents`

---

## 10. HttpSession Usage

| Event | Action |
|-------|--------|
| Successful login | `request.getSession(true)` — new session created |
| Store user | `session.setAttribute("loggedInUser", userBean)` |
| Auth check | `session.getAttribute("loggedInUser") != null` |
| Logout | `session.invalidate()` |
| Timeout | 30 minutes (configured in `web.xml`) |

---

## 11. Known Limitations

1. **No persistence** — data is lost when Tomcat restarts.
2. **Hard-coded credentials** — for demo only; not for production.
3. **No pagination** — all records in one table.
4. **Basic concurrency** — `synchronized` methods; adequate for classroom demo.

---

## 12. Future Enhancements

- JDBC/MySQL persistence.
- Multiple user accounts with role-based access.
- Pagination and sorting.
- CSV/PDF export.
- Password hashing (BCrypt).

---

## 13. How to Deploy

1. Open project in Eclipse / IntelliJ IDEA / NetBeans.
2. Configure Tomcat 9 server in the IDE.
3. Add project to server.
4. Start server.
5. Visit `http://localhost:8080/StudentManagementSystem/`
6. Login: **admin / admin123**

> **Eclipse:** Create "Dynamic Web Project", copy `src/` and `WebContent/` into it, add to Tomcat server, run.

---

## 14. Conclusion

This project demonstrates a complete Student Management System built with core Java web technologies: Servlets, JSP, HttpSession, and JavaBeans — with no external frameworks or build tools. It covers the full MVC request-response cycle suitable for academic evaluation and viva defence.

---
*Developed as a college mini project — Web Technology / Advanced Java.*
