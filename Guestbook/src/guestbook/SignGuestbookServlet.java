package guestbook;

import java.io.IOException;
import java.util.Date;
import java.util.logging.Logger;

import javax.jdo.PersistenceManager;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.google.appengine.api.users.User;
import com.google.appengine.api.users.UserService;
import com.google.appengine.api.users.UserServiceFactory;

public class SignGuestbookServlet extends HttpServlet{
	private static final long serialVersionUID = 2733502940600139641L;
	
	private static final Logger log = Logger.getLogger(SignGuestbookServlet.class.getName());
	
	public void doPost(HttpServletRequest req, HttpServletResponse response)
		throws IOException {
		UserService userService = UserServiceFactory.getUserService();
		User user = userService.getCurrentUser();
		
		String content = req.getParameter("content");
		Date date = new Date();
		Greeting greeting = new Greeting(user, content, date);
		
		PersistenceManager pm = PMF.get().getPersistenceManager();
		
		try {
			pm.makePersistent(greeting);
		} catch (Exception e) {
			log.warning(e.getMessage());
		} finally {
			pm.close();
		}
		
//		if (content == null){
//			content = "(No greeting)";
//		}
//		
//		if (user != null){
//			log.info("Greeting posted by user " + user.getNickname() + " : " + content);
//		} else {
//			log.info("Greeting posted anonymously: " + content);
//		}
		
		response.sendRedirect("/guestbook.jsp");
	}
}
