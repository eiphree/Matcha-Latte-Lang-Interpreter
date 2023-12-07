URUCHOMIENIE:
make
./interpreter filename

________________________________________________________________________________

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
8. Przesłanianie identyfikatorów ze statycznym ich wiązaniem (zmienne lokalne i globalne)
9. Obsługa błędów wykonania: komunikat błędu i zatrzymanie interpretera

Interpreter uzywa typu 'type IM = ReaderT Env (ExceptT InterpreterException (StateT Store IO))'.
Zmieniane lokalnie środowisko przechowuje mapowanie z nazw zmiennych i funkcji na lokacje, a Store 
mapowanie z lokacji na wartości. Wyrazenia ewaluowane są do IM Value gdzie Value to typ reprezentujący
dostępne w języku wartości. Bloki, deklaracje i stejtmenty są ewaluowane do IM Env.
__________________________________________________________
TABELKA wykonanych funkcjonalności:

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

Razem: 20
