package com.mycompany.eventmanagement.servlets;

import java.io.IOException;
import java.sql.*;
import javax.servlet.ServletException;
import javax.servlet.http.*;

public class ApproveEventServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action"); // approve or reject
        int eventId = Integer.parseInt(request.getParameter("eventId"));

        String status = "";
        if ("approve".equalsIgnoreCase(action)) {
            status = "approved";
        } else if ("reject".equalsIgnoreCase(action)) {
            status = "rejected";
        }

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/event_management", "root", "");

            PreparedStatement ps = con.prepareStatement(
                "UPDATE events SET status = ? WHERE id = ?");
            ps.setString(1, status);
            ps.setInt(2, eventId);
            ps.executeUpdate();
            con.close();

            // Redirect with a success message
            response.sendRedirect("dashboardAdmin.jsp?message=" + status + "_success");

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Error: " + e.getMessage());
        }
    }
}
