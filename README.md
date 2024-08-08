# Node Docker ExpressJS modules: JWT Authentication, Permissions, CRUD Example

## Ogólne uruchomienie jak wygląda?

> Upewnij się, że zmienna `MONGO_URI` w pliku `.env` wygląda tak:
> ```
> MONGO_URI=mongodb://root:example@mongodb:27017/your_db_name?authSource=admin
> ```
>
> Upewnij się, że masz zainstalowane:
> - Docker
> - Node.js

Procedura:
```bash
# enter directory and install dependencies
cd express-docker-template
npm install

# build image as express-app
docker build -t express-app .

# build network for containers
docker network create express-network

# run MongoDB container in background
docker run -d --name mongodb --network express-network -p 27017:27017 -e MONGO_INITDB_ROOT_USERNAME=root -e MONGO_INITDB_ROOT_PASSWORD=example mongo

# run express-app container
docker run --env-file .env --network express-network -p 5000:5000 express-app

# TEST: 1. get User JWT
curl -X POST http://localhost:5000/api/auth/login -H "Content-Type: application/json" -d '{"username": "user", "password": "password"}'

# TEST: 2. get list of products
curl -X GET http://localhost:5000/api/products -H "Authorization: Bearer <TOKEN>"
```

## Menu

1. [Jak zbudować kontener?](#jak-zbudować-kontener)
2. [Jak zatrzymać kontener?](#jak-zatrzymać-kontener)
3. [Testowanie Aplikacji](#testowanie-aplikacji)
4. [Jak zamknąć sieć Docker?](#jak-zamknąć-sieć-docker)

> **#AIGeneratedContent**: przetestowane i działa ;)

## Jak zbudować kontener?

Aby uruchomić kontener bazując na Dockerfile, postępuj zgodnie z poniższymi krokami:

1. **Zbuduj obraz Dockera**: W katalogu projektu, w którym znajduje się Dockerfile, wykonaj polecenie `docker build`. Nazwij obraz na przykład `express-app`:
    ```bash
    docker build -t express-app .
    ```

2. **Uruchom kontener**: Po zbudowaniu obrazu uruchom kontener z tego obrazu. Przekaż zmienne środowiskowe z pliku `.env` i przekieruj porty:
    ```bash
    docker run --env-file .env -p 5000:5000 express-app
    ```

Poniżej przedstawiam dokładniejsze kroki i polecenia:

### Budowanie obrazu Dockera

Wykonaj poniższe polecenie w katalogu projektu, gdzie znajduje się Dockerfile:
```bash
docker build -t express-app .
```

### Uruchamianie kontenera

Po zbudowaniu obrazu uruchom kontener za pomocą poniższego polecenia:
```bash
docker run --env-file .env -p 5000:5000 express-app
```

### Alternatywne kroki (tworzenie network i uruchomienie MongoDB w kontenerze)

Jeśli nie masz lokalnie uruchomionej bazy danych MongoDB i chcesz używać MongoDB w kontenerze, wykonaj poniższe kroki:

1. **Utwórz sieć Dockera**:
    ```bash
    docker network create express-network
    ```

2. **Uruchom MongoDB w kontenerze**:
    ```bash
    docker run -d --name mongodb --network express-network -p 27017:27017 -e MONGO_INITDB_ROOT_USERNAME=root -e MONGO_INITDB_ROOT_PASSWORD=example mongo
    ```

    Upewnij się, że zmienna `MONGO_URI` w pliku `.env` wygląda tak:
    ```
    MONGO_URI=mongodb://root:example@mongodb:27017/your_db_name?authSource=admin
    ```

3. **Uruchom aplikację Express**:
    ```bash
    docker run --env-file .env --network express-network -p 5000:5000 express-app
    ```

### Podsumowanie

Podsumowując, poniżej znajdują się wszystkie niezbędne polecenia:

1. Budowanie obrazu:
    ```bash
    docker build -t express-app .
    ```

2. Tworzenie sieci (opcjonalnie):
    ```bash
    docker network create express-network
    ```

3. Uruchomienie MongoDB (opcjonalnie):
    ```bash
    docker run -d --name mongodb --network express-network -p 27017:27017 -e MONGO_INITDB_ROOT_USERNAME=root -e MONGO_INITDB_ROOT_PASSWORD=example mongo
    ```

4. Uruchomienie aplikacji Express:
    ```bash
    docker run --env-file .env -p 5000:5000 express-app
    ```

Lub, jeśli używasz sieci Docker:
    ```bash
    docker run --env-file .env --network express-network -p 5000:5000 express-app
    ```

Te kroki powinny pozwolić ci uruchomić aplikację w kontenerze Docker.

## Jak zatrzymać kontener?

Aby zatrzymać kontener Docker, wykonaj poniższe kroki:

1. **Znajdź identyfikator lub nazwę uruchomionego kontenera**: Użyj polecenia `docker ps`, aby wyświetlić listę uruchomionych kontenerów.
    ```bash
    docker ps
    ```

   W wyniku otrzymasz coś podobnego do poniższego:
    ```plaintext
    CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS              PORTS                    NAMES
    abc123def456        express-app         "node src/index.js"      2 minutes ago       Up 2 minutes        0.0.0.0:5000->5000/tcp   some-container-name
    ```

2. **Zatrzymaj kontener**: Użyj polecenia `docker stop` z identyfikatorem kontenera lub nazwą kontenera, który chcesz zatrzymać. Na przykład, jeśli identyfikator kontenera to `abc123def456`:
    ```bash
    docker stop abc123def456
    ```

   Alternatywnie, możesz użyć nazwy kontenera, np. `some-container-name`:
    ```bash
    docker stop some-container-name
    ```

3. **(Opcjonalnie) Usuń kontener**: Jeśli chcesz całkowicie usunąć kontener po jego zatrzymaniu, użyj polecenia `docker rm`:
    ```bash
    docker rm abc123def456
    ```

   Lub, używając nazwy kontenera:
    ```bash
    docker rm some-container-name
    ```

### Podsumowanie

1. Wyświetl uruchomione kontenery:
    ```bash
    docker ps
    ```

2. Zatrzymaj kontener, używając jego identyfikatora lub nazwy:
    ```bash
    docker stop <container_id_or_name>
    ```

3. (Opcjonalnie) Usuń zatrzymany kontener:
    ```bash
    docker rm <container_id_or_name>
    ```

Te polecenia pozwolą ci zatrzymać uruchomione kontenery Docker.

## Testowanie Aplikacji

Poniżej znajdują się komendy `curl` do szybkiego testowania aplikacji:

### 1. Logowanie jako admin
```bash
curl -X POST http://localhost:5000/api/auth/login -H "Content-Type: application/json" -d '{"username": "admin", "password": "password"}'
```

### 2. Logowanie jako user
```bash
curl -X POST http://localhost:5000/api/auth/login -H "Content-Type: application/json" -d '{"username": "user", "password": "password"}'
```

### 3. Dodawanie nowego produktu (jako admin)
Zamień `<TOKEN>` na token otrzymany z logowania.
```bash
curl -X POST http://localhost:5000/api/products -H "Content-Type: application/json" -H "Authorization: Bearer <TOKEN>" -d '{"name": "Product 1", "price": 100, "description": "Description for product 1"}'
```

### 4. Pobieranie listy produktów (jako user)
Zamień `<TOKEN>` na token otrzymany z logowania.
```bash
curl -X GET http://localhost:5000/api/products -H "Authorization: Bearer <TOKEN>"
```

### 5. Pobieranie szczegółów produktu według ID (jako user)
Zamień `<TOKEN>` na token otrzymany z logowania i `<PRODUCT_ID>` na ID istniejącego produktu.
```bash
curl -X GET http://localhost:5000/api/products/<PRODUCT_ID> -H "Authorization: Bearer <TOKEN>"
```

### 6. Aktualizacja produktu (jako admin)
Zamień `<TOKEN>` na token otrzymany z logowania i `<PRODUCT_ID>` na ID istniejącego produktu.
```bash
curl -X PUT http://localhost:5000/api/products/<PRODUCT_ID> -H "Content-Type: application/json" -H "Authorization: Bearer <TOKEN>" -d '{"name": "Updated Product", "price": 150, "description": "Updated description for product"}'
```

### 7. Usuwanie produktu (jako admin)
Zamień `<TOKEN>` na token otrzymany z logowania i `<PRODUCT_ID>` na ID istniejącego produktu.
```bash
curl -X DELETE http://localhost:5000/api/products/<PRODUCT_ID> -H "Authorization: Bearer <TOKEN>"
```

## Jak zamknąć sieć Docker?

Aby zamknąć sieć Docker, należy usunąć utworzoną sieć. Możesz to zrobić za pomocą polecenia `docker network rm`. Poniżej znajdują się kroki, które należy wykonać:

1. **Wyświetl listę sieci**: Aby zobaczyć wszystkie sieci Docker, użyj polecenia:
    ```bash
    docker network ls
    ```

   Otrzymasz listę podobną do poniższej:
    ```plaintext
    NETWORK ID     NAME             DRIVER    SCOPE
    1d3d4567dc1e   bridge           bridge    local
    2a7b89cd1234   host             host      local
    3c9d10111213   none             null      local
    4e8f14151617   express-network  bridge    local
    ```

2. **Usuń sieć**: Użyj polecenia `docker network rm` z nazwą lub identyfikatorem sieci, którą chcesz usunąć. Na przykład, aby usunąć sieć `express-network`:
    ```bash
    docker network rm express-network
    ```

   Lub używając identyfikatora sieci:
    ```bash
    docker network rm 4e8f14151617
    ```

### Podsumowanie
Aby zamknąć i usunąć sieć Docker:

1. Wyświetl listę sieci:
    ```bash
    docker network ls
    ```

2. Usuń sieć:
    ```bash
    docker network rm express-network
    ```

Powyższe kroki powinny pomóc w zamknięciu sieci Docker. Upewnij się, że żadne kontenery nie są podłączone do sieci, którą chcesz usunąć, ponieważ Docker nie pozwoli na usunięcie sieci, do której podłączone są uruchomione kontenery. W takim przypadku będziesz musiał najpierw zatrzymać lub usunąć te kontenery.