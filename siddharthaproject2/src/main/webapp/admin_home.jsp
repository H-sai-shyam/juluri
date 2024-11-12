<%@ include file="dbconfig.jsp" %>
<%@ page import="java.sql.PreparedStatement, java.sql.ResultSet" %>

<%
    String username = (String) session.getAttribute("username");
    String role = (String) session.getAttribute("role");
    String businessName = (String) session.getAttribute("businessName");

    if (username == null || !"admin".equals(role)) {
        response.sendRedirect("login.jsp");
        return;
    }

    String sanitizedBusinessName = businessName.replaceAll("\\s+", "_") + "_transactions";
%>

<html>
<head>
    <title>Admin Home</title>
</head>
<body>
    <h2>Welcome, <%= username %>! Transactions for <%= businessName %></h2>

    <table border="1">
        <tr>
            <th>Date</th>
            <th>Amount</th>
            <th>Description</th>
        </tr>

        <%
            String selectQuery = "SELECT transaction_date, amount, description FROM `" + sanitizedBusinessName + "`";
            try (PreparedStatement pstmt = conn.prepareStatement(selectQuery); ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    out.println("<tr>");
                    out.println("<td>" + rs.getDate("transaction_date") + "</td>");
                    out.println("<td>" + rs.getDouble("amount") + "</td>");
                    out.println("<td>" + rs.getString("description") + "</td>");
                    out.println("</tr>");
                }
            } catch (Exception e) {
                out.println("<tr><td colspan='3'>Error: " + e.getMessage() + "</td></tr>");
            }
        %>
    </table>
</body>
</html>
