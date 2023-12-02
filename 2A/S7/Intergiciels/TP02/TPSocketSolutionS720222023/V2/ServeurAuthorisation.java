package TPSocket2018V2Solution;


// imports pour la communication udp entre serveur http et serveur d'autorisation
import java.io.IOException;
import java.net.DatagramPacket;
import java.net.DatagramSocket;
import java.net.SocketException;




public class ServeurAuthorisation  {

	final static int port = 8532;
	static int cpt = 0;
	//final static int taille = 1024;
	//final static byte buffer[] = new byte[taille];



	public static void main(String[] args){

		Thread t = new Thread(new Runnable(){
			public void run(){
				try {

					//Création de la connexion côté serveur, en spécifiant un port d'écoute
					DatagramSocket server = new DatagramSocket(port);

					while(true){

						//On s'occupe maintenant de l'objet paquet
						byte[] buffer = new byte[8192];

						System.out.println("avant la reception de demande d'autorisation");
						DatagramPacket packet = new DatagramPacket(buffer, buffer.length);

						//Cette méthode permet de récupérer le datagramme envoyé par le client
						//Elle bloque le thread jusqu'à ce que celui-ci ait reçu quelque chose.
						// TODO il faut vérifier si le client est autorisé ou pas une fois la demande d'autoprisation est reçu
						// le packet doit contenir une demande d'autoprisation (auth_request) pour un client  (idealement il faut l'identité du client)


						server.receive(packet);
						System.out.println("après la reception de demande d'autorisation");


						//nous récupérons le contenu de celui-ci et nous l'affichons
						String str = new String(packet.getData());
						print("Reçu de la part de " + packet.getAddress()
								+ " sur le port " + packet.getPort() + " : ");

						println(str);

						System.out.println("affichage de donnée reçue : " + str);

						//On réinitialise la taille du datagramme, pour les futures réceptions
						packet.setLength(buffer.length);




						//et nous allons répondre à notre client, donc même principe
						// retourner l'autrisation ou le rejet
						byte[] buffer2;

						System.out.print("affichage compteur" + cpt);


						System.out.println();

						if ( 3 - cpt > 0)
						{  buffer2 = "ok".getBytes(); cpt=cpt+1;}
						else{ buffer2 = "ko".getBytes();}
						DatagramPacket packet2 = new DatagramPacket(
								buffer2,             //Les données
								buffer2.length,      //La taille des données
								packet.getAddress(), //L'adresse de l'émetteur
								packet.getPort()     //Le port de l'émetteur
								);

						System.out.println("trace réponse coté serveurAuthorisation : " + new String(packet2.getData()));
						//Et on envoie vers l'émetteur du datagramme reçu précédemment

						//packet2.setData("ok".getBytes());
						server.send(packet2);
						packet2.setLength(buffer2.length);
					}
				} catch (SocketException e) {
					e.printStackTrace();
				} catch (IOException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
			}
		});

		//Lancement du serveur
		t.start();


	}

	/**
	 * @param str
	 */
	public static synchronized void print(String str){
		System.out.print(str);
	}
	/**
	 * @param str
	 */
	public static synchronized void println(String str){
		System.err.println(str);
	}



}