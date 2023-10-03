set NDM_LIBS {}
set FRAME_LIBS {}
set LEF_FILES {/home/aedc4/0_SysV_Mewan/ASIC_flow_ass_3/libs/saed32nm_hvt_1p9m.lef}
set DB_FILES {/home/aedc4/libs/tsmc_32nm/SAED32_EDK/lib/stdcell_hvt/db_nldm/saed32hvt_ss0p7v125c.db}
set TECH_FILE "/home/aedc4/0_SysV_Mewan/ASIC_flow_ass_3/libs/saed32nm_1p9m_mw.tf"

set_app_options -name lib.workspace.create_cached_lib -value true
#suppress_messages

set_app_options -name lib.workspace.allow_read_aggregate_lib -value true
create_workspace saed32hvt_ss0p7v125c -technology $TECH_FILE -scale_factor 10000
read_lef $LEF_FILES
read_db $DB_FILES
process_workspaces -check_options {-allow_missing} -force -directory CLIBs -output saed32hvt_ss0p7v125c.ndm
