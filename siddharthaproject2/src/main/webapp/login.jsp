<%@ page import="java.sql.PreparedStatement, java.sql.ResultSet" %>
<%@ include file="dbconfig.jsp" %>

<%
    String message = "";
    if ("POST".equalsIgnoreCase(request.getMethod())) {
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        String query = "SELECT username, role, business_name FROM users WHERE username = ? AND password = ?";
        try (PreparedStatement pstmt = conn.prepareStatement(query)) {
            pstmt.setString(1, username);
            pstmt.setString(2, password);
            ResultSet rs = pstmt.executeQuery();

            if (rs.next()) {
                String role = rs.getString("role");
                session.setAttribute("username", username);
                session.setAttribute("role", role);
                session.setAttribute("businessName", rs.getString("business_name"));

                if ("admin".equals(role)) {
                    response.sendRedirect("admin_home.jsp");
                } else {
                    response.sendRedirect("customer_home.jsp");
                }
            } else {
                message = "Invalid username or password.";
            }
        } catch (Exception e) {
            message = "Error: " + e.getMessage();
        }
    }
%>

<html>
<head>
    <title>Login</title>
</head>
<body>
    <h2>Login</h2>
    <p style="color:red;"><%= message %></p>
    <form method="POST" action="login.jsp">
        <label for="username">Username:</label>
        <input type="text" name="username" required><br>

        <label for="password">Password:</label>
        <input type="password" name="password" required><br>

        <button type="submit">Login</button>
    </form>
</body>
</html>
