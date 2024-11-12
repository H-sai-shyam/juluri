<%@ include file="dbconfig.jsp" %>
<%@ page import="java.sql.PreparedStatement, java.sql.ResultSet" %>

<%
    String username = (String) session.getAttribute("username");
    String role = (String) session.getAttribute("role");

    if (username == null || !"customer".equals(role)) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    String message = "";
    if ("POST".equalsIgnoreCase(request.getMethod())) {
        // Capture form inputs
        String businessName = request.getParameter("business_name");
        double amount = Double.parseDouble(request.getParameter("amount"));
        String description = request.getParameter("description");

        // Insert new transaction into the business-specific table
        String sanitizedBusinessName = businessName.replaceAll("\\s+", "_") + "_transactions";
        String insertQuery = "INSERT INTO `" + sanitizedBusinessName + "` (transaction_date, amount, description) VALUES (CURRENT_DATE, ?, ?)";
        
        try (PreparedStatement pstmt = conn.prepareStatement(insertQuery)) {
            pstmt.setDouble(1, amount);
            pstmt.setString(2, description);
            pstmt.executeUpdate();
            message = "Transaction added successfully!";
        } catch (Exception e) {
            message = "Error: " + e.getMessage();
        }
    }
%>

<html>
<head>
    <title>Customer Home</title>
</head>
<body>
    <h2>Welcome, <%= username %>! Your Payments</h2>
    <p style="color:green;"><%= message %></p>

    <!-- Transaction Form -->
    <form method="POST" action="customer_home.jsp">
        <label for="business_name">Business Name:</label>
        <input type="text" name="business_name" required><br>

        <label for="amount">Amount:</label>
        <input type="number" name="amount" step="0.01" required><br>

        <label for="description">Description:</label>
        <input type="text" name="description" required><br>

        <button type="submit">Add Transaction</button>
    </form>

    <!-- Display Customer Payments -->
    <h3>Your Transactions</h3>
    <table border="1">
        <tr>
            <th>Business Name</th>
            <th>Amount</th>
        </tr>
        
        <%
            String selectPaymentsQuery = "SELECT business_name, amount FROM payments WHERE username = ?";
            try (PreparedStatement pstmt = conn.prepareStatement(selectPaymentsQuery)) {
                pstmt.setString(1, username);
                ResultSet rs = pstmt.executeQuery();
                while (rs.next()) {
                    out.println("<tr>");
                    out.println("<td>" + rs.getString("business_name") + "</td>");
                    out.println("<td>" + rs.getDouble("amount") + "</td>");
                    out.println("</tr>");
                }
            } catch (Exception e) {
                out.println("<tr><td colspan='2'>Error: " + e.getMessage() + "</td></tr>");
            }
        %>
    </table>
</body>
</html>
