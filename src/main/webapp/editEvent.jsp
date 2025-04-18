<%@ page import="java.sql.*, java.util.*" %>
<%@ page import="database.DBConnection" %>
<%
    Integer organizerIdObj = (Integer) session.getAttribute("organizerId");
    if (organizerIdObj == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    int organizerId = (Integer) session.getAttribute("userId");

    List<Map<String, String>> events = new ArrayList<>();

    try {
        Connection con = DBConnection.getConnection();
        PreparedStatement ps = con.prepareStatement("SELECT * FROM events WHERE organizer_id = ?");
        ps.setInt(1, organizerId);
        ResultSet rs = ps.executeQuery();

        while (rs.next()) {
            Map<String, String> event = new HashMap<>();
            event.put("id", rs.getString("id"));
            event.put("title", rs.getString("title"));
            event.put("description", rs.getString("description"));
            event.put("date", rs.getString("date"));
            event.put("location", rs.getString("location"));
            event.put("status", rs.getString("status"));
            events.add(event);
        }
        con.close();
    } catch (Exception e) {
        out.println("Error: " + e.getMessage());
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>Manage Your Events</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            background-color: #f8f9fa;
            padding: 40px;
            font-family: 'Segoe UI', sans-serif;
        }
        .event-form {
            border: 1px solid #dee2e6;
            padding: 20px;
            margin-bottom: 20px;
            border-radius: 10px;
            background-color: white;
            box-shadow: 0 2px 8px rgba(0,0,0,0.05);
        }
        .cancelled {
            color: red;
            font-weight: bold;
            margin-top: 10px;
        }
    </style>
</head>
<body>
<div class="container">
    <h1 class="mb-4 text-primary">Your Events</h1>

    <!-- Back to Dashboard Button -->
    <a href="dashboardOrganizer.jsp" class="btn btn-outline-primary mb-4">Back to Dashboard</a>

    <% String msg = request.getParameter("message");
       if (msg != null) { %>
       <div class="alert 
           <%= "updated".equals(msg) ? "alert-success" : 
               "cancelled".equals(msg) ? "alert-warning" : 
               "alert-danger" %>">
           <%= "updated".equals(msg) ? "Event updated!" : 
               "cancelled".equals(msg) ? "Event cancelled!" : 
               "Something went wrong." %>
       </div>
    <% } %>

    <% if (events.isEmpty()) { %>
        <div class="alert alert-info">No events found.</div>
    <% } else {
        for (Map<String, String> e : events) {
            String status = e.get("status");
            boolean isCancelled = "cancelled".equalsIgnoreCase(status);
    %>
        <form method="post" class="event-form row g-3">
            <input type="hidden" name="id" value="<%= e.get("id") %>">

            <div class="col-md-6">
                <label class="form-label">Title</label>
                <input type="text" name="title" class="form-control" value="<%= e.get("title") %>" required <%= isCancelled ? "disabled" : "" %>>
            </div>

            <div class="col-md-6">
                <label class="form-label">Location</label>
                <input type="text" name="location" class="form-control" value="<%= e.get("location") %>" required <%= isCancelled ? "disabled" : "" %>>
            </div>

            <div class="col-md-6">
                <label class="form-label">Date</label>
                <input type="datetime-local" name="date" class="form-control"
                       value="<%= e.get("date").replace(" ", "T") %>" required <%= isCancelled ? "disabled" : "" %>>
            </div>

            <div class="col-md-12">
                <label class="form-label">Description</label>
                <textarea name="description" class="form-control" rows="3" required <%= isCancelled ? "disabled" : "" %>><%= e.get("description") %></textarea>
            </div>

            <% if (isCancelled) { %>
                <div class="col-12">
                    <p class="cancelled">Status: Cancelled</p>
                </div>
            <% } else { %>
                <div class="col-12">
                    <button type="submit" formaction="updateEvent" class="btn btn-success me-2">Update Event</button>
                    <button type="submit" formaction="cancelEvent" class="btn btn-danger"
                            onclick="return confirm('Are you sure you want to cancel this event?');">Cancel Event</button>
                </div>
            <% } %>
        </form>
    <% } } %>
</div>
</body>
</html>
