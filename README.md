# devi_garden

## Zadanie „Garden”

### Cel
Celem zadania jest stworzenie aplikacji z możliwością przeglądania, dodawania,
aktualizowania i wyszukiwania roślin w ogrodzie.

### Funkcjonalność

#### Lista roślin

Ekran posiada:
- Tytuł - „Garden”
- Pole do wyszukiwania
- Przycisk do otwierania formularza dodawania rośliny „+ Add plant”
- Listę
 
Element listy posiada:
- Pierwszą i ostatnią literę z nazwy rośliny umieszczoną po lewej stronie
elementu
- Nazwę rośliny
- Typ rośliny
- Datę zasadzenia
 
Lista jest pobierana z lokalnej bazy danych i paginowana po 10 elementów.
Wyszukiwać można po nazwie rośliny. Gdy nie ma elementów w bazie danych,
widok powinien pokazać odpowiedni napis na środku ekranu. Zdarzenie
dotknięcia elementu listy powinno otworzyć formularz z możliwością
zaktualizowania danych danego wpisu.

#### Formularz

Ekran posiada:
- Tytuł - „Add plant” lub „Update plant”, w zależności od trybu
- Pole tekstowe do wpisania nazwy rośliny
- Pole z możliwością wyboru typu rośliny
- Pole z możliwością wyboru daty zasadzenia
- Przycisk z napisem „Save”

Lista typów powinna zostać pobrana z bazy danych. Wyszczególniamy typy:
alpines, aquatic, bulbs, succulents, carnivorous, climbers, ferns, grasses, threes.
Przycisk „Save” powinien spowodować zapisanie danych i powrót na listę roślin.
Na liście roślin powinien wyświetlić się snackbar z potwierdzeniem dodania
rośliny, który zawiera jej nazwę.

#### Prośba o wykorzystanie:
- [x] Bloc,
- [ ] Freezed,
- [ ] Dartz,
- [x] Floor,
- [ ] Bloc Test
 
#### Oceniane będzie
- Zgodność z wymaganiami oraz ich interpretacja
- Rozpisany plan zadań
- Czystość kodu i semantyka
- Podejście do architektury aplikacji
- Ogólny wygląd aplikacji
- Testy jednostkowe oraz widgetów

## Commands
- fvm flutter packages pub run build_runner watch --delete-conflicting-outputs
