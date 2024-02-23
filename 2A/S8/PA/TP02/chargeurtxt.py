class ChargeurTxt:
    def __init__(self):
        self.__cumuls = {}

    def capable(self, fichier):
        return fichier.endswith('.txt')

    def charger(self, fichier, cumuls):
        with open(fichier, 'r') as entree:
            self.__cumuls = {}
            for ligne in entree:
				mots = ligne.split()
				assert len(mots) == 4
				x = int(mots[0])
				y = int(mots[1])
				p = (x, y)
				v = float(mots[-1])
                self.__cumuls.add(p)
            for p in self.__cumuls
			    cumuls[p] = self.cumul(p) + v