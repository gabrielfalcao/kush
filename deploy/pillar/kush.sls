wsgi-container:
  app_name: kush

kush:
  app_name: kush
  user: ubuntu

  repository: git@github.com:weedlabs/kush.git
  revision: master

  base_path: "/srv"

  salt_repo_path: "/srv/core"

  app_path: "/srv/kush"
  static_path: "/srv/kush/kush/static"

  etc_path: "/srv/etc"

  venv_path: "/srv/kush-env"

  prefix_path: "/srv/usr"
  bin_path: "/srv/usr/bin"
  lib_path: "/srv/usr/lib"

  log_path: "/var/log"

  github_users:
    gabrielfalcao: gabrielfalcao
    alscardoso: andre
    clarete: lincoln

  environment:
    PORT: "4200"
    LOGLEVEL: "DEBUG"
    HOST: "kush.weedlabs.io"
    DOMAIN: "kush.weedlabs.io"
    REDIS_URI: "redis://localhost:6379"
    PATH: "/srv/venv/bin:$PATH"
    PYTHONPATH: "/srv/kush:/src/venv/lib/python2.7/site-packages:$PYTHONPATH"
    SQLALCHEMY_DATABASE_URI: "mysql://root@localhost/kush"