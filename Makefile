all: test

export SQLALCHEMY_DATABASE_URI:=mysql://root@localhost/kush_db_local

test: unit functional

prepare:
	@pip install -q curdling
	@curd install -r development.txt

clean:
	@git clean -Xdf # removing files that match patterns inside .gitignore

unit:
	@python manage.py unit

functional:
	@python manage.py functional

acceptance:
	@python manage.py acceptance

shell:
	python manage.py shell

run:
	python manage.py run

check:
	python manage.py check


prod-simulation:
       PYTHONPATH=`pwd` PORT="4000" DOMAIN="0.0.0.0" REDIS_URI="redis://localhost:6379" gunicorn --worker-class kush.upstream.WebsocketsSocketIOWorker kush.server:application

static:
	bower install
	rm -rf kush/static/.webassets-cache
	python manage.py assets clean
	python manage.py assets build
