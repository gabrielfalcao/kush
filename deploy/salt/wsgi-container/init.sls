{% set app_name = pillar["wsgi-container"]["app_name"] %}
ssh_config:
  file.managed:
    - name: /root/.ssh/config
    - source: salt://wsgi-container/ssh_config
    - makedirs: True


{% for service_name in ['redis-server', 'supervisor', 'nginx'] %}
{{ service_name }}:
  pkg:
    - installed

  service:
    - running
    - require:
      - pkg: {{ service_name }}

{% endfor %}

{% for subname in ["enabled", "available"] %}
/etc/nginx/sites-{{ subname }}/default:
  file:
    - absent
{% endfor %}


{{ app_name }}-repository:
  git.latest:
    - name: {{ pillar[app_name]['repository'] }}
    - rev: {{ pillar[app_name]['revision'] }}
    - target: {{ pillar[app_name]['app_path'] }}
    - identity: /root/.ssh/{{ app_name }}
    - force: true
    - require:
      - pkg: app-pkgs
      - file: {{ app_name }}_deploy_key
      - file: {{ app_name }}_public_key
      - file: ssh_config


ez_setup:
  file.managed:
    - name: /srv/ez_setup.py
    - source: salt://wsgi-container/ez_setup.py
    - makedirs: True
    - mode: 755


app-pkgs:
  pkg.installed:
    - names:
      - git
      - virtualenvwrapper
      - libevent-dev
      - libev-dev
      - python-dev
      - python-bcrypt
      - libcrypto++-dev
      - libmysqlclient-dev
      - vim
      - pkg-config
      - htop
      - libtool
      - libpq-dev
      - zlib1g-dev
      - libssl-dev
      - screen
      - libxml2-dev
      - libxslt1-dev
      - build-essential



/usr/lib/python2.7/site-packages/sitecustomize.py:
  file.managed:
    - source: salt://wsgi-container/sitecustomize.py
    - makedirs: True
    - mode: 755


distribute.global:
  pip.installed:
    - name: distribute==0.7.3


{{ pillar[app_name]['venv_path'] }}:
  virtualenv.manage:
    - requirements: {{ pillar[app_name]['app_path'] }}/requirements.txt
    - no_site_packages: true
    - clear: false
    - require:
      - pkg: app-pkgs


easy_install.force:
  cmd.run:
    - name: {{ pillar[app_name]['venv_path'] }}/bin/python /srv/ez_setup.py

pip.force:
  cmd.run:
    - name: {{ pillar[app_name]['venv_path'] }}/bin/easy_install pip

requirements.force:
  cmd.run:
    - name: {{ pillar[app_name]['venv_path'] }}/bin/pip install -r {{ pillar[app_name]['app_path'] }}/development.txt

{% for github_user, user in pillar[app_name]['github_users'].items() %}

{{ user }}:
  user.present

/home/{{ user }}/.ssh:
  file.directory:
    - user: {{ user }}
    - group: {{ user }}
    - mode: 755
    - makedirs: True

{{ user }}-keys:
  cmd.run:
    - name: curl https://github.com/{{ github_user }}.keys > /home/{{ user }}/.ssh/authorized_keys

/home/{{ user }}/.ssh/authorized_keys:
  file.managed:
    - mode: 600

{% endfor %}


set-cronjob-update-{{ app_name }}:
  module.run:
    - name: cron.set_job
    - user: root
    - minute: 60
    - hour: '*'
    - month: '*'
    - daymonth: '*'
    - dayweek: '*'
    - cmd: 'cd {{ pillar[app_name]['app_path'] }} && (git fetch --prune; git reset --hard origin/{{ pillar[app_name]['revision'] }};git reset --hard;git clean -df) && supervisorctl {{ app_name }} force-reload'
