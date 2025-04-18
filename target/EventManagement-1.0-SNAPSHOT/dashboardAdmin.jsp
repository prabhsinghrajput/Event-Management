<%@ page import="java.sql.*, java.util.*" %>
<%@ page import="database.DBConnection" %>
<%
    class Event {
        int id;
        String title, description, location, status;
        Timestamp date;
        int organizerId;

        Event(int id, String title, String desc, Timestamp date, String location, int organizerId, String status) {
            this.id = id;
            this.title = title;
            this.description = desc;
            this.date = date;
            this.location = location;
            this.organizerId = organizerId;
            this.status = status != null ? status : "unknown";
        }
    }

    List<Event> pendingEvents = new ArrayList<>();
    List<Event> approvedEvents = new ArrayList<>();
    List<Event> rejectedEvents = new ArrayList<>();
    List<Event> cancelledEvents = new ArrayList<>();
    List<Event> unknownEvents = new ArrayList<>();

    try {
        Connection con = DBConnection.getConnection();
        PreparedStatement ps = con.prepareStatement("SELECT * FROM events");
        ResultSet rs = ps.executeQuery();

        while (rs.next()) {
            Event event = new Event(
                rs.getInt("id"),
                rs.getString("title"),
                rs.getString("description"),
                rs.getTimestamp("date"),
                rs.getString("location"),
                rs.getInt("organizer_id"),
                rs.getString("status")
            );

            switch (event.status.toLowerCase()) {
                case "pending": pendingEvents.add(event); break;
                case "approved": approvedEvents.add(event); break;
                case "rejected": rejectedEvents.add(event); break;
                case "cancelled": cancelledEvents.add(event); break;
                default: unknownEvents.add(event); break;
            }
        }

        con.close();
    } catch (Exception e) {
        out.println("<div class='alert alert-danger'>Error: " + e.getMessage() + "</div>");
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Admin Dashboard - Events</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            background-color: #f8f9fa;
            padding: 30px;
        }

        .card {
            margin-bottom: 40px;
            border-radius: 10px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.05);
        }

        .table thead {
            background-color: #e9ecef;
        }

        .badge-status {
            font-size: 0.9em;
        }

        .section-title {
            margin-bottom: 15px;
            color: #333;
        }

        .action-buttons button {
            margin-right: 5px;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1 class="mb-5 text-center text-primary">Admin Dashboard - Events</h1>

        <%-- Pending Events Section --%>
        <div class="card">
            <div class="card-header bg-warning text-white">
                <h5 class="mb-0">Pending Events</h5>
            </div>
            <div class="card-body">
                <table class="table table-hover table-bordered align-middle">
                    <thead>
                        <tr>
                            <th>Title</th><th>Description</th><th>Date</th><th>Location</th><th>Organizer ID</th><th>Action</th>
                        </tr>
                    </thead>
                    <tbody>
                    <%
                        for (Event e : pendingEvents) {
                    %>
                        <tr>
                            <td><%= e.title %></td>
                            <td><%= e.description %></td>
                            <td><%= e.date %></td>
                            <td><%= e.location %></td>
                            <td><%= e.organizerId %></td>
                            <td class="action-buttons">
                                <form method="post" action="approveEvent" class="d-inline">
                                    <input type="hidden" name="eventId" value="<%= e.id %>">
                                    <button type="submit" name="action" value="approve" class="btn btn-success btn-sm">Approve</button>
                                    <button type="submit" name="action" value="reject" class="btn btn-danger btn-sm">Reject</button>
                                </form>
                            </td>
                        </tr>
                    <%
                        }
                    %>
                    </tbody>
                </table>
            </div>
        </div>

        <%-- Approved Events Section --%>
        <div class="card">
            <div class="card-header bg-success text-white">
                <h5 class="mb-0">Approved Events</h5>
            </div>
            <div class="card-body">
                <table class="table table-bordered table-striped">
                    <thead>
                        <tr><th>Title</th><th>Description</th><th>Date</th><th>Location</th><th>Organizer ID</th></tr>
                    </thead>
                    <tbody>
                    <%
                        for (Event e : approvedEvents) {
                    %>
                        <tr>
                            <td><%= e.title %></td>
                            <td><%= e.description %></td>
                            <td><%= e.date %></td>
                            <td><%= e.location %></td>
                            <td><%= e.organizerId %></td>
                        </tr>
                    <%
                        }
                    %>
                    </tbody>
                </table>
            </div>
        </div>

        <%-- Rejected Events Section --%>
        <div class="card">
            <div class="card-header bg-danger text-white">
                <h5 class="mb-0">Rejected Events</h5>
            </div>
            <div class="card-body">
                <table class="table table-bordered">
                    <thead>
                        <tr><th>Title</th><th>Description</th><th>Date</th><th>Location</th><th>Organizer ID</th></tr>
                    </thead>
                    <tbody>
                    <%
                        for (Event e : rejectedEvents) {
                    %>
                        <tr>
                            <td><%= e.title %></td>
                            <td><%= e.description %></td>
                            <td><%= e.date %></td>
                            <td><%= e.location %></td>
                            <td><%= e.organizerId %></td>
                        </tr>
                    <%
                        }
                    %>
                    </tbody>
                </table>
            </div>
        </div>

        <%-- Cancelled Events Section --%>
        <div class="card">
            <div class="card-header bg-secondary text-white">
                <h5 class="mb-0">Cancelled Events</h5>
            </div>
            <div class="card-body">
                <table class="table table-bordered table-light">
                    <thead>
                        <tr><th>Title</th><th>Description</th><th>Date</th><th>Location</th><th>Organizer ID</th></tr>
                    </thead>
                    <tbody>
                    <%
                        for (Event e : cancelledEvents) {
                    %>
                        <tr>
                            <td><%= e.title %></td>
                            <td><%= e.description %></td>
                            <td><%= e.date %></td>
                            <td><%= e.location %></td>
                            <td><%= e.organizerId %></td>
                        </tr>
                    <%
                        }
                    %>
                    </tbody>
                </table>
            </div>
        </div>

        <%-- Unknown Events Section --%>
        <%
            if (!unknownEvents.isEmpty()) {
        %>
        <div class="card">
            <div class="card-header bg-info text-white">
                <h5 class="mb-0">Unknown Status Events</h5>
            </div>
            <div class="card-body">
                <table class="table table-bordered table-warning">
                    <thead>
                        <tr><th>Title</th><th>Description</th><th>Date</th><th>Location</th><th>Status</th><th>Organizer ID</th></tr>
                    </thead>
                    <tbody>
                    <%
                        for (Event e : unknownEvents) {
                    %>
                        <tr>
                            <td><%= e.title %></td>
                            <td><%= e.description %></td>
                            <td><%= e.date %></td>
                            <td><%= e.location %></td>
                            <td><span class="badge bg-dark"><%= e.status %></span></td>
                            <td><%= e.organizerId %></td>
                        </tr>
                    <%
                        }
                    %>
                    </tbody>
                </table>
            </div>
        </div>
        <%
            }
        %>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
