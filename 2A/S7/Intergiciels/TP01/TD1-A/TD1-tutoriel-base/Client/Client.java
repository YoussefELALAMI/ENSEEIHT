import java.net.*;
import java.io.*;

public class Client {

    public static void main(String[] args) {

        try {
            Socket csock = new Socket("localhost", 6666);
            OutputStream os = csock.getOutputStream();
            ObjectOutputStream oos = new ObjectOutputStream(os);
            oos.writeObject(new Voiture("peugeot", 123));
            System.out.println("Voiture envoyée");
            oos.close();
            os.close();
        } catch (Exception e) {
            e.printStackTrace();
        }

    }

}
