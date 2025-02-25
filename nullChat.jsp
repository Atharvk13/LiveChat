<%-- 
    Document   : chat
    Created on : 15 Feb, 2025, 10:51:52 PM
    Author     : kanun
--%>

<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.SQLException"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.DriverManager"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Live Chat</title>
    </head>
    <body>
        <%
            session = request.getSession(false);
            String name = null;
            if (session != null) {
                name = (String) session.getAttribute("name");
            }

            if (name == null) {

                response.sendRedirect("index.html");
                return;
            }

            session = request.getSession(true);
            name = (String) session.getAttribute("name");
            out.println("<h1>Hello " + name + "</h1>");

            try {

                Class.forName("com.mysql.jdbc.Driver");
                Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/livechat", "root", "root");
                Statement st = con.createStatement();

                String query = "SELECT * FROM message";
                ResultSet rs = st.executeQuery(query);

                while (rs.next()) {
                    out.println("<br>");
                    out.print(rs.getString(1) + "\t");
                    out.println("<br>");
                    out.print(rs.getString(2) + "\t");
                    out.println("<br>");
                }
            } catch (ClassNotFoundException | SQLException ex) {
                System.out.println(ex);
            }


        %>
        <form action="Chat" method="post">
            <br>
            <input name="input" placeholder="Enter your message here"><br><br>
            <button value="submit">Send

        </form>

        <form action="logout.jsp">
            <button type="submit">Logout</button>

        </form>

    </body>
</html>

