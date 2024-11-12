<%@ include file="dbconfig.jsp" %>
<%@ page import="java.sql.PreparedStatement, java.sql.SQLException" %>

<%
    String message = "";
    if ("POST".equalsIgnoreCase(request.getMethod())) {
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String role = request.getParameter("role");
        String businessName = role.equals("admin") ? request.getParameter("business_name") : null;

        String query = "INSERT INTO users (username, password, role, business_name) VALUES (?, ?, ?, ?)";

        try (PreparedStatement pstmt = conn.prepareStatement(query)) {
            pstmt.setString(1, username);
            pstmt.setString(2, password);
            pstmt.setString(3, role);
            pstmt.setString(4, businessName);
            pstmt.executeUpdate();
            message = "Registration successful!";

            // For admins, create a table specific to their business
            if ("admin".equals(role) && businessName != null) {
                String sanitizedBusinessName = businessName.replaceAll("\\s+", "_");
                String createTableQuery = "CREATE TABLE IF NOT EXISTS `" + sanitizedBusinessName + "_transactions` ("
                    + "id INT AUTO_INCREMENT PRIMARY KEY, "
                    + "transaction_date DATE, "
                    + "amount DOUBLE, "
                    + "description VARCHAR(255))";
                conn.createStatement().executeUpdate(createTableQuery);
            }
        } catch (SQLException e) {
            message = "Error: " + e.getMessage();
        }
    }
%>

<html>
<head>
    <title>Register</title>
</head>
<body>
    <h2>Register</h2>
    <p style="color:red;"><%= message %></p>
    <form method="POST" action="register.jsp">
        <label for="username">Username:</label>
        <input type="text" name="username" required><br>

        <label for="password">Password:</label>
        <input type="password" name="password" required><br>

        <label for="role">Role:</label>
        <select name="role" required onchange="document.getElementById('businessField').style.display = (this.value === 'admin') ? 'block' : 'none';">
            <option value="customer">Customer</option>
            <option value="admin">Admin</option>
        </select><br>

        <div id="businessField" style="display:none;">
            <label for="business_name">Business Name (Admin Only):</label>
            <input type="text" name="business_name"><br>
        </div>

        <button type="submit">Register</button>
    </form>
</body>
</html>
