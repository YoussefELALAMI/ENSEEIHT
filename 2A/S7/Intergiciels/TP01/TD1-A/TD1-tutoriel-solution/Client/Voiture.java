import java.io.*;

public class Voiture implements Serializable {

    public String type;
    public int imm;

    public Voiture(String type, int imm) {
        this.type = type;
        this.imm = imm;
    }

    public String toString() {
        return this.type + " " + this.imm;
    }

}
