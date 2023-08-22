function cost = cost_func(actual, desired)
	cost = .5.*sum((actual-desired).^2);
endfunction
