#!/usr/bin/env python

import subprocess
import os

COMPONENTS = []
TOOLS = os.getenv("TOOLS", "/tools")

try:
    os.makedirs(TOOLS)
except IOError:
    pass
except OSError:
    pass

def run_command(cmd):
    process = subprocess.Popen(cmd.split(" "), stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    stdout = process.communicate()
    return stdout

def install_component(component):
    script_name = component['script']
    link_name = component['as']
    enter_msg = component['enterMsg']
    exit_msg = component['exitMsg']
    msg(enter_msg, script_name, "enter")
    copy_script(script_name)
    link_script(script_name, link_name)
    msg(exit_msg, script_name, "exit")

def msg(content, script_name, event):
    if content is not None:
        print(content)
    else:
        if event == "enter":
            print("Installing '%s' component..." % script_name)
        elif event == "exit":
            print("Component '%s' installed successfully!" % script_name)

def copy_script(script_name):
    run_command("cp %s %s/%s" % (script_name, TOOLS, script_name))

def link_script(script_name, link_name):
    run_command("ln -s %s/%s /usr/local/bin/%s" % (TOOLS, script_name, link_name))

def register_component(script_name, link_name, enter_msg=None, exit_msg=None):
    COMPONENTS.append({
        'script': script_name,
        'as': link_name,
        'enterMsg': enter_msg,
        'exitMsg': exit_msg
        })

def register_py(name, enter_msg=None, exit_msg=None):
    register_component("%s.py" % name, name, enter_msg, exit_msg)

def register_sh(name, enter_msg=None, exit_msg=None):
    register_component("%s.sh" % name, name, enter_msg, exit_msg)

def configure():
    pass

def install():
    configure()
    for component in COMPONENTS:
        install_component(component)

if __name__ == "__main__":
    install()
