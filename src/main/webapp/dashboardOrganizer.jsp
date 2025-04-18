<%@ page import="java.sql.*, javax.servlet.http.*, javax.servlet.*" %>
<%@ page import="database.DBConnection" %>
<%
    HttpSession sessionUser = request.getSession(false);
    if (sessionUser == null || !"organizer".equals(sessionUser.getAttribute("role"))) {
        response.sendRedirect("login.jsp");
        return;
    }

    int userId = (Integer) sessionUser.getAttribute("userId");
    session.setAttribute("organizerId", userId);
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Organizer Dashboard</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            background-color: #f8f9fa;
            padding: 40px;
            font-family: 'Segoe UI', sans-serif;
        }
        h2 {
            color: #343a40;
        }
        .nav-links .btn {
            margin-right: 10px;
        }
        .table th {
            background-color: #0d6efd;
            color: white;
        }
        .status-approved {
            color: green;
            font-weight: bold;
        }
        .status-pending {
            color: orange;
            font-weight: bold;
        }
        .status-cancelled {
            color: red;
            font-weight: bold;
        }
    </style>
</head>
<body>

<div class="container">
    <h2 class="mb-3">Welcome, <%= sessionUser.getAttribute("userName") %> (Organizer)</h2>

    <div class="nav-links mb-4">
        <a href="addEvent.jsp" class="btn btn-primary btn-sm">Add New Event</a>
        <a href="editEvent.jsp" class="btn btn-secondary btn-sm">Edit Events</a>
        <a href="logout.jsp" class="btn btn-danger btn-sm">Logout</a>
    </div>

    <h4 class="mb-3">Your Events Overview</h4>
    <table class="table table-bordered table-hover shadow-sm bg-white">
        <thead>
            <tr>
                <th>Title</th>
                <th>Date</th>
                <th>Location</th>
                <th>Status</th>
            </tr>
        </thead>
        <tbody>
        <%
            try {
                Connection con = DBConnection.getConnection();
                String eventSql = "SELECT id, title, date, location, status FROM events WHERE organizer_id = ? AND status IN ('approved', 'cancelled', 'pending')";
                PreparedStatement ps = con.prepareStatement(eventSql);
                ps.setInt(1, userId);
                ResultSet rs = ps.executeQuery();

                while (rs.next()) {
                    String title = rs.getString("title");
                    Timestamp date = rs.getTimestamp("date");
                    String location = rs.getString("location");
                    String status = rs.getString("status");
                    String cssClass = "status-" + status.toLowerCase();
        %>
            <tr>
                <td><%= title %></td>
                <td><%= date %></td>
                <td><%= location %></td>
                <td class="<%= cssClass %>">
                    <%= status.substring(0, 1).toUpperCase() + status.substring(1).toLowerCase() %>
                </td>
            </tr>
        <%
                }
                rs.close();
                ps.close();
                con.close();
            } catch (Exception e) {
        %>
            <tr>
                <td colspan="4" class="text-danger">Error: <%= e.getMessage() %></td>
            </tr>
        <%
            }
        %>
        </tbody>
    </table>
</div>

</body>
</html>
