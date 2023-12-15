<img align="right" src="https://raw.githubusercontent.com/vroncevic/sh_util/dev/docs/sh_util_logo.png" width="25%">

# Shell Utilities

**sh_util** modules are build blocks for bash applications/tools/scripts.

Developed in **[bash](https://en.wikipedia.org/wiki/Bash_(Unix_shell))** code: **100%**.

[![sh_util shell checker](https://github.com/vroncevic/sh_util/workflows/sh_util%20shell%20checker/badge.svg)](https://github.com/vroncevic/sh_util/actions?query=workflow%3A%22sh_util+shell+checker%22)

The README is used to introduce the modules and provide instructions on
how to install the modules, any machine dependencies it may have and any
other information that should be provided before the modules are installed.

[![GitHub issues open](https://img.shields.io/github/issues/vroncevic/sh_util.svg)](https://github.com/vroncevic/sh_util/issues) [![GitHub contributors](https://img.shields.io/github/contributors/vroncevic/sh_util.svg)](https://github.com/vroncevic/sh_util/graphs/contributors)

<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**

- [Installation](#installation)
- [Dependencies](#dependencies)
- [Library structure](#library-structure)
- [Docs](#docs)
- [Copyright and license](#copyright-and-license)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

### Installation

![Debian Linux OS](https://raw.githubusercontent.com/vroncevic/sh_util/dev/docs/debtux.png)

Navigate to release **[page](https://github.com/vroncevic/sh_util/releases)** download and extract release archive.

To install **sh_util** type the following

```
tar xvzf sh_util-x.y.z.tar.gz
cd sh_util-x.y.z
cp -R ~/sh_tool/bin/   /root/scripts/sh_util/ver.1.0/
cp -R ~/sh_tool/conf/  /root/scripts/sh_util/ver.1.0/
cp -R ~/sh_tool/log/   /root/scripts/sh_util/ver.1.0/
```

<details>
  <summary>Click to expand!</summary>

    ./sh_util_setup.sh 

    [setup] installing App/Tool/Script sh_util
        Mon 08 Jun 2020 09:13:28 PM CEST
    [setup] copy App/Tool/Script structure
    [setup] remove github editor configuration files
    [setup] set App/Tool/Script permission
    [setup] done

    /root/scripts/sh_util/ver.1.0/
    ├── bin/
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
    │   ├── named_pipe_reader.sh
    │   ├── named_pipe_writer.sh
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
    ├── conf/
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
    │   ├── template/
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
    └── log/
        └── sh_util.log
</details>

Or You can use docker to create image/container.

### Dependencies

**sh_util** requires next modules and libraries

```
None
```

### Library structure

**sh_util** is based on MOP.

```
sh_util/
├── bin/
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
│   ├── named_pipe_reader.sh
│   ├── named_pipe_writer.sh
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
├── conf/
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
│   ├── template/
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
└── log/
    └── sh_util.log
```

### Docs

[![Documentation Status](https://readthedocs.org/projects/sh_util/badge/?version=latest)](https://sh-util.readthedocs.io/projects/sh_util/en/latest/?badge=latest)

More documentation and info at
* [https://sh_util.readthedocs.io/en/latest/](https://sh-util.readthedocs.io/en/latest/)
* [https://www.gnu.org/software/bash/manual/](https://www.gnu.org/software/bash/manual/)

### Copyright and license

[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0) [![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)

Copyright (C) 2015 by [vroncevic.github.io/sh_util](https://vroncevic.github.io/sh_util)

**sh_util** is free software; you can redistribute it and/or modify
it under the same terms as Bash itself, either Bash version 4.2.47 or,
at your option, any later version of Bash 4 you may have available.

Lets help and support FSF.

[![Free Software Foundation](https://raw.githubusercontent.com/vroncevic/sh_util/dev/docs/fsf-logo_1.png)](https://my.fsf.org/)

[![Donate](https://www.paypalobjects.com/en_US/i/btn/btn_donateCC_LG.gif)](https://my.fsf.org/donate/)
