import java.net.*;
import java.io.*;

public class UsagerClient extends Thread {

    final static String hosts[] = {"localhost", "localhost", "localhost"};
    final static int ports[] = {8081, 8082, 8083};
    final static int nb = 3;
    static String document[] = new String[nb];

    int fragment;

    public UsagerClient(int i) {
        this.fragment = i;
    }

    public void run() {
        System.out.println("Début du thread " + this.fragment);

        try {
            Socket s = new Socket(hosts[this.fragment], ports[this.fragment]);

            OutputStream os = s.getOutputStream();
            InputStream is = s.getInputStream();
            ObjectOutputStream oos = new ObjectOutputStream(os);
            ObjectInputStream ois = new ObjectInputStream(is);

            oos.writeObject(this.fragment);
            System.out.println("Demande envoyée du fragment " + fragment);
            document[this.fragment] = (String)ois.readObject();

            ois.close();
            oos.close();
            is.close();
            os.close();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public static void main(String[] args) {

        try {
            Thread t[] = new Thread[nb];

            for (int i = 0; i < nb; i++) {
                t[i] = new UsagerClient(i);
                t[i].start();
            }

            for (int i = 0; i < nb; i++) {
                t[i].join();
                System.out.println("Thread " + i + " terminé");
            }

            for (int i = 0; i < nb; i++) {
                System.out.println(document[i]);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

}
