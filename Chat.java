import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class Chat extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect("index.html"); // Redirect if accessed via GET
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("name") == null) {
            response.sendRedirect("index.html");
            return;
        }
        
        String name = (String) session.getAttribute("name");
        String input = request.getParameter("input");

        if (input == null || input.trim().isEmpty()) {
            response.sendRedirect("chat.jsp"); // Prevent empty messages
            return;
        }

        Connection con = null;
        Statement st = null;
        ResultSet rs = null;

        try {
            con = DriverManager.getConnection("jdbc:mysql://localhost:3306/livechat", "root", "root");
            st = con.createStatement();

            // Get last logout time
            String timeQuery = "SELECT ChatExit_time FROM name WHERE name = '" + name + "'";
            rs = st.executeQuery(timeQuery);

            String exitTime = null;
            if (rs.next()) {
                exitTime = rs.getString("ChatExit_time");
            }

            // Generate new message ID
            int maxId = 1;
            String idQuery = "SELECT MAX(Serial_No) AS max_id FROM message";
            rs = st.executeQuery(idQuery);
            if (rs.next()) {
                maxId = rs.getInt("max_id") + 1;
            }

            // Insert the new message
            String insertQuery = "INSERT INTO message (Serial_No, Name, Message, MessageSent_time) " +
                                 "VALUES ('" + maxId + "', '" + name + "', '" + input + "', NOW())";
            st.executeUpdate(insertQuery);

        } catch (SQLException ex) {
            System.out.println("Database error: " + ex.getMessage());
        } finally {
            try {
                if (rs != null) rs.close();
                if (st != null) st.close();
                if (con != null) con.close();
            } catch (SQLException ex) {
                System.out.println("Closing error: " + ex.getMessage());
            }
        }
//          response.sendRedirect("refreshPage.jsp");
        response.sendRedirect("chat.jsp");
    }
}
