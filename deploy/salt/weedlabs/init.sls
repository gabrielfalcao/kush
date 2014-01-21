/etc/nginx/sites-enabled/weedlabs:
  file:
    - managed
    - template: jinja
    - source: salt://weedlabs/nginx.conf
    - require:
      - pkg: nginx

/etc/nginx/sites-enabled/fallback:
  file:
    - managed
    - template: jinja
    - source: salt://weedlabs/www-fallback.conf
    - require:
      - pkg: nginx


copy-fallback-files:
  module.run:
    - name: cp.get_dir
    - path: salt://weedlabs/www-fallback
    - dest: {{ pillar['weedlabs']['www_fallback'] }}


weedlabs_deploy_key:
  file.managed:
    - name: /root/.ssh/github
    - source: salt://weedlabs/id_rsa
    - makedirs: True
    - mode: 600

weedlabs_public_key:
  file.managed:
    - name: /root/.ssh/github.pub
    - source: salt://weedlabs/id_rsa.pub
    - makedirs: True
    - mode: 600

weedlabs.io:
  git.latest:
    - name: {{ pillar['weedlabs']['repository'] }}
    - rev: {{ pillar['weedlabs']['revision'] }}
    - target: {{ pillar['weedlabs']['www_root'] }}
    - force: true
    - require:
      - pkg: app-pkgs
      - file: weedlabs_deploy_key
      - file: weedlabs_public_key

weedlabs-reload-nginx:
  cmd.run:
    - name: service nginx force-reload
