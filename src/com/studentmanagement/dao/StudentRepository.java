package com.studentmanagement.dao;

import com.studentmanagement.beans.StudentBean;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

public class StudentRepository {

    private static StudentRepository instance;

    private StudentRepository() {
        students.add(new StudentBean("S001", "Alice Johnson",    "alice@college.edu",  "9876543210",
                "Computer Science",  3, "Female", "12 Maple Street"));
        students.add(new StudentBean("S002", "Bob Smith",        "bob@college.edu",    "9123456780",
                "Electronics",       5, "Male",   "44 Oak Avenue"));
        students.add(new StudentBean("S003", "Priya Sharma",     "priya@college.edu",  "9988776655",
                "Mechanical",        1, "Female", "7 Rose Colony"));
    }

    public static synchronized StudentRepository getInstance() {
        if (instance == null) {
            instance = new StudentRepository();
        }
        return instance;
    }

    private final List<StudentBean> students = new ArrayList<>();

    public synchronized List<StudentBean> getAllStudents() {
        return Collections.unmodifiableList(new ArrayList<>(students));
    }

    public synchronized int getStudentCount() {
        return students.size();
    }

    public synchronized StudentBean findById(String studentId) {
        if (studentId == null || studentId.trim().isEmpty()) return null;
        for (StudentBean s : students) {
            if (s.getStudentId().equalsIgnoreCase(studentId.trim())) {
                return s;
            }
        }
        return null;
    }

    public synchronized boolean addStudent(StudentBean student) {
        if (findById(student.getStudentId()) != null) {
            return false;
        }
        students.add(student);
        return true;
    }

    public synchronized boolean updateStudent(StudentBean updated) {
        for (int i = 0; i < students.size(); i++) {
            if (students.get(i).getStudentId().equalsIgnoreCase(updated.getStudentId())) {
                students.set(i, updated);
                return true;
            }
        }
        return false;
    }

    public synchronized boolean deleteStudent(String studentId) {
        return students.removeIf(s -> s.getStudentId().equalsIgnoreCase(studentId.trim()));
    }

    public synchronized List<StudentBean> search(String query, String field) {
        List<StudentBean> results = new ArrayList<>();
        if (query == null || query.trim().isEmpty()) {
            results.addAll(students);
            return results;
        }

        String trimmedQuery = query.trim().toLowerCase();
        String targetField = (field == null || field.trim().isEmpty()) ? "all" : field.trim().toLowerCase();
        String[] tokens = trimmedQuery.split("\\s+");

        for (StudentBean s : students) {
            if (matchesStudent(s, targetField, trimmedQuery, tokens)) {
                results.add(s);
            }
        }
        return results;
    }

    private boolean matchesStudent(StudentBean s, String field, String fullQuery, String[] tokens) {
        if (s == null) return false;

        String id       = s.getStudentId()  != null ? s.getStudentId()  : "";
        String name     = s.getName()       != null ? s.getName()       : "";
        String email    = s.getEmail()      != null ? s.getEmail()      : "";
        String phone    = s.getPhone()      != null ? s.getPhone()      : "";
        String dept     = s.getDepartment() != null ? s.getDepartment() : "";
        String sem      = String.valueOf(s.getSemester());
        String semFull  = "sem " + sem;
        String gender   = s.getGender()     != null ? s.getGender()     : "";
        String address  = s.getAddress()    != null ? s.getAddress()    : "";

        switch (field) {
            case "id":
                return containsIgnoreCase(id, fullQuery);
            case "name":
                return containsIgnoreCase(name, fullQuery);
            case "email":
                return containsIgnoreCase(email, fullQuery);
            case "phone":
                return containsIgnoreCase(phone, fullQuery);
            case "department":
                return containsIgnoreCase(dept, fullQuery);
            case "semester":
                return sem.equals(fullQuery) || containsIgnoreCase(semFull, fullQuery) || containsIgnoreCase("semester " + sem, fullQuery);
            case "gender":
                return gender.equalsIgnoreCase(fullQuery);
            case "address":
                return containsIgnoreCase(address, fullQuery);
            case "all":
            default:
                if (containsIgnoreCase(id, fullQuery)
                        || containsIgnoreCase(name, fullQuery)
                        || containsIgnoreCase(email, fullQuery)
                        || containsIgnoreCase(phone, fullQuery)
                        || containsIgnoreCase(dept, fullQuery)
                        || sem.equals(fullQuery)
                        || containsIgnoreCase(semFull, fullQuery)
                        || containsIgnoreCase(gender, fullQuery)
                        || containsIgnoreCase(address, fullQuery)) {
                    return true;
                }
                if (tokens.length > 1) {
                    String combined = (id + " " + name + " " + email + " " + phone + " " + dept + " " + semFull + " " + gender + " " + address).toLowerCase();
                    boolean allTokensMatch = true;
                    for (String token : tokens) {
                        if (!combined.contains(token)) {
                            allTokensMatch = false;
                            break;
                        }
                    }
                    return allTokensMatch;
                }
                return false;
        }
    }

    private boolean containsIgnoreCase(String source, String target) {
        if (source == null || target == null) return false;
        return source.toLowerCase().contains(target.toLowerCase());
    }
}
