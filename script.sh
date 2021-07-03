#! /bin/bash

python manage.py makemigrations blog
python manage.py makemigrations polls
python manage.py makemigrations
python manage.py migrate
