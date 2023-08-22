function retval = get_time()
	retval = strftime("%Y:%m:%d:%H:%M:%S", localtime(time()));
endfunction
