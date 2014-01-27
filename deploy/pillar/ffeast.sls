wsgi-container:
  app_name: ffeast

ffeast:
  app_name: ffeast
  user: ubuntu

  repository: git@github.com:weedlabs/ffeast.git
  revision: master

  base_path: "/srv"

  app_path: "/srv/ffeast"
  static_path: "/srv/ffeast/ffeast/static"

  etc_path: "/srv/etc"

  venv_path: "/srv/ffeast-env"

  prefix_path: "/srv/usr"
  bin_path: "/srv/usr/bin"
  lib_path: "/srv/usr/lib"

  log_path: "/var/log"

  github_users:
    gabrielfalcao: gabrielfalcao
    alscardoso: andre
    clarete: lincoln

  environment:
    PORT: "5050"
    LOGLEVEL: "DEBUG"
    HOST: "ffeast.weedlabs.io"
    DOMAIN: "ffeast.weedlabs.io"
    REDIS_URI: "redis://localhost:6379"
    PATH: "/srv/ffeast-env/bin:$PATH"
    PYTHONPATH: "/srv/ffeast:/srv/ffeast-env/lib/python2.7/site-packages:$PYTHONPATH"
    SQLALCHEMY_DATABASE_URI: "mysql://root@localhost/ffeast"