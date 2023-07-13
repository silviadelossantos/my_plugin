# Displays Disks tab on Host form
Deface::Override.new(
    :virtual_path => 'hosts/_form',
    :name => 'host_disks_tab',
    :insert_after => 'li.active',
    :partial => 'foreman_disk_management/disks/select_tab_title'
  )

  Deface::Override.new(
    :virtual_path => 'hosts/_form',
    :name => 'host_disks_tab_content',
    :insert_after => 'div.tab-pane.active',
    :partial => 'foreman_disk_management/disks/select_tab_content'
  )