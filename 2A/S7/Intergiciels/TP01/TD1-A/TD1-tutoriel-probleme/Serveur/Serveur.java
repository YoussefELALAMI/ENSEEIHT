import java.net.*;
import java.io.*;
import java.util.concurrent.TimeUnit;

public class Serveur {

    public static void main(String[] args) {

        ServerSocket ssock;
        int port = 6666;

        try {
            ssock = new ServerSocket(port);
            System.out.println("Serveur prêt");

            while (true) {
                Socket s = ssock.accept();
                System.out.println("Connexion d'un client");
                InputStream is = s.getInputStream();
                ObjectInputStream ois = new ObjectInputStream(is);
                Voiture v = (Voiture)ois.readObject();
                TimeUnit.SECONDS.sleep(5);
                System.out.println("Voiture reçue " + v);
                ois.close();
                is.close();
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

    }

}
