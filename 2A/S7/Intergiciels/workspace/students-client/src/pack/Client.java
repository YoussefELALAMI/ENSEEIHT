package pack;

import javax.ws.rs.core.UriBuilder;

import org.jboss.resteasy.client.jaxrs.ResteasyClient;
import org.jboss.resteasy.client.jaxrs.ResteasyClientBuilder;
import org.jboss.resteasy.client.jaxrs.ResteasyWebTarget;

import pack.Record;
import pack.Student;

public class Client {

	public static void main(String[] args) {
		final String path = "http://localhost:8080/students-server";
		
		ResteasyClient client = new ResteasyClientBuilder().build();
		ResteasyWebTarget target = client.target(UriBuilder.fromPath(path));
		ServiceInterface proxy = target.proxy(ServiceInterface.class);
		
		Record r = proxy.getRecord("1111111111");
		Student s = proxy.getStudent("Alain", "Tchana");
		
		System.out.println("Student Name : " + s.getFirstname() + " " + s.getLastname() + " INE : " + r.getINE());
	}

}
