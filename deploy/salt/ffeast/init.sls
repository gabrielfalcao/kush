ffeast_deploy_key:
  file.managed:
    - name: /root/.ssh/ffeast
    - source: salt://ffeast/id_rsa
    - makedirs: True
    - mode: 600

ffeast_public_key:
  file.managed:
    - name: /root/.ssh/ffeast.pub
    - source: salt://ffeast/id_rsa.pub
    - makedirs: True
    - mode: 600

include:
  - wsgi-container

/etc/nginx/sites-enabled/ffeast:
  file:
    - managed
    - template: jinja
    - source: salt://ffeast/nginx.conf
    - require:
      - pkg: nginx


/etc/supervisor/conf.d/ffeast.conf:
  file:
    - managed
    - template: jinja
    - source: salt://ffeast/supervisor.conf
    - require:
      - pkg: supervisor


ffeast-reread-supervisor:
  cmd.run:
    - name: supervisorctl reread


ffeast-update-supervisor:
  cmd.run:
    - name: supervisorctl update


ffeast-reload-supervisor:
  cmd.run:
    - name: supervisorctl reload all


start-ffeast:
  cmd.run:
    - name: supervisorctl restart ffeast || echo "running"
    - require:
      - pkg: supervisor


ffeast-reload-nginx:
  cmd.run:
    - name: service nginx force-reload
