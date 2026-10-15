package com.studentmanagement.beans;

public class StudentBean {

    private String studentId;
    private String name;
    private String email;
    private String phone;
    private String department;
    private int semester;
    private String gender;
    private String address;

    public StudentBean() {
    }

    public StudentBean(String studentId, String name, String email, String phone,
                       String department, int semester, String gender, String address) {
        this.studentId   = studentId;
        this.name        = name;
        this.email       = email;
        this.phone       = phone;
        this.department  = department;
        this.semester    = semester;
        this.gender      = gender;
        this.address     = address;
    }

    public String getStudentId()   { return studentId; }
    public String getName()        { return name; }
    public String getEmail()       { return email; }
    public String getPhone()       { return phone; }
    public String getDepartment()  { return department; }
    public int    getSemester()    { return semester; }
    public String getGender()      { return gender; }
    public String getAddress()     { return address; }

    public void setStudentId(String studentId)   { this.studentId   = studentId; }
    public void setName(String name)             { this.name        = name; }
    public void setEmail(String email)           { this.email       = email; }
    public void setPhone(String phone)           { this.phone       = phone; }
    public void setDepartment(String department) { this.department  = department; }
    public void setSemester(int semester)        { this.semester    = semester; }
    public void setGender(String gender)         { this.gender      = gender; }
    public void setAddress(String address)       { this.address     = address; }

    @Override
    public String toString() {
        return "StudentBean{studentId='" + studentId + "', name='" + name + "'}";
    }
}
