import java.net.*;
import java.io.*;
import java.util.concurrent.TimeUnit;

public class Slave extends Thread {

    Socket s;

    public Slave(Socket s) {
        this.s = s;
    }

    public void run() {

        try {
            InputStream is = s.getInputStream();
            ObjectInputStream ois = new ObjectInputStream(is);
            Voiture v = (Voiture)ois.readObject();
            TimeUnit.SECONDS.sleep(5);
            System.out.println("Voiture reçue " + v);
            ois.close();
            is.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

}
