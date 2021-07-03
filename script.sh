#! /bin/bash

echo "Start Migrations"
python manage.py makemigrations blog
python manage.py makemigrations polls
python manage.py makemigrations
python manage.py migrate
echo "End migrations"
