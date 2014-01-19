supervisor:
  pkg:
    - installed
  service.running:
    - enable: True
    - watch:
      - file: /etc/supervisor/conf.d/{{ pillar['app_name'] }}.conf
