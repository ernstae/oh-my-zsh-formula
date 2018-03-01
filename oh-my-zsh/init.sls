include: 
    - oh-my-zsh.zsh

{% for uname in salt['pillar.get']('oh-my-zsh:users', {}) %}
change_shell_{{ uname }}:
  module.run:
    - name: user.chshell
    - m_name: {{ uname.name }}
    - shell: /usr/bin/zsh

add-oh-my-zsh_{{ uname }}:
  git.latest:
    - name: https://github.com/robbyrussell/oh-my-zsh.git
    - rev: master
    - target: "{{ uname.home }}/.oh-my-zsh"
    - unless: "test -d {{ uname.home }}/.oh-my-zsh"

zshrc_{{ uname }}:
  file.managed:
    - name: "{{ uname.home }}/.zshrc"
    - source: salt://oh-my-zsh/files/.zshrc
    - user: {{ uname.name }}
    - group: {{ uname.group }}
    - mode: '0644'
    - template: jinja
{% endfor %}
