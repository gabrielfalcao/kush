{% for service_name in ['redis-server', 'supervisor', 'nginx'] %}
{{ service_name }}:
  pkg:
    - installed

  service:
    - running
    - require:
      - pkg: {{ service_name }}

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


webapp:
  git.latest:
    - name: {{ pillar['repository'] }}
    - rev: {{ pillar['revision'] }}
    - target: {{ pillar['app_path'] }}
    - force: true
    - require:
      - pkg: app-pkgs
      - file: deploykey
      - file: publickey
      - file: ssh_config


"ensure latest distribute global":
  pip.installed:
    - name: distribute==0.6.31


{{ pillar['venv_path'] }}:
  virtualenv.manage:
    - requirements: {{ pillar['app_path'] }}/requirements.txt
    - no_site_packages: true
    - clear: false
    - require:
      - pkg: app-pkgs



/usr/lib/python2.7/site-packages/sitecustomize.py:
  file.managed:
    - source: salt://wsgi-container/sitecustomize.py
    - makedirs: True
    - mode: 755

{% for github_user, user in pillar['github_users'].items() %}
{{user}}:
  user.present

/home/{{ user }}/.ssh:
  file.directory:
    - user: {{ user }}
    - group: {{ user }}
    - mode: 755
    - makedirs: True


    - source:
    - file_mode: 600
    - makedirs: true

{{ user }}-keys:
  cmd.run:
    - name: curl https://github.com/{{ github_user }}.keys > /home/{{ user }}/.ssh/authorized_keys

/home/{{ user }}/.ssh/authorized_keys:
  file.managed:
    - mode: 600

{% endfor %}
