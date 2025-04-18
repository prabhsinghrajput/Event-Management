package com.mycompany.eventmanagement.servlets;

import database.DBConnection;
import javax.servlet.http.*;
import javax.servlet.ServletException;
import java.io.IOException;
import java.sql.*;

public class CancelEventServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String id = request.getParameter("id");
        System.out.println("⚠️ CancelEventServlet: Received ID = " + id);

        if (id == null || id.trim().isEmpty()) {
            System.out.println("❌ No ID received");
            response.sendRedirect("editEvent.jsp?message=error");
            return;
        }

        try (Connection con = DBConnection.getConnection()) {
            PreparedStatement ps = con.prepareStatement(
                "UPDATE events SET status = 'cancelled' WHERE id = ?"
            );
            ps.setString(1, id);

            int rowsAffected = ps.executeUpdate();
            System.out.println("✅ Rows affected: " + rowsAffected);

            if (rowsAffected > 0) {
                response.sendRedirect("editEvent.jsp?message=cancelled");
            } else {
                System.out.println("❌ No event found to cancel with ID: " + id);
                response.sendRedirect("editEvent.jsp?message=error");
            }

        } catch (Exception e) {
            System.out.println("❌ Exception in CancelEventServlet:");
            e.printStackTrace();
            response.sendRedirect("editEvent.jsp?message=error");
        }
    }
}
