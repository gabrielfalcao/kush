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


/etc/nginx/sites-enabled/weedlabs.io:
  file:
    - managed
    - template: jinja
    - source: salt://weedlabs/www-fallback.conf
    - require:
      - pkg: nginx


{{ pillar['weedlabs']['www_fallback'] }}:
  file.directory:
    - mode: 755
    - makedirs: True


extract-www-fallback:
  module.run:
    - name: archive.tar
    - options: zxfv
    - tarfile: salt://weedlabs/www-fallback.tar.gz
    - dest: {{ pillar['weedlabs']['www_fallback'] }}/
    - archive_format: tar
    - require:
      - file: {{ pillar['weedlabs']['www_fallback'] }}

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
