import java.io.*;
import java.util.*;

/** Analyser des donnÃ©es d'un fichier, une donnÃ©e par ligne avec 4 informations
 * sÃ©parÃ©es par des blancs : x, y, ordre (ignorÃ©e), valeur.
 */
public class Analyseur {
	/** Conserve la somme des valeurs associÃ©es Ã  une position. */
	private Map<Position, Double> cumuls;
	private static List<String> listeFichier = new ArrayList<>();

	/** Construire un analyseur vide. */
	public Analyseur() {
		cumuls = new HashMap<>();
	}

	/** Charger l'analyseur avec les donnÃ©es du fichier "donnees.java". */
	public void charger() {
		for (int i = 0; i < listeFichier.size(); i++) {
			try (BufferedReader in = new BufferedReader(new FileReader(listeFichier.get(i)))) {
				String ligne = null;
				if (listeFichier.get(i).endsWith("-f2.txt")) {
					while ((ligne = in.readLine()) != null) {
						String[] mots = ligne.split("\\s+");
						assert mots.length == 6;	// 4 mots sur chaque ligne
						int x = Integer.parseInt(mots[1]);
						int y = Integer.parseInt(mots[2]);
						Position p = new Position(x, y);
						double valeur = Double.parseDouble(mots[4]);
						if (x < 0 || y < 0 || valeur < 0) {
							throw new MalformedFileException();
						}
						cumuls.put(p, valeur(p) + valeur);
						// p.setY(p.getY() + 1);	//  p.y += 1;
					}
				} else {
					while ((ligne = in.readLine()) != null) {
						String[] mots = ligne.split("\\s+");
						assert mots.length == 4;	// 4 mots sur chaque ligne
						int x = Integer.parseInt(mots[0]);
						int y = Integer.parseInt(mots[1]);
						Position p = new Position(x, y);
						double valeur = Double.parseDouble(mots[3]);
						if (x < 0 || y < 0 || valeur < 0) {
							throw new MalformedFileException();
						}
						cumuls.put(p, valeur(p) + valeur);
						// p.setY(p.getY() + 1);	//  p.y += 1;
					}
				}
			} catch (IOException e) {
				throw new RuntimeException(e);
			}
		}
	}

	/** Obtenir la valeur associÃ©e Ã  une position. */
	public double valeur(Position position) {
		Double valeur = cumuls.get(position);
		return valeur == null ? 0.0 : valeur;
	}

	/** Obtenir toutes les donnÃ©es. */
	public Map<Position, Double> donnees() {
		return Collections.unmodifiableMap(this.cumuls);
	}

	/** Affichier les donnÃ©es. */
	public static void main(String[] args) {
		Analyseur a = new Analyseur();
		for (int i = 0; i < args.length; i++) {
			listeFichier.add(args[i]);
		}
		a.charger();
		System.out.println(a.donnees());
		System.out.println("Nombres de positions : " + a.donnees().size());
	}
}
