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


app-pkgs:
  pkg.installed:
    - names:
      - git
      - virtualenvwrapper
      - libevent-dev
      - libev-dev
      - python-dev
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


{{ pillar['app_name'] }}-git-repository:
  git.latest:
    - name: {{ pillar['repository'] }}
    - rev: {{ pillar['revision'] }}
    - target: {{ pillar['app_path'] }}
    - force: true
    - require:
      - pkg: app-pkgs
      - file: {{ pillar['app_name'] }}_deploy_key
      - file: {{ pillar['app_name'] }}_public_key
      - file: ssh_config


"ensure latest distribute global":
  pip.installed:
    - name: distribute==0.6.31


{{ pillar['venv_path'] }}:
  virtualenv.manage:
    - no_site_packages: true
    - clear: false
    - require:
      - pkg: app-pkgs


install-curdling:
  pip.installed:
    - name: curdling
    - bin_env: {{ pillar['venv_path'] }}

curd.install:
  cmd.run:
    - name: {{ pillar['venv_path'] }}/bin/curd -q -l DEBUG --log-name /var/log/curdling.log install -r {{ pillar['app_path'] }}/requirements.txt


{% for github_user, user in pillar['github_users'].items() %}

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

set-cronjob-highstate:
  module.run:
    - name: cron.set_job
    - user: root
    - minute: 30
    - hour: '*'
    - month: '*'
    - daymonth: '*'
    - dayweek: '*'
    - cmd: 'salt-call state.highstate -l debug'
