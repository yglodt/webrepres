package lu.mind.projects.cms;

//http://www.stardeveloper.com/articles/display.html?article=2001111901&page=1

//import java.util.Timer;
import javax.servlet.ServletContext;
import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;

public class ApplicationListener implements ServletContextListener {
	private long applicationInitialized = 0L;
	//private Timer ssoSessionCleanUpTimer = null;

	public long getApplicationInitialized() {
		return applicationInitialized;
	}

	public void setApplicationInitialized(long applicationInitialized) {
		this.applicationInitialized = applicationInitialized;
	}

	/* Application Startup Event */
	public void contextInitialized(ServletContextEvent ce) {
		ServletContext context = null;
		context = ce.getServletContext();
		//ssoSessionCleanUpTimer = new java.util.Timer(true);
		this.applicationInitialized = System.currentTimeMillis();
		Application.log.info("contextInitialized");
		Application.context = context;
		Application.readConfigFile();
		Application.connectToPool();
		//ssoSessionCleanUpTimer.schedule(new CleanUpSsoSessions(context), 0, 60 * 1000);
	}

	/* Application Shutdown	Event */
	public void contextDestroyed(ServletContextEvent ce) {
		Application.log.info("contextDestroyed");
	}
}
