# Unix hacking

## Content

* [Logging in root without pass](#logging-in-root-without-pass)

## Logging in root without pass

* While starting unix press 'e' till grub edit will open
* Find `[your unix image here] ro initrd` change `ro` to `rw init=/bin/bash` (or sh or other bash shell which you are using)

### More info:

* [Here](http://askubuntu.com/questions/15284/how-to-boot-to-root-shell-when-grub-recovery-menu-fails-to-load-a-shell)
* [Here 2](http://askubuntu.com/questions/92556/how-do-i-boot-into-a-root-shell)
* [Here 3](http://www.symantec.com/connect/forums/recover-root-grub)
* [Here 4](http://www.cyberciti.biz/faq/grub-boot-into-single-user-mode/)
