// TODO : éviter de faire tourner le code plusieurs fois quand le fichier n'est pas trouvé!



package TPSocket2018V2Solution;


import java.io.BufferedOutputStream;
import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.io.PrintWriter;
import java.net.DatagramPacket;
import java.net.DatagramSocket;
import java.net.InetAddress;
import java.net.ServerSocket;
import java.net.Socket;
import java.net.SocketException;
import java.net.SocketTimeoutException;
import java.net.UnknownHostException;
import java.util.Arrays;
import java.util.Date;
import java.util.StringTokenizer;


// imports pour le lien serveur http et serveurAuthorisation tel que serveur http est le client
//import java.net.DatagramPacket;
//import java.net.DatagramSocket;
//import java.net.InetAddress;



public class Serveurhttp implements Runnable{

	static final File WEB_ROOT = new File(".");
	static final String DEFAULT_FILE = "Serveurhttp.java";
	static final String FILE_NOT_FOUND = "notFound.txt"; //"404.html";
	static final String METHOD_NOT_SUPPORTED = "not_supported.html";
	// port to listen connection
	static final int PORT = 8080;

	// verbose mode
	static final boolean verbose = true;

	// Client Connection via Socket Class
	private final Socket connect;

	public Serveurhttp(Socket c) {
		connect = c;
	}

	public static void main(String[] args) {
		try {
			ServerSocket serverConnect = new ServerSocket(PORT);
			System.out.println("Server started.\nListening for connections on port : " + PORT + " ...\n");

			// we listen until user halts server execution
			while (true) {

				System.out.println("Avant connexion");
				Serveurhttp myServer = new Serveurhttp(serverConnect.accept());

				if (verbose) {
					System.out.println("Connecton opened. (" + new Date() + ")");
				}

				// TODO à enlever
				//System.out.println("identité du serveur : "  + serverConnect.getInetAddress() + serverConnect.getLocalSocketAddress());

				// create dedicated thread to manage the client connection
				Thread thread = new Thread(myServer);
				thread.start();
			}

		} catch (IOException e) {
			System.err.println("Server Connection error : " + e.getMessage());
		}
	}

	public void run() {


		System.out.println("debut de run");
		// we manage our particular client connection
		BufferedReader in = null;
		PrintWriter out = null;
		BufferedOutputStream dataOut = null;
		String fileRequested = null;

		try {
			// we read characters from the client via input stream on the socket
			in = new BufferedReader(new InputStreamReader(connect.getInputStream()));
			// we get character output stream to client (for headers)
			out = new PrintWriter(connect.getOutputStream());
			// get binary output stream to client (for requested data)
			dataOut = new BufferedOutputStream(connect.getOutputStream());

			// get first line of the request from the client
			String input = in.readLine();
			// we parse the request with a string tokenizer
			StringTokenizer parse = new StringTokenizer(input);
			String method = parse.nextToken().toUpperCase(); // we get the HTTP method of the client
			// we get file requested
			fileRequested = parse.nextToken().toLowerCase();

			System.out.println("le fichier demande est : " + fileRequested);



			// we support only GET method, we check
			if (!method.equals("GET")) {
				if (verbose) {
					System.out.println("501 Not Implemented : " + method + " method.");
				}

				// we return the not supported file to the client
				File file = new File(WEB_ROOT, METHOD_NOT_SUPPORTED);
				int fileLength = (int) file.length();
				String contentMimeType = "text/html";
				//read content to return to client
				byte[] fileData = readFileData(file, fileLength);

				// we send HTTP Headers with data to client
				out.println("HTTP/1.1 501 Not Implemented");
				out.println("Server: Java HTTP Server from SSaurel : 1.0");
				out.println("Date: " + new Date());
				out.println("Content-type: " + contentMimeType);
				out.println("Content-length: " + fileLength);
				out.println(); // blank line between headers and content, very important !
				out.flush(); // flush character output stream buffer
				// file
				dataOut.write(fileData, 0, fileLength);
				dataOut.flush();

			} else {
				// GET or HEAD method
				// TODO verifier si le client est autorisé ou pas
				// envoyer une demande d'autorisation a ServeurAuthentification

				//String auth_response = new String();
				// Si la réponse est positive alors

				if (Arrays.equals(check_authorisation(), "ok".getBytes())){
					if (fileRequested.endsWith("/")) {
						fileRequested += DEFAULT_FILE;
					}

					File file = new File(WEB_ROOT, fileRequested);
					int fileLength = (int) file.length();
					String content = getContentType(fileRequested);


					System.out.println("Avant la verification de GET");

					if (method.equals("GET")) { // GET method so we return content
						byte[] fileData = readFileData(file, fileLength);

						// send HTTP Headers
						out.println("HTTP/1.1 200 OK");
						out.println("Server: Java HTTP Server from SSaurel : 1.0");
						out.println("Date: " + new Date());
						out.println("Content-type: " + content);
						out.println("Content-length: " + fileLength);
						out.println(); // blank line between headers and content, very important !
						out.flush(); // flush character output stream buffer

						dataOut.write(fileData, 0, fileLength);
						dataOut.flush();
					}

					if (verbose) {
						System.out.println("File " + fileRequested + " of type " + content + " returned");
					}

				}
				// il n'y a pas eu d'autorisation pour renvoyer le fichier au client
				else{
					// envoyer au client le message disant qu'il n'est pas autorisé
					if (verbose) {
						System.out.println("Autorisation non accordée");}
				}
			}


		} catch (FileNotFoundException fnfe) {
			try {
				fileNotFound(out, dataOut, fileRequested);
			} catch (IOException ioe) {
				System.err.println("Error with file not found exception : " + ioe.getMessage());
			}

		} catch (IOException ioe) {
			System.err.println("Server error : " + ioe);
		} finally {
			try {
				in.close();
				out.close();
				dataOut.close();
				connect.close(); // we close socket connection
			} catch (Exception e) {
				System.err.println("Error closing stream : " + e.getMessage());
			}

			if (verbose) {
				System.out.println("Connection closed.\n");
			}
		}


	}

	private byte[] readFileData(File file, int fileLength) throws IOException {
		FileInputStream fileIn = null;
		byte[] fileData = new byte[fileLength];

		try {
			fileIn = new FileInputStream(file);
			fileIn.read(fileData);
		} finally {
			if (fileIn != null)
				fileIn.close();
		}

		return fileData;
	}

	// return supported MIME Types
	private String getContentType(String fileRequested) {
		if (fileRequested.endsWith(".htm")  ||  fileRequested.endsWith(".html"))
			return "text/html";
		else
			return "text/plain";
	}

	private void fileNotFound(PrintWriter out, OutputStream dataOut, String fileRequested) throws IOException {

		File file = new File(WEB_ROOT, FILE_NOT_FOUND);
		int fileLength = (int) file.length();
		String content = "text/html";
		byte[] fileData = readFileData(file, fileLength);

		out.println("HTTP/1.1 404 File Not Found");
		out.println("Server: Java HTTP Server from SSaurel : 1.0");
		out.println("Date: " + new Date());
		out.println("Content-type: " + content);
		out.println("Content-length: " + fileLength);
		out.println(); // blank line between headers and content, very important !
		out.flush(); // flush character output stream buffer


		dataOut.write(fileData, 0, fileLength);
		dataOut.flush();

		if (verbose) {
			System.out.println("File " + fileRequested + " not found");
		}
	}




	/*String name = "";
	long sleepTime = 1000;

	public UDPClient(String pName, long sleep){
		name = pName;
		sleepTime = sleep;
	}*/


	// cette méthode a pour objectif de créer le sokcet udp où serveurhttp est client
	private byte[] check_authorisation(){

		byte[] reply = null;
		int nbre = 0;
		//while(true){
		//String envoi = name + "-" + (++nbre);
		byte[] buffer = "auth_request".getBytes() ; //= envoi.getBytes();

		try {
			//On initialise la connexion côté client
			DatagramSocket ServeurClientUDP = new DatagramSocket();

			//On crée notre datagramme
			InetAddress adresse = InetAddress.getByName("127.0.0.1");
			DatagramPacket sendData = new DatagramPacket(buffer, buffer.length, adresse, 8532);

			//On lui affecte les données à envoyer
			sendData.setData(buffer);

			//On envoie au serveur
			ServeurClientUDP.send(sendData);

			ServeurClientUDP.setBroadcast(true);
			ServeurClientUDP.setSoTimeout(1000);

			System.out.println("demande envoyé");

			//Et on récupère la réponse du serveur
			try{
				byte[] buffer2 = "ok".getBytes() ; //= new byte[8196];
				DatagramPacket receiveData = new DatagramPacket(buffer2, buffer2.length, adresse, 8532);
				ServeurClientUDP.receive(receiveData);
				//print(envoi + " a reçu une réponse du serveur : ");

				println("trace de la réponse : " + new String(receiveData.getData()));
				reply = receiveData.getData() ;


			}
			catch (SocketTimeoutException e){
				// timeout exception.
				System.out.println("Timeout reached!!! " + e);

				ServeurClientUDP.close();
			}


			/*try {
				Thread.sleep(sleepTime);
			} catch (InterruptedException e) {
				e.printStackTrace();
			}*/

		} catch (SocketException e) {
			e.printStackTrace();
		} catch (UnknownHostException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}


		return reply;
	}

	public static synchronized void print(String str){
		System.out.print(str);
	}
	public static synchronized void println(String str){
		System.err.println(str);
	}


}




