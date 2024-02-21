import java.util.Hashtable;

import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.QueryParam;
import javax.ws.rs.core.UriBuilder;

import org.jboss.resteasy.client.jaxrs.ResteasyClient;
import org.jboss.resteasy.client.jaxrs.ResteasyClientBuilder;
import org.jboss.resteasy.client.jaxrs.ResteasyWebTarget;

import pack.Record;
import pack.ServiceInterface;
import pack.Student;

public class Mark {
	
	String firstname;
	String lastname;
	String lecture;
	int mark;
	
	
	
	public Mark() {}
	
	public static void main(String[] args) {
		final String path = "http://localhost:8080/students-server";
	}

	@GET
	@Path("/getmark")
	@Produces({ "application/json" })
	public int getMark(@QueryParam("firstname") String firstname, @QueryParam("lastname") String lastname, @QueryParam("lecture") String lecture) {
		final String path = "http://localhost:8080/students-server";
		
		ResteasyClient client = new ResteasyClientBuilder().build();
		ResteasyWebTarget target = client.target(UriBuilder.fromPath(path));
		ServiceInterface proxy = target.proxy(ServiceInterface.class);
		
		Student student = proxy.getStudent(firstname, lastname);
		Record record = proxy.getRecord(student.getINE());
		switch (lecture) {
		case "mathematics":
			return Integer.parseInt(record.getMathematics());
		case "middleware":
			return Integer.parseInt(record.getMiddleware());
		case "networks":
			return Integer.parseInt(record.getNetworks());
		case "systems":
			return Integer.parseInt(record.getSystems());
		case "architecture":
			return Integer.parseInt(record.getArchitecture());
		case "programming":
			return Integer.parseInt(record.getProgramming());
		default:
			return 0;
		}
		
	}
}
