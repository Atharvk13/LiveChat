<%@page import="java.sql.*"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <meta http-equiv="refresh" content="5">
        <title>Live Chat</title>
        <style>
            body {
                font-family: Arial, sans-serif;
                background: linear-gradient(135deg, #0f2027, #203a43, #2c5364);
                display: flex;
                justify-content: center;
                align-items: center;
                height: 100vh;
                margin: 0;
                flex-direction: column;
            }
            .chat-container {
                width: 400px;
                height: 500px;
                background: #1b2a41;
                box-shadow: 0px 4px 10px rgba(0, 0, 0, 0.4);
                border-radius: 10px;
                display: flex;
                flex-direction: column;
                overflow: hidden;
            }
            .chat-header {
                background: #00adb5;
                color: white;
                padding: 15px;
                text-align: center;
                font-size: 20px;
                font-weight: bold;
            }
            .chat-box {
                flex-grow: 1;
                padding: 10px;
                overflow-y: auto;
                display: flex;
                flex-direction: column;
            }
            .chat-bubble {
                max-width: 75%;
                padding: 10px;
                border-radius: 10px;
                margin: 5px;
                word-wrap: break-word;
                font-size: 16px;
                line-height: 1.4;
            }
            .received { background: #30475e; color: white; align-self: flex-start; }
            .sent { background: #00adb5; color: white; align-self: flex-end; }
            .chat-input {
                display: flex;
                padding: 10px;
                background: #16213e;
                border-top: 2px solid #00adb5;
            }
            .chat-input input {
                flex-grow: 1;
                padding: 10px;
                border-radius: 5px;
                border: none;
                font-size: 16px;
                background: #1b2a41;
                color: white;
                outline: none;
            }
            .chat-input button {
                background: #00adb5;
                color: white;
                border: none;
                padding: 10px;
                margin-left: 10px;
                border-radius: 5px;
                cursor: pointer;
                font-weight: bold;
            }
            .logout-btn {
                margin-top: 10px;
                padding: 10px;
                background: #007c86;
                color: white;
                border: none;
                border-radius: 5px;
                cursor: pointer;
            }
        </style>
    </head>
    <body>
        <%
            String tablename = "";
            session = request.getSession(false);
            if (session == null || session.getAttribute("name") == null) {
                response.sendRedirect("index.html");
                return;
            }
            String name = (String) session.getAttribute("name");
            Timestamp enterTime = null;
            Timestamp exitTime = null;

            Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/livechat", "root", "root");
            Statement st = con.createStatement();

            String timeQuery = "SELECT ChatEnter_time FROM name WHERE name = '" + name + "'";
            System.out.println(timeQuery);
            ResultSet timeResult = st.executeQuery(timeQuery);
            if (timeResult.next()) {
                enterTime = timeResult.getTimestamp("ChatEnter_time");
//                exitTime = timeResult.getTimestamp("ChatExit_time");
            }
            String query = "SELECT Logout_time FROM message WHERE name = '" + name + "'";
            timeResult = st.executeQuery(query); 

            if (timeResult.next()) {
                exitTime = timeResult.getTimestamp("Logout_time"); 
            }

            if (timeResult.next()) {
                exitTime = timeResult.getTimestamp("Logout_time");
            }

            System.out.println(enterTime);
            System.out.println(exitTime);
            query = "SELECT name FROM name WHERE name='" + name + "'";

            System.out.println("Query " + query);
            ResultSet rs = st.executeQuery(query);

            if (rs.next()) {
                tablename = rs.getString(1);
                System.out.println(tablename);
            }

            String messageQuery;
            if (enterTime != null && exitTime != null) {
                messageQuery = "SELECT name, message FROM message WHERE MessageSent_time >= '" + enterTime + "' AND MessageSent_time >= '" + exitTime + "'";
            } else if (enterTime != null) {
                messageQuery = "SELECT name, message FROM message WHERE MessageSent_time >= '" + enterTime + "'";
            } else {
                messageQuery = "SELECT name, message FROM message"; 
            }


        %>
        <div class="chat-container">
            <div class="chat-header">Welcome, <%= name%></div>
            <div class="chat-box">
                <%
                    rs = st.executeQuery(messageQuery);
                    while (rs.next()) {
                        String sender = rs.getString("name");  // Column name is 'name'
                        String message = rs.getString("message");
                %>
                <div class="chat-bubble <%= sender.equals(name) ? "sent" : "received"%>">
                    <strong><%= sender.equals(name) ? "You" : sender%>:</strong> <%= message%>

                </div>
                <%
                    }
                    con.close();
                %>
            </div>
            <form class="chat-input" action="Chat" method="post">
                <input name="input" placeholder="Type a message..." required>
                <button type="submit">Send</button>
            </form>
        </div>
        <form action="logout.jsp">
            <button class="logout-btn" type="submit">Logout</button>
        </form>
    </body>
</html>