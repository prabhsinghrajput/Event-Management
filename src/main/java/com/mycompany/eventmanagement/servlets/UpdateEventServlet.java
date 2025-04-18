package com.mycompany.eventmanagement.servlets;

import database.DBConnection;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import javax.servlet.ServletException;
import java.io.IOException;
import java.sql.*;

//@WebServlet("/updateEvent")
public class UpdateEventServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String id = request.getParameter("id");
        String title = request.getParameter("title");
        String description = request.getParameter("description");
        String date = request.getParameter("date");
        String location = request.getParameter("location");

        try {
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement(
                "UPDATE events SET title = ?, description = ?, date = ?, location = ? WHERE id = ?"
            );

            ps.setString(1, title);
            ps.setString(2, description);
            ps.setString(3, date.replace("T", " "));
            ps.setString(4, location);
            ps.setString(5, id);

            ps.executeUpdate();
            con.close();

            response.sendRedirect("editEvent.jsp?message=updated");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("editEvent.jsp?message=error");
        }
    }
}
