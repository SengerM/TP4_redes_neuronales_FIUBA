function delta_w = calcular_delta_w(w, n, d, pin, pout)
	delta_w = w;
	delta_w(1:end-1,:) = ( n*(d').*(sign(w(1:end-1,:)).^2) );
	delta_w(end,:) = ( (d').*(sign(w(end,:)).^2) );
endfunction
