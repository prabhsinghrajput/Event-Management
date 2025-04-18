<%@ page import="java.sql.*" %>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>
<%@ page contentType="text/html; charset=UTF-8" %>

<%
    String email = request.getParameter("email");
    String password = request.getParameter("password");
    String errorMessage = null;

    if (email != null && password != null) {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/event_management", "root", "");

            PreparedStatement ps = con.prepareStatement("SELECT id, name, role FROM users WHERE email=? AND password=?");
            ps.setString(1, email);
            ps.setString(2, password);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                HttpSession sessionUser = request.getSession();
                sessionUser.setAttribute("userId", rs.getInt("id"));
                sessionUser.setAttribute("userName", rs.getString("name"));
                sessionUser.setAttribute("role", rs.getString("role"));

                if (rs.getString("role").equals("organizer")) {
                    response.sendRedirect("dashboardOrganizer.jsp");
                } else if (rs.getString("role").equals("attendee")) {
                    response.sendRedirect("dashboardAttendee.jsp");
                } else {
                    response.sendRedirect("dashboardAdmin.jsp");
                }
                return;
            } else {
                errorMessage = "Invalid email or password!";
            }

            con.close();
        } catch (Exception e) {
            errorMessage = "Database error: " + e.getMessage();
        }
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Login | Event Management</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

    <!-- Custom Styles -->
    <style>
        body {
            background: #f4f6f9;
        }

        .login-container {
            max-width: 400px;
            margin: auto;
            padding-top: 80px;
        }

        .card {
            border-radius: 1rem;
            box-shadow: 0 0 20px rgba(0, 0, 0, 0.1);
        }

        .btn-primary {
            background-color: #007bff;
            border-color: #007bff;
        }

        .btn-primary:hover {
            background-color: #0056b3;
        }

        .form-control:focus {
            box-shadow: none;
            border-color: #86b7fe;
        }
    </style>
</head>
<body>
    <div class="login-container">
        <div class="card p-4">
            <h2 class="text-center mb-4">Login</h2>

            <% if (errorMessage != null) { %>
                <div class="alert alert-danger text-center"><%= errorMessage %></div>
            <% } %>

            <form method="post" action="login.jsp">
                <div class="mb-3">
                    <label class="form-label">Email</label>
                    <input type="email" name="email" class="form-control" required>
                </div>
                <div class="mb-3">
                    <label class="form-label">Password</label>
                    <input type="password" name="password" class="form-control" required>
                </div>
                <button type="submit" class="btn btn-primary w-100">Login</button>
            </form>

            <p class="mt-3 text-center">
                New user? <a href="register.jsp">Register here</a>
            </p>
        </div>
    </div>

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
