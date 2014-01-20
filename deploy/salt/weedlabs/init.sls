deploykey:
  file.managed:
    - name: /root/.ssh/github
    - source: salt://weedlabs/id_rsa
    - makedirs: True
    - mode: 600

publickey:
  file.managed:
    - name: /root/.ssh/github.pub
    - source: salt://weedlabs/id_rsa.pub
    - makedirs: True
    - mode: 600


/etc/nginx/sites-enabled/weedlabs.io:
  file:
    - managed
    - template: jinja
    - source: salt://weedlabs/nginx.conf
    - require:
      - pkg: nginx


weedlabs.io:
  git.latest:
    - name: {{ pillar['weedlabs']['repository'] }}
    - rev: {{ pillar['weedlabs']['revision'] }}
    - target: {{ pillar['app_path'] }}
    - force: true
    - require:
      - pkg: app-pkgs
      - file: deploykey
      - file: publickey
      - file: ssh_config

reload-nginx:
  cmd.run:
    - name: service nginx force-reload
