sh_util
-------

**sh_util** modules are build blocks for bash applications/tools/scripts.

Developed in `bash <https://en.wikipedia.org/wiki/Bash_(Unix_shell)>`_ code: **100%**.

|GitHub shell checker|

.. |GitHub shell checker| image:: https://github.com/vroncevic/sh_util/actions/workflows/sh_util_shell_checker.yml/badge.svg
   :target: https://github.com/vroncevic/sh_util/actions/workflows/sh_util_shell_checker.yml

The README is used to introduce the modules and provide instructions on
how to install the modules, any machine dependencies it may have and any
other information that should be provided before the modules are installed.

|GitHub issues| |Documentation Status| |GitHub contributors|

.. |GitHub issues| image:: https://img.shields.io/github/issues/vroncevic/sh_util.svg
   :target: https://github.com/vroncevic/sh_util/issues

.. |GitHub contributors| image:: https://img.shields.io/github/contributors/vroncevic/sh_util.svg
   :target: https://github.com/vroncevic/sh_util/graphs/contributors

.. |Documentation Status| image:: https://readthedocs.org/projects/sh_util/badge/?version=latest
   :target: https://sh-util.readthedocs.io/projects/sh_util/en/latest/?badge=latest

.. toctree::
    :hidden:

    self

Installation
------------

|Debian Linux OS|

.. |Debian Linux OS| image:: https://raw.githubusercontent.com/vroncevic/sh_util/dev/docs/debtux.png
   :target: https://www.debian.org

Navigate to release `page`_ download and extract release archive.

.. _page: https://github.com/vroncevic/sh_util/releases

To install **sh_util** type the following

.. code-block:: bash

    tar xvzf sh_util-1.0.tar.gz
    cd sh_util-1.0
    sudo mkdir -p /root/scripts/sh_util/ver.1.0/
    sudo cp -R ~/sh_tool/bin/   /root/scripts/sh_util/ver.1.0/
    sudo cp -R ~/sh_tool/conf/  /root/scripts/sh_util/ver.1.0/
    sudo cp -R ~/sh_tool/log/   /root/scripts/sh_util/ver.1.0/

Or You can use Docker to create image/container.

Dependencies
------------

**sh_util** requires next modules and libraries

* None

Library structure
-----------------

**sh_util** is based on MOP.

Library structure

.. code-block:: bash

    sh_tool/
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
    │   ├── center.sh
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
    │   ├── devel_check.sh
    │   ├── devel_const.sh
    │   ├── devel.sh
    │   ├── dir_utils.sh
    │   ├── disk_label.sh
    │   ├── display_logo.sh
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
    
    5 directories, 138 files

Copyright and licence
---------------------

|License: GPL v3| |License: Apache 2.0|

.. |License: GPL v3| image:: https://img.shields.io/badge/License-GPLv3-blue.svg
   :target: https://www.gnu.org/licenses/gpl-3.0

.. |License: Apache 2.0| image:: https://img.shields.io/badge/License-Apache%202.0-blue.svg
   :target: https://opensource.org/licenses/Apache-2.0

Copyright (C) 2015 - 2026 by `vroncevic.github.io/sh_util <https://vroncevic.github.io/sh_util>`_

**sh_util** is free software; you can redistribute it and/or modify it
under the same terms as Bash itself, either Bash version 4.2.47 or,
at your option, any later version of Bash 4 you may have available.

Lets help and support FSF.

|Free Software Foundation|

.. |Free Software Foundation| image:: https://raw.githubusercontent.com/vroncevic/sh_util/dev/docs/fsf-logo_1.png
   :target: https://my.fsf.org/

|Donate|

.. |Donate| image:: https://www.paypalobjects.com/en_US/i/btn/btn_donateCC_LG.gif
   :target: https://my.fsf.org/donate/

Indices and tables
------------------

* :ref:`genindex`
* :ref:`modindex`
* :ref:`search`
