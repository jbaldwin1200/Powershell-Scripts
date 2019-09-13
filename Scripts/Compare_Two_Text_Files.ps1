compare-object (get-content "C:\Users\jbaldwin\OneDrive - IGT PLC\Desktop\Servers_from_AD_Script.txt") `
(get-content "C:\Users\jbaldwin\OneDrive - IGT PLC\Desktop\Servers_from_Reboot_List.txt") | format-list | Out-File "C:\Users\jbaldwin\OneDrive - IGT PLC\Desktop\Servers_from_Reboot_List.txt"
