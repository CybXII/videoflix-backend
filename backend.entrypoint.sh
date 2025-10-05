#!/bin/sh

set -e

echo "Warte auf PostgreSQL auf $DATABASE_HOST:$DATABASE_PORT..."

# -q für "quiet" (keine Ausgabe außer Fehlern)
# Die Schleife läuft, solange pg_isready *nicht* erfolgreich ist (Exit-Code != 0)
while ! pg_isready -h "$DATABASE_HOST" -p "$DATABASE_PORT" -q; do
  echo "PostgreSQL ist nicht erreichbar - schlafe 1 Sekunde"
  sleep 1
done

echo "PostgreSQL ist bereit - fahre fort..."

mkdir -p /media /static
chown -R 1000:1000 /media /static
chmod -R 775 /media /static

# Deine originalen Befehle (ohne wait_for_db)
python manage.py collectstatic --noinput
python manage.py makemigrations
python manage.py migrate

# Create a superuser using environment variables
# (Dein Superuser-Erstellungs-Code bleibt gleich)
python manage.py shell <<EOF
import os
from django.contrib.auth import get_user_model

User = get_user_model()
username = os.environ.get('DJANGO_SUPERUSER_USERNAME', 'admin')
email = os.environ.get('DJANGO_SUPERUSER_EMAIL', 'admin@example.com')
password = os.environ.get('DJANGO_SUPERUSER_PASSWORD', 'adminpassword')

if not User.objects.filter(username=username).exists():
    print(f"Creating superuser '{username}'...")
    # Korrekter Aufruf: username hier übergeben
    User.objects.create_superuser(username=username, email=email, password=password)
    print(f"Superuser '{username}' created.")
else:
    print(f"Superuser '{username}' already exists.")
EOF

python manage.py rqworker default &

exec gunicorn videoflix.wsgi:application --bind 0.0.0.0:8000
