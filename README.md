# Shell Utilities.

The README is used to introduce the modules and provide instructions on
how to install the modules, any machine dependencies it may have and any
other information that should be provided before the modules are installed.

sh_util modules are build blocks for bash applications/tools/scripts.

### INSTALLATION

To install this set of modules type the following:

```
cp -R ~/sh_util/bin/   /root/scripts/sh_util/ver.1.0/
cp -R ~/sh_util/conf/  /root/scripts/sh_util/ver.1.0/
cp -R ~/sh_util/log/   /root/scripts/sh_util/ver.1.0/
```

### DEPENDENCIES

This module requires these other modules and libraries:

* None

### COPYRIGHT AND LICENCE

Copyright (C) 2018 by http://vroncevic.github.io/sh_util/

This tool is free software; you can redistribute it and/or modify
it under the same terms as Bash itself, either Bash version 4.2.47 or,
at your option, any later version of Bash 4 you may have available.

:sparkles:

### SH_UTIL STRUCTURE

```
/sh_util/
│
├── /bin/
│   ├── add_new_tool.sh
│   ├── app_shortcut.sh
│   ├── app_to_user.sh
│   ├── archiving.sh
│   ├── array_utils.sh
│   ├── avi_to_mp4.sh
│   ├── blot_out.sh
│   ├── broadcast_message.sh
│   ├── byte_traffic.sh
│   ├── cal_utils.sh
│   ├── check_cfg.sh
│   ├── check_ipv4.sh
│   ├── check_op.sh
│   ├── check_process.sh
│   ├── check_root.sh
│   ├── check_tool.sh
│   ├── check_x.sh
│   ├── color_print.sh
│   ├── cpu.sh
│   ├── create_file_nsize.sh
│   ├── create_ram_disk.sh
│   ├── cut_operations.sh
│   ├── cut_pdf.sh
│   ├── date_to_iso8601.sh
│   ├── dep_to_group.sh
│   ├── devel.sh
│   ├── dir_utils.sh
│   ├── disk_label.sh
│   ├── email_sign.sh
│   ├── employee.sh
│   ├── file_integrity.sh
│   ├── gen_from_template.sh
│   ├── get_ipv4.sh
│   ├── get_ipv6.sh
│   ├── gz_to_bz2.sh
│   ├── hash.sh
│   ├── id_to_branch.sh
│   ├── inserting_passwd.sh
│   ├── insert_text.sh
│   ├── is_spammer.sh
│   ├── java_heap_dump.sh
│   ├── list_open_files.sh
│   ├── list_ports.sh
│   ├── list_ssh.sh
│   ├── list_users.sh
│   ├── load_conf.sh
│   ├── load_util_conf.sh
│   ├── logged_in.sh
│   ├── logged_out.sh
│   ├── logging.sh
│   ├── longer_lines.sh
│   ├── low_swap.sh
│   ├── make_iso.sh
│   ├── md5sum.sh
│   ├── on_connect.sh
│   ├── open_terminals.sh
│   ├── path_proc.sh
│   ├── progress_bar.sh
│   ├── record_mic.sh
│   ├── rm_blanks.sh
│   ├── rm_dups.sh
│   ├── rm_leads.sh
│   ├── rm_lines.sh
│   ├── rm_old.sh
│   ├── same_size.sh
│   ├── send_mail.sh
│   ├── slof.sh
│   ├── sort_copy.sh
│   ├── spam_lookup.sh
│   ├── ssh_cmd.sh
│   ├── ssh_config.sh
│   ├── strip_comment.sh
│   ├── sym_links.sh
│   ├── test_hdd.sh
│   ├── timely_kill.sh
│   ├── unpack_to_dir.sh
│   ├── usage.sh
│   ├── uudecodes.sh
│   ├── vbox_config.sh
│   ├── vdeploy.sh
│   ├── vnc_config.sh
│   ├── voffice_list.sh
│   ├── vpn_config.sh
│   ├── which_bin.sh
│   ├── word_to_txt.sh
│   ├── wrap_text.sh
│   ├── x_break.sh
│   ├── x_copy.sh
│   └── zip_file.sh
├── /conf/
│   ├── add_new_tool.cfg
│   ├── app_shortcut.cfg
│   ├── app_to_user.cfg
│   ├── avi_to_mp4.cfg
│   ├── broadcast_message.cfg
│   ├── create_esignature.cfg
│   ├── create_ram_disk.cfg
│   ├── cut_pdf.cfg
│   ├── dep_to_group.cfg
│   ├── disk_label.cfg
│   ├── employee.cfg
│   ├── file_integrity.cfg
│   ├── gz_to_bz2.cfg
│   ├── id_to_branch.cfg
│   ├── java_heap_dump.cfg
│   ├── list_open_files.cfg
│   ├── md5sum.cfg
│   ├── online_connect.cfg
│   ├── open_terminals.cfg
│   ├── record_mic.cfg
│   ├── send_mail.cfg
│   ├── sh_util.cfg
│   ├── spam_lookup.cfg
│   ├── ssh_config.cfg
│   ├── /template/
│   │   ├── app_shortcut.template
│   │   ├── broadcast_message.template
│   │   ├── create_esignature.template
│   │   ├── info_file.template
│   │   ├── manual_file.template
│   │   ├── send_mail.template
│   │   ├── ssh_config.template
│   │   ├── vnc_config.template
│   │   ├── vpn_config.template
│   │   └── xtools_file.template
│   ├── uudecodes.cfg
│   ├── vbox_config.cfg
│   ├── vdeploy.cfg
│   ├── vnc_config.cfg
│   ├── voffice_list.cfg
│   ├── vpn_config.cfg
│   ├── word_to_txt.cfg
│   └── x_break.cfg
├── /log/
│   └── sh_util.log
```

