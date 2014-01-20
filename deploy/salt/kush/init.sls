ssh_config:
  file.managed:
    - name: /root/.ssh/config
    - source: salt://ffeast/ssh_config
    - makedirs: True

deploykey:
  file.managed:
    - name: /root/.ssh/github
    - source: salt://ffeast/id_rsa
    - makedirs: True
    - mode: 600

publickey:
  file.managed:
    - name: /root/.ssh/github.pub
    - source: salt://ffeast/id_rsa.pub
    - makedirs: True
    - mode: 600


{% for subname in ["enabled", "available"] %}
/etc/nginx/sites-{{ subname }}/default:
  file:
    - absent
{% endfor %}


/etc/nginx/sites-enabled/{{ pillar['app_name'] }}:
  file:
    - managed
    - template: jinja
    - source: salt://ffeast/nginx.conf
    - require:
      - pkg: nginx


/etc/supervisor/conf.d/{{ pillar['app_name'] }}.conf:
  file:
    - managed
    - template: jinja
    - source: salt://ffeast/supervisor.conf
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
    - require:
      - pkg: supervisor


reload-nginx:
  cmd.run:
    - name: service nginx force-reload
