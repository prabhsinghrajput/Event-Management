<%@ page import="java.sql.*" %>
<%@ page session="true" %>

<%
    Integer userId = (Integer) session.getAttribute("userId");
    String role = (String) session.getAttribute("role");

    if (userId == null || role == null || !role.equals("attendee")) {
        response.sendRedirect("login.jsp");
        return;
    }

    String eventIdStr = request.getParameter("event_id");

    if (eventIdStr != null) {
        int eventId = Integer.parseInt(eventIdStr);

        Connection con = null;
        PreparedStatement checkStmt = null;
        PreparedStatement insertStmt = null;
        ResultSet rs = null;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            con = DriverManager.getConnection("jdbc:mysql://localhost:3306/event_management", "root", "");

            // Check if already registered
            checkStmt = con.prepareStatement("SELECT * FROM registrations WHERE user_id = ? AND event_id = ?");
            checkStmt.setInt(1, userId);
            checkStmt.setInt(2, eventId);
            rs = checkStmt.executeQuery();

            if (!rs.next()) {
                // Not already registered, insert new record
                insertStmt = con.prepareStatement("INSERT INTO registrations (user_id, event_id, status) VALUES (?, ?, 'registered')");
                insertStmt.setInt(1, userId);
                insertStmt.setInt(2, eventId);
                insertStmt.executeUpdate();
            }

        } catch (Exception e) {
            out.println("<p>Error: " + e.getMessage() + "</p>");
            e.printStackTrace();
        } finally {
            if (rs != null) try { rs.close(); } catch (Exception e) {}
            if (checkStmt != null) try { checkStmt.close(); } catch (Exception e) {}
            if (insertStmt != null) try { insertStmt.close(); } catch (Exception e) {}
            if (con != null) try { con.close(); } catch (Exception e) {}
        }
    }

    // Redirect back to joinEvents.jsp
    response.sendRedirect("joinEvents.jsp");
%>
