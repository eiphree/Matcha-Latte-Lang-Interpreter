OPIS:

Matcha Latte [na owsianym] Lang

Język niby jak Latte, ale trochę inaczej, bo z herbatą zamiast kawy i na mleku roślinnym.

1. Typy: int, bool, string, void - jak w Latte
2. Literały, arytmetyka, porównania - jak w Latte
3. Zmienne, operacja przypisania - jak w Latte
4. Wypisywanie: PrintInt, PrintString, PrintBool, PrintArray, PrintTuple;
dwa ostatnie oprócz obiektu do wypisania dostają string/tablicę stringów opisujących typy do wypisania
5. while, if (ciało pętli/instrukcji zawsze występuje w nawiasach klamrowych, również gdy jest jedno-linijkowe)
6. Funkcje (przyjmujące i zwracające wartość dowolnych obsługiwanych typów), rekurencja - jak w Latte
7. Przekazywanie parametrów przez zmienną oraz przez wartość
8. 9. Przesłanianie identyfikatorów ze statycznym ich wiązaniem (zmienne lokalne i globalne)
9. Obsługa błędów wykonania: komunikat błędu i zatrzymanie interpretera
10. Tablice wielowymiarowe przekazywane i przypisywane przez wskaźnik;
    składnia jak w Javie (np. int[][] a)
11. Dowolnie zagnieżdżone krotki
12. break i continue 
__________________________________________________________
PRZYKŁADY:

int a = 7;

void lok() {
	int a = 77;
	a++;
	PrintInt(a);
}

void glob() {
	a++;
	PrintInt(a);
}


int main() {
	PrintInt(a); 	// 7
	lok();		// 78
	glob();		// 8
	PrintBool(a); 	// "Error: PrintBool wypisuje BOOLA!!! ヾ(`ヘ´)ﾉﾞ" 
}

------------------
void br_cnt_loop() {
	int a = 1;
	while (a < 10) {
		if (a > 5)
			{ break; }
		if (a % 2 == 0)
			{ continue; }
		PrintInt(a);
	}
}

int main() {
	br_cnt_loop();	// 1 / 3 / 5
}

---------------------------
void init_arr(int[][] arr) {
	int i, j, val;
	i = 0;
	j = 0;
	val = 1;
	while (i < arr.length()) {
		while (j < arr[0].length()) {
			arr[i][j] = val;
			val++;
			j++;
		}
		j = 0;
		i++;
	}
}

int arr_sum (int[][] arr) {
	int i, j, sum;
	i = 0;
	j = 0;
	sum = 0;
	while (i < arr.length()) {
		while (j < arr[0].length()) {
			sum = sum + arr[i][j];
			j++;
		}
		j = 0;
		i++;
	}
	return sum;
}

int main() {
	int[][] arr = new array[2][2];
	init_arr(arr);
	PrintArray(arr, "int"); 	// {{1,2}, {3,4}};
	int sum;
	sum = arr_sum(arr);
	PrintInt(sum);	// 10
	PrintArray(arr, "bool"); 	// "Error: Zły typ tablicy ヾ(`ヘ´)ﾉﾞ"
}

-------------------------------------
int main() {
	tuple(string, tuple(bool, int)) tup = ("hola", (false, 7));
	string[] tup_types = {"string, tuple(bool, int)"};
	PrintTuple(tup, tup_types); 	// ("hola", (false, 7))
}

__________________________________________________________
TABELKA (poniższe punkty są zaplanowane do zrobienia):

  Na 15 punktów
  01 (trzy typy)
  02 (literały, arytmetyka, porównania)
  03 (zmienne, przypisanie)
  04 (print)
  05 (while, if)
  06 (funkcje, rekurencja)
  07 (przez zmienną / przez wartość)
  
  Na 20 punktów
  09 (przesłanianie i statyczne wiązanie)
  10 (obsługa błędów wykonania)
  11 (funkcje zwracające wartość)

  Na 30 punktów
  14 (2) (tablice wielowymiarowe)
  15 (2) (krotki z przypisaniem)
  16 (1) (break, continue)

Razem: 25