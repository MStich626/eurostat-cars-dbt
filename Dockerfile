# lekki obraz Pythona
FROM python:3.11-slim

# Ustawienie katalogu roboczego
WORKDIR /app

# Kopia pliku z zależnościami do kontenera
COPY requirements.txt .

# Instalacja zależności
RUN pip install --no-cache-dir -r requirements.txt

# Kopiowanie całego projektu do kontenera
COPY . .

# Uruchomienie dbt run oraz dbt test
CMD ["sh", "-c", "dbt run --profiles-dir . && dbt test --profiles-dir ."]