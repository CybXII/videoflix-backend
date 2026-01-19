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
python manage.py shell <<'EOF'
import os
from django.contrib.auth import get_user_model
from django.db import IntegrityError, transaction

User = get_user_model()

username = (os.environ.get('DJANGO_SUPERUSER_USERNAME') or 'admin').strip()
email = (os.environ.get('DJANGO_SUPERUSER_EMAIL') or 'admin@example.com').strip().lower()
password = os.environ.get('DJANGO_SUPERUSER_PASSWORD') or 'adminpassword'

try:
    with transaction.atomic():
        user, created = User.objects.get_or_create(
            email=email,
            defaults={'username': username}
        )

    if created:
        user.set_password(password)
        user.is_staff = True
        user.is_superuser = True
        user.is_active = True
        user.save(update_fields=['password','is_staff','is_superuser','is_active'])
        print(f"Created superuser: {email}")
    else:
        updated = False
        if not user.is_staff:
            user.is_staff = True
            updated = True
        if not user.is_superuser:
            user.is_superuser = True
            updated = True
        if updated:
            user.save(update_fields=['is_staff','is_superuser'])
        print(f"Superuser already exists: {email}")
except IntegrityError as e:
    print(f"Superuser creation skipped due to IntegrityError: {e}")
EOF

python manage.py rqworker default &

exec gunicorn videoflix.wsgi:application --bind 0.0.0.0:8000
