function retval = ecm(x,y)
	if (length(x)!=length(y))
		error ("La longitud de los vectores debe ser igual");
	else
		retval = sum((x-y).^2)./length(x);
	endif
endfunction
