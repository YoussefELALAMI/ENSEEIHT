import java.net.*;
import java.io.*;
import java.util.concurrent.TimeUnit;

public class UsagerServer_i {

    final static String hosts[] = {"localhost", "localhost", "localhost"};
    final static int ports[] = {8081, 8082, 8083};
    final static int nb = 3;
    static String document[] = new String[nb];

    public static void main(String[] args) {

        document[0] = "Début";
        document[1] = "Milieu";
        document[2] = "Fin";

        int numero = Integer.parseInt(args[0]);
        System.out.println("Je suis UsagerServer_" + numero);

        try {
            ServerSocket ssock = new ServerSocket(ports[numero]);

            while (true) {
                Socket s = ssock.accept();

                OutputStream os = s.getOutputStream();
                InputStream is = s.getInputStream();
                ObjectOutputStream oos = new ObjectOutputStream(os);
                ObjectInputStream ois = new ObjectInputStream(is);

                int fragment = (int)ois.readObject();
                System.out.println("Demande reçue du fragment " + fragment);
                TimeUnit.SECONDS.sleep(2+2*fragment);
                oos.writeObject(document[fragment]);
                System.out.println("document[" + fragment + "] envoyé");

                ois.close();
                oos.close();
                is.close();
                os.close();

            }

        } catch (Exception e) {
            e.printStackTrace();
        }

    }

}
