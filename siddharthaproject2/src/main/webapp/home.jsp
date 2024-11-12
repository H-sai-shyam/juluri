<%@ include file="dbconfig.jsp" %>
<%@ page import="java.sql.PreparedStatement, java.sql.ResultSet, java.sql.SQLException" %>

<%
    // Check if the user is logged in and if the role is 'customer'
    String username = (String) session.getAttribute("username");
    String role = (String) session.getAttribute("role");

    if (username == null || role == null || !role.equals("customer")) {
        response.sendRedirect("login.jsp");
        return;
    }
%>

<html>
<head>
    <title>Customer Dashboard</title>
</head>
<body>
    <h2>Welcome, <%= username %>! (Customer)</h2>
    <form action="home.jsp" method="post">
        <table>
            <tr>
                <th>Business Name</th>
                <th>Amount to be Paid</th>
            </tr>
            <tr>
                <td><input type="text" name="business_name" required></td>
                <td><input type="number" name="amount" required></td>
            </tr>
        </table>
        <input type="submit" value="Save">
    </form>

    <%
        // Get form input values
        String businessName = request.getParameter("business_name");
        String amountStr = request.getParameter("amount");

        if (businessName != null && amountStr != null) {
            try {
                double amount = Double.parseDouble(amountStr);
                String query = "INSERT INTO payments (username, business_name, amount) VALUES (?, ?, ?)";
                PreparedStatement pstmt = conn.prepareStatement(query);
                pstmt.setString(1, username);
                pstmt.setString(2, businessName);
                pstmt.setDouble(3, amount);
                pstmt.executeUpdate();
                out.println("<p>Data saved successfully!</p>");
            } catch (SQLException e) {
                out.println("<p>Error: " + e.getMessage() + "</p>");
            }
        }

        // Display existing records for this user
        String selectQuery = "SELECT business_name, amount FROM payments WHERE username = ?";
        try {
            PreparedStatement pstmt = conn.prepareStatement(selectQuery);
            pstmt.setString(1, username);
            ResultSet rs = pstmt.executeQuery();
    %>

    <h3>Your Payments:</h3>
    <table border="1">
        <tr>
            <th>Business Name</th>
            <th>Amount to be Paid</th>
        </tr>
        <%
            while (rs.next()) {
                String business = rs.getString("business_name");
                double amount = rs.getDouble("amount");
        %>
        <tr>
            <td><%= business %></td>
            <td><%= amount %></td>
        </tr>
        <%
            }
            rs.close();
            pstmt.close();
        } catch (SQLException e) {
            out.println("<p>Error: " + e.getMessage() + "</p>");
        }
    %>
    </table>
</body>
</html>
