pro MOVE_FILE, ucams, tmp_folder, old_file_name

cmd = "/usr/local/bin/ionrncp " 
cmd += tmp_folder+file_name
cmd += " " + ucams
spawn, cmd

end

