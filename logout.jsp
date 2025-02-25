<%-- 
    Document   : logout
    Created on : 30 Jan, 2025, 12:32:02 AM
    Author     : kanun
--%>

<%@page import="java.sql.SQLException"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.Connection"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Logout</title>
    </head>
    <body>

        <%
            session = request.getSession(false);
            if (session != null) {
                String name = (String) session.getAttribute("name");
                if (name != null) {
                    try {
                        Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/livechat", "root", "root");
                        Statement st = con.createStatement();

                       
                        String updateLogoutQuery = "UPDATE name SET ChatExit_time = NOW() WHERE name = '" + name + "'";
                        st.executeUpdate(updateLogoutQuery);

                        String updateMessageLogoutQuery = "UPDATE message SET Logout_time = NOW() WHERE name = '" + name + "'";
                        st.executeUpdate(updateMessageLogoutQuery);

                        st.executeUpdate(updateLogoutQuery);
                        System.out.println(updateLogoutQuery);

                        session.invalidate(); // Destroy session
                    } catch (SQLException e) {
                        out.println("Error: " + e.getMessage());
                    }
                }
            }
            response.sendRedirect("index.html");


        %>


    </body>
</html>
