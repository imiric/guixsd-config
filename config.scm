;; This is an operating system configuration template
;; for a "bare bones" setup, with no X11 display server.

(use-modules (gnu)
             (gnu packages))
(use-service-modules networking)

(operating-system
  (host-name "work")
  (timezone "Europe/Amsterdam")
  (locale "en_US.UTF-8")

  ;; Assuming /dev/sdX is the target hard disk, and "my-root" is
  ;; the label of the target root file system.
  (bootloader (grub-configuration (device "/dev/sda")))
  (file-systems (cons (file-system
                        (device "root")
                        (title 'label)
                        (mount-point "/")
                        (type "ext4"))
                      %base-file-systems))

  ;; This is where user accounts are specified.  The "root"
  ;; account is implicit, and is initially created with the
  ;; empty password.
  (users (cons (user-account
                (name "ivan")
                (comment "Admin")
                (group "users")

                ;; Adding the account to the "wheel" group
                ;; makes it a sudoer.  Adding it to "audio"
                ;; and "video" allows the user to play sound
                ;; and access the webcam.
                (supplementary-groups '("wheel"
                                        "audio" "video"))
                (home-directory "/home/ivan"))
               %base-user-accounts))

  ;; Globally-installed packages.
  (packages (append (map specification->package
                    '("tcpdump" "htop" "git"))
             %base-packages))

  ;; Add services to the baseline: a DHCP client
  (services (cons* (dhcp-client-service)
                   %base-services)))
