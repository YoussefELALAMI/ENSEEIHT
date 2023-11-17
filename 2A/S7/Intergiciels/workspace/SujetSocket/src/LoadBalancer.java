import java.io.*;
import java.net.*;
import java.util.*;

public class LoadBalancer extends Thread {
	static String hosts[] = {"localhost", "localhost"};
	static int ports[] = {8081,8082};
	static int nbHosts = 2;
	static Random rand = new Random();
	static Socket client;
	public LoadBalancer(Socket s) {
		this.client = s;
	}
	
	public static void main(String[] args){
		try {
			ServerSocket ss = new ServerSocket(8080);
			while(true) {
				LoadBalancer LB = new LoadBalancer(ss.accept());
				LB.start();
			}
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
	public void run(){
		try {
			int i = rand.nextInt(nbHosts);
			Socket server = new Socket(hosts[i],ports[i]);
			InputStream cis = client.getInputStream();
			OutputStream ces = client.getOutputStream();
			InputStream sis = server.getInputStream();
			OutputStream ses = server.getOutputStream();
			byte[] buffer = new byte[1024];
			int nblu = cis.read(buffer);
			ses.write(buffer,0,nblu);
			nblu = sis.read(buffer);
			ces.write(buffer,0,nblu);
			server.close();
			client.close();
		} catch (UnknownHostException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

}
