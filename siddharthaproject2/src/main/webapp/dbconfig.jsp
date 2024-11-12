<%@ page import="java.sql.Connection, java.sql.DriverManager, java.sql.SQLException" %>
<%
    Connection conn = null;
    String dbURL = "jdbc:mysql://localhost:3306/users_db"; // Update to your database name
    String dbUser = "root"; // Update with your MySQL username
    String dbPass = "1234"; // Update with your MySQL password

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection(dbURL, dbUser, dbPass);
        application.setAttribute("DBConnection", conn);
    } catch (SQLException | ClassNotFoundException e) {
        out.println("Database Connection Error: " + e.getMessage());
    }
%>
