include:
  - deploy


redis-server:
  pkg:
    - installed

  service:
    - running
    - require:
      - pkg: redis-server


app-pkgs:
  pkg.installed:
    - names:
      - git
      - python-virtualenv
      - python-dev
      - libmysqlclient-dev

webapp:
  git.latest:
    - name: {{ pillar['git_repo'] }}
    - rev: {{ pillar['git_rev'] }}
    - target: {{ pillar['app_path'] }}
    - force: true
    - require:
      - pkg: app-pkgs
      - file: deploykey
      - file: publickey
      - file: ssh_config


{{ pillar['venv_path'] }}:
  virtualenv.manage:
    - requirements: {{ pillar['app_path'] }}/requirements.txt
    - no_site_packages: true
    - clear: false
    - require:
      - pkg: app-pkgs



/usr/lib/python2.7/site-packages/sitecustomize.py:
  file.managed:
    - source: salt://webserver/sitecustomize.py
    - makedirs: True
    - mode: 755


nginx:
  pkg:
    - latest
  service:
    - running
    - watch:
      - file: nginxconf


nginxconf:
  file.managed:
    - name: /etc/nginx/sites-enabled/default
    - source: salt://webserver/nginx.conf
    - template: jinja
    - makedirs: True
    - mode: 755


supervisor:
  pkg:
    - installed

  service:
    - running
    - require:
      - pkg: supervisor
    - watch:
      - file: /etc/supervisor/conf.d/{{ pillar['app_name'] }}.conf


/etc/supervisor/conf.d/{{ pillar['app_name'] }}.conf:
  file:
    - managed
    - template: jinja
    - source: salt://supervisor/application.conf
    - require:
      - pkg: supervisor

reread-supervisor:
  cmd.run:
    - name: supervisorctl reread

update-supervisor:
  cmd.run:
    - name: supervisorctl update

reload-supervisor:
  cmd.run:
    - name: supervisorctl reload all

start-{{ pillar['app_name'] }}:
  cmd.run:
    - name: supervisorctl restart {{ pillar['app_name'] }} || echo "running"
