<%@ page import="java.sql.*, javax.servlet.http.*, javax.servlet.*" %>
<%
    HttpSession sessionUser = request.getSession(false);
    if (sessionUser == null || !"attendee".equals(sessionUser.getAttribute("role"))) {
        response.sendRedirect("login.jsp");
        return;
    }

    int userId = (Integer) sessionUser.getAttribute("userId");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Attendee Dashboard</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            background-color: #f5f9ff;
            padding: 40px;
            font-family: 'Segoe UI', sans-serif;
        }

        .dashboard-card {
            max-width: 600px;
            margin: auto;
            padding: 30px;
            background-color: white;
            border-radius: 15px;
            box-shadow: 0 10px 25px rgba(0,0,0,0.1);
        }

        .dashboard-card h2 {
            color: #0d6efd;
            margin-bottom: 30px;
        }

        .dashboard-buttons .btn {
            width: 100%;
            margin-bottom: 15px;
        }
    </style>
</head>
<body>
    <div class="dashboard-card text-center">
        <h2>Welcome, <%= sessionUser.getAttribute("userName") %> </h2>
        <p class="text-muted">You are logged in as <strong>Attendee</strong></p>

        <div class="dashboard-buttons mt-4">
            <a href="joinEvents.jsp" class="btn btn-primary btn-lg">Join an Event</a>
            <a href="logout.jsp" class="btn btn-outline-danger btn-lg">Logout</a>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
