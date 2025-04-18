<%@ page import="java.sql.*" %>
<%@ page session="true" %>
<%
    Integer userId = (Integer) session.getAttribute("userId");
    String role = (String) session.getAttribute("role");

    if (userId == null || role == null || !role.equals("attendee")) {
        response.sendRedirect("login.jsp");
        return;
    }

    Connection con = null;
    PreparedStatement ps = null;
    ResultSet rs = null;
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Join Events</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            background-color: #f2f7ff;
            padding: 40px;
            font-family: 'Segoe UI', sans-serif;
        }
        .table thead {
            background-color: #0d6efd;
            color: white;
        }
        .already-joined {
            color: gray;
            font-weight: bold;
        }
        .container {
            max-width: 1000px;
        }
    </style>
</head>
<body>
<div class="container">
    <h2 class="mb-4 text-primary">Available Events to Join</h2>

    <table class="table table-bordered table-hover shadow-sm bg-white">
        <thead>
            <tr>
                <th>Title</th>
                <th>Description</th>
                <th>Date</th>
                <th>Location</th>
                <th>Action</th>
            </tr>
        </thead>
        <tbody>
        <%
            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                con = DriverManager.getConnection("jdbc:mysql://localhost:3306/event_management", "root", "");

                ps = con.prepareStatement(
                    "SELECT e.id, e.title, e.description, e.date, e.location, " +
                    "(SELECT COUNT(*) FROM registrations r WHERE r.user_id=? AND r.event_id=e.id) AS registered " +
                    "FROM events e WHERE e.status = 'approved'"
                );
                ps.setInt(1, userId);
                rs = ps.executeQuery();

                while (rs.next()) {
                    int eventId = rs.getInt("id");
                    boolean alreadyRegistered = rs.getInt("registered") > 0;
        %>
            <tr>
                <td><%= rs.getString("title") %></td>
                <td><%= rs.getString("description") %></td>
                <td><%= rs.getTimestamp("date") %></td>
                <td><%= rs.getString("location") %></td>
                <td>
                    <% if (alreadyRegistered) { %>
                        <span class="already-joined"> Already Joined</span>
                    <% } else { %>
                        <form method="post" action="registerEvent.jsp" class="d-inline">
                            <input type="hidden" name="event_id" value="<%= eventId %>">
                            <button type="submit" class="btn btn-success btn-sm">Join</button>
                        </form>
                    <% } %>
                </td>
            </tr>
        <%
                }
            } catch (Exception e) {
                out.println("<tr><td colspan='5' class='text-danger'>Error: " + e.getMessage() + "</td></tr>");
                e.printStackTrace();
            } finally {
                if (rs != null) try { rs.close(); } catch (Exception e) {}
                if (ps != null) try { ps.close(); } catch (Exception e) {}
                if (con != null) try { con.close(); } catch (Exception e) {}
            }
        %>
        </tbody>
    </table>

    <a href="dashboardAttendee.jsp" class="btn btn-secondary mt-3"> Back to Dashboard</a>
</div>
</body>
</html>
