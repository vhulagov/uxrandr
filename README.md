uxrandr
=======

uxrandr is a tool for changing display configuration upon udev events. It is intended for 
Linux desktop environments without such capability (e.g. Xfce 4.10 which I currently use). 

Principle
---------

The tool consists of two parts (scripts) a observer, a worker and an udev rule. The rule 
launches the observer (signal-change.sh) every time an udev event occurs in video subsytem, 
e.g. new display is connected. The observer signals it further to the worker (do_change.sh)
and it does rest of the job. The worker has to be run in a current xsession otherwise it will 
not be possible to change display configuration (authorization will fail). Launching worker
with graphical user interface is the easiest way to achieve it.

Installation
------------

Scripts can be put wherever you want, if they are executable by udev and user running X.

Configuration
-------------

Configuration dirs:
  * $HOME/.uxrandr
  * installation_dir/conf

Configuration files can have human-readable names. However, one must use update.sh script
to convert (symlink) these to worker-understandable names.

Please refer to configuration file syntax to provided examples.
