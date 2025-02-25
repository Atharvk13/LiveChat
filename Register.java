import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class Register extends HttpServlet {

    public void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect("index.html");
    }

    public void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Connection con = null;
        Statement st = null;
        ResultSet rs = null;
        String tablename = "";
        String name = request.getParameter("name");
        System.out.println(name);
        if (name == null || name.trim().equals("")) {
            response.sendRedirect("index.html");
            return;
        }
        session.setAttribute("ChatEnter_time", new Timestamp(System.currentTimeMillis()));

        try {

            Class.forName("com.mysql.jdbc.Driver");
            con = DriverManager.getConnection("jdbc:mysql://localhost:3306/livechat", "root", "root");
            st = con.createStatement();

            

            
                String query = "INSERT INTO name (name, ChatEnter_time) VALUES ('" + name + "', NOW())";

                int i = st.executeUpdate(query);
                System.out.println(query);
//                String updateLoginQuery = "UPDATE message SET login_time = NOW(), logout_time = NULL WHERE name = '" + name + "'";
//                st.executeUpdate(updateLoginQuery);
//                 session = request.getSession(true);
                session.setAttribute("name", name);
                response.sendRedirect("chat.jsp");
            

        } catch (ClassNotFoundException | SQLException ex) {
            System.out.println(ex);
        }

    }
}