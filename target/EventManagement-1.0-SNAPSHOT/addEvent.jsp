<%@ page import="java.sql.*" %>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>
<%@ page contentType="text/html; charset=UTF-8" %>

<%
    HttpSession sessionUser = request.getSession(false);
    if (sessionUser == null || sessionUser.getAttribute("role") == null || !sessionUser.getAttribute("role").equals("organizer")) {
        response.sendRedirect("login.jsp");
        return;
    }

    String title = request.getParameter("title");
    String description = request.getParameter("description");
    String date = request.getParameter("date");
    String location = request.getParameter("location");
    int organizerId = (int) sessionUser.getAttribute("userId");

    String message = "";
    String messageClass = "";

    if (title != null && description != null && date != null && location != null) {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/event_management", "root", "");
            PreparedStatement ps = con.prepareStatement("INSERT INTO events (title, description, date, location, organizer_id) VALUES (?, ?, ?, ?, ?)");
            ps.setString(1, title);
            ps.setString(2, description);
            ps.setString(3, date);
            ps.setString(4, location);
            ps.setInt(5, organizerId);
            ps.executeUpdate();
            con.close();

            message = "Event added successfully!";
            messageClass = "alert-success";
        } catch (Exception e) {
            message = "Error: " + e.getMessage();
            messageClass = "alert-danger";
        }
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Add Event</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            background-color: #f8f9fa;
            padding: 40px;
            font-family: 'Segoe UI', sans-serif;
        }
        .container {
            max-width: 600px;
            background: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 0 15px rgba(0,0,0,0.1);
        }
        h2 {
            margin-bottom: 25px;
            color: #343a40;
        }
    </style>
</head>
<body>

<div class="container">
    <h2>Add New Event</h2>

    <% if (!message.isEmpty()) { %>
        <div class="alert <%= messageClass %>"><%= message %></div>
    <% } %>

    <form method="post" action="addEvent.jsp">
        <div class="mb-3">
            <label class="form-label">Title</label>
            <input type="text" name="title" class="form-control" required>
        </div>

        <div class="mb-3">
            <label class="form-label">Description</label>
            <textarea name="description" class="form-control" rows="4" required></textarea>
        </div>

        <div class="mb-3">
            <label class="form-label">Date & Time</label>
            <input type="datetime-local" name="date" class="form-control" required>
        </div>

        <div class="mb-3">
            <label class="form-label">Location</label>
            <input type="text" name="location" class="form-control" required>
        </div>

        <button type="submit" class="btn btn-primary">Add Event</button>
        <a href="dashboardOrganizer.jsp" class="btn btn-secondary">Back to Dashboard</a>
    </form>
</div>

</body>
</html>
